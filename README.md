Forked from [Caarlos0 dotfiles](https://github.com/caarlos0/dotfiles.fish)

## Installation

### Install

On a fresh Mac, run these in order. `bootstrap.fish` needs `fish`, and the
OpenCode step needs `bun`; both come from the Brewfile, so it has to be
installed first.

1. Install Homebrew (it also installs the Xcode Command Line Tools, which
   provide `git`; if that fails, run `xcode-select --install`):

   ```console
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Clone the repo and install the Brewfile (`fish`, `starship`, `bun`, `nvm`,
   apps):

   ```console
   git clone https://github.com/stvmachine/dotfiles_v3 ~/.dotfiles
   brew bundle --file ~/.dotfiles/macos/Brewfile
   ```

3. Run the bootstrap:

   ```console
   cd ~/.dotfiles
   ./script/bootstrap.fish
   ```

What bootstrap does with existing files:

- Files it replaces with symlinks (`*.symlink` → `~/.<name>`, fish plugins,
  ssh config) and an existing `~/.gitconfig` are moved to `<name>.backup`.
- Files in `~/.config/fish/conf.d/` with the same name as one of the repo's
  `*/conf.d/*.fish` are **overwritten without a backup**.
- An existing `~/.config/opencode` that isn't the opencode-config clone is
  moved to `~/.config/opencode.backup-<timestamp>`.

#### Update

To update, pull and run the bootstrap script again:

```console
cd ~/.dotfiles
git pull origin main
./script/bootstrap.fish
```

## Revert

Reverting is not totally automated, but it pretty much consists in removing
the fish config and dotfiles folder, as well as moving back some config files.

```console
rm -rf ~/.dotfiles $__fish_config_dir
rm -rf ~/.config/opencode ~/.config/ocx
bun remove --global ocx
```

The bootstrap script would have created a bunch of symlinks that will now be broken.
You will have to investigate those manually.
Where a file already existed, bootstrap moved it to `<name>.backup` (see the
list above); move those back. Overwritten `conf.d` files can't be restored.

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

## Terminals

Warp and Rio are configured to behave the same: `warp/settings.toml` and
`rio/config.toml` are symlinked into place by bootstrap. Both show the same
Starship prompt (from `starship/config.toml`), and both send Alt from left
Option so herdr's shortcuts work. See `AGENTS.md` for how they're kept in sync.

## OpenCode

OpenCode configuration lives in a **separate repo** —
[`stvmachine/opencode-config`](https://github.com/stvmachine/opencode-config) —
because it changes far more often than the rest of these dotfiles. `opencode/install.fish`
clones (or pulls) that repo directly into `~/.config/opencode` during bootstrap, then
rebuilds the generated preset config.

That repo holds `opencode.jsonc`, the OCX 3 profiles (`ocx/`),
`oh-my-opencode-slim` presets, and vendored skills. See its
README and `docs/PROFILES.md` for the profile → preset mapping and setup details.

Besides cloning, `opencode/install.fish` sets up `~/.config/ocx` from the
repo's `ocx/`, rebuilds the presets, and installs `ocx@next` with bun.
`opencode/conf.d/ocx.fish` puts `~/.bun/bin` on PATH so `ocx` resolves.

### Install

```console
cd ~/.dotfiles
./script/bootstrap.fish   # clones/updates ~/.config/opencode from opencode-config
```

> First-time setup needs the `github-personal` SSH key, since the clone is over
> SSH: run `add-github-profile personal "<name>" "<email>"` (see
> [SSH keys / GitHub](#ssh-keys--github)), then re-run bootstrap.

### GSD-core

GSD workflows and agents install on top of this OpenCode setup. The install
command, its Node requirement, and the cleanup it needs afterwards are in the
opencode-config README's "GSD Core" section.

## Mac Setup

### macOS defaults

You use it by running:

```console
~/.dotfiles/macos/set-defaults.sh
```

And logging out and in again or restart.


## Acknowledge

Thanks to alexramirez: <https://github.com/alexramirez/mac-setup>
