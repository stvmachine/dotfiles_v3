# stop brew install from update everything
set -x HOMEBREW_NO_AUTO_UPDATE 1

# disable annoying hits
set -x HOMEBREW_NO_ENV_HINTS 1

# Strip Homebrew's internal shims from PATH. brew prepends
# /opt/homebrew/Library/Homebrew/shims/* only for its own subprocesses; if one
# leaks into fish_user_paths, its `git` shim shadows the real git and fails with
# "This shim is internal and must be run via brew." Clean the universal var
# (only when dirty) and the session PATH, same approach as fork-git-path-fix.
if string match -q "*/Homebrew/shims/*" -- $fish_user_paths
    set -U fish_user_paths (string match -v "*/Homebrew/shims/*" -- $fish_user_paths)
end
set -gx PATH (string match -v "*/Homebrew/shims/*" -- $PATH)
