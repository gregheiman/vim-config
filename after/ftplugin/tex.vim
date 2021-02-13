" Assign F8 to compile the current LaTeX file
autocmd FileType tex nnoremap <F8> :update<CR>:VimtexCompileSS<CR>

" Assign F9 to view the current LaTeX file
autocmd FileType tex nnoremap <F9> :update<CR>:VimtexView<CR>

" Clean Tex file directory before exiting Vim
autocmd FileType tex autocmd VimLeave * call execute("VimtexClean")
