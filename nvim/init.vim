lua require('plugins')
lua require('settings')

call neomake#configure#automake('nrwi')

" Use CTRL + direction to change windows/buffers
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k

" CTags regeneration on write
au BufWritePost *.php silent! !eval '[ -f ".git/hooks/uctags" ] && .git/hooks/uctags' &

" Tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_ctags_bin = '/usr/bin/uctags'

" barbar
" Move to previous/next
nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>

" lspsaga
" show hover doc
nnoremap <silent> <C-j> :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>
inoremap <silent> <C-k> :Lspsaga signature_help<CR>
