function add-github-profile -d "Add github-personal or github-work SSH profile"
	# usage: add-github-profile work|personal [email] | [name] [email]
	if test (count $argv) -eq 0
		echo "usage: add-github-profile work|personal [email] | [name] [email]" >&2
		return 1
	end

	set profile $argv[1]
	if test "$profile" != work -a "$profile" != personal
		echo "usage: add-github-profile work|personal [email] | [name] [email]" >&2
		return 1
	end

	if test "$profile" = work
		set host github-work
		set key ~/.ssh/id_work_ed25519
		set env_name GIT_WORK_NAME
		set env_email GIT_WORK_EMAIL
	else
		set host github-personal
		set key ~/.ssh/id_ed25519
		set env_name GIT_PERSONAL_NAME
		set env_email GIT_PERSONAL_EMAIL
	end
	# Resolve name and email independently: explicit args, else env vars,
	# else prompt. Persist answers as universal vars (outside the repo) so
	# the git-profile scripts find them on later runs.
	set name ''
	set email ''
	if test (count $argv) -ge 3
		set name $argv[2]
		set email $argv[3]
	else if test (count $argv) -ge 2
		set email $argv[2]
		if set -q $env_name; and test -n "$$env_name"
			set name $$env_name
		end
	else
		if set -q $env_name; and test -n "$$env_name"
			set name $$env_name
		end
		if set -q $env_email; and test -n "$$env_email"
			set email $$env_email
		end
	end
	if test -z "$name"
		# Attempt `read` unconditionally: succeeds on terminal or pipe,
		# fails only when stdin is closed.
		read -P "Git user.name for $profile profile: " name
		or begin
			echo "$env_name is not set (or pass name/email as arguments)" >&2
			return 1
		end
		if test -z "$name"
			echo "name for $profile profile must not be empty" >&2
			return 1
		end
	end
	if test -z "$email"
		read -P "Git user.email for $profile profile: " email
		or begin
			echo "$env_email is not set (or pass name/email as arguments)" >&2
			return 1
		end
		if test -z "$email"
			echo "email for $profile profile must not be empty" >&2
			return 1
		end
	end
	set -U $env_name $name
	set -U $env_email $email

	mkdir -p ~/.ssh
	if not test -f $key
		ssh-keygen -t ed25519 -f $key -C $email
			or return 1
	end

	switch (uname)
	case Darwin
		ssh-add --apple-use-keychain $key
			or return 1
	case '*'
		ssh-add $key
			or return 1
	end

	set dotfiles (set -q DOTFILES; and echo $DOTFILES; or echo ~/.dotfiles)
	set conf $dotfiles/ssh/config.dotfiles
	# config.dotfiles convention uses a literal ~ path; $key may already be expanded
	set conf_key (string replace -r "^$HOME" '~' -- (string unescape -- $key))
	if test -f $conf; and not grep -q "Host $host" $conf
		printf '\n# %s GitHub profile\nHost %s\n\tHostName github.com\n\tUser git\n\tAddKeysToAgent yes\n\tUseKeychain yes\n\tIdentityFile %s\n\tIdentitiesOnly yes\n' (string sub -l 1 -- $profile | string upper)(string sub -s 2 -- $profile) $host $conf_key >>$conf
		echo "appended Host $host to $conf"
	end

	echo "upload $key.pub to GitHub, then test: ssh -T git@$host"
end
