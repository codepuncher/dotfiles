local telescope = require('telescope')
local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')

local M = {}

local function git_push_to_remote_branch(prompt_bufnr)
  local selection = actions_state.get_selected_entry()
  local branch_name = selection.name
  local origin_position = string.find(branch_name, 'origin/')
  if origin_position then
    branch_name = string.sub(branch_name, 8)
  end
  actions.close(prompt_bufnr)
  vim.api.nvim_command('Git push origin HEAD:' .. branch_name)
end

telescope.setup({
  defaults = {
    prompt_prefix = '🔍',
    layout_config = {
      prompt_position = 'top',
    },
  },
  pickers = {
    git_branches = {
      mappings = {
        i = {
          ["<C-p>"] = git_push_to_remote_branch,
        },
        n = {
          ["<C-p>"] = git_push_to_remote_branch,
        },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
})

telescope.load_extension('fzf')
telescope.load_extension('gh')

M.find_files = function()
  require('telescope.builtin').find_files({
    hidden = true,
    no_ignore = true,
  })
end

M.live_grep = function()
  local opts = {
    no_ignore = true,
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--hidden',
      '--smart-case',
      '-uu',
    },
  }

  require('telescope.builtin').live_grep(opts)
end

M.lsp_workspace_symbols = function()
  local query = vim.fn.input('Query: ')

  if query == nil or query == '' then
    return require('telescope.builtin').lsp_dynamic_workspace_symbols()
  end

  return require('telescope.builtin').lsp_workspace_symbols({
    query = query,
  })
end

return M
