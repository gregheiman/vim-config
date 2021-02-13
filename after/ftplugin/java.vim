" Assign F8 to compile the current Java file
autocmd FileType java nnoremap <F8> :update<CR>:javac ./%<CR>

" Assigns F9 to run the current Java file
autocmd FileType java nnoremap <F9> :update<CR>:!java %:p:r<CR>
