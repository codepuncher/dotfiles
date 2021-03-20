#!/usr/bin/env bash

# Uncomment below line for "debug mode"
# set -x

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Running from $PWD"

# Initialize a few directories.
init_dirs () {
  echo "Creating ~/Code"
  mkdir -p "$HOME/Code"
  echo "Creating ~/Tools"
  mkdir -p "$HOME/Tools"
}

backup() {
  [ -e $HOME/$1 ] && mv $HOME/$1 $HOME/$1.bak
}

move_link() {
  backup $1
  from="$SCRIPT_PATH/$2"
  to="$HOME/$1"
  new_path="$(dirname "$to")"
  mkdir -p "$new_path"
  ln -s "$from" "$to"
}

init_links () {
  echo "Ready to symlink dotfiles? (y/n)"
  read resp

  if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
    move_link .bashrc bash/bashrc
    move_link .profile bash/profile
    move_link .bash_aliases bash/bash_aliases
    move_link .aliases/overrides bash/aliases/overrides
    move_link .zshrc zsh/zshrc
    move_link .vim vim
    backup .vimrc
    move_link .config/nvim nvim
    move_link .gitconfig git/gitconfig
    echo "Symlinking complete"
  else
    echo "Symlinking cancelled by user"
    return 1
  fi
}

# TODO: Install tools like git, valet etc.
# install_tools () {
# }

# install_tools
init_dirs
init_links
