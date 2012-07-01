set number
syntax on
set autochdir

set nowrap " forces style
set expandtab
set tabstop=2
set autoindent
set copyindent
set shiftwidth=2
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

colorscheme desert

if has ("autocmd")
  filetype plugin indent on
endif

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

nnoremap ; :
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :call Underline("=")<CR>
nnoremap <F4> <Esc>:1,$!xmllint --format -<CR>
nmap <silent> <F5> :!open -a Google\ Chrome %<CR>
if has("win32") 
  echo "WINDOWS"
elseif has("mac")
  echo "MAC"
else
  echo "DEFAULT UNIX"
endif
