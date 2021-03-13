" Set the program that is called with :make
set makeprg=clang++\ -Wall\ %:p\ -o\ %:r.exe

" Assign F8 to compile the current C++ file with Clang
nnoremap <F8> :update<CR>:make<CR><C-w><Up>

" Assign F9 to run the current C++ file's executable that Clang created
nnoremap <F9> :update<CR>:!%:p:r.exe<CR>

" Abbreviations
iabbrev main int<Space>main()<Space>{}<Left><CR><CR>return<Space>1;<Up><Tab><C-R>=Eatchar('\s')<CR>
iabbrev #i #include<><Left><C-R>=Eatchar('\s')<CR>
iabbrev #d #define<><Left><C-R>=Eatchar('\s')<CR>
iabbrev /* /*<CR><CR>/<Up>
iabbrev for for<Space>()<space>{}<Left><CR><Up><Right><C-R>=Eatchar('\s')<CR>
iabbrev struct struct<Space>{};<Left><Left><CR><Up><Right><Right><Space><C-R>=Eatchar('\s')<CR>
iabbrev class class<Space>{};<Left><Left><CR><Up><Right><Space><C-R>=Eatchar('\s')<CR>
iabbrev cout cout<Space><<<Space><C-R>=Eatchar('\s')<CR>
