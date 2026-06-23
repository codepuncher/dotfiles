#!/usr/bin/env bash

install_nvm() {
  section_start 'Installing NVM'
  export NVM_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/nvm"
  mkdir -p "${NVM_DIR}"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

  # Load NVM after installing it.
  # shellcheck disable=SC1091
  [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh" # This loads nvm

  nvm install --lts
  nvm use --lts
  nvm alias default node

  if command -v corepack >/dev/null 2>&1; then
    corepack enable
  fi
}

install_rustup() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

install_node_packages() {
  export NVM_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/nvm"
  # Fall back to a legacy ~/.nvm install if the XDG path has none.
  if [[ ! -s "${NVM_DIR}/nvm.sh" ]] && [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
    export NVM_DIR="${HOME}/.nvm"
  fi
  if [[ ! -s "${NVM_DIR}/nvm.sh" ]]; then
    install_nvm
  else
    # shellcheck disable=SC1091
    \. "${NVM_DIR}/nvm.sh"
  fi

  section_start 'Installing NPM packages'
  PACKAGES=(
    @ansible/ansible-language-server
    @fsouza/prettierd
    @github/copilot
    @tailwindcss/language-server
    @vue/language-server
    bash-language-server
    blade-formatter
    devsense-php-ls
    doctoc
    eslint_d
    fast-cli
    lighthouse
    markdownlint
    markdownlint-cli
    speed-test
    stylelint
    stylelint-config-prettier
    stylelint-lsp
    typescript
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
  )

  npm install --global "${PACKAGES[@]}" "$@"
}

install_go_packages() {
  PACKAGES=(
    github.com/evilmartians/lefthook/v2@latest
    github.com/rhysd/actionlint/cmd/actionlint@latest
    golang.org/x/tools/gopls@latest
    mvdan.cc/sh/v3/cmd/shfmt@latest
    mvdan.cc/xurls/v2/cmd/xurls@latest
  )

  for P in "${PACKAGES[@]}"; do
    go install "${P}" "$@"
  done
}

install_composer() {
  section_start 'Installing Composer'
  EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "${EXPECTED_CHECKSUM}" != "${ACTUAL_CHECKSUM}" ]; then
    echo >&2 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    return 1
  fi

  php composer-setup.php --quiet
  rm composer-setup.php
  sudo mv composer.phar /usr/local/bin/composer
  # shellcheck disable=2119
  install_composer_packages
}

# shellcheck disable=SC2120
install_composer_packages() {
  PACKAGES=(
    cpriego/valet-linux:dev-master
    wp-cli/wp-cli-bundle
    itinerisltd/itineris-wp-coding-standards
  )

  composer global require "${PACKAGES[@]}" "$@"
}

install_pip_packages() {
  PACKAGES=(
    csvkit
    yamllint
  )

  for P in "${PACKAGES[@]}"; do
    pipx install "${P}" "$@"
  done
}

install_cargo_packages() {
  PACKAGES=(
    stylua
  )

  cargo install "${PACKAGES[@]}" "$@"
}
