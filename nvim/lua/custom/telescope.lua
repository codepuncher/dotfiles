local telescope = require('telescope')
local M = {}

telescope.setup {
  defaults = {
    prompt_prefix='🔍',
  },
}

M.find_files = function ()
  local opts = {
    no_ignore = true,
  }

  require('telescope.builtin').find_files(opts)
end

return M
