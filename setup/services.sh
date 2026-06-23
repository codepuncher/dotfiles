#!/usr/bin/env bash

setup_arch_services() {
  SERVICES=(
    nginx
    mariadb
    php-fpm
  )

  # shellcheck disable=2046
  sudo systemctl start $(
    IFS=' '
    echo "${SERVICES[*]}"
  )
  # shellcheck disable=2046
  sudo systemctl enable $(
    IFS=' '
    echo "${SERVICES[*]}"
  )
}

setup_mysql() {
  # shellcheck disable=2016
  echo 'Running `mysql_secure_installation`'
  sudo mysql_secure_installation

  echo -e 'Creating wp mysql user'
  sudo mysql -e "CREATE USER IF NOT EXISTS 'wp'@'localhost' IDENTIFIED BY 'wp'"
  sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'wp'@'localhost' WITH GRANT OPTION"
  sudo mysql -e "FLUSH PRIVILEGES"
}

post_setup_arch_services() {
  section_start 'Post setup arch services'

  setup_mysql
}

post_setup_wsl_services() {
  setup_mysql
}
