" Set the global tex flavor
let g:tex_flavor='latex'

" Set make program to latexmk pdf output
set makeprg=latexmk\ -pdf\ %:p

" https://github.com/lervag/vimtex/blob/98327bfe0e599bf580e61cfaa6216c8d4177b23d/compiler/latexmk.vim
setlocal errorformat=%-P**%f
setlocal errorformat+=%-P**\"%f\"
setlocal errorformat+=%E!\ LaTeX\ %trror:\ %m
setlocal errorformat+=%E%f:%l:\ %m
setlocal errorformat+=%E!\ %m
setlocal errorformat+=%Z<argument>\ %m
setlocal errorformat+=%Cl.%l\ %m
setlocal errorformat+=%+WLaTeX\ Font\ Warning:\ %.%#line\ %l%.%#
setlocal errorformat+=%-CLaTeX\ Font\ Warning:\ %m
setlocal errorformat+=%-C(Font)%m
"setlocal errorformat+=%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#
"setlocal errorformat+=%+WLaTeX\ %.%#Warning:\ %m
"setlocal errorformat+=%+WOverfull\ %\\%\\hbox%.%#\ at\ lines\ %l--%*\\d
"setlocal errorformat+=%+WUnderfull\ %\\%\\hbox%.%#\ at\ lines\ %l--%*\\d
setlocal errorformat+=%+WPackage\ natbib\ Warning:\ %m\ on\ input\ line\ %l%.
setlocal errorformat+=%+WPackage\ biblatex\ Warning:\ %m
setlocal errorformat+=%-C(biblatex)%.%#in\ t%.%#
setlocal errorformat+=%-C(biblatex)%.%#Please\ v%.%#
setlocal errorformat+=%-C(biblatex)%.%#LaTeX\ a%.%#
setlocal errorformat+=%-C(biblatex)%m
setlocal errorformat+=%-Z(babel)%.%#input\ line\ %l.
setlocal errorformat+=%-C(babel)%m
setlocal errorformat+=%+WPackage\ hyperref\ Warning:\ %m
setlocal errorformat+=%-C(hyperref)%.%#on\ input\ line\ %l.
setlocal errorformat+=%-C(hyperref)%m
setlocal errorformat+=%+WPackage\ scrreprt\ Warning:\ %m
setlocal errorformat+=%-C(scrreprt)%m
setlocal errorformat+=%+WPackage\ fixltx2e\ Warning:\ %m
setlocal errorformat+=%-C(fixltx2e)%m
setlocal errorformat+=%+WPackage\ titlesec\ Warning:\ %m
setlocal errorformat+=%-C(titlesec)%m
setlocal errorformat+=%-G%.%#

" Assign F8 to compile the current LaTeX file
nnoremap <silent> <F8> :update<CR>:silent make<CR>
inoremap <silent> <F8> <Esc>:update<CR>:silent make<CR><i>

augroup make_errors
    autocmd!
    " Shows the quickfix window if there are errors after making
    autocmd QuickFixCmdPost *make* cwindow
augroup END

" Assign F9 to view the current LaTeX file
nnoremap <silent> <F9> :update<CR>:call TexView()<CR>
inoremap <silent> <F9> <Esc>:update<CR>:call TexView()<CR><i>

" Compile and clean tex files before exiting
autocmd VimLeave * call execute("make") | call execute("TexClean")

" View the current .tex file's pdf file if there is one
function! TexView()
    let s:texCurrentPDFFile = expand('%:t:r') . ".pdf"

    if glob(s:texCurrentPDFFile) != ""
        if has('unix')
            let s:command = printf('zathura ' . s:texCurrentPDFFile)
            if !has('nvim')
                let s:zathuraOpen = job_start(s:command)
            else
                let s:zathuraOpen = jobstart(s:command)
            endif
        endif
    else 
        echo "Could not find PDF file to open"
    endif
endfunction
" Clean the tex directory
command! TexClean silent execute '!latexmk -c' | silent execute 'redraw!' | echo "Cleaned the directory"
