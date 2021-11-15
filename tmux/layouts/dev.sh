#!/bin/bash
tmux new-session \; \
  split-window -v -p 25 -c '#{pane_current_path}' \; \
  split-window -h -p 50 -c '#{pane_current_path}' \; \
  select-pane -U
