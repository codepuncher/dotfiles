vim.g.mapleader = ' '

vim.o.backspace = '2'    --Backspace deletes like most programs in insert mode
vim.o.hlsearch = true    --highlight searches (:noh to turn off)
vim.o.ignorecase = true  --case insensitive searching
vim.o.smartcase = true   --overrides ignorecase when pattern contains caps
vim.o.laststatus = 2     --Always display the status line
vim.o.ruler = true       --show the cursor position all the time
vim.o.showcmd = true     --display incomplete commands
vim.o.incsearch = true   --do incremental searching
vim.o.cursorline = true  --Enable highlighting of the current line

----Tabs and spaces
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

--Folding
--vim.opt.fillchars = 'fold'
--vim.wo.foldmethod = 'expr'
--vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

----Numbers
vim.o.number = true
vim.o.numberwidth = 5
----On insert, use absolute. On leave, use relative. From: https://jeffkreeftmeijer.com/vim-number/
vim.api.nvim_command [[augroup numbertoggle]]
  vim.api.nvim_command [[autocmd!]]
  vim.api.nvim_command [[autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif]]
  vim.api.nvim_command [[autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif]]
vim.api.nvim_command [[augroup END]]

----Layout
vim.o.completeopt = 'menu,menuone,noselect' --Vim popup style
----Open new split panes to right and bottom, which feels more natural
vim.o.splitbelow = true
vim.o.splitright = true

----Colours
vim.opt.termguicolors = true
vim.g.tokyonight_style = 'night'
vim.cmd[[colorscheme tokyonight]]
vim.g.Hexokinase_highlighters = { 'virtual' }

----Misc
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250 --Update sign column every quarter second
vim.api.nvim_command [[augroup highlight_yank]]
  vim.api.nvim_command [[autocmd!]]
  vim.api.nvim_command [[au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}]]
vim.api.nvim_command [[augroup END]]

----Dev
vim.g.tagbar_ctags_bin = '/usr/bin/uctags'
vim.g.NERDDefaultAlign = 'left'
vim.g.NERDSpaceDelims = 1
