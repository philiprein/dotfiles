#!/usr/bin/env zsh

SOURCE="https://github.com/philiprein/dotfiles"
TARBALL="$SOURCE/tarball/main"
TARGET="$HOME/.dotfiles"
TAR_CMD="tar -xzv -C "$TARGET" --strip-components=1 --exclude='{.gitignore}'"

function is-executable() {
  return $( whence $1 &> /dev/null )
}

if is-executable "git"; then
  CMD="git clone $SOURCE $TARGET"
elif is-executable "curl"; then
  CMD="curl -#L $TARBALL | $TAR_CMD"
elif is-executable "wget"; then
  CMD="wget --no-check-certificate -O - $TARBALL | $TAR_CMD"
fi

if [ -z "$CMD" ]; then
  echo "No git, curl or wget available. Aborting."
else
  echo "Installing dotfiles..."
  mkdir -p "$TARGET"
  eval "$CMD"
fi