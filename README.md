# dotfiles
My dotfiles, used on Ubuntu, Arch and macOS systems.

## Requirements
- ZSH
  - macOS: `brew install zsh && chsh -s $(which zsh)`
  - Ubuntu: `sudo apt install zsh && chsh -s $(which zsh)`
- Git 
  - macOS: `brew install git`
  - Ubuntu: `sudo apt install zsh && chsh -s $(which zsh)`
- Neovim
  - macOS: `brew install neovim`
  - Ubuntu: `sudo apt install neovim`

## Installation
1. `git clone git@github.com:codepuncher/dotfiles.git ~/.dotfiles`
3. `~/.dotfiles/setup.sh`
3. Choose `y` to symlink the dotfiles
4. The script will finish and run `command zsh` for you, loading the new dotfiles
5. Finish the installation by running `vim` (aliased to `nvim`) and then `:PlugInstall` to install the `neovim` plugins

## Features
1. Many [aliases](https://github.com/codepuncher/dotfiles/blob/master/bash/bash_aliases)
2. Supports loading any alias files from `~/.aliases`
3. Supports loading [`~/.env`](https://github.com/codepuncher/dotfiles/blob/master/.env.example) for secrets
4. Automatically installs [Zinit](https://github.com/zdharma/zinit/pull)
5. [zsh-users/zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
6. [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
7. [zsh-users/zsh-completions](https://github.com/zsh-users/zsh-completions)
8. [zdharma/fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)
9. [lukechilds/zsh-nvm](https://github.com/lukechilds/zsh-nvm)
    1. [Auto Use](https://github.com/lukechilds/zsh-nvm#auto-use)
10. [OMZP::npm](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/npm)
11. [denysdovhan/spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt)
12. [trellis-cli](https://github.com/roots/trellis-cli) `virtualenv` integration
13. iTerm2 shell integration (macOS only)
