" Assign makeprg
if executable("python3")
    set makeprg=python3
endif

" Assign F8 to run the current Python file
nnoremap <F8> :update<CR>:silent make<CR>
inoremap <F8> <Esc>:update<CR>:silent make<CR><i>

" Highlight whitespace
autocmd BufRead,BufNewFile match BadWhitespace /\s\+$/

setlocal foldmethod=indent
setlocal nofoldenable
