#!/usr/bin/env fish
#
# Symlink dotfiles-managed opencode config to ~/.config/opencode

set -q DOTFILES; or set DOTFILES ~/.dotfiles
set dotfiles_opencode $DOTFILES/.config/opencode
set home_opencode $HOME/.config/opencode

if test -L $home_opencode
	set target (readlink $home_opencode)
	if test "$target" = "$dotfiles_opencode"
		echo "  skipped $home_opencode (already linked)"
		exit 0
	end
	echo "  removing existing symlink $home_opencode -> $target"
	rm $home_opencode
else if test -e $home_opencode
	set backup $home_opencode.backup-(date +%Y%m%d-%H%M%S)
	mv $home_opencode $backup
	or begin
		echo "  failed to backup $home_opencode"
		exit 1
	end
	echo "  moved $home_opencode to $backup"
end

mkdir -p (dirname $home_opencode)
ln -sf $dotfiles_opencode $home_opencode
or begin
	echo "  failed to link $dotfiles_opencode to $home_opencode"
	exit 1
end

echo "  linked $home_opencode"
