set number
syntax on
set autochdir

set nowrap " forces style
set expandtab
set tabstop=4
set autoindent
set copyindent
set shiftwidth=4
set smarttab " makes you go back 4 when you del from tab
set hlsearch
set incsearch " incrementally highlight your searches
set pastetoggle=<F2>

" remove backups from vim
set nobackup
set noswapfile

ab teh the
ab dont' don't
ab its' it's
ab haev have
ab cccc Cool. Cool cool cool.

nnoremap ; :
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :call Underline("=")<CR>

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

function! Underline(delimiter)
    let x = line('.')
    if x == "0"
        echo "Nope"
    else
        :call append(line('.'), repeat('=' ,strlen(getline(x))))
    endif
endfunction
