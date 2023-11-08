#!/usr/bin/env zsh

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
# Disable Gatekeeper for casks installed by Homebrew
export HOMEBREW_CASK_OPTS="--no-quarantine"

# ###########################################################
# Define Functions
# ###########################################################

# Function to determine if the provided command is executable
function is-executable() {
  return $(whence $1 &>/dev/null)
}

# Function to determine if the underlying OS is macOS based on the presence of a command specific to macOS, 'sw_vers'
function is-macos() {
  return $(whence sw_vers &>/dev/null)
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
# Install Xcode Command Line Tools
# ###########################################################

echo "Installing Xcode Command Line Tools..."
# Check if Xcode Command Line Tools are already installed
if ! xcode-select --print-path &>/dev/null; then

  # Prompt user to install the Xcode Command Line Tools
  xcode-select --install &>/dev/null

  # Wait until the Xcode Command Line Tools are installed
  until xcode-select --print-path &>/dev/null; do
    sleep 5
  done
  if [[ $? != 0 ]]; then
    error "Unable to install Xcode Command Line Tools, exiting..."
    exit 2
  else
    echo 'Xcode Command Line Tools installed successfully.'
    # Prompt user to agree to the terms of the Xcode license
    sudo xcodebuild -license
  fi
else
  echo "Skipping install of Xcode Command Line Tools. They are already installed."
fi

# ###########################################################
# Install Homebrew
# ###########################################################

echo "Installing Homebrew..."
if ! is-executable brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ $? != 0 ]]; then
    error "Unable to install Homebrew, exiting..."
    exit 2
  else
    echo 'Homebrew installed successfully.'
  fi
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew analytics off
else
  echo "Skipping install of Homebrew. It is already installed."
fi
echo "Updating Homebrew..."
brew update && brew upgrade
brew doctor

# ###########################################################
# Install Homebrew Formulae, Casks, Mac App Store Apps
# ###########################################################

echo "Installing Homebrew formulae, casks and Mac App Store apps..."
brew bundle --file=$(DOTFILES_DIR)/install/Brewfile --verbose

echo "Cleaning up Homebrew..."
brew cleanup --force &>/dev/null
rm -rf /Library/Caches/Homebrew/* &>/dev/null

# ###########################################################
# Symlinking Dotfiles
# ###########################################################

echo "Creating symlinks..."
for item in config/*; do
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

# ###########################################################
# MacOS Settings
# ###########################################################

echo "Applying macOS settings..."

. "$DOTFILES_DIR/macos/defaults.sh"
. "$DOTFILES_DIR/macos/dock.sh"
