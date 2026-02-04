# See: https://github.com/spaceship-prompt/spaceship-prompt/issues/1193
SPACESHIP_PROMPT_ASYNC=false

SPACESHIP_PROMPT_ORDER=(
	user      # Username section
	host      # Hostname section
	dir       # Current directory section
	git       # Git section (git_branch + git_status)
	php       # PHP section
	package   # Package version
	node      # Node.js section
	exec_time # Execution time
	line_sep  # Line break
	vi_mode   # Vi-mode indicator
	jobs      # Background jobs indicator
	exit_code # Exit code section
	char      # Prompt character
)

SPACESHIP_RPROMPT_ORDER=(
	time # Time stampts section
)

# Add a custom vi-mode section to the prompt
# See: https://github.com/spaceship-prompt/spaceship-vi-mode
spaceship add --before char vi_mode
