#!/usr/bin/env bash
# Tests for project_open discovery/cache/resolution (shell/aliases).
# shellcheck disable=SC2030,SC2031 # BATS runs each test in a subshell by design

load test_helper

# tmux is irrelevant here; stub it to a no-op so sourcing/aliases stay quiet.
tmux() { return 0; }

setup() {
	ROOT="$(temp_make)"
	export PROJECT_OPEN_ROOT="${ROOT}"
	XDG_CACHE_HOME="$(temp_make)"
	export XDG_CACHE_HOME

	mkdir -p \
		"${ROOT}/mods/HoldFast/.git" \
		"${ROOT}/mods/HoldFast/lib" \
		"${ROOT}/mods/HoldFast/lib/vcpkg/.git" \
		"${ROOT}/misc/khuey/.git" \
		"${ROOT}/wordpress/acme/.git" \
		"${ROOT}/wordpress/acme/site" \
		"${ROOT}/wordpress/beta/.git" \
		"${ROOT}/wordpress/beta/bedrock" \
		"${ROOT}/wordpress/itineris/bedrock/.git" \
		"${ROOT}/wordpress/itineris/trellis/.git"

	# shell/aliases sources ${HOME}/.dotfiles/shell/os.sh, so point HOME at a
	# temp dir whose .dotfiles symlinks to this repo. That lets the suite run
	# from any checkout path, not only ~/.dotfiles.
	TEST_HOME="$(temp_make)"
	ln -s "$(cd "${DOTFILES_DIR}" && pwd)" "${TEST_HOME}/.dotfiles"
	export HOME="${TEST_HOME}"

	# shellcheck source=/dev/null
	source "${HOME}/.dotfiles/shell/aliases"
}

teardown() {
	temp_del "${ROOT}"
	temp_del "${XDG_CACHE_HOME}"
	temp_del "${TEST_HOME}"
}

@test "scan finds category/project dirs and excludes itineris submodules" {
	local out
	out="$(_project_open_scan | sed "s#^${ROOT}/##" | LC_ALL=C sort | tr '\n' ',')"
	assert_equal "${out}" "misc/khuey,mods/HoldFast,wordpress/acme,wordpress/beta,wordpress/itineris,"
}

@test "po_refresh creates the cache file" {
	po_refresh
	assert_file_exist "$(_project_open_cache_file)"
}

@test "build is a no-op when the cache already exists" {
	po_refresh
	mkdir -p "${ROOT}/mods/NewMod/.git"
	_project_open_build_cache
	run grep -q '/NewMod$' "$(_project_open_cache_file)"
	assert_failure
}

@test "po_refresh rebuilds and picks up new projects" {
	po_refresh
	mkdir -p "${ROOT}/mods/NewMod/.git"
	po_refresh
	run grep -q '/NewMod$' "$(_project_open_cache_file)"
	assert_success
}

@test "read_cache is empty when the cache is missing" {
	rm -f "$(_project_open_cache_file)"
	run _project_open_read_cache
	assert_output ''
}

@test "resolve falls back to a scan when the cache is missing" {
	rm -f "$(_project_open_cache_file)"
	run _project_open_resolve HoldFast
	assert_output "${ROOT}/mods/HoldFast"
}

@test "resolve cache_only returns nothing when the cache is missing" {
	rm -f "$(_project_open_cache_file)"
	run _project_open_resolve HoldFast cache_only
	assert_output ''
}

@test "no cache is built when the root is missing" {
	export PROJECT_OPEN_ROOT="${ROOT}/missing"
	local missing_cache
	missing_cache="$(_project_open_cache_file)"
	run _project_open_build_cache
	assert_file_not_exist "${missing_cache}"
}

@test "resolve maps a project name to its path" {
	run _project_open_resolve HoldFast
	assert_output "${ROOT}/mods/HoldFast"
}

@test "resolve maps a wordpress project to its path" {
	run _project_open_resolve acme
	assert_output "${ROOT}/wordpress/acme"
}

@test "resolve maps a itineris-git project (no root .git) to its path" {
	run _project_open_resolve itineris
	assert_output "${ROOT}/wordpress/itineris"
}

@test "resolve of an unknown name is empty" {
	run _project_open_resolve nope
	assert_output ''
}

@test "projects lists project basenames" {
	po_refresh
	local out
	out="$(_project_open_projects | LC_ALL=C sort | tr '\n' ',')"
	assert_equal "${out}" "HoldFast,acme,beta,itineris,khuey,"
}

@test "targets lists a project's subdirs" {
	po_refresh
	run _project_open_targets HoldFast
	assert_output "lib"
}

@test "targets of a childless project is empty" {
	po_refresh
	run _project_open_targets khuey
	assert_output ''
}

@test "targets of an unknown project is empty" {
	po_refresh
	run _project_open_targets nope
	assert_output ''
}

@test "no-arg project_open cds to the root" {
	po_refresh
	local dir
	dir="$(cd / && project_open >/dev/null 2>&1 && pwd)"
	assert_equal "${dir}" "${ROOT}"
}

@test "project_open <name> cds into a plain project" {
	po_refresh
	local dir
	dir="$(cd / && project_open HoldFast >/dev/null 2>&1 && pwd)"
	assert_equal "${dir}" "${ROOT}/mods/HoldFast"
}

@test "project_open descends into bedrock" {
	po_refresh
	local dir
	dir="$(cd / && project_open beta >/dev/null 2>&1 && pwd)"
	assert_equal "${dir}" "${ROOT}/wordpress/beta/bedrock"
}

@test "project_open descends into site" {
	po_refresh
	local dir
	dir="$(cd / && project_open acme >/dev/null 2>&1 && pwd)"
	assert_equal "${dir}" "${ROOT}/wordpress/acme/site"
}

@test "project_open descends into bedrock for a itineris-git project" {
	po_refresh
	local dir
	dir="$(cd / && project_open itineris >/dev/null 2>&1 && pwd)"
	assert_equal "${dir}" "${ROOT}/wordpress/itineris/bedrock"
}

@test "project_open <name> <subdir> cds into the subdir" {
	po_refresh
	local dir
	dir="$(cd / && project_open HoldFast lib >/dev/null 2>&1 && pwd)"
	assert_equal "${dir}" "${ROOT}/mods/HoldFast/lib"
}

@test "project_open of an unknown project returns 1" {
	po_refresh
	local rc=0
	(cd / && project_open nope >/dev/null 2>&1) || rc=$?
	assert_equal "${rc}" "1"
}
