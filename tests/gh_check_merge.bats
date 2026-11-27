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
			echo "${*}" >>"${CALLS}.repo"
			echo "${SETTINGS}"
			return 0
		fi
		if [[ "${1} ${2}" == 'pr view' ]]; then
			echo "${*}" >>"${CALLS}.view"
			echo "${VIEW}"
			return 0
		fi
		echo "${*}" >>"${CALLS}"
		if [[ "${1} ${2}" == 'pr checks' ]]; then
			return "${CHECKS_STATUS:-0}"
		fi
		if [[ "${1} ${2}" == 'pr merge' && -n "${MERGE_FAILS:-}" ]]; then
			local ATTEMPTS
			ATTEMPTS="$(grep -c 'pr merge' "${CALLS}")"
			((ATTEMPTS <= MERGE_FAILS)) && return 1
		fi
		return 0
	}

	# Stub sleep: record it, and abort a runaway loop instead of hanging.
	sleep() {
		echo "${*}" >>"${CALLS}.sleep"
		(($(wc -l <"${CALLS}.sleep") <= 5)) || exit 99
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

@test 'passes the selector and --repo to checks and merge, and the repo to the settings lookup' {
	SETTINGS='true true true'
	run gh_check_merge 123 --repo owner/name --admin
	assert_success
	assert_equal "$(grep 'pr checks' "${CALLS}")" 'pr checks --watch --interval 2 123 --repo owner/name'
	assert_equal "$(tail -n1 "${CALLS}")" 'pr merge -m -d 123 --repo owner/name --admin'
	assert_equal "$(cat "${CALLS}.repo")" 'repo view owner/name --json mergeCommitAllowed,squashMergeAllowed,rebaseMergeAllowed --jq [.mergeCommitAllowed, .squashMergeAllowed, .rebaseMergeAllowed] | map(tostring) | join(" ")'
}

@test 'accepts -R, -R<repo> and --repo=<repo>' {
	SETTINGS='true true true'
	for ARGS in '-R owner/name' '-Rowner/name' '--repo=owner/name'; do
		: >"${CALLS}"
		# shellcheck disable=SC2086
		run gh_check_merge ${ARGS}
		assert_success
		assert_equal "$(grep 'pr checks' "${CALLS}")" 'pr checks --watch --interval 2 --repo owner/name'
	done
}

@test 'does not leak value-taking merge flags into checks' {
	SETTINGS='true true true'
	run gh_check_merge 123 --body 'Fixes the thing'
	assert_success
	assert_equal "$(grep 'pr checks' "${CALLS}")" 'pr checks --watch --interval 2 123'
	assert_equal "$(tail -n1 "${CALLS}")" 'pr merge -m -d 123 --body Fixes the thing'
}

@test 'retries a merge blocked on approval when --wait is given' {
	SETTINGS='true true true'
	MERGE_FAILS=2
	VIEW='OPEN REVIEW_REQUIRED BLOCKED'
	run gh_check_merge --wait
	assert_success
	assert_output --partial 'waiting for approval'
	run grep -c 'pr merge' "${CALLS}"
	assert_output '3'
	assert_equal "$(cat "${CALLS}.sleep")" $'15\n15'
}

@test 'does not forward --wait to checks or merge, wherever it appears' {
	SETTINGS='true true true'
	run gh_check_merge 123 --repo owner/name --wait --admin
	assert_success
	assert_equal "$(grep 'pr checks' "${CALLS}")" 'pr checks --watch --interval 2 123 --repo owner/name'
	assert_equal "$(tail -n1 "${CALLS}")" 'pr merge -m -d 123 --repo owner/name --admin'
}

@test 'passes no empty selector when only --wait is given' {
	SETTINGS='true true true'
	run gh_check_merge --wait
	assert_success
	assert_equal "$(grep 'pr checks' "${CALLS}")" 'pr checks --watch --interval 2'
	assert_equal "$(tail -n1 "${CALLS}")" 'pr merge -m -d'
}

@test 'does not retry a failed merge without --wait' {
	SETTINGS='true true true'
	MERGE_FAILS=1
	run gh_check_merge
	assert_failure
	run grep -c 'pr merge' "${CALLS}"
	assert_output '1'
	assert_not_exist "${CALLS}.sleep"
}

@test 'does not retry when checks fail, even with --wait' {
	SETTINGS='true true true'
	CHECKS_STATUS=1
	run gh_check_merge --wait
	assert_failure
	run grep -c 'pr merge' "${CALLS}"
	assert_output '0'
	assert_not_exist "${CALLS}.sleep"
}

@test 'does not retry a merge that waiting cannot fix' {
	SETTINGS='true true true'
	MERGE_FAILS=1
	for VIEW in 'OPEN APPROVED DIRTY' 'OPEN REVIEW_REQUIRED DIRTY' 'OPEN REVIEW_REQUIRED BEHIND' 'OPEN CHANGES_REQUESTED BLOCKED' 'CLOSED  UNKNOWN'; do
		export VIEW
		: >"${CALLS}"
		run gh_check_merge --wait
		assert_failure
	done
	assert_not_exist "${CALLS}.sleep"
}

@test 'treats an already merged PR as success with --wait' {
	SETTINGS='true true true'
	MERGE_FAILS=1
	VIEW='MERGED APPROVED UNKNOWN'
	run gh_check_merge --wait
	assert_success
	assert_not_exist "${CALLS}.sleep"
}

@test 'fails immediately with --wait when no merge method is allowed' {
	SETTINGS='false false false'
	run gh_check_merge --wait
	assert_failure
	assert_not_exist "${CALLS}"
	assert_not_exist "${CALLS}.sleep"
}
