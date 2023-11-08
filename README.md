# dotfiles
These are my dotfiles to setup macOS.

# Installation

On a sparkling fresh installation of macOS:

```zsh
sudo softwareupdate -i -a --verbose
```

The Xcode Command Line Tools includes `git` (not available on stock macOS). Now there are two options:

1. Install this repo with `curl` available:

```zsh
bash -c "`curl -fsSL https://raw.githubusercontent.com/philiprein/dotfiles/main/remote_setup.sh`"
```

This will clone or download this repo to `~/.dotfiles` (depending on the availability of `git`, `curl` or `wget`).

1. Alternatively, clone manually into the desired location:

```zsh
git clone https://github.com/webpro/dotfiles.git ~/.dotfiles
```

Use the [setup.sh](./setup.sh) script to start the setup:

```zsh
cd ~/.dotfiles
./setup.sh
```

# Credits

I first got the idea from watching Fireship's [video](https://www.youtube.com/watch?v=r_MpUP6aKiQ) about dotfiles and taking Patrick McDonald's fantastic [course](https://dotfiles.eieio.xyz) on Udemy. When building my own, I got inspiration from the [dotfiles community](https://dotfiles.github.io) on GitHub. This dotfiles repo was mainly inspired by [Dries Vints' dotfiles](https://github.com/driesvints/dotfiles), [Lars Kappert's dotfiles](https://github.com/webpro/dotfiles), [Ian Langworth's dotfiles](https://github.com/statico/dotfiles) and [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles). I also got some helpful scripts from [tiiiecherle](https://github.com/tiiiecherle/osx_install_config), i. e. for setting the dock in macOS.