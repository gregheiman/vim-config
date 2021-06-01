function! java#DetectMaven()
    if glob("pom.xml") != "" && executable('mvn')
        " Assign makeprg to mvn
        set makeprg=mvn\ -Dstyle.color=never\ clean\ compile
       " Ignored message
        setlocal errorformat=
            \%-G[INFO]\ %.%#,
            \%-G[debug]\ %.%#
        " Error message for POM
        setlocal errorformat+=
            \[FATAL]\ Non-parseable\ POM\ %f:\ %m%\\s%\\+@%.%#line\ %l\\,\ column\ %c%.%#,
            \[%tRROR]\ Malformed\ POM\ %f:\ %m%\\s%\\+@%.%#line\ %l\\,\ column\ %c%.%#
        " Error message for compiling
        setlocal errorformat+=
            \[%tARNING]\ %f:[%l\\,%c]\ %m,
            \[%tRROR]\ %f:[%l\\,%c]\ %m
        " Message from JUnit 5(5.3.X), TestNG(6.14.X), JMockit(1.43), and AssertJ(3.11.X)
        setlocal errorformat+=
            \%+E%>[ERROR]\ %.%\\+Time\ elapsed:%.%\\+<<<\ FAILURE!,
            \%+E%>[ERROR]\ %.%\\+Time\ elapsed:%.%\\+<<<\ ERROR!,
            \%+Z%\\s%#at\ %f(%\\f%\\+:%l),
            \%+C%.%#

        echohl title | redraw | echom "Maven project detected" | echohl None
    elseif glob("mvnw") != "" || glob("mvnw.bat") != ""
        " Assign makeprg to mvnw
        set makeprg=mvnw\ clean\ compile
        " POM related messages
        setlocal errorformat=%E[ERROR]\ %#Non-parseable\ POM\ %f:\ %m\ %#\\@\ line\ %l\\,\ column\ %c%.%#,%Z,
        setlocal errorformat+=%+E[ERROR]\ %#Malformed\ POM\ %f:%m\ %#\\@\ %.%#\\,\ line\ %l\\,\ column\ %c%.%#,%Z,
        " Java related build messages
        setlocal errorformat+=%+I[INFO]\ BUILD\ %m,%Z
        setlocal errorformat+=%E[ERROR]\ %f:[%l\\,%c]\ %m,%Z
        setlocal errorformat+=%A[%t%[A-Z]%#]\ %f:[%l\\,%c]\ %m,%Z
        setlocal errorformat+=%A%f:[%l\\,%c]\ %m,%Z

        " jUnit related build messages
        setlocal errorformat+=%+E\ \ %#test%m,%Z
        setlocal errorformat+=%+E[ERROR]\ Please\ refer\ to\ %f\ for\ the\ individual\ test\ results.

        " Misc message removal
        setlocal errorformat+=%-G%.%#,%Z
        echohl title | redraw | echom "Maven project detected" | echohl None
    else
        " Assign default makeprg
        set makeprg=javac\ %:p
        " Assigns F9 to run the current Java file
        nnoremap <F9> :update<CR>:!java %:p:r<CR>
    endif
endfunction

" Set up make
autocmd BufEnter,BufNewFile,BufReadPost * silent call java#DetectMaven()

" Assign F8 to compile the current Java file
nnoremap <F8> :update<CR>:silent make<CR>

" Setup :find command
set path+=src/**,target/**,config/**