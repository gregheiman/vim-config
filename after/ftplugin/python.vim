" Assign makeprg
if executable("python3")
    set makeprg=python3
endif

if !empty(globpath(&runtimepath, 'plugged/vim-dispatch'))
    nnoremap <buffer> <F8> :update<CR>:Make %<CR>
else
    nnoremap <buffer> <F8> :update<CR>:make %<CR>
endif 

" Highlight whitespace
autocmd BufRead,BufNewFile match BadWhitespace /\s\+$/

setlocal foldmethod=indent
setlocal nofoldenable
