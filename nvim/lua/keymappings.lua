local _wk, wk = pcall(require, 'which-key')
if not _wk then
  return
end

wk.add({
  mode = 'n',
  prefix = '',
  silent = false,
  noremap = true,
  nowait = true,
  { '<leader>w', '<cmd>update<cr>', group = 'buffers', desc = 'Write unsaved buffer contents' },
})

-- Buffers
wk.add({
  group = 'buffers',
  mode = 'n',
  prefix = '',
  silent = true,
  noremap = true,
  nowait = true,
  ---- BufferLine
  ------ Linux
  { '<A-,>', '<Cmd>BufferLineCyclePrev<cr>', desc = 'Cycle to previous' },
  { '<A-.>', '<Cmd>BufferLineCycleNext<cr>', desc = 'Cycle to next' },
  { '<A-<>', '<Cmd>BufferLineMovePrev<cr>', desc = 'Move to previous' },
  { '<A->>', '<Cmd>BufferLineMoveNext<cr>', desc = 'Move to next' },
  { '<A-1>', '<Cmd>BufferLineGoToBuffer 1<cr>', desc = 'Go to #1' },
  { '<A-2>', '<Cmd>BufferLineGoToBuffer 2<cr>', desc = 'Go to #2' },
  { '<A-3>', '<Cmd>BufferLineGoToBuffer 3<cr>', desc = 'Go to #3' },
  { '<A-4>', '<Cmd>BufferLineGoToBuffer 4<cr>', desc = 'Go to #4' },
  { '<A-5>', '<Cmd>BufferLineGoToBuffer 5<cr>', desc = 'Go to #5' },
  { '<A-6>', '<Cmd>BufferLineGoToBuffer 6<cr>', desc = 'Go to #6' },
  { '<A-7>', '<Cmd>BufferLineGoToBuffer 7<cr>', desc = 'Go to #7' },
  { '<A-8>', '<Cmd>BufferLineGoToBuffer 8<cr>', desc = 'Go to #8' },
  { '<A-9>', '<Cmd>BufferLineGoToBuffer 9<cr>', desc = 'Go to #9' },
  { '<A-c>', '<Cmd>Bdelete<cr>', desc = 'Delete' },
  ------ Mac
  { '≤', '<Cmd>BufferLineCyclePrev<cr>', desc = 'Cycle to previous' },
  { '≥', '<Cmd>BufferLineCycleNext<cr>', desc = 'Cycle to next' },
  { '¯', '<Cmd>BufferLineMovePrev<cr>', desc = 'Move to previous' },
  { '˘', '<Cmd>BufferLineMoveNext<cr>', desc = 'Move to next' },
  { '¡', '<Cmd>BufferLineGoToBuffer 1<cr>', desc = 'Go to #1' },
  { '™', '<Cmd>BufferLineGoToBuffer 2<cr>', desc = 'Go to #2' },
  { '£', '<Cmd>BufferLineGoToBuffer 3<cr>', desc = 'Go to #3' },
  { '€', '<Cmd>BufferLineGoToBuffer 4<cr>', desc = 'Go to #4' },
  { '∞', '<Cmd>BufferLineGoToBuffer 5<cr>', desc = 'Go to #5' },
  { '§', '<Cmd>BufferLineGoToBuffer 6<cr>', desc = 'Go to #6' },
  { '¶', '<Cmd>BufferLineGoToBuffer 7<cr>', desc = 'Go to #7' },
  { '•', '<Cmd>BufferLineGoToBuffer 8<cr>', desc = 'Go to #8' },
  { 'ª', '<Cmd>BufferLineGoToBuffer 9<cr>', desc = 'Go to #9' },
  { 'ç', '<Cmd>Bdelete<cr>', desc = 'Delete' },
})

