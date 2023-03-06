#!/usr/bin/env bash

tmux split-window -h -p 40 -c '#{pane_current_path}' \; \
	select-pane -U \; \
	split-window -v -p 25 -c '#{pane_current_path}' \; \
	select-pane -L \; \
	send-keys v Enter
