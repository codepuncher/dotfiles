local _plugin, plugin = pcall(require, 'lualine')
if not _plugin then
  return
end

local old_config = {
  options = {
    theme = 'tokyonight',
  },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
  },
}

local evil_config = require('plugins.configs.lualine.evil')

plugin.setup(evil_config)

-- refresh lualine
vim.cmd([[
augroup lualine_augroup
    autocmd!
    autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
augroup END
]])
