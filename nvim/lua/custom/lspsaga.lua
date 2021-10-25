if not vim.fn.exists('g:loaded_lspsaga') then return end

local saga = require'lspsaga'

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = 'round',
}

-- TODO: figure out why Lua mappings do not work
-- vim.api.nvim_set_keymap('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', { noremap = true, silent = true } )
vim.api.nvim_set_keymap('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>', { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', 'gh','<Cmd>Lspsaga lsp_finder<CR>', { noremap = true, silent = true } )
