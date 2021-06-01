" Custom Vim Functions
"""""""""""""""""""""""""""""""""""""""""""""""""
" Check if the buffer is empty and determine how to open my vimrc
function! functions#CheckHowToOpenVimrc()
    if @% == "" || filereadable(@%) == 0 || line('$') == 1 && col('$') == 1
        e $MYVIMRC " If the buffer is empty open vimrc fullscreen 
    else
        vsp $MYVIMRC " Otherwise open vimrc in a vertical split
    endif
endfunction

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

" Finds the directory that the .vimrc is in
" Safe for symbolic links
" Needs to be outside of function in order to work correctly
let s:vimrclocation = fnamemodify(resolve(expand('<sfile>:p')), ':h')
function! functions#GitFetchVimrc()
    " Make sure git exists on the system
    if !executable("git")
        echohl Error | redraw | echom "Git not found on system. Can't check Vimrc." | echohl None
        finish
    endif 

    " Change to the vimrc git directory
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
    " Go back to the original startup directory
    silent execute("lcd ~") 
    return
endfunction

function! functions#GoToSpecifiedBuffer()
    " Show list of buffers
    execute("buffers") 
    let l:bufferNum = input("Enter Buffer Number: ") " Take in user input for which buffer they would like to go to
    " Go to that buffer
    execute(":buffer " . bufferNum) 
endfunction

" If in a Git repo, sets the working directory to its root,
" or if not, to the directory of the current file.
function! functions#SetWorkingDirectory()
    " Stops fugitive from throwing error on :Gdiff
    if bufname('fugitive') != "" || bufname('term') != ""
        return
    endif

    " Default to the current file's directory (resolving symlinks.)
    let current_file = expand('%:p')
    if getftype(current_file) == 'link'
        let current_file = resolve(current_file)
    endif
    exe ':lcd ' . fnameescape(fnamemodify(current_file, ':h'))

    " Get the path to `.git` if we're inside a Git repo.
    " Works both when inside a worktree, or inside an internal `.git` folder.
    silent let git_dir = system('git rev-parse --git-dir')[:-2]
    " Check whether the command output starts with 'fatal'; if it does, we're not inside a Git repo.
    let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
    " If we're inside a Git repo, change the working directory to its root.
    if empty(is_not_git_dir)
        " Expand path -> Remove trailing slash -> Remove trailing `.git`.
        exe ':lcd ' . fnameescape(fnamemodify(git_dir, ':p:h:h'))
    endif
endfunction

function! functions#UpdateTagsFile()
    " Make sure Ctags exists on the system
    if !executable("ctags")
        echohl WarningMsg | redraw | echom "Could not execute ctags" | echohl None
        finish
    endif 

    " Rename old tags file and set vim to use that
    " While new tags file is being generated
    let s:currentTagsFile=expand("%:p:h") . "/tags"
    call rename(s:currentTagsFile, "old-tags")
    set tags^=./old-tags,old-tags
    
    " Create new tags file. Uses ~/.config/ctags/.ctags config file
    if has('win64') || has('win32')
        if !has('nvim')
            let l:createNewTagsJob = job_start("cmd ctags -R")
        else 
            let l:createNewTagsJob = jobstart("ctags -R")
        endif
    else
        " *nix distributions
        if !has('nvim')
            let l:createNewTagsJob = job_start("/bin/sh ctags -R")
        else 
            let l:createNewTagsJob = jobstart("ctags -R")
        endif
    endif

    " Get job status if not using Nvim
    if !has('nvim') | let l:newTagsJobStatus = job_status(l:createNewTagsJob) | endif 

    if !has('nvim') && (l:newTagsJobStatus ==? "fail" || l:newTagsJobStatus ==? "dead")
        echohl WarningMsg | redraw | echom "Tags file failed to be created with status " . l:newTagsJobStatus| echohl None
        call job_stop(l:createNewTagsJob)
    elseif has('nvim') && (l:createNewTagsJob < 1)
        echohl WarningMsg | redraw | echom "Tags file failed to be created with status " . l:createNewTagsJob | echohl None
        call jobstop(l:createNewTagsJob)
    else 
        " If job does not report fail status
        echohl title | redraw | echom "Tags file was updated successfully" | echohl None
    endif 
        
    " Delete old tags file and reset tags
    set tags-=./old-tags,old-tags
    call delete("./old-tags")
endfunction

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

" Function to display Git branch in statusline
function! functions#GitBranchStatusLine()
    if executable('git')
        if exists("b:git_branch")
            return b:git_branch
        else
            return ''
        endif
    endif
endfunction
" Function to retrieve Git branch from the repository
function! functions#GetGitBranch()
    if executable('git')
        let l:is_git_dir = trim(system('git rev-parse --is-inside-work-tree'))
        if l:is_git_dir is# 'true'
            let b:git_branch = " " . trim(system('git rev-parse --abbrev-ref HEAD')) . " |"
            if strlen(b:git_branch) > 50
                let b:git_branch = ''
            endif
        else
            let b:git_branch = ''
        endif 
    endif
endfunction

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
        silent execute "grep! " . shellescape(expand(a:word)) . " "
        silent execute "copen"
    elseif (l:grepPreference == 2) " Files of the same type (eg. *.java)
        let b:current_filetype = &ft
        silent execute "grep! " . shellescape(expand(a:word)) . " -t " . b:current_filetype
        silent execute "copen"
    elseif (l:grepPreference == 3) " Files in the current file's folder
        let b:current_folder = expand('%:p:h')
        silent execute "grep! " . shellescape(expand(a:word)) . " " . b:current_folder 
        silent execute "copen"
    elseif (l:grepPreference == 4) " Only in the current file
        silent execute "grep! " . shellescape(expand(a:word)) . " %"
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
    execute "cdo %s/\\<" . expand(a:PatternToReplace) . "\\>/" . expand(l:replace) . "/gc"
    return
endfunction
