function! java#DetectMaven()
    if glob("pom.xml") != "" && executable('mvn')
        " Assign makeprg to mvn
        compiler mvn
        echohl title | redraw | echom "Maven project detected" | echohl None
    elseif glob("pom.xml") && (glob("mvnw") != "" || glob("mvnw.bat") != "")
        compiler mvn
        echohl title | redraw | echom "Maven wrapper detected" | echohl None
    else
        compiler javac
    endif
endfunction

" Improve java syntax highlighting
let java_highlight_functions = "style"
let java_highlight_all = 1
let java_highlight_debug = 0

" Assign F8 to compile the current Java file
if !empty(globpath(&runtimepath, 'plugged/vim-dispatch'))
    nnoremap <buffer> <F8> :update<CR>:Make %<CR>
else
    nnoremap <buffer> <F8> :update<CR>:make %<CR>
endif 

" Setup :find command
" Setup inefficient path that will find pretty much everything in the project
setlocal path^=src/main/java/**,src/test/java/**,src/main/resources/**,src/test/resources/**
setlocal wildignore+=**/target/**
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
iabbrev <buffer> amain public<Space>static<Space>void<Space>main(String[] args)<Space>{}<Left><CR><C-R>=Eatchar('\s')<CR>
" Println and print
iabbrev <buffer> aprintln System.out.println(<pl++>);<++><Esc>/<pl++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> aprint System.out.print(<pr++>);<++><Esc>/<pr++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
" Import statement
iabbrev <buffer> aimp import<Space>"<im++>"<Esc>/<im++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
" For loop
iabbrev <buffer> aforl for<Space>(<f++>; <++>; <++>)<space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<f++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
" If statment
iabbrev <buffer> aif if<Space>(<if++>)<Space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<if++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
" Try catch block
iabbrev <buffer> atry try<Space>{<tr++>}<Esc>F{a<CR><Esc>f}i<CR><Esc>a<Space>catch<Space>(<++>)<Space>{<++>}<++><Esc>F{a<CR><Esc>f}i<CR><Esc>/<tr++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
" Private and public methods
iabbrev <buffer> aprm private<Space><pr++>(<++>)<Space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<pr++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> apbm public<Space><pb++>(<++>)<Space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<pb++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
