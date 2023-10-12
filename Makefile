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

# TODO this is generic, move it to a more prominent place
$(MY_SYSD)/xsession.target.wants/%: $(MY_SYSD)/%
	runuser -u $(MY_USER) -- systemctl --user enable $*
	runuser -u $(MY_USER) -- systemctl --user daemon-reload
