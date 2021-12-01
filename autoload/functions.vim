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
        let b:windowpos = winsaveview() " Save current position to go back to
        silent Explore
    else
        silent Rexplore " Return to previous file
        call winrestview(b:windowpos) " Reset view
    endif
endfunction
" }}}

"{{{ Grepping Functions
" Function that lets the user decide what to grep through visual selection
function! functions#GrepOperator(type, ...)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        " Yanks the last visual selection
        normal! `<v`>y
        " Determines grep scope
        if (a:0 > 0)
            call functions#DetermineGrep(@@, a:1)
        else
            call functions#DetermineGrep(@@)
        endif
        " Cleans the register
        let @@ = saved_unnamed_register
    elseif a:type ==# 'char'
        " Yanks the motion
        normal! `[v`]y
        if (a:0 > 0)
            call functions#DetermineGrep(@@, a:1)
        else
            call functions#DetermineGrep(@@)
        endif
        let @@ = saved_unnamed_register
    else
        return
    endif
endfunction
" Determine the scope of :grep
function! functions#DetermineGrep(word, ...)
    let l:grepPreference = input("1. Project Wide \n2. Only in files of the same type \n3. Only in current file's folder \n4. Only in current file \nSelect Method of Grep for pattern \"" . expand(a:word) . "\": ")

    if (l:grepPreference == 1) " Project wide
        if executable('rg')
            silent execute "grep! " . shellescape(expand(a:word)) . " "
        else
            silent execute "grep! -R" . shellescape(expand(a:word)) . " "
        endif
        silent execute "copen"
    elseif (l:grepPreference == 2) " Files of the same type (eg. *.java)
        let b:current_filetype = &ft
        if executable('rg')
            silent execute "grep! " . shellescape(expand(a:word)) . " -t " . b:current_filetype
        else
            silent execute "grep! -R" . shellescape(expand(a:word)) . " --include=*." . b:current_filetype
        endif
        silent execute "copen"
    elseif (l:grepPreference == 3) " Files in the current file's folder
        let b:current_folder = expand('%:p:h')
        if executable('rg')
            silent execute "grep! " . shellescape(expand(a:word)) . " " . b:current_folder 
        else
            silent execute "grep! -R" . shellescape(expand(a:word)) . " " . b:current_folder
        endif
        silent execute "copen"
    elseif (l:grepPreference == 4) " Only in the current file
        if executable('rg')
            silent execute "grep! " . shellescape(expand(a:word)) . " %"
        else 
            silent execute "grep! " . shellescape(expand(a:word)) . " %"
        endif
        silent execute "copen"
    else
        echohl WarningMsg | echo "\nPlease enter in a valid option" | echohl None
        return
    endif
    
    if (a:0 > 0) " If optional arugments are present
        if (a:1 == 1) " Replace the grepped word
            call functions#ReplaceGrep(a:word)
        endif
    endif
endfunction
" Function to replace Greped pattern
function! functions#ReplaceGrep(PatternToReplace)
    let l:replace = input("What would you like to replace \"" . expand(a:PatternToReplace). "\" with? ")
    " Needs to write at end in order to not error on switching to next file in
    " list
    execute "cfdo %s/" . expand(a:PatternToReplace) . "/" . expand(l:replace) . "/gc | w"
    return
endfunction
"}}}

" {{{ Template functions
" Template functions
function! functions#SetupJavaClass()
    execute "%s/__CLASS_NAME__/" . expand('%:t:r')
    let filePath = expand('%:h:r')
    echom filePath
    let packageName = matchstr(filePath, "\\(org\\\|com\\).*")
    echom packageName
    let finalPackageName = substitute(packageName, '\/','.','g')
    echom finalPackageName
    execute "%s/__PACKAGE_NAME__/" . finalPackageName
endfunction

function! functions#SetupHeaderGuards()
    let headerName = toupper(expand('%:t:r')) . '_H'
    execute "%s/__HEADER_NAME__/" . headerName
endfunction
"}}}
