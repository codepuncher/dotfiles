-- CTags regeneration on write
vim.api.nvim_command([[au BufWritePost *.php silent! !eval '[ -f ".git/hooks/uctags" ] && .git/hooks/uctags' &]])
