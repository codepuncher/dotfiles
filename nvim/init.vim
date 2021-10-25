scriptencoding utf-8

let mapleader = " "

set backspace=2       " Backspace deletes like most programs in insert mode
set hlsearch          " highlight searches (:noh to turn off)
set ignorecase        " case insensitive searching
set smartcase         " overrides ignorecase when pattern contains caps
set laststatus=2      " Always display the status line
set ruler             " show the cursor position all the time
set showcmd           " display incomplete commands
set incsearch         " do incremental searching

" Tabs and spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start
set expandtab
set autoindent
set smartindent
set smarttab
set list listchars=tab:->,trail:·
set nojoinspaces

" Numbers
set number
set numberwidth=5
" On insert, use absolute. On leave, use relative.
" From: https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

lua require('plugins')
lua require('custom/nvim-tree')

let g:colorizer_auto_color = 1

syntax on
colorscheme nightfox
let g:lightline = {
  \ 'colorscheme': 'nightfox',
  \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
  \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
\ }

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors

call neomake#configure#automake('nrwi')
let g:neomake_php_phpcs_args_standard='PSR2'

" Use CTRL + direction to change windows/buffers
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k

" NERDCommenter
let g:NERDDefaultAlign = 'left'
let g:NERDSpaceDelims = 1

" CTags regeneration on write
au BufWritePost *.php silent! !eval '[ -f ".git/hooks/uctags" ] && .git/hooks/uctags' &

" Tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_ctags_bin = '/usr/bin/uctags'

" Update sign column every quarter second
set updatetime=250

" barbar
" Move to previous/next
nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>

" lspsaga
" show hover doc
nnoremap <silent> <C-j> :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>
inoremap <silent> <C-k> :Lspsaga signature_help<CR>
