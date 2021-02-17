" Set the program that is called with :make
set makeprg=clang++\ -Wall\ %:p\ -o\ %:p:r.exe

" Assign F8 to compile the current C++ file with Clang
nnoremap <F8> :update<CR>:make<CR><C-w><Up>

" Assign F9 to run the current C++ file's executable that Clang created
nnoremap <F9> :update<CR>:!%:p:r.exe<CR>
