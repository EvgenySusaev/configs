#!/bin/bash

# Define target directories for Neovim
nvim_target_dir="$HOME/.config/nvim"
current_dir=$(pwd)
nvim_config_dir="$current_dir/nvim"

# Ensure Neovim config directory exists
if [ ! -d "$nvim_config_dir" ]; then
    echo "Neovim config directory '$nvim_config_dir' does not exist. Aborting."
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$nvim_target_dir"

# Backup existing ~/.config/nvim if it exists
if [ -e "$nvim_target_dir" ]; then
    echo "Backing up existing '$nvim_target_dir' to '$nvim_target_dir.bak'..."
    mv "$nvim_target_dir" "$nvim_target_dir.bak"
fi

# Create symbolic link for Neovim config
ln -sf "$nvim_config_dir" "$nvim_target_dir"
echo "Symbolic link created: $nvim_config_dir -> $nvim_target_dir"


# Define source and target locations for Git config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
git_source="$SCRIPT_DIR/git/.gitconfig"
git_target="$HOME/.gitconfig"

# Check if the Git config source file exists
if [ ! -f "$git_source" ]; then
    echo "Error: Git config '$git_source' does not exist. Aborting."
    exit 1
fi

# Backup existing ~/.gitconfig if it exists
if [ -e "$git_target" ]; then
    echo "Backing up existing '$git_target' to '$git_target.bak'..."
    mv "$git_target" "$git_target.bak"
fi

# Create the symbolic link for Git config
ln -s "$git_source" "$git_target"
echo "Symbolic link created: $git_source -> $git_target"

