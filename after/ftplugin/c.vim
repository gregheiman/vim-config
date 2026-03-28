" Set the program that is called with :make
if glob("makefile") != "" || glob("Makefile") != ""
    set makeprg=make
else
    if executable("gcc")
        compiler gcc
        set makeprg=gcc
    elseif executable("clang")
        set makeprg=clang 
    endif
endif

" Set up :find
setlocal path^=src/**,include/**,resources/**,/usr/include,lib/**,
setlocal wildignore^=obj/**
setlocal suffixesadd+=.c,.h
setlocal keywordprg=:Man
