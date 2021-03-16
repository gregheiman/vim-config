" Assign makeprg
set makeprg=python3\ ./%:p

if exists('g:autoloaded_dispatch')
    " Assign F8 to run the current Python file
    nnoremap <F8> :update<CR>:Make!<CR>
else 
    nnoremap <F8> :update<CR>:make<CR>

if exists('g:autoloaded_dispatch')
    autocmd BufWritePost *.py Make!
else 
    autocmd BufWritePost *.py silent make! | silent redraw!
