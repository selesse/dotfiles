highlight TrailingWhiteSpace ctermbg=red guibg=red
match TrailingWhiteSpace /\v +\n/
nnoremap <leader>dw :%s/\v +\n/\r/g<CR><C-o>
