# AGENTS.md

Orientation for AI agents working in this repo. Update this file in the same
change whenever conventions, structure, or workflows change.

## What this is

Personal dotfiles for **macOS** with the **fish** shell, forked from
caarlos0/dotfiles.fish. No Ansible or nix: just symlinks, fish snippets, and a
few helpers. `./script/bootstrap.fish` applies everything; README.md has the
install order (Homebrew → clone → `brew bundle` → bootstrap).

## Layout

Each top-level directory is a topic (`git/`, `starship/`, `rio/`, ...). The
bootstrap picks these up by convention, so a new topic needs no registration:

- `*.symlink`: linked to `~/.<name>` (existing files are moved to `.backup`).
- `install.fish`: run by bootstrap in alphabetical order. Topics that link
  into `~/.config` do it here with `ln -sf $DOTFILES/...`.
- `conf.d/*.fish`: linked into `~/.config/fish/conf.d/`, overwriting files with
  the same name (no backup).
- `functions/`: added to `fish_function_path`.
- `bin/`: on PATH.

Notable topics:

- `macos/`: `Brewfile` (all apps and CLIs) and `set-defaults.sh` (macOS
  defaults; Dock apps come from `macos/dock.<hostname>.txt` when that file
  exists).
- `opencode/`: only clones the separate `stvmachine/opencode-config` repo into
  `~/.config/opencode`. Change OpenCode config in that repo, not here.
- `git/`, `ssh/`, `bin/git-profile-*`: per-repo work/personal identities.

## Conventions

- Commit messages are conventional with a scope: `feat(macos): ...`,
  `chore(homebrew): ...`, `docs: ...`.
- This repo is personal: commit as the personal profile (`gpersonal` /
  `git-profile-personal` sets it). Never commit as the work identity.
- Never commit secrets or private keys. SSH keys live only in `~/.ssh/`.
- Default branch is `main`.

## Keep the Warp and Rio configs in sync

Warp and Rio are the two terminal emulators, used interchangeably. They must
stay behavior-equivalent. When you change one, mirror the change in the other
in the same commit.

| Terminal | Repo file | Linked to |
| --- | --- | --- |
| Warp | `warp/settings.toml` | `~/.warp/settings.toml` |
| Rio | `rio/config.toml` | `~/.config/rio/config.toml` |

- Each Rio setting has a comment naming the Warp setting it mirrors. Keep that
  up to date; it is how the two files are compared.
- Warp rewrites `settings.toml` through the symlink whenever a setting changes
  in its UI, and drops comments when it does. Keep explanations in `rio/` or
  here, never in `warp/settings.toml`. After using Warp's settings UI, check
  `git diff warp/` and mirror any change into Rio.
- Warp may not reload edits made to the repo file; restart it to be sure.
- The prompt is shared, not per-terminal: both run fish, which loads Starship
  (`starship/config.toml`). Starship's glyphs need a Nerd Font, so Rio uses
  "DroidSansM Nerd Font Mono" (from the Brewfile); Warp falls back to its
  bundled fonts. Warp must keep `honor_ps1 = true` to show Starship.
- herdr (agent multiplexer, run inside either terminal) needs Option to send
  Alt: Warp `extra_meta_keys.left_alt = true`, Rio `option-as-alt = "left"`.

Known divergences, where one terminal has no equivalent. Keep them as comments
in `rio/config.toml` rather than silently differing:

- Warp-only features have no Rio counterpart: agent mode, Warp Drive, the code
  editor panels, and the AI execution profile.
- Warp's vertical tabs: Rio 0.5 has no vertical or sidebar tab mode, so it uses
  its regular tab bar.
- Font: Warp uses its bundled Hack; Rio uses the Nerd Font at the same 13pt.

Before finishing a change to either file, compare them setting by setting and
confirm every shared behavior still matches.
