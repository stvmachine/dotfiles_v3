#!/usr/bin/env fish

# Link the Yazi config files. `ya pkg` writes package.toml through the link,
# so plugin changes land in this repo.
mkdir -p ~/.config/yazi
for file in yazi.toml keymap.toml package.toml
	set target ~/.config/yazi/$file
	if test -e $target; and not test -L $target
		mv $target $target.backup
	end
	ln -sf $DOTFILES/yazi/$file $target
end

# Plugins aren't committed: fetch the ones pinned in package.toml.
if command -q ya
	ya pkg install
end

# Markdown previews draw mermaid blocks with mermaid-ascii (see
# bin/glow-mermaid). It isn't in Homebrew, so build it into ~/.local/bin.
if not test -x ~/.local/bin/mermaid-ascii; and command -q go
	GOBIN=$HOME/.local/bin go install github.com/AlexanderGrooff/mermaid-ascii@latest
end
