" Vim syntax file
" Language: WIG
" Maintainer: Ismail Badawi <isbadawi@gmail.com>
" Last Change: 2012 Apr 24

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
    finish
endif

syn keyword    Statement     show exit plug receive return session
syn keyword    Conditional   if else
syn keyword    Repeat        while
syn keyword    Type          const html int bool string void schema tuple service
syn keyword    Boolean       true false
syn match      Number        display "\d\+"
syn keyword    Todo          contained TODO FIXME XXX
syn region     String        start=+"+ skip=+\\"+ end=+"+
syn region     Comment       start="/\*" end="\*/" contains=Todo
syn region     Comment       start="//" end="$" keepend contains=Todo
syn include    @HTML         syntax/html.vim
syn region     htmlLiteral   start="<html>" end="</html>" keepend contains=@HTML

let b:current_syntax = "wig"
