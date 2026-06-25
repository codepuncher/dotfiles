#!/usr/bin/env bash
# Common test helper for BATS tests.

# GitHub Actions sets TERM=dumb, which makes tput error; force a sane value.
if [[ -z "${TERM:-}" || "${TERM}" == "dumb" ]]; then
	export TERM="xterm"
fi

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'
load 'test_helper/bats-file/load'

# Repo root (tests/ lives directly under it).
DOTFILES_DIR="${BATS_TEST_DIRNAME}/.."
