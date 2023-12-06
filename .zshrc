### Internal Utility Functions ###

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 &>/dev/null )
}


### Aliases ###
alias ls='ls -lAFh'
alias trail='<<<${(F)path}'

# eza is a fancy replacement for ls
if _has eza ; then
  alias l='ls -lAFh'
  alias ls='eza -laFh --git'
  alias eza='eza -laFh --git'
fi

# bat is fancy replacement for cat
if _has bat ; then
  alias cat=bat
fi


### Variables ###
export DOTFILES_DIR="$HOME/.dotfiles"


### Functions ###
mkcd() {
  mkdir -p "$@" && cd "$_";
}

is-executable() {
  return $( whence $1 &>/dev/null )
}


### Prompt ###
PROMPT='%1~ %# '


### PATH ###
# Functions which modify the path given a directory, but only if the directory exists and is not already in the path.
_prepend_to_path() {
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($1 $path);
  fi
}

_append_to_path() {
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($path $1);
  fi
}

_force_prepend_to_path() {
  path=($1 ${(@)path:#$1})
}

_append_to_path "${HOME}/.bin"

# Can also be used to deduplicate $PATH
#typeset -U path