" Assign F8 to compile the current LaTeX file
nnoremap <F8> :update<CR>:VimtexCompileSS<CR>

" Assign F9 to view the current LaTeX file
nnoremap <F9> :update<CR>:VimtexView<CR>

" Clean Tex file directory before exiting Vim
autocmd VimLeave * call execute("VimtexClean")
