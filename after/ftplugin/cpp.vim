" Set the program that is called with :make
if glob("makefile") != "" || glob("Makefile") != ""
    set makeprg=make
else
    if executable("g++")
        set makeprg=g++
    elseif executable("clang++")
        set makeprg=clang++
    endif
endif

if !empty(globpath(&runtimepath, 'plugged/vim-dispatch'))
    nnoremap <buffer> <F8> :update<CR>:Make %<CR>
else
    nnoremap <buffer> <F8> :update<CR>:make %<CR>
endif 

" Assign F9 to run the current C++ file's executable that Clang created
nnoremap <F9> :update<CR>:!%:p:r.exe<CR>

let g:termdebug_wide = 1

" Set up :find
setlocal path^=src/**,include/**,resources/**,/usr/include,lib/**,
setlocal wildignore^=obj/**,
setlocal suffixesadd+=.cpp,.cc,.h,.hpp
setlocal keywordprg=:Man
" Proper define statement for defines and constants
setlocal define=^\\(#\\s*define\\\|[a-z]*\\s*const\\s*[a-z]*\\)

" Abbreviations
iabbrev <buffer> main int<Space>main(int argc, char* argv[])<Space>{}<Left><Left><CR><Right><CR><CR>return<Space>0;<Up><Tab><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> #i< #include<Space><<i++>><++><Esc>/<i++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> #i" #include<Space>"<i++>"<++><Esc>/<i++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> #d #define<Space><d++><++><Esc>/<d++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> forl for<Space>(<f++>; <++>; <++>)<Space>{<++>}<Esc>F{i<CR><Esc>f<i<CR><Esc>f}i<CR><Esc>/<f++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> if if<Space>(<if++>)<Space>{<++>}<++><Esc>bi<CR><Esc>f{a<CR><Esc>f}i<CR><Esc>/<if++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> elif else<Space>if<Space>(<elif++>)<Space>{<++>}<++><Esc>bi<CR><Esc>f{a<CR><Esc>f}i<CR><Esc>/<elif++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> else else<Space>{<else++>}<++><Esc>F{i<CR><Esc>f{a<CR><Esc>f}i<CR><Esc>/<else++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> structdef struct<Space><s++><Space>{<++>};<Esc>F{i<CR><Esc>f<i<CR><Esc>f}i<CR><Esc>/<s++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> class class<Space><c++><Space>{<++>};<Esc>F{i<CR><Esc>f<i<CR><Esc>f}i<CR><Esc>/<c++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> cout std::cout<Space><<<Space><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> cin std::cin<Space>>><Space><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> endl <<<Space>std::endl;<C-R>=Eatchar('\s')<CR>
iabbrev <buffer> namespacestd using<Space>namespace<Space>std;<C-R>=Eatchar('\s')<CR>
