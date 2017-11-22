if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au! BufRead,BufNewFile *.gradle setfiletype groovy
    au! BufRead,BufNewFile *.md     setfiletype markdown
