#!/bin/zsh

# ###########################################################
# Preparations
# ###########################################################

# Set error handling
set -eo pipefail

# ###########################################################
# Set variables
# ###########################################################

DOTFILES_DIR="$HOME/.dotfiles"
BIN_DIR="$HOME/.bin"

# ###########################################################
# Define Functions
# ###########################################################

# Function to determine if the provided command is executable
function is-executable() {
  return $(whence $1 &>/dev/null)
}

# Robust symlinking
function symlink() {
  src="$1"
  dest="$2"

  # Check if destination already exists
  if [ -e "$dest" ]; then
    # Check if destination is a symbolic link
    if [ -L "$dest" ]; then
      # Check if symbolic link is broken
      if [ ! -e "$dest" ]; then
        echo "Removing broken symlink at $dest"
        rm "$dest"
      else
        # Already symlinked -- I'll assume correctly.
        return 0
      fi
    else
      # Rename files with a ".bak" extension.
      echo "$dest already exists, renaming to $dest.bak"
      mv -f "$dest" "$dest.bak"
    fi
  fi
  ln -sf "$src" "$dest"
}

# ###########################################################
# Symlinking Dotfiles
# ###########################################################

echo "Creating symlinks..."
for item in "$DOTFILES_DIR/config/*"; do
  case "$item" in
  . | .. | .git)
    continue
    ;;
  *)
    symlink "$DOTFILES_DIR/$item" "$HOME/$(basename $item)"
    ;;
  esac
done

echo "Adding executables to ~/.bin/..."
mkdir -p "$BIN_DIR"
for item in bin/*; do
  symlink "$DOTFILES_DIR/$item" "$BIN_DIR/$(basename $item)"
done

