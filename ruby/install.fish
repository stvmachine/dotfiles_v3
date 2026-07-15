#!/usr/bin/env fish
# Ruby and rbenv setup

# Ensure rbenv shims win over Homebrew Ruby
set -gx PATH $HOME/.rbenv/shims $PATH

# Init rbenv with fish. Source: https://github.com/rbenv/rbenv#basic-git-checkout
if command -sq rbenv
    status --is-interactive; and rbenv init - fish | source
    rbenv rehash >/dev/null 2>&1
end

