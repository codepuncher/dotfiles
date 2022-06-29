local telescope = require('telescope')
local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')

local M = {}

local function git_push_to_remote_branch(prompt_bufnr, force)
  local should_force = false
  force = force or (force == nil and should_force)
  local selection = actions_state.get_selected_entry()
  local branch_name = selection.name
  local origin_position = string.find(branch_name, 'origin/')
  if origin_position then
    branch_name = string.sub(branch_name, 8)
  end
  actions.close(prompt_bufnr)

  if force then
    vim.api.nvim_command('Git push origin HEAD:' .. branch_name .. ' -f')
  else
    vim.api.nvim_command('Git push origin HEAD:' .. branch_name)
  end
end

telescope.setup({
  defaults = {
    prompt_prefix = '🔍',
    layout_config = {
      prompt_position = 'top',
    },
    theme = 'dropdown',
  },
  pickers = {
    git_branches = {
      mappings = {
        i = {
          ['<C-p>'] = git_push_to_remote_branch,
          ['<C-M-p>'] = function(bufnr)
            git_push_to_remote_branch(bufnr, true)
          end,
        },
        n = {
          ['<C-p>'] = git_push_to_remote_branch,
          ['<C-M-p>'] = function(bufnr)
            git_push_to_remote_branch(bufnr, true)
          end,
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

M.find_files_no_ignore = function()
  local theme = require('telescope.themes').get_dropdown({
    hidden = true,
    no_ignore = true,
    theme = 'dropdown',
    layout_config = {
      prompt_position = 'bottom',
      width = 0.5,
    },
  })
  require('telescope.builtin').find_files(theme)
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
