# dotfiles
These are my dotfiles. I mostly use them on macOS and Linux but to keep the environment in sync.

# Installation

1. Install this repo with `curl` available:

```zsh
zsh -c "`curl -fsSL https://raw.githubusercontent.com/philiprein/dotfiles/main/remote_setup.sh`"
```

This will clone or download this repo to `~/.dotfiles` (depending on the availability of `git`, `curl` or `wget`).

1. Alternatively, clone manually into the desired location:

```zsh
git clone https://github.com/philiprein/dotfiles.git ~/.dotfiles
```

Use the [setup.sh](./setup.sh) script to start the setup:

```zsh
cd ~/.dotfiles
./setup.sh
```

# Credits

I first got the idea from watching Fireship's [video](https://www.youtube.com/watch?v=r_MpUP6aKiQ) about dotfiles and taking Patrick McDonald's fantastic [course](https://dotfiles.eieio.xyz) on Udemy. When building my own, I got inspiration from the [dotfiles community](https://dotfiles.github.io) on GitHub. This dotfiles repo was mainly inspired by [Ian Langworth's dotfiles](https://github.com/statico/dotfiles).