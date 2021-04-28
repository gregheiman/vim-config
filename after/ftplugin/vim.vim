" Set up :find
setlocal path^=after/**,autoload/**
" Set fold method
setlocal foldmethod=marker

" Assign F12 to reload the current file
nnoremap <silent> <F12> :so %<CR> | redraw
inoremap <silent> <F12> <Esc>:so %<CR> | redraw
