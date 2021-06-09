function! java#DetectMaven()
    if glob("pom.xml") != "" && executable('mvn')
        " Assign makeprg to mvn
        compiler mvn
        echohl title | redraw | echom "Maven project detected" | echohl None
    elseif glob("mvnw") != "" || glob("mvnw.bat") != ""
        compiler mvn
        echohl title | redraw | echom "Maven wrapper detected" | echohl None
    else
        compiler javac
        " Assigns F9 to run the current Java file
        nnoremap <F9> :update<CR>:!java %:p:r<CR>
    endif
endfunction

" Assign F8 to compile the current Java file
nnoremap <F8> :update<CR>:silent make<CR>

" Use vim's built in help system with K
setlocal keywordprg=

" Setup :find command
set path^=src/**,config/**

" Set up make
augroup Project
    autocmd!
    autocmd BufEnter,BufNewFile,BufReadPost * silent call java#DetectMaven()
augroup END
