#!/bin/bash

# Debug mode
# set -x

echo Running from $(pwd)

# Initialize a few things
init_dirs () {
  echo "Creating ~/Code"
  mkdir -p ~/Code
  echo "Creating ~/Tools"
  mkdir -p ~/Tools
}

move() {
  [ -e $HOME/$1 ] && mv $HOME/$1 $HOME/$1.bak
}

move_link() {
  move $1
  from="$(pwd)/$2"
  to="$HOME/$1"
  new_path=`dirname $to`
  mkdir -p $new_path
  ln -sv $from $to
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
    move .vimrc
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
