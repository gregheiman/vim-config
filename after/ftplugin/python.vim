" Assign makeprg
set makeprg=python3\ ./%:p

" Assign F8 to run the current Python file
nnoremap <F8> :update<CR>:silent make<CR>

" Automatically run the make command upon writing a python file
autocmd BufWritePost *.py silent make! | silent redraw!
