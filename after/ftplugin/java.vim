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
        " Assigns F9 to run the current mvn project
        nnoremap <F9> :update<CR>:!mvn exec:java<CR>
        echohl title | redraw | echom "Maven project detected" | echohl None
    else 
        " Assign default makeprg
        set makeprg=javac\ -cp\ "."\ %:p
        " Assigns F9 to run the current Java file
        nnoremap <F9> :update<CR>:!java %:p:r<CR>
    endif
endfunction

" Set up make
autocmd BufEnter,BufNewFile,BufReadPost * silent call java#DetectMaven()

" Assign F8 to compile the current Java file
nnoremap <F8> :update<CR>:silent make<CR>

