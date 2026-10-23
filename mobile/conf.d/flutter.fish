# Flutter — Dart/Flutter SDK
# Installed via: manual download to /Applications/flutter
# Binary lives at /Applications/flutter/bin (added to PATH below)

set -gx FLUTTER_HOME /Applications/flutter

# Only add to PATH if Flutter is installed
if test -d $FLUTTER_HOME/bin
	set -gx PATH $FLUTTER_HOME/bin $PATH 2>/dev/null; or true
end
