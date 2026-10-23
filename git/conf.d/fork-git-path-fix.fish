# Remove Fork.app's bundled portable git from PATH.
#
# Fork.app's "shell integration" injects its git-instance dirs into the
# universal `fish_user_paths`, AHEAD of Homebrew/system git. That portable git
# is missing `git-sh-i18n`, so any operation that sources `git-sh-setup` breaks
# — notably submodule fetches, which makes `pod install` fail when a pod pulls
# submodules (e.g. libdav1d). Fork re-injects these on launch, so removing them
# from `fish_user_paths` doesn't stick; instead we strip them from the session
# PATH on every shell startup here (conf.d runs after universal vars load).
#
# Fork.app itself is unaffected — it invokes its bundled git via absolute paths
# internally, not via your CLI PATH.
#
# Stripping only $PATH here is NOT enough: later conf.d files (nvm, rbenv, paths)
# touch $fish_user_paths, and fish's handler then re-prepends the ENTIRE
# $fish_user_paths — Fork included — back onto $PATH, undoing our strip. So we
# clean the universal $fish_user_paths itself (only rewriting it when dirty to
# avoid needless universal-var writes), then also clean the inherited session
# $PATH for good measure.
if string match -q "*Fork.app*git-instance*" -- $fish_user_paths
    set -U fish_user_paths (string match -v "*Fork.app*git-instance*" -- $fish_user_paths)
end
set -gx PATH (string match -v "*Fork.app*git-instance*" -- $PATH)
