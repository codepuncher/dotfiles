#!/usr/bin/env bash

THEME_DIR="$(fd '(composer|package).json' {wp-content,web/app}/themes 2>/dev/null | head -n 1 | xargs dirname)"
if [[ -z "${THEME_DIR}" ]]; then
	THEME_DIR='#{pane_current_path}'
fi

TRELLIS_DIR="${PWD}/../trellis/"
PANE_THIRD_DIR=''
if [[ -d "${TRELLIS_DIR}" ]]; then
	PANE_SECOND_DIR="${TRELLIS_DIR}"
	PANE_THIRD_DIR="${THEME_DIR}"
else
	PANE_SECOND_DIR="${THEME_DIR}"
fi

tmux split-window -v -p 25 -c "${PANE_SECOND_DIR}"
if [[ -n "${PANE_THIRD_DIR}" ]]; then
	tmux split-window -h -c "${PANE_THIRD_DIR}"
fi

tmux \
	select-pane -L \; \
	select-pane -U \; \
	send-keys nvim
