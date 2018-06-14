source ~/.config/nvim/plugins.vim

let mapleader=","

inoremap jk <esc>
nnoremap ; :

nnoremap <leader><leader> <C-^>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <Right> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j
nnoremap <C-j> <C-w>j

colorscheme molokai256

set number
set relativenumber
set clipboard+=unnamedplus
set colorcolumn=81

source ~/.config/nvim/fuzzy-finding.vim
source ~/.config/nvim/smart-tab.vim
source ~/.config/nvim/test-support.vim
source ~/.config/nvim/trailing-whitespace.vim

if filereadable($HOME . '/.config/nvim/local.vim')
    source $HOME/.config/nvim/local.vim
endif
