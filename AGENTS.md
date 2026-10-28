# AGENTS.md

Orientation for AI agents working in this repo. Keep this file up to date in the
same change whenever conventions, structure, or workflows change.

## What this is

My personal dotfiles, applied with a plain shell script (`./setup`). No Ansible,
no nix — just symlinks and a few helpers. Must run on **macOS**.

## Keep terminal emulator configs in sync

`zed` and `rio` configure two terminal emulators that I
use interchangeably. **They must stay behavior-equivalent.** Whenever you change
one, mirror the change in the other in the same commit:

When only one emulator supports a given option, document why in a comment rather
than silently diverging. Before finishing any change to one of these files,
diff the two and confirm the shared settings still match.
