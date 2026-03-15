" Set up :find
setlocal path^=after/**,autoload/**,compiler/**
" Set fold method
setlocal foldmethod=marker
setlocal keywordprg=:help

" Assign F12 to reload the current file
nnoremap <silent> <leader>r :so %<CR> | redraw
inoremap <silent> <leader>r <Esc>:so %<CR> | redraw
