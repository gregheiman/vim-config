" Auto wipe netrw buffers after closing them
augroup AutoDeleteNetrwHiddenBuffers
  autocmd!
  autocmd FileType netrw setlocal bufhidden=wipe
augroup end
