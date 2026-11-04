#!/usr/bin/env fish

# Link the Zed config files. Zed writes UI setting changes through the links,
# so they land in this repo.
mkdir -p ~/.config/zed
for file in settings.json keymap.json tasks.json
	set target ~/.config/zed/$file
	if test -e $target; and not test -L $target
		mv $target $target.backup
	end
	ln -sf $DOTFILES/zed/$file $target
end

# The tv and lazygit tasks open files with the `zed` CLI. The Homebrew cask
# installs it; a Zed installed from zed.dev does not, so link the bundled one.
if not command -q zed; and test -x /Applications/Zed.app/Contents/MacOS/cli
	mkdir -p ~/.local/bin
	ln -sf /Applications/Zed.app/Contents/MacOS/cli ~/.local/bin/zed
end
