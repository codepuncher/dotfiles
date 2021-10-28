--Lspsaga
vim.api.nvim_set_keymap('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', 'gs', '<Cmd>Lspsaga signature_help<CR>', { noremap = true, silent = true } )
vim.api.nvim_set_keymap('n', 'gh','<Cmd>Lspsaga lsp_finder<CR>', { noremap = true, silent = true } )

--Navigation
----Switch windows
vim.api.nvim_set_keymap('', '<C-l>', '<C-w>l', { noremap = true })
vim.api.nvim_set_keymap('', '<C-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('', '<C-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('', '<C-k>', '<C-w>k', { noremap = true })
----Switch buffers
vim.api.nvim_set_keymap('n', '<A-,>', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-.>', '<Cmd>BufferNext<CR>', { noremap = true, silent = true })

--Tagbar
vim.api.nvim_set_keymap('n', '<F8>', ':TagbarToggle<CR>', { noremap = false })

