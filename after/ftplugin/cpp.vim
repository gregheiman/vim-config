" Set the program that is called with :make
set makeprg=clang++\ -Wall\ %:p\ -o\ %:r.exe

nnoremap <F8> :update<CR>:silent make<CR>

" Assign F9 to run the current C++ file's executable that Clang created
nnoremap <F9> :update<CR>:!%:p:r.exe<CR>

" Automatically run the make command upon writing a cpp file
autocmd BufWritePost *.cpp silent make! | silent redraw!

" Abbreviations
iabbrev main int<Space>main()<Space>{}<Left><CR><CR>return<Space>1;<Up><Tab><C-R>=Eatchar('\s')<CR>
iabbrev #i #include<<i++>><++><Esc>/<i++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev #d #define<<d++>><++><Esc>/<d++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev /* /*<CR><CR>/<Up>
iabbrev for for<Space>(<f++>; <++>; <++>)<space>{<++>}<Left><Left><Left><Left><Left><CR><Esc>/f<++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev struct struct<Space><s++><Space>{<++>};<Left><Left><Left><Left><Left><Left><CR><Esc>/<s++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev class class<Space><c++>{<++>};<Left><Left><Left><Left><Left><Left><Esc>/<c++><CR><Esc>cf><CR><C-R>=Eatchar('\s')<CR>
iabbrev cout cout<Space><<<Space><C-R>=Eatchar('\s')<CR>
