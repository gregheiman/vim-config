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

" Setup :find command
set path^=src/main/java/**,src/test/java/**,src/main/resources/**
" Proper include statement
setlocal include=^\\s*import
" Proper define statement for the beginning of functions
setlocal define=^\\s*\\(private\\\|public\\\|protected\\)\\s*\\a*\\s*


" Set up make
augroup Project
    autocmd!
    autocmd BufEnter,BufNewFile,BufReadPost * silent call java#DetectMaven()
augroup END

" Abbreviations
" Main
iabbrev main public<Space>static<Space>void<Space>main(String[] args)<Space>{}<Left><CR><C-R>=Eatchar('\s')<CR>
" Println and print
iabbrev println System.out.println(<pl++>);<++><Esc>/<pl++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev print System.out.print(<pr++>);<++><Esc>/<pr++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
" Import statement
iabbrev imp import<Space>"<im++>"<Esc>/<im++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
" For loop
iabbrev forl for<Space>(<f++>; <++>; <++>)<space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<f++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
" If statment
iabbrev ifs if<Space>(<if++>)<Space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<if++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
" Try catch block
iabbrev tryb try<Space>{<tr++>}<Esc>F{a<CR><Esc>f}i<CR><Esc>a<Space>catch<Space>(<++>)<Space>{<++>}<++><Esc>F{a<CR><Esc>f}i<CR><Esc>/<tr++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
" Private and public methods
iabbrev prm private<Space><pr++>(<++>)<Space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<pr++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev pbm public<Space><pb++>(<++>)<Space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<pb++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
