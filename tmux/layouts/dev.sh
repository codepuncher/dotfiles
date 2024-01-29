#!/usr/bin/env bash

THEME_DIR=$(fd '(composer|package).json' {wp-content,web/app}/themes 2>/dev/null | head -n 1 | xargs dirname || '#{pane_current_path}')
tmux \
	split-window -v -p 25 -c '#{pane_current_path}' \; \
	split-window -h -c "${THEME_DIR}" \; \
	select-pane -L \; \
	send-keys 'cd ../trellis || exit' Enter \; \
	select-pane -U \; \
	send-keys nvim
