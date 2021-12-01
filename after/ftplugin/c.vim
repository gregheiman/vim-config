" Set the program that is called with :make
if glob("makefile") || glob("Makefile")
    set makeprg=make
else
    if executable("gcc")
        compiler=gcc
    elseif executable("clang")
        set makeprg=clang 
    endif
endif

nnoremap <buffer> <F8> :update<CR>:make<CR>

" Assign F9 to run the current C++ file's executable that Clang created
nnoremap <F9> :update<CR>:!%:p:r.exe<CR>

if exists("g:lsp_loaded")
    call g:On_lsp_buffer_enabled()
else
    setlocal omnifunc=ccomplete#Complete
endif

" Set up :find
setlocal path^=src/**,include/**,resources/**,/usr/include,
setlocal wildignore^=lib/**
setlocal suffixesadd+=.c,.h
setlocal keywordprg=:Man

" Abbreviations
iabbrev <buffer> main int<Space>main()<Space>{}<Left><Left><CR><Right><CR><CR>return<Space>0;<Up><Tab><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> #i< #include<Space><<i++>><++><Esc>/<i++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> #i" #include<Space>"<i++>"<++><Esc>/<i++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> #d #define<Space><d++><++><Esc>/<d++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> /* /*<CR><CR>/<Up>
iabbrev <buffer> forl for<Space>(<f++>; <++>; <++>)<Space>{<++>}<Esc>bi<CR><Esc>a<CR><Esc>f}i<CR><Esc>/<f++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> if if<Space>(<if++>)<Space>{<++>}<++><Esc>bi<CR><Esc>f{a<CR><Esc>f}i<CR><Esc>/<if++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> elif else<Space>if<Space>(<elif++>)<Space>{<++>}<++><Esc>bi<CR><Esc>f{a<CR><Esc>f}i<CR><Esc>/<elif++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> else else<Space>{<else++>}<++><Esc>F{i<CR><Esc>f{a<CR><Esc>f}i<CR><Esc>/<else++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> struct struct<Space><s++><Space>{<++>};<Esc>bi<CR><Esc>a<CR><Esc>f}i<CR><Esc>/<s++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
