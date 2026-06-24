#!/usr/bin/env bash

# Dotfiles setup script using GNU Stow
# This script creates symlinks from your home directory to files in this repo

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up dotfiles from $DOTFILES_DIR"
echo

cd "$DOTFILES_DIR"

# Get all directories (these are our "packages")
# Exclude .git and any hidden directories
for package in */; do
    package=${package%/}  # Remove trailing slash

    # Skip if it's not a directory or is hidden
    [[ -d "$package" ]] || continue
    [[ "$package" == .* ]] && continue

    echo "Stowing $package..."
    stow -v -t "$HOME" "$package"
done

echo
echo "✓ Dotfiles setup complete!"
echo "All symlinks have been created in your home directory."
