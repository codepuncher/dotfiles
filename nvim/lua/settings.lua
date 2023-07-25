vim.o.backspace = '2' -- Backspace deletes like most programs in insert mode
vim.o.hlsearch = true -- highlight searches (:noh to turn off)
vim.o.ignorecase = true -- case insensitive searching
vim.o.smartcase = true -- overrides ignorecase when pattern contains caps
vim.o.laststatus = 1 -- Always display the status line
vim.o.cmdheight = 0 -- Hide the command line until activated.
vim.o.ruler = true -- show the cursor position all the time
vim.o.showcmd = true -- display incomplete commands
vim.o.incsearch = true -- do incremental searching
vim.o.cursorline = true -- Enable highlighting of the current line
vim.o.statuscolumn = '%s %l %r'

-- Tabs and spaces
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.backspace = 'indent,eol,start'
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.opt.list = true
vim.opt.listchars = 'tab:->,trail:·'
vim.o.joinspaces = false

-- Folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99
vim.foldlevelstart = 99

-- Numbers
vim.o.number = true
vim.o.numberwidth = 5
---- On insert, use absolute. On leave, use relative. From: https://jeffkreeftmeijer.com/vim-number/
local numbertoggle_group = vim.api.nvim_create_augroup('numbertoggle', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  group = numbertoggle_group,
  callback = function()
    if not vim.wo.nu or vim.api.nvim_get_mode() == 'i' then
      return
    end

    vim.wo.rnu = true
  end,
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  group = numbertoggle_group,
  callback = function()
    if not vim.wo.nu then
      return
    end

    vim.wo.rnu = false
  end,
})

-- Layout
vim.o.completeopt = 'menu,menuone,noselect' -- Vim popup style
---- Open new split panes to right and bottom, which feels more natural
vim.o.splitbelow = true
vim.o.splitright = true

-- Colours
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, 'TelescopeNormal', { ctermbg = 220 })

-- Misc
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250 -- Update sign column every quarter second
local highlight_group = vim.api.nvim_create_augroup('highlight_yank', { clear = true })
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = highlight_group,
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 700,
    })
  end,
})

-- Filetypes
vim.api.nvim_create_autocmd({ 'FileType' }, {
  desc = 'Set indents for Lua files',
  pattern = 'lua',
  command = 'setlocal shiftwidth=2 softtabstop=2 expandtab',
})
vim.api.nvim_create_autocmd({ 'FileType' }, {
  desc = 'Set indents for Markdown files',
  pattern = 'markdown',
  command = 'setlocal shiftwidth=4 softtabstop=4 expandtab',
})
