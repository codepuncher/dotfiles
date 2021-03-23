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
    move_link .vim vim
    backup .vimrc
    move_link .config/nvim nvim
    move_link .gitconfig git/gitconfig
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
    command git clone https://github.com/zdharma/zinit "$ZINIT_HOME/bin" && \
      echo "Zinit installed." || \
      echo "Zinit installation failed."
  fi
}

install_tools () {
  install_zinit
}

install_tools
init_dirs
init_links
command zsh
