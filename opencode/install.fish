#!/usr/bin/env fish
#
# Install the OpenCode config: clone (or update) the dedicated
# stvmachine/opencode-config repo as ~/.config/opencode.
#
# The config lives in its own repo because it changes far more often than the
# rest of dotfiles; keeping it out of this repo avoids constant churn here.

set -q DOTFILES; or set DOTFILES ~/.dotfiles
set home_opencode $HOME/.config/opencode
set repo git@github-personal:stvmachine/opencode-config.git

# Is this dir already our opencode-config clone?
function oc_is_ours -a dir
	test -d $dir/.git
		and git -C $dir remote get-url origin 2>/dev/null | grep -q opencode-config
end

# Migrate away from the old setup, where ~/.config/opencode was a symlink into
# a dotfiles-managed copy (removed from this repo).
if test -L $home_opencode
	echo "  removing old symlink $home_opencode -> "(readlink $home_opencode)
	rm $home_opencode
else if test -e $home_opencode; and not oc_is_ours $home_opencode
	set backup $home_opencode.backup-(date +%Y%m%d-%H%M%S)
	echo "  moving non-opencode-config $home_opencode to $backup"
	mv $home_opencode $backup
		or begin
			echo "  failed to move $home_opencode" >&2
			exit 1
		end
end

if not test -d $home_opencode
	echo "  cloning opencode-config into $home_opencode"
	git clone $repo $home_opencode
		or begin
			echo "  WARN: could not clone $repo (SSH key not set up yet?)." >&2
			echo "        Run 'add-github-profile personal <name> <email>' then re-run bootstrap." >&2
			exit 0
		end
else
	echo "  updating opencode-config"
	git -C $home_opencode pull --ff-only
		or echo "  WARN: opencode-config pull failed (offline?); keeping current checkout" >&2
end

# Rebuild the generated preset config from presets/*.json (node, no deps).
if test -f $home_opencode/scripts/build-presets.js
	node $home_opencode/scripts/build-presets.js
		or echo "  WARN: build-presets.js failed" >&2
end
