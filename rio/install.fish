#!/usr/bin/env fish

# Link the Rio config file
mkdir -p ~/.config/rio
ln -sf $DOTFILES/rio/config.toml ~/.config/rio/config.toml
