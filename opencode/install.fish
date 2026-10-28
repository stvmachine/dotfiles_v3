#!/usr/bin/env fish
#
# Install the opencode + ocx monorepo:
#   1. Clone (or update) stvmachine/opencode-config into ~/.config/opencode.
#   2. Rebuild the generated preset configs and copy the profiles into
#      ~/.config/ocx/profiles/.
#   3. Install ocx (OCX 3 preview) via Bun's global bin.
#
# The monorepo holds both the OpenCode config (repo root) and the OCX profiles
# (ocx/ subdir). Runtime state is gitignored via the repo's .gitignore.

set -q DOTFILES; or set DOTFILES ~/.dotfiles
set home_opencode $HOME/.config/opencode
set repo git@github-personal:stvmachine/opencode-config.git

function oc_is_ours -a dir
	test -d $dir/.git
		and git -C $dir remote get-url origin 2>/dev/null | grep -q opencode
end

# Migrate away from a symlinked or non-mono ~/.config/opencode.
if test -L $home_opencode
	echo "  removing old symlink $home_opencode -> "(readlink $home_opencode)
	rm $home_opencode
else if test -e $home_opencode; and not oc_is_ours $home_opencode
	set backup $home_opencode.backup-(date +%Y%m%d-%H%M%S)
	echo "  moving non-mono $home_opencode to $backup"
	mv $home_opencode $backup
		or begin
			echo "  failed to move $home_opencode" >&2
			exit 1
		end
end

if not test -d $home_opencode
	echo "  cloning opencode monorepo into $home_opencode"
	git clone $repo $home_opencode
		or begin
			echo "  WARN: could not clone $repo (SSH key not set up yet?)." >&2
			echo "        Run 'add-github-profile personal <name> <email>' then re-run bootstrap." >&2
			exit 0
		end
else
	echo "  updating opencode monorepo"
	git -C $home_opencode pull --ff-only
		or echo "  WARN: pull failed (offline?); keeping current checkout" >&2
end

# Rebuild the generated preset configs from presets/*.json (node/bun, no deps),
# then copy the profiles into ~/.config/ocx/profiles/. OCX 3 rejects symlinks on
# its managed path, so this replaces the old ~/.config/ocx symlink with a real dir.
if test -f $home_opencode/scripts/build-presets.js
	bun $home_opencode/scripts/build-presets.js
		or echo "  WARN: build-presets.js failed" >&2
end

# Install ocx (OCX 3 preview for OpenCode v2), via Bun's global bin.
if command -qs bun
	bun add --global ocx@next
		or echo "  WARN: ocx install failed" >&2
end
