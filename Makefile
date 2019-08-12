IGNORE = .git .gitignore
FILES = $(filter-out $(IGNORE), $(wildcard .*))
LINKS = $(FILES:%=~/%)

BUNDLEDIR = .vim/bundle
VUNDLEDIR = $(BUNDLEDIR)/Vundle.vim

ST_PACKAGE = st-git
ST_FILES = /usr/bin/st /usr/share/doc/st-git/README /usr/share/licenses/st-git/LICENSE /usr/share/man/man1/st.1.gz
ST_AUR_REPO = https://aur.archlinux.org/st-git.git

XKB_LAYOUT := /usr/share/X11/xkb/symbols/my_gb
XORG_KBD_CONF := /etc/X11/xorg.conf.d/00-keyboard.conf

all: $(LINKS) plugins st-install st-uninstall

.PHONY: all plugins st-install xkb

# TODO switch to ~ before executing and use vpath
~/.%:
	ln -s ~/dotfiles/.$* $@

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
