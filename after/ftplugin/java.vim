" Assign makeprg
set makeprg=javac\ -cp\ "."\ %:p

" Assign F8 to compile the current Java file
nnoremap <F8> :update<CR>:silent make<CR>

" Assigns F9 to run the current Java file
nnoremap <F9> :update<CR>:!java %:p:r<CR>
