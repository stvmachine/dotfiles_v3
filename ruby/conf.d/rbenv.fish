# Initialize rbenv and prepend its shims before Homebrew's Ruby
status --is-interactive; and command -sq rbenv; and rbenv init - fish | source

# Trigger 'rbenv install x.y.z' if .ruby-version exists in the folder
function __check_ruby_version --on-variable PWD --description 'Do rbenv stuff'
  if test -f .ruby-version
    yes no | rbenv install (cat .ruby-version)
  end
end

# Install ruby version if it's necessary
__check_ruby_version

