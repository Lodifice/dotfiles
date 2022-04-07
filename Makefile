# use xdg user-dirs defaults and systemd-path definitions
XDG_CONFIG_HOME ?= $(HOME)/.config
USER_BINARIES := $(shell systemd-path user-binaries)

IGNORE = .git .gitignore
FILES = $(filter-out $(IGNORE), $(wildcard .*))
LINKS = $(FILES:%=~/%)
SCRIPTS = $(realpath bin)

BUNDLEDIR = .vim/bundle
VUNDLEDIR = $(BUNDLEDIR)/Vundle.vim

# TODO make the following determine the user automatically
MY_USER = richard
MY_SYSD = /home/$(MY_USER)/.config/systemd/user

PASS_USER = gpg
PASS_HOME = /home/$(PASS_USER)
PASS_WRAP = passwrap
PASS_SYSD = $(PASS_HOME)/.config/systemd/user
PASS_INIT = /usr/local/bin/passinit

ST_PACKAGE = st-git
ST_FILES = /usr/bin/st /usr/share/doc/st-git/README /usr/share/licenses/st-git/LICENSE /usr/share/man/man1/st.1.gz
ST_AUR_REPO = https://aur.archlinux.org/st-git.git

XKB_LAYOUT := /usr/share/X11/xkb/symbols/my_gb
XORG_KBD_CONF := /etc/X11/xorg.conf.d/00-keyboard.conf
XORG_TOUCHPAD_CONF := /etc/X11/xorg.conf.d/30-touchpad.conf

all: $(LINKS) $(patsubst $(SCRIPTS)%,$(USER_BINARIES)%,$(wildcard $(SCRIPTS)/*)) plugins st-install st-uninstall

.PHONY: all plugins st-install xkb xtouchpad pass-setup mbsync-setup

# TODO switch to ~ before executing and use vpath
~/.%:
	ln -s ~/dotfiles/.$* $@

$(USER_BINARIES)/%: $(SCRIPTS)/%
	ln -s $< $@

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

xtouchpad: $(XORG_TOUCHPAD_CONF)

.SECONDEXPANSION:

$(XKB_LAYOUT): $$(notdir $$@)
	sudo ln -s $(realpath $<) $@

$(XORG_KBD_CONF): $$(notdir $$@)
	sudo ln -s $(realpath $<) $@

$(XORG_TOUCHPAD_CONF): $$(notdir $$@)
	sudo ln -s $(realpath $<) $@

# TODO only execute the recipe if something has actually changed
# least priority, as the recipe is idempotent
mbsync-setup: pass-setup $(PASS_SYSD)/timers.target.wants/mbsync.timer $(PASS_SYSD)/mbsync.service
	XDG_RUNTIME_DIR=/run/user/$$(id -u $(PASS_USER)) runuser -u $(PASS_USER) -- systemctl --user daemon-reload

pass-setup: $(PASS_HOME)/$(PASS_WRAP) $(PASS_INIT) $(MY_SYSD)/xsession.target.wants/passinit.service /etc/sudoers.d/pass-user
	
$(PASS_HOME)/$(PASS_WRAP): $(PASS_WRAP) | $(PASS_HOME)
	install -o $(PASS_USER) -g $(PASS_USER) $< $@

$(PASS_INIT): $$(notdir $$@)
	install $< $@

passinit:
	@echo "Please provide the file $@"
	@echo "It is to be obtained from $@.tpl by adding your personal information"
	@false

$(PASS_HOME):
	useradd -Um $(PASS_USER)
	loginctl enable-linger $(PASS_USER)

/etc/sudoers.d/pass-user: pass-user-sudoers
	install -m 0440 $< $@

# TODO this is generic, move it to a more prominent place
$(MY_SYSD)/xsession.target.wants/%: $(MY_SYSD)/%
	runuser -u $(MY_USER) -- systemctl --user enable $*
	runuser -u $(MY_USER) -- systemctl --user daemon-reload

$(MY_SYSD)/passinit.service: passinit.service
	runuser -u $(MY_USER) -- cp $< $@

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
