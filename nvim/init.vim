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

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

call plug#begin('~/.local/share/nvim/plugged')

Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'mattn/emmet-vim'
Plug 'neomake/neomake'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'jwalton512/vim-blade', { 'for': 'blade' }
Plug 'joshdick/onedark.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'chrisbra/Colorizer'
Plug 'vim-scripts/buftabs'
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

let g:deoplete#enable_at_startup = 1
let g:colorizer_auto_color = 1

call plug#end()

syntax on
let g:onedark_termcolors=256
colorscheme onedark
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
  \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
\ }

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

" Make background transparent
highlight Normal guibg=none
highlight NonText guibg=none

call neomake#configure#automake('nrwi')
let g:neomake_php_phpcs_args_standard='PSR2'

" Use CTRL + direction to change windows/buffers
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
