" Auto wipe netrw buffers after closing them
augroup AutoDeleteNetrwHiddenBuffers
  autocmd!
  autocmd FileType netrw setlocal bufhidden=wipe
augroup end

noremap <silent> <buffer> <F1> :call functions#ToggleNetrw()<Cr>
