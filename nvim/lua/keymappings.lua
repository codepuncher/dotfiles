local _wk, wk = pcall(require, 'which-key')
if not _wk then
  return
end

local nNoremap = {
  mode = 'n',
  prefix = '',
  silent = false,
  noremap = true,
  nowait = true,
}
wk.register({
  ['<leader>w'] = { '<cmd>update<cr>', '[BUFFER] Write unsaved buffer contents' },
}, nNoremap)

local nNoremapSilent = nNoremap
nNoremapSilent.silent = true
wk.register({
  -- Buffers
  ---- BufferLine
  ------ Linux
  ['<A-,>'] = { '<Cmd>BufferLineCyclePrev<cr>', '[BUFFER] Cycle to previous' },
  ['<A-.>'] = { '<Cmd>BufferLineCycleNext<cr>', '[BUFFER] Cycle to next' },
  ['<A-<>'] = { '<Cmd>BufferLineMovePrev<cr>', '[BUFFER] Move to previous' },
  ['<A->>'] = { '<Cmd>BufferLineMoveNext<cr>', '[BUFFER] Move to next' },
  ['<A-1>'] = { '<Cmd>BufferLineGoToBuffer 1<cr>', '[BUFFER] Go to #1' },
  ['<A-2>'] = { '<Cmd>BufferLineGoToBuffer 2<cr>', '[BUFFER] Go to #2' },
  ['<A-3>'] = { '<Cmd>BufferLineGoToBuffer 3<cr>', '[BUFFER] Go to #3' },
  ['<A-4>'] = { '<Cmd>BufferLineGoToBuffer 4<cr>', '[BUFFER] Go to #4' },
  ['<A-5>'] = { '<Cmd>BufferLineGoToBuffer 5<cr>', '[BUFFER] Go to #5' },
  ['<A-6>'] = { '<Cmd>BufferLineGoToBuffer 6<cr>', '[BUFFER] Go to #6' },
  ['<A-7>'] = { '<Cmd>BufferLineGoToBuffer 7<cr>', '[BUFFER] Go to #7' },
  ['<A-8>'] = { '<Cmd>BufferLineGoToBuffer 8<cr>', '[BUFFER] Go to #8' },
  ['<A-9>'] = { '<Cmd>BufferLineGoToBuffer 9<cr>', '[BUFFER] Go to #9' },
  ['<A-c>'] = { '<Cmd>Bdelete<cr>', '[BUFFER] Delete' },
  ------ Mac
  ['≤'] = { '<Cmd>BufferLineCyclePrev<cr>', '[BUFFER] Cycle to previous' },
  ['≥'] = { '<Cmd>BufferLineCycleNext<cr>', '[BUFFER] Cycle to next' },
  ['¯'] = { '<Cmd>BufferLineMovePrev<cr>', '[BUFFER] Move to previous' },
  ['˘'] = { '<Cmd>BufferLineMoveNext<cr>', '[BUFFER] Move to next' },
  ['¡'] = { '<Cmd>BufferLineGoToBuffer 1<cr>', '[BUFFER] Go to #1' },
  ['™'] = { '<Cmd>BufferLineGoToBuffer 2<cr>', '[BUFFER] Go to #2' },
  ['£'] = { '<Cmd>BufferLineGoToBuffer 3<cr>', '[BUFFER] Go to #3' },
  ['€'] = { '<Cmd>BufferLineGoToBuffer 4<cr>', '[BUFFER] Go to #4' },
  ['∞'] = { '<Cmd>BufferLineGoToBuffer 5<cr>', '[BUFFER] Go to #5' },
  ['§'] = { '<Cmd>BufferLineGoToBuffer 6<cr>', '[BUFFER] Go to #6' },
  ['¶'] = { '<Cmd>BufferLineGoToBuffer 7<cr>', '[BUFFER] Go to #7' },
  ['•'] = { '<Cmd>BufferLineGoToBuffer 8<cr>', '[BUFFER] Go to #8' },
  ['ª'] = { '<Cmd>BufferLineGoToBuffer 9<cr>', '[BUFFER] Go to #9' },
  ['ç'] = { '<Cmd>Bdelete<cr>', '[BUFFER] Delete' },

  -- NvimTree
  ['<C-e>'] = { '<cmd>NvimTreeToggle<cr>', '[NVIMTREE] Toggle' },

  -- Telescope
  ['<leader>f'] = {
    name = '[TELESCOPE]',
    f = {
      [[<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({layout_config={width=0.5}}))<cr>]],
      '[TELESCOPE] Find files (ignore=true)',
    },
    t = { [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], '[TELESCOPE] Grep files (ignore=true)' },
    b = { [[<cmd>lua require('telescope').extensions.file_browser.file_browser()<cr>]], '[TELESCOPE] Buffers' },
    h = { [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], '[TELESCOPE] Help tags' },
    r = { [[<cmd>lua require('telescope.builtin').lsp_references()<cr>]], '[TELESCOPE] LSP references' },
  },
  ['<leader>F'] = {
    name = '[TELESCOPE] ignore=false',
    F = {
      [[<cmd>lua require('plugins.configs.telescope').find_files_no_ignore()<cr>]],
      '[TELESCOPE] Find files (ignore=false)',
    },
    T = { [[<cmd>lua require('plugins.configs.telescope').live_grep()<cr>]], '[TELESCOPE] Grep files (ignore=false)' },
  },
  ['<leader>fg'] = {
    name = '[TELESCOPE] Git',
    s = { [[<cmd>lua require('telescope.builtin').git_status()<cr>]], '[TELESCOPE] Git status' },
    b = {
      [[<cmd>lua require('telescope.builtin').git_branches(require('telescope.themes').get_ivy({}))<cr>]],
      '[TELESCOPE] Git branches',
    },
    r = { '<cmd>Telescope gh run<cr>', '[TELESCOPE] GitHub view workflow runs' },
  },
  ['<leader>fl'] = {
    name = '[TELESCOPE] LSP',
    w = {
      [[<cmd>lua require('plugins.configs.telescope').lsp_workspace_symbols()<cr>]],
      '[TELESCOPE] LSP workspace symbols',
    },
  },

  -- Trouble
  ['<leader>x'] = {
    name = '[TROUBLE]',
    x = { '<cmd>TroubleToggle<cr>', '[TROUBLE] Toggle' },
    w = { '<cmd>Trouble workspace_diagnostics<cr>', '[TROUBLE] Workspace diagnostics' },
    d = { '<cmd>Trouble document_diagnostics<cr>', '[TROUBLE] Document diagnostics' },
    l = { '<cmd>Trouble loclist<cr>', '[TROUBLE] Loclist' },
    q = { '<cmd>Trouble quickfix<cr>', '[TROUBLE] Quickfix' },
    r = { '<cmd>Trouble lsp_references<cr>', '[TROUBLE] References' },
  },

  -- Misc
  ['+'] = { '<c-a>', 'Increment number' },
  ['-'] = { '<c-x>', 'Decrement number' },

  -- Git/Fugitive
  ['<leader>g'] = {
    name = '[GIT]',
    da = { '<cmd>Git diff<cr>', '[GIT] Diff all' },
    df = { '<cmd>Git diff %<cr>', '[GIT] Diff current file' },
    s = { '<cmd>Git<cr>', '[GIT] Status' },
    h = { '<cmd>diffget //3<cr>' },
    l = { '<cmd>diffget //2<cr>' },
    cc = { '<cmd>Git commit<cr>', '[GIT] Commit' },
    ca = { '<cmd>Git commit -a<cr>', '[GIT] Commit all tracked files' },
    af = { "<Cmd>Git add % <bar> echo 'Staged ' . expand('%')<cr>", '[GIT] Stage current file' },
    aa = { "<Cmd>Git add . <bar> echo 'Staged tracked files'<cr>", '[GIT] Stage tracked files' },
    aA = {
      "<Cmd>Git add -A <bar> echo 'Staged tracked and untracked files'<cr>",
      '[GIT] Stage tracked and untracked files',
    },
    p = { '<cmd>Git push<cr>', '[GIT] Push' },
    P = { '<cmd>Git push -f<cr>', '[GIT] Push (force)' },
    bn = { "<Cmd>lua require('utils').git_branch_new()<cr>", '[GIT] Create new branch' },
    br = { "<Cmd>lua require('utils').git_branch_rename()<cr>", '[GIT] Rename current branch' },
    ['='] = {
      "<cmd>Git push -u origin @ | :execute '!gh pr create -f'<cr>",
      '[GIT] Push new branch, create a PR and watch the Actions job',
    },
    mpr = { '<cmd>!gh pr merge -md<cr>', '[GIT] Merge PR and delete branch' },
  },

  -- Symbols Outline
  ['<leader>so'] = { '<cmd>LSoutlineToggle<cr>', '[LSP] Outline symbols' },

  -- Lua stuff
  ['<leader>l'] = {
    name = '[LUA]',
    rk = { "<cmd>source ~/.config/nvim/lua/keymappings.lua | echo 'Keymaps reloaded'<cr>", '[LUA] Reload keymaps' },
  },

  -- Lines
  ['<c-J>'] = { '<cmd>m .+1<cr>==', '[LINES] Move line up' },
  ['<c-K>'] = { '<cmd>m .-2<cr>==', '[LINES] Move line down' },
}, nNoremapSilent)

wk.setup({})

---- Lines
---- TODO: Migrate to Lua
vim.api.nvim_command([[vnoremap J :m '>+1<cr>gv=gv]])
vim.api.nvim_command([[vnoremap K :m '<-2<cr>gv=gv]])
