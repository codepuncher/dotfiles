#!/usr/bin/env bash

section_start() {
  printf '%*s\n' "${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}" '' | tr ' ' -
  echo "${1}"
}

detect_aur_helper() {
  local h
  for h in paru pamac yay; do
    if command -v "${h}" &>/dev/null; then
      AUR_HELPER="${h}"
      return 0
    fi
  done
  echo 'No supported AUR helper (paru/pamac/yay) found' >&2
  return 1
}

arch_install() {
  [[ -n "${AUR_HELPER:-}" ]] || detect_aur_helper || return 1
  local cmd
  case "${AUR_HELPER}" in
  paru | yay) cmd=("${AUR_HELPER}" -S --noconfirm --needed "$@") ;;
  pamac) cmd=(sudo pamac install --no-confirm --no-upgrade "$@") ;;
  *)
    echo "Unknown AUR helper: ${AUR_HELPER}" >&2
    return 1
    ;;
  esac
  if [[ -n "${DRY:-}" ]]; then
    echo "${cmd[*]}"
    return 0
  fi
  "${cmd[@]}"
}

enable_aur() {
  [[ -n "${AUR_HELPER:-}" ]] || detect_aur_helper || return 1
  [[ "${AUR_HELPER}" == pamac ]] || return 0
  [[ -n "${DRY:-}" ]] && return 0
  sudo sed -Ei '/EnableAUR/s/^#//' /etc/pamac.conf
}

is_arch() {
  local id id_like
  # shellcheck disable=SC1091
  id="$(. /etc/os-release 2>/dev/null && echo "${ID:-}")"
  # shellcheck disable=SC1091
  id_like="$(. /etc/os-release 2>/dev/null && echo "${ID_LIKE:-}")"
  [[ "${id}" == arch ]] || [[ " ${id_like} " == *' arch '* ]]
}

gh_get_latest_tag() {
  if [[ -z "${1}" ]]; then
    echo 'No repo provided' >&2
    return 1
  fi

  TIMEOUT=90
  curl --silent --location --max-time "${TIMEOUT}" "https://api.github.com/repos/${1}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}
