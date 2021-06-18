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
set path^=src/main/java/**,src/test/java/**,src/main/resources/**
" Proper include statement
setlocal include=^\\s*import
" Proper define statement for the beginning of functions
setlocal define=^\\s*public\\s\\a*\\s
"setlocal define=^\\s*private\\\|public\\\|protected


" Set up make
augroup Project
    autocmd!
    autocmd BufEnter,BufNewFile,BufReadPost * silent call java#DetectMaven()
augroup END

" Abbreviations
iabbrev main public<Space>static<Space>void<Space>main(String[] args)<Space>{}<Left><CR><C-R>=Eatchar('\s')<CR>
iabbrev println System.out.println(<pl++>);<++><Esc>/<pl++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev print System.out.print(<pr++>);<++><Esc>/<pr++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev imp import<Space>"<im++>"<Esc>/<im++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev forl for<Space>(<f++>; <++>; <++>)<space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<f++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev ifs if<Space>(<if++>)<Space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<if++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
