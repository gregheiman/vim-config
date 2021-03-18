" Assign makeprg
set makeprg=javac\ ./%:p

" Assign F8 to compile the current Java file
nnoremap <F8> :update<CR>:silent make<CR>

" Assigns F9 to run the current Java file
nnoremap <F9> :update<CR>:!java %:p:r<CR>

" Automatically make the java file after save
"autocmd BufWritePost *.java silent make! | silent redraw!

