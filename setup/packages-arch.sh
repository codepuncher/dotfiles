#!/usr/bin/env bash

install_arch_packages() {
  echo 'Enabling the AUR...'
  enable_aur

  PACKAGES=(
    # General
    redshift
    ulauncher
    variety
    bitwarden
    plank
    spotify-launcher
    spotifyd
    pandoc
    texlive-basic
    texlive-latex
    texlive-latexrecommended
    texlive-pictures
    texlive-latexextra
    texlive-fontsrecommended

    # Social
    discord
    caprine
    whatsapp-for-linux

    # Work
    microsoft-edge-stable-bin
    clickup
    zoom

    # Dev
    alacritty
    ghostty
    tmux
    github-cli
    go
    rustup
    nginx
    mailpit
    mariadb
    php-legacy
    php-legacy-fpm
    php-legacy-gd
    php-legacy-imagick
    php-legacy-sodium
    php-legacy-sqlite
    php-legacy-tidy
    php-legacy-xdebug
    php-legacy-xsl
    python
    python-pip
    python-pipx

    # Fonts
    noto-fonts-emoji
    ttf-anonymouspro-nerd
    ttf-dejavu-nerd
    ttf-firacode-nerd
    ttf-go-nerd
    ttf-hack-nerd
    ttf-jetbrains-mono-nerd
    ttf-liberation-mono-nerd
    ttf-sourcecodepro-nerd
    ttf-terminus-nerd

    # IDE
    neovim
    lua-language-server
    shellcheck
    hadolint-bin

    # System
    vim
    tldr
    git
    jq
    headsetcontrol
    ripgrep
    exa
    fd
    git-delta
    xsel
    xclip
    imagemagick
    dnsutils
    bat
  )

  arch_install "${PACKAGES[@]}" "$@"
}

post_install_packages() {
  section_start 'Post package install'

  # shellcheck disable=2016
  echo 'Running `mariadb-install-db`'
  sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

  echo 'Enabling PHP extensions'
  sudo sed -Ei '/^;extension=mysqli/s/^;//' /etc/php7/php.ini
  sudo sed -Ei '/^;extension=gd/s/^;//' /etc/php7/php.ini

  # shellcheck disable=2016
  echo 'Installing `spotify-tui`'
  mkdir "${HOME}/.rustup"
  rustup default stable
  arch_install spotify-tui
}

setup_arch_system_emoji_support() {
  arch_install noto-fonts-emoji
  sudo cp ~/.dotfiles/templates/fonts-local.conf /etc/fonts/local.conf
}
