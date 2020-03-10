IGNORE = .git .gitignore
FILES = $(filter-out $(IGNORE), $(wildcard .*))
LINKS = $(FILES:%=~/%)
SCRIPTS = bin
BIN = ~/$(SCRIPTS)

BUNDLEDIR = .vim/bundle
VUNDLEDIR = $(BUNDLEDIR)/Vundle.vim

PASS_USER = gpg
PASS_HOME = /home/$(PASS_USER)
PASS_WRAP = passwrap
PASS_INIT = passinit
PASS_SYSD = $(PASS_HOME)/.config/systemd/user

ST_PACKAGE = st-git
ST_FILES = /usr/bin/st /usr/share/doc/st-git/README /usr/share/licenses/st-git/LICENSE /usr/share/man/man1/st.1.gz
ST_AUR_REPO = https://aur.archlinux.org/st-git.git

XKB_LAYOUT := /usr/share/X11/xkb/symbols/my_gb
XORG_KBD_CONF := /etc/X11/xorg.conf.d/00-keyboard.conf

all: $(LINKS) plugins st-install st-uninstall

.PHONY: all $(BIN) plugins st-install xkb pass-setup mbsync-setup

# TODO switch to ~ before executing and use vpath
~/.%:
	ln -s ~/dotfiles/.$* $@

$(BIN): $(SCRIPTS)
	ln -s ~/dotfiles/$< $@

plugins: $(VUNDLEDIR)
	vim +PluginUpdate +PluginClean +qa
	@# PluginUpdate updates the timestamp of $(BUNDLEDIR), thus it is newer
	@# than $(VUNDLEDIR). Hence, make wants to clone vundle again during the
	@# next execution, leading to a git error!
	@# The hack below circumvents this.
	@# Note: it also makes it unnecessary to list $(VUNDLEDIR) as an
	@# order-only prerequisite, though it actually is one.
	touch $(VUNDLEDIR)

$(VUNDLEDIR): $(BUNDLEDIR)
	git clone https://github.com/gmarik/Vundle.vim.git $@

$(BUNDLEDIR):
	mkdir $@

st-install: $(ST_FILES)

$(ST_FILES): st-pkgbuild.diff st-font-and-colors.diff
	(cd /tmp && [ -d $(ST_PACKAGE) ] || git clone $(ST_AUR_REPO))
	cp st-pkgbuild.diff st-font-and-colors.diff /tmp/$(ST_PACKAGE)
	(cd /tmp/$(ST_PACKAGE) && git apply st-pkgbuild.diff; makepkg -fis)

st-uninstall:
	sudo pacman -Runs $(ST_PACKAGE)

xkb: $(XKB_LAYOUT) $(XORG_KBD_CONF)

.SECONDEXPANSION:

$(XKB_LAYOUT): $$(notdir $$@)
	sudo ln -s $(realpath $<) $@

$(XORG_KBD_CONF): $$(notdir $$@)
	sudo ln -s $(realpath $<) $@

# TODO only execute the recipe if something has actually changed
# least priority, as the recipe is idempotent
mbsync-setup: pass-setup $(PASS_SYSD)/timers.target.wants/mbsync.timer $(PASS_SYSD)/mbsync.service
	XDG_RUNTIME_DIR=/run/user/$$(id -u $(PASS_USER)) runuser -u $(PASS_USER) -- systemctl --user daemon-reload

pass-setup: $(PASS_HOME)/$(PASS_WRAP) $(PASS_HOME)/$(PASS_INIT)
	
$(PASS_HOME)/$(PASS_WRAP): $(PASS_WRAP) | $(PASS_HOME)
	install -o $(PASS_USER) -g $(PASS_USER) $< $@

$(PASS_HOME)/$(PASS_INIT): $(PASS_INIT) | $(PASS_HOME)
	install -o $(PASS_USER) -g $(PASS_USER) $< $@

$(PASS_INIT): $(PASS_INIT).tpl
	@echo "Please provide the file $@"
	@echo "It is to be obtained from $@.tpl by adding your personal information"
	@false

$(PASS_HOME):
	useradd -Um $(PASS_USER)
	loginctl enable-linger $(PASS_USER)
	@echo Remember to sudo-enable the $(PASS_USER) user to run your \
	    synchronization services by adding the following lines to your \
	    sudoers file
	@echo
	@echo "Cmnd_Alias SYNC = $(shell which mbsync), $(shell which vdirsyncer)"
	@echo "Defaults!SYNC closefrom_override"
	@echo "$(PASS_USER) ALL=(ALL) NOPASSWD: SYNC"
	@echo "$(PASS_USER) ALL=(ALL) NOPASSWD: $(shell which pass)"
	@echo

$(PASS_SYSD): | $(PASS_HOME)
	install -o $(PASS_USER) -g $(PASS_USER) -d $@

# TODO the following is bad make, but shall we really use vpath here?
$(PASS_SYSD)/%: pass-systemd/% | $(PASS_SYSD)
	install -o $(PASS_USER) -g $(PASS_USER) pass-systemd/$* $@

.PRECIOUS: $(PASS_SYSD)/%

pass-systemd/%.service:
	@echo "Please provide the service file $@"
	@echo "It is to be obtained from $@.tpl by adding your personal information"
	@false

$(PASS_SYSD)/timers.target.wants/%: $(PASS_SYSD)/%
	XDG_RUNTIME_DIR=/run/user/$$(id -u $(PASS_USER)) runuser -u $(PASS_USER) -- systemctl --user enable $*

$(PASS_SYSD)/default.target.wants/%: $(PASS_SYSD)/%
	XDG_RUNTIME_DIR=/run/user/$$(id -u $(PASS_USER)) runuser -u $(PASS_USER) -- systemctl --user enable $*
