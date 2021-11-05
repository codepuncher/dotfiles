local map = vim.api.nvim_set_keymap;
local noremapSilent = { noremap = true, silent = true }

-- Navigation
---- Switch windows
map('', '<C-l>', '<C-w>l', { noremap = true })
map('', '<C-h>', '<C-w>h', { noremap = true })
map('', '<C-j>', '<C-w>j', { noremap = true })
map('', '<C-k>', '<C-w>k', { noremap = true })
---- Barbar
------ Linux
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', noremapSilent)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', noremapSilent)
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', noremapSilent)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', noremapSilent)
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', noremapSilent)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', noremapSilent)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', noremapSilent)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', noremapSilent)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', noremapSilent)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', noremapSilent)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', noremapSilent)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', noremapSilent)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', noremapSilent)
map('n', '<A-c>', '<Cmd>BufferClose<CR>', noremapSilent)
------ Mac
map('n', '≤', '<Cmd>BufferPrevious<CR>', noremapSilent)
map('n', '≥', '<Cmd>BufferNext<CR>', noremapSilent)
map('n', '¯', '<Cmd>BufferMovePrevious<CR>', noremapSilent)
map('n', '˘', '<Cmd>BufferMoveNext<CR>', noremapSilent)
map('n', '¡', '<Cmd>BufferGoto 1<CR>', noremapSilent)
map('n', '™', '<Cmd>BufferGoto 2<CR>', noremapSilent)
map('n', '£', '<Cmd>BufferGoto 3<CR>', noremapSilent)
map('n', '€', '<Cmd>BufferGoto 4<CR>', noremapSilent)
map('n', '∞', '<Cmd>BufferGoto 5<CR>', noremapSilent)
map('n', '§', '<Cmd>BufferGoto 6<CR>', noremapSilent)
map('n', '¶', '<Cmd>BufferGoto 7<CR>', noremapSilent)
map('n', '•', '<Cmd>BufferGoto 8<CR>', noremapSilent)
map('n', 'ª', '<Cmd>BufferGoto 9<CR>', noremapSilent)
map('n', 'ç', '<Cmd>BufferClose<CR>', noremapSilent)

---- Toggle tree
map('', '<C-e>', [[<Cmd>lua require('custom.nvim-tree').toggle()<CR>]], { noremap = true })

-- Telescope
map('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true })
map('n', '<Leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true })
map('n', '<Leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true })
map('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true })

-- Tagbar
map('n', '<F8>', ':TagbarToggle<CR>', { noremap = false })

-- Terminal
map('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

-- Trouble
map('n', '<leader>xx', '<cmd>Trouble<cr>', noremapSilent)
map('n', '<leader>xw', '<cmd>Trouble lsp_workspace_diagnostics<cr>', noremapSilent)
map('n', '<leader>xd', '<cmd>Trouble lsp_document_diagnostics<cr>', noremapSilent)
map('n', '<leader>xl', '<cmd>Trouble loclist<cr>', noremapSilent)
map('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', noremapSilent)
map('n', 'gR', '<cmd>Trouble lsp_references<cr>', noremapSilent)
