IGNORE = .git
FILES = $(filter-out $(IGNORE), $(wildcard .*))
LINKS = $(FILES:%=~/%)

BUNDLEDIR = .vim/bundle
VUNDLEDIR = $(BUNDLEDIR)/Vundle.vim

all: $(LINKS) plugins

.PHONY: all plugins

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
