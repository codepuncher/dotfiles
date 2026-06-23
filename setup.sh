#!/usr/bin/env bash

SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
source "${SCRIPT_PATH}/shell/os.sh"

for f in common symlinks packages-arch packages-wsl languages tools services; do
  # shellcheck source=/dev/null
  source "${SCRIPT_PATH}/setup/${f}.sh"
done

usage() {
  cat <<'EOF'
Usage: ./setup.sh [options]

Options:
  --reinstall   Wipe installed tool/runtime dirs, then run the full setup.
  -h, --help    Show this help.

With no options, runs the interactive flow: prompts for packages and tools,
then creates directories and symlinks.
EOF
}

reinstall() {
  rm -rf ~/.{local/bin,npm,nvm,zinit,go/bin,config/composer/vendor,nvim,config/nvim}
}

run_packages() {
  # TODO: support macOS
  if [[ ! "${OSTYPE}" =~ ^linux ]]; then
    return
  fi

  section_start 'Install packages? [y/n]'
  read -r resp
  if [ "${resp}" != 'y' ] && [ "${resp}" != 'Y' ]; then
    return
  fi

  if is_arch; then
    # shellcheck disable=2119
    install_arch_packages
    post_install_packages
    setup_arch_services
    post_setup_arch_services
  elif is_wsl; then
    install_wsl_packages
    post_setup_wsl_services
  fi

  # shellcheck disable=2119
  install_go_packages
  # shellcheck disable=SC2119
  install_pip_packages
}

run_tools() {
  section_start 'Install tools? [y/n]'
  read -r resp
  if [ "${resp}" != 'y' ] && [ "${resp}" != 'Y' ]; then
    return
  fi

  install_zinit
  install_tpm
  # shellcheck disable=SC2119
  install_node_packages
  install_composer
}

run_links() {
  section_start 'Symlink dotfiles? [y/n]'
  read -r resp
  if [ "${resp}" != 'y' ] && [ "${resp}" != 'Y' ]; then
    echo 'Symlinking cancelled by user'
    return
  fi

  init_links
  echo "Symlinking complete. Backups stored in ${SCRIPT_PATH}/backups."
}

main() {
  case "${1:-}" in
  -h | --help)
    usage
    return 0
    ;;
  --reinstall)
    reinstall
    ;;
  '') ;;
  *)
    echo "Unknown option: ${1}" >&2
    usage
    return 1
    ;;
  esac

  section_start "Running from ${PWD}"

  run_packages
  run_tools
  init_dirs
  run_links

  if [[ "${SHELL}" != */zsh ]]; then
    chsh -s "$(which zsh)"
    command zsh
  else
    echo 'Restart your terminal'
  fi
}

main "$@"
