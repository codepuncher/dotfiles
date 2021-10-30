local map = vim.api.nvim_set_keymap;
local opts = { noremap = true, silent = true }

-- Navigation
---- Switch windows
map('', '<C-l>', '<C-w>l', { noremap = true })
map('', '<C-h>', '<C-w>h', { noremap = true })
map('', '<C-j>', '<C-w>j', { noremap = true })
map('', '<C-k>', '<C-w>k', { noremap = true })
---- Switch buffers
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
---- Toggle tree
map('', '<C-e>', [[<Cmd>lua require('custom.nvim-tree').toggle()<CR>]], { noremap = true })

-- Telescope
map('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true })
map('n', '<Leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true })
map('n', '<Leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true })
map('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true })

-- Tagbar
map('n', '<F8>', ':TagbarToggle<CR>', { noremap = false })
