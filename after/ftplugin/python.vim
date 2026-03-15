" Assign makeprg
if executable("python3")
    set makeprg=python3
endif

" Highlight whitespace
autocmd BufRead,BufNewFile match BadWhitespace /\s\+$/

setlocal foldmethod=indent
setlocal nofoldenable
