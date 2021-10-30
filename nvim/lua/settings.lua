-- vim.o.scriptencoding = 'utf-8' --unsure how to set this
vim.g.mapleader = ' '

vim.o.backspace = '2'       --Backspace deletes like most programs in insert mode
vim.o.hlsearch = true          --highlight searches (:noh to turn off)
vim.o.ignorecase = true        --case insensitive searching
vim.o.smartcase = true         --overrides ignorecase when pattern contains caps
vim.o.laststatus = 2      --Always display the status line
vim.o.ruler = true             --show the cursor position all the time
vim.o.showcmd = true           --display incomplete commands
vim.o.incsearch = true         --do incremental searching

--Tabs and spaces
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

--Numbers
vim.o.number = true
vim.o.numberwidth = 5
--On insert, use absolute. On leave, use relative.
--From: https://jeffkreeftmeijer.com/vim-number/
vim.api.nvim_command [[augroup numbertoggle]]
  vim.api.nvim_command [[autocmd!]]
  vim.api.nvim_command [[autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif]]
  vim.api.nvim_command [[autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif]]
vim.api.nvim_command [[augroup END]]

--Vim popup style
vim.o.completeopt = 'menu,menuone,noselect'

--Open new split panes to right and bottom, which feels more natural
vim.o.splitbelow = true
vim.o.splitright = true

--Colours
vim.opt.termguicolors = true
vim.cmd [[colorscheme nightfox]]
local nightfox = require('nightfox')
nightfox.setup({
  fox = 'nightfox',
})
nightfox.load()

vim.g.lightline = {
  colorscheme = 'nightfox',
}
vim.g.colorizer_auto_color = 1

--Misc
vim.o.updatetime = 250 --Update sign column every quarter second

--Dev
vim.g.neomake_php_phpcs_args_standard = 'PSR2'
vim.g.tagbar_ctags_bin = '/usr/bin/uctags'
vim.g.NERDDefaultAlign = 'left'
vim.g.NERDSpaceDelims = 1

