# Maestro — mobile UI automation / E2E CLI
# Installed via: curl -Ls "https://get.maestro.mobile.dev" | bash
# Binary lives at ~/.maestro/bin (default installer location)

set -gx MAESTRO_HOME $HOME/.maestro

# Only add to PATH if Maestro is installed
if test -d $MAESTRO_HOME/bin
	set -gx PATH $MAESTRO_HOME/bin $PATH 2>/dev/null; or true
end
