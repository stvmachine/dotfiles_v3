# Make rbenv's shims win over Homebrew's Ruby.
#
# system/conf.d/paths.fish adds /opt/homebrew/bin to the *universal*
# fish_user_paths, which fish always re-prepends to $PATH. `rbenv init` only
# prepends the shims to the *session* $PATH, so Homebrew's ruby shadows them.
# Instead we move the shims to the front of fish_user_paths — persistent, and
# applied in every shell (interactive or not, so scripts and foreman/bin/dev
# get the pinned ruby too). This conf.d runs after paths.fish (alphabetical),
# so Homebrew is already present when --move reorders the shims ahead of it.
if command -sq rbenv
    fish_add_path --prepend --move ~/.rbenv/shims
    set -gx RBENV_SHELL fish
    # Provide the `rbenv` shell function (for `rbenv shell` / `rbenv rehash`).
    status --is-interactive; and rbenv init - fish | source
end

# Trigger 'rbenv install x.y.z' if .ruby-version exists in the folder
function __check_ruby_version --on-variable PWD --description 'Do rbenv stuff'
  if test -f .ruby-version
    yes no | rbenv install (cat .ruby-version)
  end
end

# Install ruby version if it's necessary
__check_ruby_version

