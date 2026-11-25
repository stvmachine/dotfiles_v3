#!/usr/bin/env fish

# Install the docsets I use in Dash. Dash downloads them itself when sent its
# install URLs, so this only asks for the ones not installed yet. Keep these
# lists in sync with Settings > Docsets.
set -q DOTFILES; or set DOTFILES ~/.dotfiles

# Settings > Downloads > Main Docsets, by feed name (kapeli.com/feeds/<name>.xml)
set main CSS JavaScript Pandas React Ruby Rust
# Settings > Downloads > Cheat Sheets
set cheat_sheets Git 'Git Flow' 'Git Subversion' Gitmoji Helix
# Settings > Downloads > User Contributed
set user_contributed 'GitHub Actions' 'GraphQL Specification'

if not test -d /Applications/Dash.app
	exit 0
end

set library ~/Library/Application\ Support/Dash
set urls

# dash-install:// doesn't support the Main Docsets repo, so subscribe to
# their feeds instead. Versioned installs live under Versioned DocSets.
for name in $main
	if not test -d $library/DocSets/$name; and not count $library/Versioned\ DocSets/$name\ -\ * >/dev/null
		set -a urls dash-feed://(string escape --style=url http://kapeli.com/feeds/$name.xml | string replace -a / %2F)
	end
end
for name in $cheat_sheets
	if not test -d $library/Cheat\ Sheets/$name
		set -a urls "dash-install://repo_name=Cheat%20Sheets&entry_name="(string escape --style=url $name)
	end
end
for name in $user_contributed
	if not test -d $library/User\ Contributed/$name
		set -a urls "dash-install://repo_name=User%20Contributed&entry_name="(string escape --style=url $name)
	end
end

if set -q urls[1]
	# Dash ignores install URLs that arrive before it has finished launching
	# and loaded its repos, so start it first and space the requests out.
	open -g -a Dash
	sleep 5
	for url in $urls
		echo "  › Dash: $url"
		open -g $url
		sleep 3
	end
end

# Docsets Dash doesn't offer, built from their docs sites.
if not test -d ~/.local/share/dash/Yazi.docset
	$DOTFILES/dash/yazi-docset
end
