local telescope = require('telescope')
local M = {}

telescope.setup {
  defaults = {
    prompt_prefix='🔍',
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
  },
}

telescope.load_extension('fzf')

M.find_files = function ()
  local opts = {
    no_ignore = true,
  }

  require('telescope.builtin').find_files(opts)
end

return M
