#!/usr/bin/env fish

# Link the Warp settings file. Warp writes UI changes through the link (so they
# land in this repo), but it rewrites the whole file, dropping comments; keep
# explanations in AGENTS.md, not in settings.toml.
mkdir -p ~/.warp
ln -sf $DOTFILES/warp/settings.toml ~/.warp/settings.toml
