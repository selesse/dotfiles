syntax on
set number
set nowrap " forces style
set autoindent
set copyindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab " makes you go back 2 when you del from tab
set hlsearch " highlight all matches in a file when searching
set incsearch " incrementally highlight your searches
set pastetoggle=<F8>
set nobackup " remove backups from vim
set noswapfile " remove backups from vim
set smartcase " use caps if any caps used in search
set laststatus=2 " forces showing status bar
set encoding=utf-8 " order matters for Windows (encoding+autochdir)
set autochdir
set title " modifies window to have filename as its title

iabbrev teh the
iabbrev dont' don't
iabbrev its' it's
iabbrev haev have
iabbrev cccc Cool. Cool cool cool.

" in Vim 7.3, built-in; otherwise fall back to other function 
if exists('+colorcolumn')
  set colorcolumn=80
  autocmd FileType html setlocal colorcolumn=
else
  highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9 
  match OverLength /\%>80v.\+/
endif

" function to underline text
function! Underline(delimiter)
  let x = line('.')
  if x == "0"
    echo "Nope"
  else
    :call append(line('.'), repeat('=', strlen(getline(x))))
  endif
endfunction

" try to set it to colorscheme, no biggie if it fails
silent!colorscheme desert

if v:version >= 600
  filetype plugin on
  filetype indent on
else
  filetype on
endif

if v:version >= 700
  set omnifunc=syntaxcomplete#Complete " override built-in C omnicomplete with C++ OmniCppComplete plugin
  let OmniCpp_GlobalScopeSearch   = 1
  let OmniCpp_DisplayMode         = 1
  let OmniCpp_ShowScopeInAbbr     = 0 "do not show namespace in pop-up
  let OmniCpp_ShowPrototypeInAbbr = 1 "show prototype in pop-up
  let OmniCpp_ShowAccess          = 1 "show access in pop-up
  let OmniCpp_SelectFirstItem     = 1 "select first item in pop-up
  set completeopt=menuone,menu,longest
endif

if version >= 700
  let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
  highlight   clear
  highlight   Pmenu         ctermfg=0 ctermbg=2
  highlight   PmenuSel      ctermfg=0 ctermbg=7
  highlight   PmenuSbar     ctermfg=7 ctermbg=0
  highlight   PmenuThumb    ctermfg=0 ctermbg=7
endif

function! UpdateTags()
  execute ":!ctags -R --languages=C++ --c++-kinds=+p --fields=+iaS --extra=+q ./"
  echohl StatusLine | echo "C/C++ tag updated" | echohl None
endfunction

nnoremap ; :
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :call Underline("=")<CR>
nnoremap <F4> <Esc>:1,$!xmllint --format %<CR>
" f5 reserved for previewing file
nnoremap <F6> :call UpdateTags()
nnoremap <F7> :NumbersToggle<CR>

" OS specific mappings {{{
" also useful - has('gui_running')
if has("win32") 
  " assume that your file ends with .html
  autocmd FileType html nmap <silent> <F5> :! start %<CR>
else
  if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
      " mac stuff
      autocmd FileType html <silent> <F5> :!open -a Google\ Chrome %<CR>
    else
      " linux stuff
      autocmd FileType html nmap <silent> <F5> :!gnome-open %<CR>
    endif
    " mac + linux stuff
  else
    echo "No idea what OS you're running"
  endif
endif
" }}}

" mappings
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
nnoremap <leader>w :set hlsearch!<CR>
nnoremap <leader>dw :%s/\v +\n/\r/g<CR> " when substituting, \r is newline
nnoremap <leader><F5> :cd $HOME/git/swmud<CR>:!sendToMud.sh %:p<CR>
nnoremap / /\v
nnoremap Y 0y$

" Shift+h/l will move you to left/right tabs, arrow key will change split
nnoremap <S-h> gT
nnoremap <S-l> gt
nnoremap <Right> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j

inoremap jk <esc>
inoremap <esc> <nop>

" flag lines that have trailing whitespace
highlight TrailingWhiteSpace ctermbg=yellow guibg=yellow
match TrailingWhiteSpace /\v +\n/

" Language-specific mapping for comments {{{
augroup commenter
  autocmd!
  autocmd FileType javascript,java,c nnoremap <buffer> <localleader>c I//<ESC>
  autocmd FileType python nnoremap <buffer> <localleader>c I#<ESC>
augroup END
" }}}

" Language-specific mappings {{{
augroup filetype_python
  autocmd!
  autocmd FileType python nnoremap <F5> :!python % <CR>
augroup END

augroup filetype_makefile
  autocmd!
  autocmd Filetype make setlocal noexpandtab
augroup END

augroup filetype_xml
  autocmd!
  autocmd BufRead,BufWrite *.xml :silent %!xmllint --format %
augroup END

augroup filetype_java
  autocmd!
  autocmd Filetype java setlocal cindent
  autocmd Filetype java setlocal omnifunc=javacomplete#Complete
augroup END

augroup filetype_c
  autocmd!
  autocmd Filetype c nnoremap <F5> :make run<CR>
augroup END

" }}}

" Vimscript file settings {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

call pathogen#infect()
call pathogen#helptags()

" Status line settings {{{
set statusline=%.40F " write full path to file, max of 40 chars
set statusline+=%h%m%r " help file, modified, and read only
set statusline+=\ %v\| " column number + |
set statusline+=%l/%L " Current line/Total Lines
set statusline+=\ B:%n " Buffer number
set statusline+=\ %y " Filetype
set statusline+=\ %b
" }}}
