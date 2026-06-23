#!/usr/bin/env bash

install_zinit() {
  local ZINIT_HOME="${HOME}/.zinit"
  if [[ -f "${ZINIT_HOME}/bin/zinit.zsh" ]]; then
    return
  fi

  echo 'Zinit not installed. Installing...'
  command mkdir -p "${ZINIT_HOME}" && command chmod g-rwX "${ZINIT_HOME}"
  if command git clone https://github.com/zdharma-continuum/zinit "${ZINIT_HOME}/bin"; then
    echo 'Zinit installed.'
    return
  fi
  echo 'Zinit installation failed.' >&2
  return 1
}

install_tpm() {
  local TMUX_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}/tmux"
  local TPM_PATH="${TMUX_HOME}/plugins/tpm"
  if [[ -d "${TPM_PATH}" ]]; then
    return
  fi

  echo 'TPM not installed. Installing...'
  if git clone https://github.com/tmux-plugins/tpm "${TPM_PATH}"; then
    echo "TPM installed. Don't forget to press prefix + I when opening tmux for the first time!"
    return
  fi
  echo 'TPM installation failed.' >&2
  return 1
}
