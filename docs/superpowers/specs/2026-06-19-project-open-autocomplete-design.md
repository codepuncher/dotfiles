# project_open bash/zsh autocomplete design

## Summary

Add native Bash and Zsh tab-completion for `project_open` and `po` in `shell/aliases`, aligned with current function behaviour and repo conventions.

## Goals

- Complete first argument with valid WordPress project directories under `~/Code/wordpress`.
- Complete second argument with immediate subdirectories of the selected project directory.
- Support both `project_open` and `po`.
- Keep completion silent and robust when paths are missing or invalid.

## Non-goals

- No nested path completion for second argument.
- No `theme` keyword completion.
- No behaviour changes to `project_open` runtime logic.
- No completion for arguments after the second.

## Architecture

Completion logic stays in `shell/aliases` alongside `project_open`, with shell-specific adapters:

- Bash: `complete -F _project_open_complete_bash project_open` and `po`
- Zsh: `compdef _project_open_complete_zsh project_open` and `po`

Shared helper functions provide discovery logic so Bash/Zsh wrappers only handle shell API differences.

## Components

1. `_project_open_projects`
   - Scans `~/Code/wordpress/*`.
   - Returns directory names where either `bedrock/` or `site/` exists.

2. `_project_open_targets <project>`
   - Resolves `~/Code/wordpress/<project>`.
   - Returns immediate child directories only (one level).

3. `_project_open_complete_bash`
   - Uses `COMP_WORDS` and `COMP_CWORD`.
   - Produces `COMPREPLY` from helper output.

4. `_project_open_complete_zsh`
   - Uses `words` and `CURRENT`.
   - Uses `compadd` with helper output.

5. Registration block
   - Attaches completions to both `project_open` and `po`.

## Data flow

1. User requests completion for first argument.
2. Adapter calls `_project_open_projects` and returns candidates.
3. User requests completion for second argument.
4. Adapter calls `_project_open_targets <selected-project>` and returns candidates.
5. For third argument or beyond, return no candidates.

## Error handling

- If `~/Code/wordpress` is missing, return no completions.
- If project argument does not map to an existing directory, return no target completions.
- Ignore non-directory entries.
- Handle spaces safely via quoted expansions and arrays.
- Emit no stderr output during completion.

## Testing strategy

Because this repository does not currently define an automated shell-completion test harness, validation is manual in both shells:

- Zsh:
  - `project_open <TAB>` suggests valid projects.
  - `project_open <project> <TAB>` suggests one-level subdirectories.
  - `po` mirrors both behaviours.
- Bash:
  - Same checks with programmable completion loaded.
- Negative checks:
  - Invalid project name for second arg returns no suggestions.
  - Missing `~/Code/wordpress` returns no suggestions.
  - Third argument returns no suggestions.

## Rollout

- Edit only `shell/aliases`.
- Keep helper names scoped to `project_open` completion.
- Preserve existing aliases and function behaviour.
