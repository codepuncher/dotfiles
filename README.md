# dotfiles

My dotfiles, used on Ubuntu, Arch and macOS systems.

## Requirements

- ZSH
  - macOS: `brew install zsh && chsh -s $(which zsh)`
  - Ubuntu: `sudo apt install zsh && chsh -s $(which zsh)`
  - Arch: `sudo pacman -S zsh && chsh -s $(which zsh)`
- Git
  - macOS: `brew install git`
  - Ubuntu: `sudo apt install git`
  - Arch: `sudo pacman -S git`
- Neovim v0.8+
  - macOS: `brew install neovim` or `brew install --HEAD luajit neovim` for latest development version
  - Ubuntu: `sudo apt install neovim`
  - Arch: `sudo pacman -S neovim` or `sudo pacman -S neovim-nightly-bin` for latest development version

## Installation

1. `git clone git@github.com:codepuncher/dotfiles.git ~/.dotfiles`
2. `~/.dotfiles/setup.sh`
3. Choose `y` to symlink the dotfiles
4. The script will finish and run `command zsh` for you, loading the new dotfiles

## Features

1. Many [aliases](https://github.com/codepuncher/dotfiles/blob/master/shell/aliases)
2. Supports loading any alias files from `~/.aliases`
3. Supports loading [`~/.env`](https://github.com/codepuncher/dotfiles/blob/master/.shell_env.example) for secrets
4. Automatically installs [Zinit](https://github.com/zdharma-continuum/zinit)
5. [zsh-users/zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
6. [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
7. [zsh-users/zsh-completions](https://github.com/zsh-users/zsh-completions)
8. [zdharma/fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)
9. [OMZP::npm](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/npm)
10. [OMZP::composer](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/composer)
11. [spaceship-prompt/spaceship-prompt](https://github.com/spaceship-prompt/spaceship-prompt)
12. [trellis-cli](https://github.com/roots/trellis-cli) `virtualenv` integration
13. iTerm2 shell integration (macOS only)
14. Alacritty config (JetBrains Mono Font, TokyoNight colours)
