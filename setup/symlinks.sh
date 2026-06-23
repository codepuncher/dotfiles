#!/usr/bin/env bash
# shellcheck disable=SC2154  # SCRIPT_PATH is set by setup.sh, which sources this file

init_dirs() {
  section_start 'Creating ~/{Code/{misc,go,wordpress},Tools}'
  mkdir -p "${HOME}"/{Code/{misc,go,wordpress},Tools}
}

backup() {
  [ -e "${HOME}/${1}" ] && mkdir -p "${SCRIPT_PATH}/backups/$(dirname "${2}")" && mv "${HOME}/${1}" "${SCRIPT_PATH}/backups/${2}"
}

move_link() {
  if backup "${1}" "${2}"; then
    echo "${1} backed up"
  fi

  local from="${SCRIPT_PATH}/${2}"
  local to="${HOME}/${1}"
  local new_path
  new_path="$(dirname "${to}")"
  mkdir -p "${new_path}"
  ln -sf "${from}" "${to}"
}

init_links() {
  move_link .shell_variables shell/variables
  move_link .shell_aliases shell/aliases
  move_link .bashrc shell/bashrc
  move_link .profile shell/profile
  move_link .zshrc shell/zshrc
  move_link .config/tmux tmux
  move_link .config/nvim nvim
  move_link .gitconfig git/gitconfig
  move_link .config/spaceship.zsh shell/spaceship.zsh
  move_link .config/alacritty/alacritty.toml terminals/alacritty.toml
  move_link .config/ghostty/config terminals/ghostty
  move_link .config/spotifyd/spotifyd.conf media/spotifyd.conf
  move_link .config/fontconfig fontconfig
  move_link .config/ngrok/ngrok.yml web/ngrok.yml
  move_link .config/systemd/user/corsair-headset.service systemd/corsair-headset.service
}
