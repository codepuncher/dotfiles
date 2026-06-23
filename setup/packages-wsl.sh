#!/usr/bin/env bash

add_wslu_ppa() {
  sudo add-apt-repository ppa:wslutilities/wslu -y
}

add_eza_ppa() {
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
}

add_php_ppa() {
  sudo add-apt-repository ppa:ondrej/php -y
}

add_gh_cli_ppa() {
  # shellcheck disable=SC2086,SC2002
  (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) &&
    sudo mkdir -p -m 755 /etc/apt/keyrings &&
    out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg &&
    cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
    sudo mkdir -p -m 755 /etc/apt/sources.list.d &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
}

install_neovim() {
  local DIRNAME='nvim-linux-x86_64'
  local FILENAME="${DIRNAME}.tar.gz"
  local OUTPUT_PATH="/tmp/${FILENAME}"

  curl -L "https://github.com/neovim/neovim/releases/latest/download/${FILENAME}" --output "${OUTPUT_PATH}"

  mkdir -p ~/.local/bin

  [ -e ~/.local/bin/nvim ] && rm ~/.local/bin/nvim

  sudo rm -rf /opt/nvim
  sudo rm -rf /opt/neovim

  sudo tar -C /opt -xzf "${OUTPUT_PATH}"

  ln -s "/opt/${DIRNAME}/bin/nvim" ~/.local/bin/nvim
}

install_git_delta() {
  REPO='dandavison/delta'
  VERSION="$(gh_get_latest_tag "${REPO}")"
  VERSION="${VERSION:-0.16.5}"
  FILE="git-delta_${VERSION}_amd64.deb"
  curl -LO "https://github.com/${REPO}/releases/latest/download/${FILE}" && sudo dpkg -i "${FILE}" && rm "${FILE}"
}

install_wsl_packages() {
  add_wslu_ppa
  add_eza_ppa
  add_php_ppa
  add_gh_cli_ppa

  PACKAGES=(
    # Text processing
    pandoc
    texlive-latex-base
    texlive-latex-extra
    texlive-latex-recommended
    texlive-fonts-recommended
    texlive-fonts-extra

    # Dev
    mariadb-server
    tmux
    golang-go
    python3
    python3-pip
    pipx
    tidy

    # Fonts
    fonts-noto-color-emoji
    fonts-firacode
    fonts-hack
    fonts-jetbrains-mono

    # IDE
    shellcheck

    # System
    cmake
    libnss3-tools
    vim
    tldr
    git
    gh
    gpg
    jq
    ripgrep
    eza
    fd-find
    fzf
    xsel
    xclip
    imagemagick
    dnsutils
    moreutils
    bat
    zsh
    wslu
  )

  PHP_PACKAGES=(
    bcmath
    bz2
    cli
    common
    curl
    fpm
    gd
    gmp
    intl
    mbstring
    mysql
    opcache
    readline
    soap
    tidy
    xdebug
    xml
    xsl
    zip
  )
  PHP_VERSIONS=(8.1 8.2 8.3 8.4)
  for VERSION in "${PHP_VERSIONS[@]}"; do
    mapfile -t PHP_COMBINED_PACKAGES < <(printf '%s\n' "${PHP_PACKAGES[@]}" | sed "s/^/php${VERSION}-/")
    PACKAGES=("${PACKAGES[@]}" "${PHP_COMBINED_PACKAGES[@]}")
  done

  sudo add-apt-repository ppa:longsleep/golang-backports -y

  sudo apt update

  # shellcheck disable=2046
  sudo apt install -y "${PACKAGES[@]}"

  install_rustup
  install_neovim
  install_git_delta
  # ensure fd is available
  ln -sf "$(which fdfind)" ~/.local/bin/fd

  # Generate the `rg` zsh completion file for zinit.
  rg --generate=complete-zsh >~/.zinit/completions/_rg
}
