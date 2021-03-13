" Stop Netrw from interfering with my focus window movement commands
nnoremap <buffer> <C-l> <C-w>l

" Auto wipe netrw buffers after closing them
augroup AutoDeleteNetrwHiddenBuffers
  autocmd!
  autocmd FileType netrw setlocal bufhidden=wipe
augroup end
