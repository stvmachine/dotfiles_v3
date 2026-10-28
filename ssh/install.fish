#!/usr/bin/env fish

# Ensure ~/.ssh exists and is private (ssh rejects group/world-writable paths).
mkdir -p ~/.ssh
chmod 700 ~/.ssh

test -f ~/.ssh/config || touch ~/.ssh/config

grep -q "Include ~/.ssh/config.dotfiles" ~/.ssh/config ||
	echo "Include ~/.ssh/config.dotfiles" >> ~/.ssh/config

switch (uname)
case Darwin
	grep -q "UseKeychain yes" ~/.ssh/config || echo -e '\nHost *\n  UseKeychain yes\n' >> ~/.ssh/config
end

# ssh refuses to read config files that are group/world writable. On machines
# with a permissive umask (002), a freshly-cloned config.dotfiles is 664, which
# breaks `Include`. Pin the modes here.
chmod 600 ~/.ssh/config
if test -e ~/.ssh/config.dotfiles
	chmod 600 ~/.ssh/config.dotfiles
end

# Pre-seed github.com host keys so the first `ssh -T git@github-*` doesn't
# stall on host verification. Skips if github.com is already known.
if not test -f ~/.ssh/known_hosts
	touch ~/.ssh/known_hosts
end
chmod 600 ~/.ssh/known_hosts
if command -q ssh-keyscan; and not grep -q "^github.com " ~/.ssh/known_hosts
	set gh_keys (ssh-keyscan -t ed25519,ecdsa,rsa github.com 2>/dev/null)
	if test -n "$gh_keys"
		echo $gh_keys >> ~/.ssh/known_hosts
	end
end
