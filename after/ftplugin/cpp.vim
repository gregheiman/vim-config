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

let g:termdebug_wide = 1

" Set up :find
setlocal path^=src/**,include/**,resources/**,/usr/include,lib/**,
setlocal wildignore^=obj/**
setlocal suffixesadd+=.cpp,.cc,.h,.hpp
setlocal keywordprg=:Man
" Proper define statement for defines and constants
setlocal define=^\\(#\\s*define\\\|[a-z]*\\s*const\\s*[a-z]*\\)
