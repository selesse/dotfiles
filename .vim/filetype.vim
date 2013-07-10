if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au! BufRead,BufNewFile *.wig    setfiletype wig
    au! BufRead,BufNewFile *.gradle setfiletype groovy
