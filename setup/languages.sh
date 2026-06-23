#!/usr/bin/env bash

install_nvm() {
  section_start 'Installing NVM'
  # shellcheck disable=SC2155
  export NVM_DIR="$(
    [ -z "${XDG_CONFIG_HOME-}" ]
    printf %s "${HOME}/.config/nvm" || printf %s "${XDG_CONFIG_HOME}/nvm"
  )"
  mkdir -p "${NVM_DIR}"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

  # Load NVM after installing it.
  [ -s "${NVM_DIR}/nvm.sh" ] && \."${NVM_DIR}/nvm.sh" # This loads nvm

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
  if [[ ! -d "${NVM_DIR:-}" ]] || [[ ! -d "${HOME}/.nvm" ]]; then
    install_nvm
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

  # shellcheck disable=2046
  npm install --global $(
    IFS=' '
    echo "${PACKAGES[*]}"
  ) "$@"
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
    return
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

  # shellcheck disable=2046
  composer global require $(
    IFS=' '
    echo "${PACKAGES[*]}"
  ) "$@"
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

  # shellcheck disable=2046
  cargo install $(
    IFS=' '
    echo "${PACKAGES[*]}"
  ) "$@"
}
