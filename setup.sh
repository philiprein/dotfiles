#!/bin/zsh

set -eo pipefail


### variables

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO_URL="https://github.com/philiprein/dotfiles.git"
BIN_DIR="$HOME/.bin"


### functions

# function for robust symlinking
function symlink() {
  src="$1"
  dest="$2"

  # check if destination already exists
  if [ -e "$dest" ]; then
    # check if destination is a symbolic link
    if [ -L "$dest" ]; then
      # check if symbolic link is broken
      if [ ! -e "$dest" ]; then
        # symlink is broken
        echo "Removing broken symlink at $dest..."
        rm "$dest"
      else
        # symlink already exists
        echo "$src is already symlinked to $dest. Skipping..."
        return 0
      fi
    else
      # Rename files with a ".bak" extension
      echo "$dest already exists, renaming to $dest.bak..."
      mv -f "$dest" "$dest.bak"
    fi
  fi
  echo "Symlinking $src to $dest..."
  ln -sf "$src" "$dest"
}


### script

# check if git is installed
if ! whence -p git &>/dev/null; then
  echo "git is not installed. Exiting..."
  exit 1
fi

# install dotfiles using git
if [ -d "$DOTFILES_DIR/.git" ]; then
  echo "Updating dotfiles..."
  cd "$DOTFILES_DIR"
  git pull --quiet --rebase origin main || exit 1
else
  echo "Downloading dotfiles..."
  rm -rf "$DOTFILES_DIR"
  git clone --quiet --depth=1 "$DOTFILES_REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# create symlinks
echo "Creating symlinks..."
for item in .*; do
  case "$item" in
  . | .. | .git)
    continue
    ;;
  *)
    symlink "$DOTFILES_DIR/$item" "$HOME/$item"
    ;;
  esac
done

# add executeables
echo "Adding executables to ~/.bin/..."
mkdir -p "$BIN_DIR"
for item in bin/* ; do
  symlink "$DOTFILES_DIR/$item" "$BIN_DIR/$(basename $item)"
done