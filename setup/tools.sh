#!/usr/bin/env bash

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
  # shellcheck disable=SC2031
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
