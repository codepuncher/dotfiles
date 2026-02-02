#!/usr/bin/env bash

# Set "strict mode"
set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE%/*}"
if [[ -f "${SCRIPT_PATH}/shell/functions" ]]; then
  source "${SCRIPT_PATH}/shell/functions"
fi

section_start "Running from ${PWD}"

# Initialize a few directories.
init_dirs() {
  section_start 'Creating ~/{Code/{misc,go,wordpress},Tools}'
  mkdir -p "${HOME}"/{Code/{misc,go,wordpress},Tools}
}

backup() {
  [ -e "${HOME}/${1}" ] && mkdir -p "${SCRIPT_PATH}/backups/$(dirname "${2}")" && mv "${HOME}/${1}" "${HOME}/.dotfiles/backups/${2}"
}

move_link() {
  backup "${1}" "${2}"
  from="${SCRIPT_PATH}/${2}"
  to="${HOME}/${1}"
  new_path="$(dirname "${to}")"
  mkdir -p "${new_path}"
  ln -s "${from}" "${to}"
}

init_links() {
  section_start 'Symlink dotfiles? [y/n]'
  read -r resp
  if [ "${resp}" = 'y' ] || [ "${resp}" = 'Y' ]; then
    move_link .shell_variables shell/variables
    move_link .shell_aliases shell/aliases
    move_link .bashrc shell/bashrc
    move_link .profile shell/profile
    move_link .zshrc shell/zshrc
    move_link .config/tmux tmux
    move_link .config/nvim nvim
    move_link .gitconfig git/gitconfig
    move_link .config/alacritty/alacritty.toml terminals/alacritty.toml
    move_link .config/ghostty/config terminals/ghostty
    move_link .config/spotifyd/spotifyd.conf media/spotifyd.conf
    move_link .config/fontconfig fontconfig
    move_link .config/ngrok/ngrok.yml web/ngrok.yml

    echo "Symlinking complete. Backups stored in ${SCRIPT_PATH}/backups."
    return
  fi

  echo 'Symlinking cancelled by user'
}

install_packages() {
  # TODO: support macOS
  if [[ ! "${OSTYPE}" =~ ^linux ]]; then
    return
  fi

  section_start 'Install packages? [y/n]'
  read -r resp
  if [ "${resp}" != 'y' ] && [ "${resp}" != 'Y' ]; then
    return
  fi

  if grep --quiet 'ID=manjaro' /etc/os-release; then
    # shellcheck disable=2119
    install_arch_packages
    post_install_packages
    setup_arch_services
    post_setup_arch_services
  elif grep --quiet --ignore-case microsoft /proc/sys/kernel/osrelease; then
    install_wsl_packages
  fi
  # shellcheck disable=2119
  install_go_packages
}

install_zinit() {
  ZINIT_HOME="${HOME}/.zinit"
  if [[ ! -f "${ZINIT_HOME}/bin/zinit.zsh" ]]; then
    echo 'Zinit not installed. Installing...'
    command mkdir -p "${ZINIT_HOME}" && command chmod g-rwX "${ZINIT_HOME}"
    command git clone https://github.com/zdharma-continuum/zinit "${ZINIT_HOME}/bin" &&
      echo 'Zinit installed.' ||
      echo 'Zinit installation failed.'
  fi
}

install_tpm() {
  TMUX_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}/tmux"
  TPM_PATH="${TMUX_HOME}/plugins/tpm"
  if [[ -d "${TPM_PATH}" ]]; then
    return
  fi

  echo 'TPM not installed. Installing...'
  git clone https://github.com/tmux-plugins/tpm \
    "${TPM_PATH}" &&
    echo "TPM installed. Don't forget to press prefix + I when opening tmux for the first time!" ||
    echo 'TPM installation failed.'
}

install_composer() {
  section_start 'Installing Composer'
  EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "${EXPECTED_CHECKSUM}" != "${ACTUAL_CHECKSUM}" ]; then
    echo >&2 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    return
  fi

  php composer-setup.php --quiet
  rm composer-setup.php
  sudo mv composer.phar /usr/local/bin/composer
  # shellcheck disable=2119
  install_composer_packages
}

install_tools() {
  section_start 'Install tools? [y/n]'
  read -r resp
  if [ "${resp}" != 'y' ] && [ "${resp}" != 'Y' ]; then
    return
  fi

  install_nvm
  install_zinit
  install_tpm
  install_composer
}

install_packages
install_tools
init_dirs
init_links
if [[ "${SHELL}" != */zsh ]]; then
  chsh -s "$(which zsh)"
fi
command zsh
