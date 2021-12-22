local map = vim.api.nvim_set_keymap;
local noremap = {noremap = true}
local noremapSilent = {noremap = true, silent = true}

-- Files
map('n', '<Leader>w', ':update<CR>', noremapSilent)

-- Navigation
---- Switch windows
map('', '<C-l>', '<C-w>l', noremap)
map('', '<C-h>', '<C-w>h', noremap)
map('', '<C-j>', '<C-w>j', noremap)
map('', '<C-k>', '<C-w>k', noremap)
---- Barbar
------ Linux
map('n', '<A-,>', '<Cmd>BufferLineCyclePrev<CR>', noremapSilent)
map('n', '<A-.>', '<Cmd>BufferLineCycleNext<CR>', noremapSilent)
map('n', '<A-<>', '<Cmd>BufferLineMovePrev<CR>', noremapSilent)
map('n', '<A->>', '<Cmd>BufferLineMoveNext<CR>', noremapSilent)
map('n', '<A-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', noremapSilent)
map('n', '<A-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', noremapSilent)
map('n', '<A-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', noremapSilent)
map('n', '<A-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', noremapSilent)
map('n', '<A-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', noremapSilent)
map('n', '<A-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', noremapSilent)
map('n', '<A-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', noremapSilent)
map('n', '<A-8>', '<Cmd>BufferLineGoToBuffer 8<CR>', noremapSilent)
map('n', '<A-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', noremapSilent)
map('n', '<A-c>', '<Cmd>Bdelete<CR>', noremapSilent)
------ Mac
map('n', '≤', '<Cmd>BufferLineCyclePrev<CR>', noremapSilent)
map('n', '≥', '<Cmd>BufferLineCycleNext<CR>', noremapSilent)
map('n', '¯', '<Cmd>BufferLineMovePrev<CR>', noremapSilent)
map('n', '˘', '<Cmd>BufferLineMoveNext<CR>', noremapSilent)
map('n', '¡', '<Cmd>BufferLineGoToBuffer 1<CR>', noremapSilent)
map('n', '™', '<Cmd>BufferLineGoToBuffer 2<CR>', noremapSilent)
map('n', '£', '<Cmd>BufferLineGoToBuffer 3<CR>', noremapSilent)
map('n', '€', '<Cmd>BufferLineGoToBuffer 4<CR>', noremapSilent)
map('n', '∞', '<Cmd>BufferLineGoToBuffer 5<CR>', noremapSilent)
map('n', '§', '<Cmd>BufferLineGoToBuffer 6<CR>', noremapSilent)
map('n', '¶', '<Cmd>BufferLineGoToBuffer 7<CR>', noremapSilent)
map('n', '•', '<Cmd>BufferLineGoToBuffer 8<CR>', noremapSilent)
map('n', 'ª', '<Cmd>BufferLineGoToBuffer 9<CR>', noremapSilent)
map('n', 'ç', '<Cmd>Bdelete<CR>', noremapSilent)
---- Toggle tree
map('', '<C-e>', [[<Cmd>lua require('nvim-tree').toggle()<CR>]], noremap)

-- Telescope
map('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], noremap) -- With ignore
map('n', '<Leader>FF', [[<cmd>lua require('custom.telescope').find_files()<CR>]], noremap) -- Without ignore
map('n', '<Leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], noremap) -- With ignore
map('n', '<Leader>FG', [[<cmd>lua require('custom.telescope').live_grep()<CR>]], noremap) -- Without ignore
map('n', '<Leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], noremap)
map('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], noremap)
map('n', '<Leader>fr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], noremap)
map('n', '<Leader>fgs', [[<cmd>lua require('telescope.builtin').git_status()<CR>]], noremap)

-- Terminal
map('t', '<Esc>', '<C-\\><C-n>', noremap)

-- Trouble
map('n', '<leader>xx', '<cmd>Trouble<cr>', noremapSilent)
map('n', '<leader>xw', '<cmd>Trouble lsp_workspace_diagnostics<cr>', noremapSilent)
map('n', '<leader>xd', '<cmd>Trouble lsp_document_diagnostics<cr>', noremapSilent)
map('n', '<leader>xl', '<cmd>Trouble loclist<cr>', noremapSilent)
map('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', noremapSilent)
map('n', 'gR', '<cmd>Trouble lsp_references<cr>', noremapSilent)

-- (In/De)crement numbers
map('n', '+', '<C-a>', noremap)
map('n', '-', '<C-x>', noremap)
