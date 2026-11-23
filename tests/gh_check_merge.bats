#!/usr/bin/env bash
# Tests for gh_check_merge merge method selection (shell/aliases).
# shellcheck disable=SC2030,SC2031 # BATS runs each test in a subshell by design

load test_helper

setup() {
	TEST_HOME="$(temp_make)"
	ln -s "$(cd "${DOTFILES_DIR}" && pwd)" "${TEST_HOME}/.dotfiles"
	export HOME="${TEST_HOME}"
	CALLS="$(temp_make)/calls"
	export CALLS

	# shellcheck source=/dev/null
	source "${HOME}/.dotfiles/shell/aliases"

	# Stub gh: `repo view` prints ${SETTINGS}, everything else is recorded.
	gh() {
		if [[ "${1}" == 'repo' ]]; then
			echo "${SETTINGS}"
			return 0
		fi
		echo "${*}" >>"${CALLS}"
		if [[ "${1} ${2}" == 'pr checks' ]]; then
			return "${CHECKS_STATUS:-0}"
		fi
		return 0
	}
}

@test 'uses a merge commit when all methods are allowed' {
	SETTINGS='true true true'
	run gh_check_merge
	assert_success
	assert_equal "$(tail -n1 "${CALLS}")" 'pr merge -m -d'
}

@test 'uses squash when merge commits are disabled' {
	SETTINGS='false true true'
	run gh_check_merge
	assert_success
	assert_equal "$(tail -n1 "${CALLS}")" 'pr merge -s -d'
}

@test 'uses rebase with a warning when it is the only method' {
	SETTINGS='false false true'
	run gh_check_merge
	assert_success
	assert_output --partial 'Only rebase merging is allowed'
	assert_equal "$(tail -n1 "${CALLS}")" 'pr merge -r -d'
}

@test 'fails before checks or merge when no method is allowed' {
	SETTINGS='false false false'
	run gh_check_merge
	assert_failure
	assert_output --partial 'allows no merge method'
	assert_not_exist "${CALLS}"
}

@test 'does not merge when checks fail' {
	SETTINGS='true true true'
	CHECKS_STATUS=1
	run gh_check_merge
	assert_failure
	run grep -c 'pr merge' "${CALLS}"
	assert_output '0'
}

@test 'passes the PR selector to both checks and merge' {
	SETTINGS='true true true'
	run gh_check_merge 123
	assert_success
	assert_equal "$(grep 'pr checks' "${CALLS}")" 'pr checks --watch --interval 2 123'
	assert_equal "$(tail -n1 "${CALLS}")" 'pr merge -m -d 123'
}

@test 'does not pass merge-only flags to checks' {
	SETTINGS='true true true'
	run gh_check_merge --admin
	assert_success
	assert_equal "$(grep 'pr checks' "${CALLS}")" 'pr checks --watch --interval 2'
	assert_equal "$(tail -n1 "${CALLS}")" 'pr merge -m -d --admin'
}

@test 'passes --repo and the PR selector to checks and merge' {
	SETTINGS='true true true'
	run gh_check_merge --repo owner/name 123 --admin
	assert_success
	assert_equal "$(grep 'pr checks' "${CALLS}")" 'pr checks --watch --interval 2 --repo owner/name 123'
	assert_equal "$(tail -n1 "${CALLS}")" 'pr merge -m -d --repo owner/name 123 --admin'
}
