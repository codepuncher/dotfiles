#!/usr/bin/env bash
# Standalone tests for project_open discovery/cache/resolution.
# Run: bash tests/project_open_test.sh
# No `set -u`: project_open references ${2} unguarded (matching the original),
# which is fine in a normal shell but would throw under nounset.

FAILS=0

assert_eq() {
	local desc="$1" expected="$2" actual="$3"
	if [[ "${expected}" == "${actual}" ]]; then
		printf 'ok   - %s\n' "${desc}"
		return 0
	fi
	printf 'FAIL - %s\n      expected: %q\n      actual:   %q\n' "${desc}" "${expected}" "${actual}"
	FAILS=$((FAILS + 1))
}

ROOT=""
setup_fixture() {
	# Templates keep mktemp portable: BSD/macOS mktemp needs one, GNU accepts it.
	ROOT="$(mktemp -d "${TMPDIR:-/tmp}/project_open_root.XXXXXX")"
	export PROJECT_OPEN_ROOT="${ROOT}"
	XDG_CACHE_HOME="$(mktemp -d "${TMPDIR:-/tmp}/project_open_cache.XXXXXX")"
	export XDG_CACHE_HOME
	mkdir -p \
		"${ROOT}/mods/HoldFast/.git" \
		"${ROOT}/mods/HoldFast/lib/vcpkg/.git" \
		"${ROOT}/misc/khuey/.git" \
		"${ROOT}/wordpress/acme/site" \
		"${ROOT}/wordpress/beta/bedrock" \
		"${ROOT}/deep/a/b/proj/.git"
}

TEST_HOME=""
cleanup() {
	[[ -n "${ROOT}" ]] && rm -rf "${ROOT}"
	[[ -n "${XDG_CACHE_HOME}" ]] && rm -rf "${XDG_CACHE_HOME}"
	[[ -n "${TEST_HOME}" ]] && rm -rf "${TEST_HOME}"
}
trap cleanup EXIT

# tmux is unavailable / irrelevant in tests; stub it to a no-op.
tmux() { return 0; }

test_scan() {
	local out
	out="$(_project_open_scan | sed "s#^${ROOT}/##" | LC_ALL=C sort | tr '\n' ',')"
	assert_eq "scan finds outermost projects, excludes submodules" \
		"deep/a/b/proj,misc/khuey,mods/HoldFast,wordpress/acme,wordpress/beta," \
		"${out}"
}

test_cache() {
	local cache
	export PROJECT_OPEN_CACHE_TTL=3600
	po_refresh
	cache="$(_project_open_cache_file)"
	assert_eq "cache file created" "yes" "$([[ -f "${cache}" ]] && echo yes || echo no)"

	# TTL guard: a new project added now must NOT appear via a guarded rebuild.
	mkdir -p "${ROOT}/mods/NewMod/.git"
	_project_open_build_cache
	assert_eq "TTL guard skips rebuild" "no" \
		"$(grep -q '/NewMod$' "${cache}" && echo yes || echo no)"

	# po_refresh bypasses the guard and picks up the new project.
	po_refresh
	assert_eq "po_refresh rebuilds" "yes" \
		"$(grep -q '/NewMod$' "${cache}" && echo yes || echo no)"

	rm -f "${cache}" "${cache}.ts"
	assert_eq "read_cache empty when cache missing" "0" \
		"$(_project_open_read_cache | grep -c '/mods/HoldFast$')"
	assert_eq "resolve scans when cache missing" "${ROOT}/mods/HoldFast" \
		"$(_project_open_resolve HoldFast)"
	assert_eq "resolve cache_only empty when cache missing" "" \
		"$(_project_open_resolve HoldFast cache_only)"

	rm -f "${cache}" "${cache}.ts"
	PROJECT_OPEN_ROOT="${ROOT}/missing" _project_open_build_cache
	assert_eq "no cache built when root missing" "no" \
		"$([[ -f "${cache}" ]] && echo yes || echo no)"
}

test_resolve_and_completion() {
	assert_eq "resolve HoldFast to path" "${ROOT}/mods/HoldFast" \
		"$(_project_open_resolve HoldFast)"
	assert_eq "resolve deep project" "${ROOT}/deep/a/b/proj" \
		"$(_project_open_resolve proj)"
	assert_eq "resolve unknown is empty" "" "$(_project_open_resolve nope)"

	# test_cache (run earlier in main) added mods/NewMod to the fixture, so it
	# appears here too. sort makes order irrelevant.
	po_refresh
	assert_eq "projects lists basenames" "HoldFast,NewMod,acme,beta,khuey,proj," \
		"$(_project_open_projects | LC_ALL=C sort | tr '\n' ',')"

	assert_eq "targets lists subdirs" "lib" "$(_project_open_targets HoldFast)"
	assert_eq "targets of childless project is empty" "" \
		"$(_project_open_targets khuey)"
	assert_eq "targets of unknown project is empty" "" \
		"$(_project_open_targets nope)"
}

test_project_open() {
	po_refresh
	assert_eq "no-arg cds to Code root" "${ROOT}" \
		"$(cd / && project_open >/dev/null 2>&1; pwd)"
	assert_eq "name cds into plain project" "${ROOT}/mods/HoldFast" \
		"$(cd / && project_open HoldFast >/dev/null 2>&1; pwd)"
	assert_eq "descends into bedrock" "${ROOT}/wordpress/beta/bedrock" \
		"$(cd / && project_open beta >/dev/null 2>&1; pwd)"
	assert_eq "descends into site" "${ROOT}/wordpress/acme/site" \
		"$(cd / && project_open acme >/dev/null 2>&1; pwd)"
	assert_eq "subdir target cds into subdir" "${ROOT}/mods/HoldFast/lib" \
		"$(cd / && project_open HoldFast lib >/dev/null 2>&1; pwd)"

	local rc
	( cd / && project_open nope >/dev/null 2>&1 ); rc=$?
	assert_eq "unknown project returns 1" "1" "${rc}"
}

main() {
	setup_fixture
	local dotfiles
	dotfiles="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
	# shell/aliases sources "${HOME}/.dotfiles/shell/os.sh", so point HOME at a
	# temp dir whose .dotfiles symlinks to this repo. That lets the test run
	# from any checkout path, not only ~/.dotfiles.
	TEST_HOME="$(mktemp -d "${TMPDIR:-/tmp}/project_open_home.XXXXXX")"
	ln -s "${dotfiles}" "${TEST_HOME}/.dotfiles"
	export HOME="${TEST_HOME}"
	# shellcheck source=/dev/null
	source "${HOME}/.dotfiles/shell/aliases"

	test_scan
	test_cache
	test_resolve_and_completion
	test_project_open

	exit $(( FAILS > 0 ? 1 : 0 ))
}

main "$@"
