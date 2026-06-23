#!/usr/bin/env bash

is_wsl() {
  grep --quiet --ignore-case microsoft /proc/sys/kernel/osrelease 2>/dev/null
}
