#!/usr/bin/env bash

# Uncomment below line for "debug mode"
# set -x

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Running from $PWD"

# Initialize a few directories.
init_dirs () {
  echo 'Creating ~/Code'
  mkdir -p "$HOME/Code"
  echo 'Creating ~/Tools'
  mkdir -p "$HOME/Tools"
  echo 'Directories created'
}

backup() {
  [ -e "$HOME/$1" ] && mv "$HOME/$1" "$HOME/$1.bak"
}

move_link() {
  backup "$1"
  from="$SCRIPT_PATH/$2"
  to="$HOME/$1"
  new_path="$(dirname "$to")"
  mkdir -p "$new_path"
  ln -s "$from" "$to"
}

init_links () {
  echo "Ready to symlink dotfiles? (y/n)"
  read -r resp

  if [ "$resp" = 'y' ] || [ "$resp" = 'Y' ] ; then
    move_link .shell_variables shell/variables
    move_link .shell_aliases shell/aliases
    move_link .bashrc shell/bashrc
    move_link .profile shell/profile
    move_link .zshrc shell/zshrc
    move_link .config/tmux tmux
    move_link .config/nvim nvim
    move_link .gitconfig git/gitconfig
    move_link .config/alacritty/alacritty.yml terminals/alacritty.yml
    echo "Symlinking complete"
  else
    echo "Symlinking cancelled by user"
    exit 1
  fi
}

install_zinit() {
  ZINIT_HOME="$HOME/.zinit"
  if [[ ! -f "$ZINIT_HOME/bin/zinit.zsh" ]]; then
    echo "Zinit not installed. Installing..."
    command mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME/bin" && \
      echo "Zinit installed." || \
      echo "Zinit installation failed."
  fi
}

install_packer_nvim() {
  NVIM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
  PACKER_NVIM_FILE="$NVIM_HOME/site/pack/packer/start/packer.nvim"
  if [[ ! -d "$PACKER_NVIM_FILE" ]]; then
    echo "packer.nvim not installed. Installing..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
      "$PACKER_NVIM_FILE" &&
      echo "packer.nvim installed. Don't forget to run :PlugInstall when opening nvim for the first time!" || \
      echo "packer.nvim installation failed."
  fi
}

install_tpm() {
  TMUX_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
  TPM_PATH="$TMUX_HOME/plugins/tpm"
  if [[ -d "$TPM_PATH" ]]; then
    return
  fi

  echo "TPM not installed. Installing..."
  git clone https://github.com/tmux-plugins/tpm \
    "$TPM_PATH" && 
    echo "TPM installed. Don't forget to press prefix + I when opening tmux for the first time!" || \
    echo 'TPM installation failed.'
}

install_tools () {
  install_zinit
  install_packer_nvim
  install_tpm
}

install_tools
init_dirs
init_links
command zsh
