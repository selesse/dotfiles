let test#strategy = 'neovim'
let test#neovim#term_position = "belowright"

nnoremap <C-t> :TestFile <C-V><C-J> call ReturnFocus()<CR>
nnoremap <C-f> :call WipeMatchingBuffers('term://')<CR>
nnoremap <leader>t :TestNearest <C-V><C-J> call ReturnFocus()<CR>

function! ReturnFocus()
  exe 'resize ' . 60 * winheight(0) / 100
  wincmd p
  stopinsert
endfunction

function! GetBufferList()
  return filter(range(1,bufnr('$')), 'buflisted(v:val)')
endfunction

function! GetMatchingBuffers(pattern)
  return filter(GetBufferList(), 'bufname(v:val) =~ a:pattern')
endfunction

function! WipeMatchingBuffers(pattern)
  let l:matchList = GetMatchingBuffers(a:pattern)

  let l:count = len(l:matchList)
  if l:count < 1
    echo 'No buffers found matching pattern ' . a:pattern
    return
  endif

  if l:count == 1
    let l:suffix = ''
  else
    let l:suffix = 's'
  endif

  exec 'bw! ' . join(l:matchList, ' ')

  echo 'Wiped ' . l:count . ' buffer' . l:suffix . ''
endfunction
