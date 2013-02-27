syntax on
set number
set nowrap " forces style
set autoindent
set smartindent
set autochdir
set backspace=indent,eol,start
set copyindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab " makes you go back 2 when you del from tab
set hlsearch " highlight all matches in a file when searching
set incsearch " incrementally highlight your searches
set pastetoggle=<f8>
set ignorecase smartcase " use caps if any caps used in search
set laststatus=2 " forces showing status bar
set encoding=utf-8 " order matters for Windows (encoding+autochdir)
set title " modifies window to have filename as its title
set scrolloff=5 " keep the last 5 lines as you're scrolling down
set shell=/bin/zsh
set viminfo='10,\"100,:20,%,n~/.viminfo " saves position in files
set clipboard=unnamed
set cursorline
set wildmode=longest,full
set wildmenu
set hidden
set noswapfile
set history=10000 " remember more commands and search history
set autoread " automatically re-read if file is modified externally
let mapleader=","

iabbrev teh the
iabbrev oyu you
iabbrev dont' don't
iabbrev its' it's
iabbrev haev have
iabbrev cccc Cool. Cool cool cool.
iabbrev arche archeology
iabbrev archi archeologist
iabbrev archl archaeological
iabbrev Meso Mesopotamia

" in Vim 7.3, built-in; otherwise fall back to other function
if exists('+colorcolumn')
  set colorcolumn=80
  autocmd FileType html setlocal colorcolumn=
else
  highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
  match OverLength /\%>80v.\+/
endif

" function to underline text with a delimiter
function! Underline(delimiter)
  let x = line('.')
  if x == "0"
    echo "Nope"
  else
    :call append(line('.'), repeat(a:delimiter, strlen(getline(x))))
  endif
endfunction

function! FindParentGit(gitIgnore)
  let x = system('find_parent_git')
  let x = substitute(x, '\n$', '', '') " removes the newline

  " if we find no parent git, return .git
  " this is a little silly, but it means Command-T will react properly
  if x == "no parent git found"
    return ".git"
  endif

  " if the root folder contains a gitignore, let's add that to wildignore
  let filename = x . '/.gitignore'
  if filereadable(filename)
      let igstring = ''
      for oline in readfile(filename)
          let line = substitute(oline, '\s|\n|\r', '', "g")
          if line =~ '^#' | con | endif
          if line == '' | con  | endif
          if line =~ '^!' | con  | endif
          if line =~ '/$' | let igstring .= "," . line . "*" | con | endif
          let igstring .= "," . line
      endfor
      if a:gitIgnore == "true"
        let execstring = "set wildignore+=".substitute(igstring, '^,', '', "g")
      else
        " may be problematic in niche cases, for now it'll do
        let execstring = "set wildignore-=".substitute(igstring, '^,', '', "g")
      endif
      execute execstring
  endif

  return x
endfunction

if v:version >= 600
  filetype plugin indent on
else
  filetype on
endif

autocmd FileType *
  \ if &omnifunc != '' |
  \   call SuperTabChain(&omnifunc, "<c-p>") |
  \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
  \ endif




command! -nargs=1 Silent
      \ | execute ':silent !'.<q-args>
      \ | execute ':redraw!'

cnoremap %% <C-R>=getcwd().'/'<cr>
cnoremap %g <C-R>=FindParentGit("true")<cr>
cnoremap %G <C-R>=FindParentGit("")<cr>
map <leader>e :edit %%
map <leader>v :edit %%
nnoremap ; :
nnoremap <leader>= :call Underline("=")<CR>
nnoremap <leader>- :call Underline("-")<CR>
nnoremap <F4> <Esc>:1,$!xmllint --format %<CR>
" f5 reserved for previewing file
nnoremap <F6> :call UpdateTags()
nnoremap <F7> :NumbersToggle<CR>
nnoremap ,, <C-^>

" ===================
" Command-T mappings:
" ===================
" <leader>f => all files in pwd + subdirectories
" <leader>F => all files in $HOME = subdirectories
" <leader>g => all files in current git repo EXCEPT gitignored
" <leader>G => all files in current git repo

map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT $HOME<cr>
map <leader>g :CommandTFlush<cr>\|:CommandT %g<cr>
map <leader>G :CommandTFlush<cr>\|:CommandT %G<cr>

" use this to paste code or anything else formatted
inoremap <leader>p <f8><cr> p<cr> <f8><cr>
" copy file's current directory for mac
map <leader>c :Silent echo -n %% \| pbcopy<cr>

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
      autocmd FileType html nmap <silent> <F5> :!open -a Google\ Chrome %<CR>
      let &titleold=getcwd()
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
nnoremap <leader>dw :%s/\v +\n/\r/g<CR><C-o> " when substituting, \r is newline
nnoremap <leader>sw :cd $HOME/git/swmud<CR>:!./sendToMud.sh %<CR>
nnoremap / /\v
nnoremap Y 0y$

nnoremap <Right> <C-w>l
nnoremap <C-l> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <C-h> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <C-k> <C-w>k
nnoremap <Down> <C-w>j
nnoremap <C-j> <C-w>j

inoremap jk <esc>
inoremap <c-c> <esc>
inoremap <esc> <nop>

augroup resCur
  " restore files to last cursor position
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

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
  autocmd FileType python nnoremap <leader>r :!python % <CR>
augroup END

augroup filetype_markdown
  autocmd!
  autocmd FileType markdown setlocal textwidth=78
augroup END

augroup filetype_lpc
  autocmd!
  autocmd BufRead,BufNewFile ~/git/swmud/wizards/sead/* set filetype=lpc
augroup END

augroup filetype_js
  autocmd!
  autocmd FileType javascript nnoremap <leader>j :call JsBeautify()<CR>
augroup END

augroup filetype_sh
  autocmd!
  autocmd Filetype sh nnoremap <leader>r :!bash %<CR>
augroup END

augroup filetype_wig
  autocmd!
  autocmd FileType wig nnoremap <leader>r :!wiggle % --symbol <CR>
  autocmd FileType wig nnoremap <leader>m :Silent cd $WIGGLEDIR && make<CR>
augroup END

augroup filetype_html
  autocmd!
  autocmd FileType html :iabbrev </ </<C-X><C-O>
augroup END

augroup filetype_perl
  autocmd!
  autocmd FileType perl nnoremap <F5> :!perl % <CR>
augroup END

augroup filetype_makefile
  autocmd!
  autocmd Filetype make setlocal noexpandtab
augroup END

augroup filetype_java
  autocmd!
  autocmd Filetype java setlocal cindent
  autocmd Filetype java setlocal omnifunc=javacomplete#Complete
  autocmd Filetype java nnoremap <F5> :make<CR>
augroup END

augroup filetype_c_cpp
  autocmd!
  autocmd Filetype c nnoremap <leader>r :make<cr>
  autocmd Filetype cpp nnoremap <leader>r :make<cr>
augroup END

augroup filetype_promela
  autocmd!
  autocmd Filetype promela nnoremap <leader>r :!spin %<CR>
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
set statusline+=\ col=%v " column number
set statusline+=\ Buf\=%n " Buffer number
set statusline+=\ %y " Filetype
set statusline+=\ char=\[%b\]
set statusline+=\ %=%l/%L\ (%p%%)\ \  " right align percentages
" }}}

set background=dark
let g:solarized_termcolors = 256
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized

" flag lines that have trailing whitespace, has to come after colorscheme
highlight TrailingWhiteSpace ctermbg=red guibg=red
match TrailingWhiteSpace /\v +\n/

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
