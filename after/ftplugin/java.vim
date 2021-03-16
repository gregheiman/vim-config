" Assign makeprg
set makeprg=javac\ ./%

if exists('g:autoloaded_dispatch')
    " Assign F8 to compile the current Java file
    nnoremap <F8> :update<CR>:Make!<CR>
else 
    nnoremap <F8> :update<CR>:make<CR>
endif 

" Assigns F9 to run the current Java file
nnoremap <F9> :update<CR>:!java %:p:r<CR>

if exists('g:autoloaded_dispatch')
    autocmd BufWritePost *.java Make!
else
    autocmd BufWritePost *.java silent make! | silent redraw!
endif 

