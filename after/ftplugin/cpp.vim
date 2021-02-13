" Assign F8 to compile the current C++ file with Clang
autocmd FileType cpp nnoremap <F8> :update<CR>:clang++ -Wall % -o "%:r.exe"<CR>

" Assign F9 to run the current C++ file's executable that Clang created
autocmd FileType cpp nnoremap <F9> :update<CR>:!%:p:r.exe<CR>
