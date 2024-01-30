#!/usr/bin/env bash

THEME_DIR="$(fd '(composer|package).json' {wp-content,web/app}/themes 2>/dev/null | head -n 1 | xargs dirname)"
if [[ -z "${THEME_DIR}" ]]; then
	THEME_DIR='#{pane_current_path}'
fi

TRELLIS_DIR="${PWD}/../trellis/"
PANE_THIRD_WORKING_DIRECTORY=''
if [[ -d "${TRELLIS_DIR}" ]]; then
	PANE_SECOND_WORKING_DIRECTORY="${TRELLIS_DIR}"
	PANE_THIRD_WORKING_DIRECTORY="${THEME_DIR}"
else
	PANE_SECOND_WORKING_DIRECTORY="${THEME_DIR}"
fi

tmux \
	split-window -v -p 25 -c "${PANE_SECOND_WORKING_DIRECTORY}"

if [[ -n "${PANE_THIRD_WORKING_DIRECTORY}" ]]; then
	tmux \
		split-window -h -c "${PANE_THIRD_WORKING_DIRECTORY}"
fi

tmux \
	select-pane -U \; \
	send-keys nvim
