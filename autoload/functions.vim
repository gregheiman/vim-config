" Custom Vim Functions
"""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ " Autosave Function
" Autosave autocmd that makes sure the file exists before saving. Stops errors
" from being thrown
function! functions#Autosave()
    if @% == "" || filereadable(@%) == 0 || line('$') == 1 && col('$') == 1 || &readonly || mode() == "c" || pumvisible()
        " If the file has no name, is not readable, doesn't exist, is readonly, is currently in command mode, or the pum 
        " is visible don't autosave
        return
    else
        silent update " Otherwise autosave
    endif
endfunction
" }}} 

" {{{ Auto save session.vim files on exit function
" Update Session.vim file on exit if one is present
function! functions#UpdateSessionOnExit()
    if glob("./Session.vim") != ""
        silent mksession!
        echohl Title | redraw | echo "Saved session file" | echohl None
    endif 
endfunction
" }}}

" {{{ Auto check if .vimrc needs updating function
" Finds the directory that the .vimrc is in
" Safe for symbolic links
" Needs to be outside of function in order to work correctly
let s:vimrclocation = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" The path of the folder or file that vim opened in
let s:openingFilePath = ""
function! functions#GitFetchVimrc(originalFilePath)
    " Make sure git exists on the system
    if !executable("git")
        echohl Error | redraw | echom "Git not found on system. Can't check Vimrc." | echohl None
        finish
    endif 
    
    " Assign the passed in variable to a script local variable
    let s:openingFilePath = a:originalFilePath
    silent execute("lcd " . s:vimrclocation) 
    
    " Execute a git fetch to update the tree
    if has("win32") || has("win64")
        if !has('nvim')
            let l:gitFetchJob = job_start("cmd git fetch", {"in_io": "null", "out_io": "null", "err_io": "null"})
        else
            let l:gitFetchJob = jobstart("git fetch")
        endif
    else
        " *nix systems 
        if !has('nvim') 
            let l:gitFetchJob = job_start("/bin/sh git fetch", {"in_io": "null", "out_io": "null", "err_io": "null"})
        else
            let l:gitFetchJob = jobstart("git fetch")
        endif
    endif 
    
    " Grab the status of the job
    if !has('nvim') | let l:gitFetchJobStatus = job_status(gitFetchJob) | endif

    " If unsuccessful let user know and stop job
    if !has('nvim') && (l:gitFetchJobStatus ==? "fail" || l:gitFetchJobStatus ==? "dead")
        echohl WarningMsg | redraw | echom "Vimrc git fetch failed with status " . l:gitFetchJobStatus | echohl None
        call job_stop(l:gitFetchJob)
    elseif has('nvim') && (l:gitFetchJob < 1)
        echohl WarningMsg | redraw | echom "Vimrc git fetch failed with status " . l:gitFetchJob | echohl None
        call jobstop(l:gitFetchJob)
    else
        " Run CompareUpstreamAndLocalVimrcGitStatus()
        " Needs to be a timer because we are running a vimscript function
        " https://vi.stackexchange.com/questions/27003/how-to-start-an-async-function-in-vim-8
        let l:compareUpstreamAndLocalTimer = timer_start(0, 'functions#CompareUpstreamAndLocalVimrcGitStatus')
    endif
    
    " Go back to the original startup directory
    return 
endfunction 

" Compare the local and upstream Git status
function! functions#CompareUpstreamAndLocalVimrcGitStatus(timer)
    " Change to the vimrc git directory
    silent execute("lcd " . s:vimrclocation) 

    " Set an upstream and local variable that is a hash returned by git
    let l:upstream = system("git rev-parse @{u}") " Upstream is the hash of the upstream commit
    let l:local = system("git rev-parse @") " Local is the hash of the current local commit
    
    " If the hashes match then the vimrc is updated 
    if l:local ==? l:upstream
        echohl title | redraw | echom "Vimrc is up to date" | echohl None
    elseif l:local !=? l:upstream 
        " Otherwise you need to update your vimrc
        echohl WarningMsg | redraw | echom "You need to update your Vimrc" | echohl None
    else 
        " Otherwise something went wrong
        echohl Error | redraw | echom "Unable to confirm whether you need to update your Vimrc" | echohl None
    endif
    
    " Return to the file or folder vim opened in
    silent execute("lcd " . s:openingFilePath) 
    return
endfunction
"}}}

" {{{ Go to specific buffer with number function
function! functions#GoToSpecifiedBuffer()
    " Show list of buffers
    execute("buffers") 
    let l:bufferNum = input("Enter Buffer Number: ") " Take in user input for which buffer they would like to go to
    " Go to that buffer
    execute(":buffer " . bufferNum) 
endfunction
"}}}

" {{{ Toggle Netrw function
" Toggle Netrw window open and close with the same key
function! functions#ToggleNetrw()
    if &filetype != "netrw"
        let w:windowpos = winsaveview() " Save current position to go back to
        silent Explore
    else
        silent Rexplore " Return to previous file
        call winrestview(w:windowpos) " Reset view
    endif
endfunction
" }}}

"{{{ Grepping Functions
" Async grep using cgetexpr
function! functions#Grep(...) 
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

" Use grep as an operator allowing for motions
function! functions#GrepOperator(type)
  " cache the register
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    " copy selected in visual mode
    normal! gvy
  elseif a:type ==# 'char'     
      normal! `[v`]y
  else
    return
  endif

  " @ is the unnameed default register
  silent execute "Grep " . shellescape(@@)

  let @@ = saved_unnamed_register
endfunction
"}}}

" {{{ Template functions
" Template functions
function! functions#SetupJavaClass()
    execute "%s/__CLASS_NAME__/" . expand('%:t:r')
    let filePath = expand('%:h:r')
    let packageName = matchstr(filePath, "\\(org\\\|com\\\|net\\\|io\\).*")
    let finalPackageName = substitute(packageName, '\/','.','g')
    execute "%s/__PACKAGE_NAME__/" . finalPackageName
endfunction

function! functions#SetupHeaderGuards()
    let headerName = toupper(expand('%:t:r')) . '_H'
    execute "%s/__HEADER_NAME__/" . headerName
endfunction
"}}}
