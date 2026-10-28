Forked from [Caarlos0 dotfiles](https://github.com/caarlos0/dotfiles.fish)

## Installation

### Dependencies

First, make sure you have all those things installed:

- `git`: to clone the repo
- `curl`: to download some stuff
- `tar`: to extract downloaded stuff
- `fish`: the shell
- `sudo`: some configs may need that

### Install

Then, run these steps:

```console
git clone https://github.com/stvmachine/dotfiles_v3 ~/.dotfiles
cd ~/.dotfiles
./script/bootstrap.fish
```

### Mac brew install

Run brew bundle from macos folder

```console
cd macos
brew bundle
```

> All changed files will be backed up with a `.backup` suffix.

#### Update

To update, you just need to `git pull` and run the bootstrap script again:

```console
cd ~/.dotfiles
git pull origin master
./script/bootstrap.fish
```

## Revert

Reverting is not totally automated, but it pretty much consists in removing
the fish config and dotfiles folder, as well as moving back some config files.

```console
rm -rf ~/.dotfiles $__fish_config_dir
```

The bootstrap script would have created a bunch of symlinks that will now be broken.
You will have to investigate those manually.
In cases a file already existed, the boostrap script should have created a `.backup` file with the same name.

## SSH keys / GitHub

GitHub access uses one SSH key per identity, selected via SSH host aliases
(`github-personal`, `github-work`) declared in `ssh/config.dotfiles`. Private
keys live in `~/.ssh/` and are **never committed** — only the host config is
version-controlled here.

`ssh/install.fish` (run by `bootstrap.fish`) makes `~/.ssh` private, pins
`config.dotfiles` to `0600` (ssh rejects group/world-writable configs), and
pre-seeds github.com host keys so the first `ssh -T git@github-*` doesn't stall
on host verification.

### Add a key (first time, or on a new machine)

```console
add-github-profile personal "Your Name" "you@example.com"
# or: add-github-profile work "Your Name" "you@work.example.com"
```

This generates the key (`~/.ssh/id_ed25519` for personal,
`~/.ssh/id_work_ed25519` for work), loads it into the macOS keychain, persists
the `GIT_PERSONAL_*` / `GIT_WORK_*` identity, and appends the matching `Host`
block to `ssh/config.dotfiles` if it isn't already there.

Copy the public key and upload it to GitHub
(**Settings → SSH and GPG keys → New SSH key**):

```console
pbcopy < ~/.ssh/id_ed25519.pub      # or: ~/.ssh/id_work_ed25519.pub
```

> The bundled `pubkey` helper runs `ssh-add -L | pbcopy`, which copies every
> key in the agent. On a fresh machine that's fine, but `pbcopy < <key>.pub`
> is unambiguous when multiple keys are loaded.

Then verify:

```console
ssh -T git@github-work        # or: git@github-personal
```

Run `add-github-profile` once per identity per machine. Re-running is safe —
it skips keys and hosts that already exist.

## Git profiles

Per-repo work/personal identities. `git-profile-work` sets local `user.name`/`user.email` and rewrites remotes to `git@github-work:...`; `git-profile-personal` does the same for the personal account with `git@github-personal:...`. Identities come from `GIT_WORK_*` / `GIT_PERSONAL_*` env vars (or a prompt when unset); nothing is hardcoded.

Prerequisites: run `./script/bootstrap.fish` (puts `bin/` on PATH), and set up the `github-work` / `github-personal` SSH keys — see [SSH keys / GitHub](#ssh-keys--github) (`add-github-profile work|personal` does keys plus hosts).

```console
cd <repo>
git-profile-work  # or: gwork
git config user.name
git remote -v
```

Fresh clones need the profile applied once after cloning, since remotes default to `github.com`/HTTPS.
`git-profile-work` also converts `github-personal` remotes to work; `git-profile-personal` does not convert `github-work` remotes back.

## Recommended Software

All tools below are compatible with Fish shell and Starship prompt:

- [`bat`](https://github.com/sharkdp/bat) a cat(1) clone with wings;
- [`fzf`](https://github.com/junegunn/fzf) for a fuzzy-finder (with Fish integration);
- [`gh`](https://github.com/cli/cli) for more GitHub integration with the terminal;
- [`grc`](https://github.com/garabik/grc) to colorize command's outputs;
- [`starship.rs`](https://starship.rs) the prompt we are using (Fish is the shell);

## OpenCode

OpenCode configuration lives in a **separate repo** —
[`stvmachine/opencode-config`](https://github.com/stvmachine/opencode-config) —
because it changes far more often than the rest of these dotfiles. `opencode/install.fish`
clones (or pulls) that repo directly into `~/.config/opencode` during bootstrap, then
rebuilds the generated preset config.

That repo holds `opencode.jsonc`, OCX profiles + wrapper scripts,
`oh-my-opencode-slim` presets, and vendored skills. See its
README and `docs/PROFILES.md` for the profile → preset mapping and setup details.

### Install

```console
cd ~/.dotfiles
./script/bootstrap.fish   # clones/updates ~/.config/opencode from opencode-config
```

> First-time setup needs the `github-personal` SSH key, since the clone is over
> SSH: run `add-github-profile personal "<name>" "<email>"` (see
> [SSH keys / GitHub](#ssh-keys--github)), then re-run bootstrap.

### GSD-core

To install GSD workflows and agents on top of this OpenCode setup:

```console
npx -y @opengsd/gsd-core@latest --opencode --global
```

GSD writes files into `~/.config/opencode/` (agents, command, gsd-core, hooks,
etc.) that the opencode-config repo's `.gitignore` already excludes.

## Mac Setup

Facing the setup of a new machine (or the need to reinstall after a fresh OS install or the like), here's a very brief and basic list of the usual suspects, related to the setup of a mac computer to work with (mostly related to a scripting languages context).

The package manager is the default first thing I always install. Simply following the default steps. Homebrew should download and install the Command Line Tools for Xcode automatically, but if it doesn't work, you can install them manually:

```bash
xcode-select --install
```

Install brew and install apps

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew bundle --file ~/.dotfiles/macos/Brewfile 
```


### macOS defaults

You use it by running:

```console
~/.dotfiles/macos/set-defaults.sh
```

And logging out and in again or restart.


## Acknowledge

Thanks to alexramirez: <https://github.com/alexramirez/mac-setup>
