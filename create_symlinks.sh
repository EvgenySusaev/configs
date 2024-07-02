#!/bin/bash

# Define target directories
target_dir="$HOME/.config/nvim"


current_dir=$(pwd)
nvim_config_dir="$current_dir/nvim"

# Ensure nvim config directory exists
if [ ! -d "$nvim_config_dir" ]; then
    echo "Neovim config directory '$nvim_config_dir' does not exist. Aborting."
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$target_dir"

# Remove existing ~/.config/nvim if it exists and is not a symlink
if [ -e "$target_dir" ] && [ ! -L "$target_dir" ]; then
    echo "Moving existing non-symlinked '$target_dir' to backup..."
    mv "$target_dir" "$target_dir.backup"
fi

# Create symbolic link
ln -sf "$nvim_config_dir" "$target_dir"

echo "Symbolic link created: $nvim_config_dir -> $target_dir"