-- LSP
wk.add({
  group = 'lsp',
  mode = 'n',
  prefix = '',
  silent = true,
  noremap = true,
  nowait = true,
  { '<leader>ca', '<cmd>Lspsaga code_action<CR>', desc = 'Code Action' },
  { '<leader>fm', '<cmd>lua vim.lsp.buf.format()<CR>', desc = 'Format' },
  { 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', desc = 'Go to definition' },
  { 'K', '<cmd>Lspsaga hover_doc<CR>', desc = 'Hover documentation' },
  { '<leader><space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', desc = 'Get signature help' },
  { '<leader>rn', '<cmd>Lspsaga rename<CR>', desc = 'Rename' },
  { 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', desc = 'Get references' },
  { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', desc = 'Go to previous diagnostic' },
  { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', desc = 'Go to next diagnostic' },
  { '<leader>so', '<cmd>Lspsaga outline<cr>', desc = '[LSP] Outline symbols' },
})

-- NvimTree
wk.add({
  group = 'nvimtree',
  { '<C-e>', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle' },
})

-- Telescope
wk.add({
  group = 'telescope',
  { '<leader>F', group = '[TELESCOPE] ignore=false' },
  {
    '<leader>FF',
    "<cmd>lua require('plugins.configs.telescope').find_files_no_ignore()<cr>",
    desc = '[TELESCOPE] Find files (ignore=false)',
  },
  {
    '<leader>FT',
    "<cmd>lua require('plugins.configs.telescope').live_grep()<cr>",
    desc = '[TELESCOPE] Grep files (ignore=false)',
  },
  { '<leader>f', group = '[TELESCOPE]' },
  {
    '<leader>fT',
    "<cmd>lua require('plugins.configs.telescope').live_grep_with_file_type ()<cr>",
    desc = '[TELESCOPE] Grep files by file type',
  },
  {
    '<leader>fb',
    "<cmd>lua require('telescope').extensions.file_browser.file_browser()<cr>",
    desc = '[TELESCOPE] Buffers',
  },
  {
    '<leader>ff',
    "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({layout_config={width=100, height=0.75}}))<cr>",
    desc = '[TELESCOPE] Find files (ignore=true)',
  },
  { '<leader>fg', group = '[TELESCOPE] Git' },
  {
    '<leader>fgb',
    "<cmd>lua require('telescope.builtin').git_branches(require('telescope.themes').get_ivy({}))<cr>",
    desc = '[TELESCOPE] Git branches',
  },
  { '<leader>fgr', '<cmd>Telescope gh run<cr>', desc = '[TELESCOPE] GitHub view workflow runs' },
  {
    '<leader>fgs',
    "<cmd>lua require('telescope.builtin').git_status(require('telescope.themes').get_dropdown({layout_strategy='vertical', layout_config={width=0.75, height=0.95}}))<cr>",
    desc = '[TELESCOPE] Git status',
  },
  { '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = '[TELESCOPE] Help tags' },
  { '<leader>fl', group = '[TELESCOPE] LSP' },
  {
    '<leader>flw',
    "<cmd>lua require('plugins.configs.telescope').lsp_workspace_symbols()<cr>",
    desc = '[TELESCOPE] LSP workspace symbols',
  },
  { '<leader>fr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", desc = '[TELESCOPE] LSP references' },
  {
    '<leader>ft',
    "<cmd>lua require('telescope.builtin').live_grep()<cr>",
    desc = '[TELESCOPE] Grep files (ignore=true)',
  },
})

-- Misc
wk.add({
  group = 'misc',
  { '+', '<c-a>', desc = 'Increment number' },
  { '-', '<c-x>', desc = 'Decrement number' },
  { '<c-J>', '<cmd>m .+1<cr>==', desc = '[LINES] Move line up' },
  { '<c-K>', '<cmd>m .-2<cr>==', desc = '[LINES] Move line down' },
  { '<c-n>', '<cmd>nohls<cr>', desc = '[LINES] Clear highlights' },
  { '<leader>l', group = '[LUA]' },
  {
    '<leader>lrk',
    "<cmd>source ~/.config/nvim/lua/keymappings.lua | echo 'Keymaps reloaded'<cr>",
    desc = '[LUA] Reload keymaps',
  },
})

wk.add({
  { '<leader>g', group = '[GIT]' },
  {
    '<leader>g=',
    "<cmd>Git push -u origin @ | :execute '!gh pr create -f'<cr>",
    desc = '[GIT] Push new branch, create a PR',
  },
  { '<leader>gP', '<cmd>Git push -f<cr>', desc = '[GIT] Push (force)' },
  {
    '<leader>gaA',
    "<Cmd>Git add -A <bar> echo 'Staged tracked and untracked files'<cr>",
    desc = '[GIT] Stage tracked and untracked files',
  },
  { '<leader>gaa', "<Cmd>Git add . <bar> echo 'Staged tracked files'<cr>", desc = '[GIT] Stage tracked files' },
  { '<leader>gaf', "<Cmd>Git add % <bar> echo 'Staged ' . expand('%')<cr>", desc = '[GIT] Stage current file' },
  {
    '<leader>gbf',
    desc = "<Cmd>lua vim.api.nvim_command('!gh browse ' .. vim.fn.expand('%') .. ':' .. vim.api.nvim_win_get_cursor(0)[1])",
  },
  { '<leader>gbn', "<Cmd>lua require('utils').git_branch_new()<cr>", desc = '[GIT] Create new branch' },
  { '<leader>gbr', "<Cmd>lua require('utils').git_branch_rename()<cr>", desc = '[GIT] Rename current branch' },
  { '<leader>gca', '<cmd>Git commit -a<cr>', desc = '[GIT] Commit all tracked files' },
  { '<leader>gcc', '<cmd>Git commit<cr>', desc = '[GIT] Commit' },
  { '<leader>gda', '<cmd>vertical Git diff<cr>', desc = '[GIT] Diff all' },
  { '<leader>gdf', '<cmd>Gvdiffsplit<cr>', desc = '[GIT] Diff current file' },
  {
    '<leader>gfrh',
    '<cmd>Git fetch --all --prune | Git reset --hard "@{u}"<cr>',
    desc = '[GIT] Fetch latest changes and reset state',
  },
  { '<leader>gh', desc = '<cmd>diffget //3<cr>' },
  { '<leader>gl', desc = '<cmd>diffget //2<cr>' },
  { '<leader>gmpr', '<cmd>!gh pr merge -md<cr>', desc = '[GIT] Merge PR and delete branch' },
  { '<leader>gp', '<cmd>Git push<cr>', desc = '[GIT] Push' },
  { '<leader>gs', '<cmd>Git<cr>', desc = '[GIT] Status' },
  { '<leader>gvpr', '<cmd>!gh pr view -w<cr>', desc = '[GIT] View PR in browser' },
})

wk.add({
  { '<leader>x', group = '[TROUBLE]' },
  { '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', desc = '[TROUBLE] Document diagnostics' },
  { '<leader>xl', '<cmd>Trouble loclist<cr>', desc = '[TROUBLE] Loclist' },
  { '<leader>xq', '<cmd>Trouble quickfix<cr>', desc = '[TROUBLE] Quickfix' },
  { '<leader>xr', '<cmd>Trouble lsp_references<cr>', desc = '[TROUBLE] References' },
  { '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', desc = '[TROUBLE] Workspace diagnostics' },
  { '<leader>xx', '<cmd>Trouble toggle diagnostics<cr>', desc = '[TROUBLE] Toggle' },
})

wk.setup({})

---- Lines
---- TODO: Migrate to Lua
vim.api.nvim_command([[vnoremap K :m '<-2<cr>gv=gv]])
vim.api.nvim_command([[vnoremap J :m '>+1<cr>gv=gv]])
