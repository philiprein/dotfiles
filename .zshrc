# Aliases

alias ls='ls -lAFh'

# Functions

function mkcd() {
 mkdir -p "$@" && cd "$_";
}

# Prompt

PROMPT='%1~ 👉%  '


