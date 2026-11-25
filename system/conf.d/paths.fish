# System PATH additions
# Don't pass $PATH here: fish_add_path persists everything into the universal
# fish_user_paths, so any transient entry (e.g. Homebrew's internal shims when a
# shell is spawned from brew) would get baked in for every future shell.
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
fish_add_path --prepend /usr/local/bin
fish_add_path $HOME/.local/bin

# Load credentials
if test -f $HOME/.credentials/npm.fish
    source $HOME/.credentials/npm.fish
end