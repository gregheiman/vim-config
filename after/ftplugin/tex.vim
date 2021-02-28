" Assign F8 to compile the current LaTeX file
nnoremap <F8> :update<CR>:VimtexCompileSS<CR>
inoremap <F8> <Esc>:update<CR>:VimtexCompileSS<CR><i>

" Assign F9 to view the current LaTeX file
nnoremap <F9> :update<CR>:VimtexView<CR>
inoremap <F9> <Esc>:update<CR>:VimtexView<CR><i>

" Compile and clean tex files before exiting
autocmd VimLeave *.tex call execute("VimtexCompileSS") | call execute("VimtexClean")

" Compile after writing
autocmd BufWritePost *.tex call execute("VimtexCompileSS")
