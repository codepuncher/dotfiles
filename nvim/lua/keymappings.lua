local map = vim.api.nvim_set_keymap;
local opts = { noremap = true, silent = true }

-- Navigation
---- Switch windows
map('', '<C-l>', '<C-w>l', { noremap = true })
map('', '<C-h>', '<C-w>h', { noremap = true })
map('', '<C-j>', '<C-w>j', { noremap = true })
map('', '<C-k>', '<C-w>k', { noremap = true })
---- Barbar
------ Linux
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
------ Mac
map('n', '≤', '<Cmd>BufferPrevious<CR>', opts)
map('n', '≥', '<Cmd>BufferNext<CR>', opts)
map('n', '¯', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '˘', '<Cmd>BufferMoveNext<CR>', opts)
map('n', '¡', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '™', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '£', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '€', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '∞', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '§', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '¶', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '•', '<Cmd>BufferGoto 8<CR>', opts)
map('n', 'ª', '<Cmd>BufferGoto 9<CR>', opts)
map('n', 'ç', '<Cmd>BufferClose<CR>', opts)

---- Toggle tree
map('', '<C-e>', [[<Cmd>lua require('custom.nvim-tree').toggle()<CR>]], { noremap = true })

-- Telescope
map('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true })
map('n', '<Leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true })
map('n', '<Leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true })
map('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true })

-- Tagbar
map('n', '<F8>', ':TagbarToggle<CR>', { noremap = false })
