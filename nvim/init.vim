lua require('plugins')
lua require('settings')
lua require('keymappings')

" CTags regeneration on write
au BufWritePost *.php silent! !eval '[ -f ".git/hooks/uctags" ] && .git/hooks/uctags' &
