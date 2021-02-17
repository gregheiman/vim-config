" Assign makeprg
set makeprg=python3\ ./%:p

" Assign F8 to run the current Python file
nnoremap <F8> :update<CR>:make<CR>
