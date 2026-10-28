#!/bin/sh
# Sets reasonable macOS defaults.
#
# Derived from Nix darwin defaults configuration:
# https://github.com/caarlos0/dotfiles/blob/2025.6.2/machines/shared/darwin.nix
#
# Run ./macos/set-defaults.sh and you'll be good to go.

if [ "$(uname -s)" != "Darwin" ]; then
  exit 0
fi

set +e

sudo -v

host="$(hostname -s)"

echo ""
echo "› System:"
echo "  › Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

echo "  › Set a really fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "  › Show scrollbars automatically"
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"

echo "  › Clicking the scrollbar jumps to the spot that was clicked"
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

echo "  › Double-clicking a title bar fills the window"
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Fill"

echo "  › Tint window background with wallpaper color"
defaults write NSGlobalDomain AppleReduceDesktopTinting -bool false

echo "  › Increase the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.1

echo "  › Disable smart quotes, smart dashes, capitalization, period substitution, and auto-correct"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "  › Disable web automatic spelling correction"
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool false

echo "  › Set dark interface style"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

echo "  › Set accent color to blue"
defaults write -g AppleAccentColor -int 4
defaults write -g AppleAquaColorVariant -int 1

echo "  › Save to disk by default, instead of iCloud"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "  › Keep menu bar visible"
defaults write NSGlobalDomain _HIHideMenuBar -bool false

echo "  › Show Bluetooth icon in menu bar"
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

echo "  › Set springing delay to 0"
defaults write -g "com.apple.springing.delay" -float 0.0

echo "  › Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "  › Don't avoid creating .DS_Store files on network volumes"
# Note: This is different from the typical setup - allows .DS_Store on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false

echo "  › Keep quarantine enabled for the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool true

echo "  › Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "  › Set sidebar icon size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo "  › Enable WebKit developer extras"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "  › Globe/fn key switches input source"
defaults write com.apple.HIToolbox AppleFnUsageType -int 1

echo "  › Show AM/PM and day of week in the menu bar clock, but not the date"
defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true

echo "  › Show battery, clock, wi-fi and focus modes in the menu bar"
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Battery" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Clock" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC WiFi" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC FocusModes" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC BentoBox-0" -bool true

echo "  › No margins around tiled windows"
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

echo "  › Hide desktop icons until the wallpaper is clicked"
defaults write com.apple.WindowManager HideDesktop -bool true

#############################

echo ""
echo "› Finder:"
echo "  › Always open everything in Finder's icon view"
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"

echo "  › Sort folders before files"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "  › New windows open in the home folder"
defaults write com.apple.finder NewWindowTarget -string "PfHm"

echo "  › Search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "  › Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "  › Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "  › Show all files"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "  › Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "  › Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "  › Don't show hard drives on desktop"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

echo "  › Don't show external hard drives on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

echo "  › Don't show removable media on desktop"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

echo "  › Don't keep the desktop and documents in iCloud Drive"
defaults write com.apple.finder FXICloudDriveDesktop -bool false

echo "  › Keep the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool true

#############################

echo ""
echo "› Photos:"
echo "  › Disable it from starting every time a device is plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

#############################


echo ""
echo "› Dock:"
echo " > Remove all dock preferences"
defaults write com.apple.dock persistent-apps -array

echo "  › Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "  › Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

echo "  › Set Dock orientation to bottom"
defaults write com.apple.dock orientation -string "bottom"

echo "  › Setting the icon size of Dock items to 42 pixels"
defaults write com.apple.dock tilesize -int 42

echo "  › Show hidden apps in the Dock"
defaults write com.apple.dock showhidden -bool true

echo "  › Don't show recent applications in Dock"
defaults write com.apple.dock show-recents -bool false

echo "  › Show process indicators in Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo "  › Speed up Mission Control animations and group windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock expose-group-apps -bool true

echo "  › Don't animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false

echo "  › Set Dock mineffect to scale"
defaults write com.apple.dock mineffect -string "scale"

echo "  › Don't automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "  › Make Dock size immutable"
defaults write com.apple.dock size-immutable -bool true

# The app list lives in macos/dock.<host>.txt because the personal and work
# machines don't dock the same apps. Missing apps are skipped rather than
# leaving a "?" tile behind.
dock_list="$(dirname "$0")/dock.$host.txt"
if [ -f "$dock_list" ]; then
  echo "  › Set Dock apps from dock.$host.txt"
  defaults delete com.apple.dock persistent-apps >/dev/null 2>&1
  while IFS= read -r app; do
    case "$app" in '' | '#'*) continue ;; esac
    if [ ! -e "$app" ]; then
      echo "    › Skipping $app, not installed"
      continue
    fi
    defaults write com.apple.dock persistent-apps -array-add \
      "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  done <"$dock_list"

  echo "  › Keep only Downloads in the Dock's folder section"
  defaults delete com.apple.dock persistent-others >/dev/null 2>&1
  defaults write com.apple.dock persistent-others -array-add \
    "<dict><key>tile-type</key><string>directory-tile</string><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$HOME/Downloads/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
else
  echo "  › No dock.$host.txt, leaving Dock apps alone"
fi

#############################

echo ""
echo "› Restart related apps"
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "ControlCenter" "Dock" "Finder" "Ghostty" "Mail" "Messages" "Safari" \
  "SystemUIServer" "Terminal" "Photos" "Image Capture"; do
  killall "$app" >/dev/null 2>&1
done
set -e

echo "Done. Some changes (keyboard shortcuts, input sources) need a log out to take effect."
