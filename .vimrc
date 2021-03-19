""""""""""""""""""""""""""""""""""""""""""
" Vimrc
" <zo> Opens the fold
" <zc> Closes the fold
" <za> Toggles the fold
" <zd> Deletes the entire fold
""""""""""""""""""""""""""""""""""""""""""
"{{{ " Plugins
""""""""""""""""""""""""""""""""""""""""""
" START Vim Plug Configuration 
filetype off " REQUIRED Disable file type for vim plug.

" Check for OS system in order to start vim-plug in
if has('win32') || has('win64')
    let g:plugDirectory = '~/vimfiles/plugged'
else
    " *nix distributions
    let g:plugDirectory = '~/.vim/plugged'     
endif

call plug#begin(plugDirectory) " REQUIRED

" Plugins
Plug 'nathanaelkane/vim-indent-guides' " Add indent guides
Plug 'tmsvg/pear-tree' " Add auto pair support for delimiters
Plug 'ervandew/supertab' " Allow context aware completion with tab
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'airblade/vim-gitgutter' " Git icons in gutter
Plug 'itchyny/lightline.vim' " Improved status bar
Plug 'nanotech/jellybeans.vim' " Jellybeans theme

call plug#end() " REQUIRED
filetype plugin indent on " REQUIRED Re-enable all that filetype goodness
"""" END Vim Plug Configuration 
"}}}"

"{{{ " Vim Configuration Settings
"""""""""""""""""""""""""""""""""""""
set nocompatible " Required to not be forced into vi mode

syntax on " Enable syntax 
set mouse=a " Enable the mouse
set nowrap " No line wrapping

" Set rendering option for brighter colors and ligatures (GUI)
if !has('nvim') | set renderoptions=type:directx | endif
set encoding=utf-8

let mapleader = "\<Space>" " Map leader to space

" Add specific common directories for Vim to search recursively with :find
set path+=src/**,config/**
set wildmenu " Vim will show a menu with matches for commands

set noshowmode " Disable the mode display below statusline

set backspace=indent,eol,start " Better backspace

set foldmethod=marker " Set fold method

set tags=./tags,tags " Set default tags file location

" Set Font and size
if has('win32') || has('win64')
    if glob("C:/DELL") != ""
        " Set the font for my Dell XPS 13
        set guifont=Iosevka:h10
    else
        set guifont=Iosevka:h11
    endif 
elseif has('unix')
        set guifont=Iosevka:h12
endif

" Start Vim fullscreen
if has('win32') || has('win64')
    au GUIEnter * simalt ~x
elseif has('macunix') || has('mac')
    set lines=999 columns=999
endif

set omnifunc=syntaxcomplete#Complete " Enable omnicomplete
set shortmess+=c " Stop messages in the command line
set completeopt=menuone,noinsert " Configure completion menu to work as expected

set number " Show linenumbers relative to current line

set tabstop=4 shiftwidth=4 smarttab expandtab " Set proper 4 space tabs

set incsearch nohlsearch ignorecase smartcase " Set searching to only be case sensitive when the first letter is capitalized

set laststatus=2 " Always display the status line

set cursorline " Enable highlighting of the current line

" True colors support for terminal
if (has("termguicolors"))
    " Fix alacritty and Vim not showing colorschemes right (Prob. a Vim issue)
    if !has('nvim') && &term == "alacritty"
        let &term = "xterm-256color"
    endif
    set termguicolors
else
    " If Vim doesn't support true colors set 256 colors
    set t_Co=256
endif 

colorscheme jellybeans " Set color theme
set background=dark

set splitright splitbelow " Sets the default splits to be to the right and below from default

set spell spelllang=en_us " Enable Vim's built in spell check and set the proper spellcheck language

let g:tex_flavor='latex' " Set the global tex flavor

"}}}

"{{{ " Auto Commands
" Autocmd to check whether vimrc needs to be updated
" Only runs if vim version >= 8.0 as it uses async features
if (v:version >= 80 && has("job") && has("timers")) || has('nvim')
    augroup CheckVimrc
        autocmd!
        autocmd VimEnter * call GitFetchVimrc()
    augroup END
endif

" Set the working directory to the git directory if there is one present
" otherwise set the working directory to the directory of the current file
augroup SetWorkingDirectory
    autocmd!
    autocmd BufEnter * call SetWorkingDirectory()
augroup END

" Automatically open completion menu 
augroup SkinnyAutoComplete
    autocmd!
    autocmd InsertCharPre * call <SID>skinny_insert(v:char)
    autocmd CompleteDone * if exists('s:skinny_complete') | unlet s:skinny_complete | endif
augroup END

augroup Autosave
    autocmd!
    " Call autosave
    autocmd CursorHold,CursorHoldI,CursorMoved,CursorMovedI,InsertLeave,InsertEnter,BufLeave,VimLeave * call Autosave()
    if (v:version >= 80 && has("job")) || has('nvim')
        autocmd BufWritePost * if glob("./tags") != "" | call UpdateTagsFile() | endif " Update tags file if one is present
    endif 
augroup END

" Autosave session.vim file if it exists
augroup SaveSessionIfExistsUponExit
    autocmd!
    autocmd VimLeave * if glob("./Session.vim") != "" | silent mksession! | endif
augroup END

augroup MakeFiles
    autocmd!
    " Automatically open quickfix window and refocus last window if errors are present after a :make command
    autocmd QuickFixCmdPost *make* cwindow
    autocmd QuickFixCmdPost <C-w><C-p>
augroup END

"}}}

"{{{ " Custom Keybindings
""""""""""""""""""""""""""""""""""""""""""
" Toggle Netrw
nnoremap <silent> <leader>o :call ToggleNetrw()<CR>
inoremap <silent> <leader>o <Esc>:call ToggleNetrw()<CR>

" Determine how to open vimrc before opening with F5
nnoremap <silent> <F5> :call CheckHowToOpenVimrc()<CR>
inoremap <silent> <F5> <Esc>:call CheckHowToOpenVimrc()<CR>

" Assign F12 to reload the current file
nnoremap <silent> <F12> :so %<CR> | redraw
inoremap <silent> <F12> <Esc>:so %<CR> | redraw

" Keybinding for tabbing visual mode selection to automatically re-select the visual selection 
vnoremap > >gv 
vnoremap < <gv

" Change split navigation keys
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k   
nnoremap <C-l> <C-w>l

" Change mappings of buffer commands. Start with <leader>b for buffer
" buffer next
nnoremap <leader>bn :bn<CR>
" buffer previous
nnoremap <leader>bp :bp<CR>
" buffer delete
nnoremap <leader>bd :bd<CR>
" buffer go to
nnoremap <silent> <leader>bg :call GoToSpecifiedBuffer()<CR>
" buffer list
nnoremap <leader>bl :buffers<CR>

" Local replace all instances of a variable using Vim
nnoremap <leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Auto jump back to the last spelling mistake and fix it
inoremap <silent> <C-s> <c-g>u<Esc>mm[s1z=`m<Esc>:delm m<CR>a<c-g>u

" Jump forward and backward to placeholders in abbreviations
inoremap <C-j> <Esc>/<++><CR><Esc>cf>
inoremap <C-k> <Esc>?<++><CR><Esc>cf>

"}}}

"{{{ " Custom Vim Functions and Commands
"""""""""""""""""""""""""""""""""""""""""""""""""
" Check if the buffer is empty and determine how to open my vimrc
function! CheckHowToOpenVimrc()
    if @% == "" || filereadable(@%) == 0 || line('$') == 1 && col('$') == 1
        e $MYVIMRC " If the buffer is empty open vimrc fullscreen 
    else
        vsp $MYVIMRC " Otherwise open vimrc in a vertical split
    endif
endfunction

" Autosave autocmd that makes sure the file exists before saving. Stops errors
" from being thrown
function! Autosave()
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
function! GitFetchVimrc()
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
        let l:compareUpstreamAndLocalTimer = timer_start(0, 'CompareUpstreamAndLocalVimrcGitStatus')
    endif
    return 
endfunction 

" Compare the local and upstream Git status
function! CompareUpstreamAndLocalVimrcGitStatus(timer)
    silent execute("lcd " . s:vimrclocation) " Change to the vimrc git directory

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
    
    silent execute("lcd ~") " Go back to the original startup directory
    return
endfunction

function! GoToSpecifiedBuffer()
    execute("buffers") " Show list of buffers
    let l:bufferNum = input("Enter Buffer Number: ") " Take in user input for which buffer they would like to go to
    execute(":buffer " . bufferNum) " Go to that buffer
endfunction

" If in a Git repo, sets the working directory to its root,
" or if not, to the directory of the current file.
function! SetWorkingDirectory()
    " Stops fugitive from throwing error on :Gdiff
    if bufname('fugitive') != ""
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

" Have the completion menu automatically pop up as you type
function! s:skinny_insert(char)
    if !pumvisible() && !exists('s:skinny_complete') &&
            \ getline('.')[col('.') - 2].a:char =~# '\k\k'
    let s:skinny_complete = 1
    noautocmd call feedkeys("\<C-n>\<C-p>", "nt")
  endif
endfunction

function! UpdateTagsFile()
    " Make sure Ctags exists on the system
    if !executable("ctags")
        echohl WarningMsg | redraw | echom "Could not execute ctags" | echohl None
        finish
    endif 

    " Rename old tags file and set vim to use that
    " While new tags file is being generated
    let s:currentTagsFile=expand("%:p:h") . "/tags"
    call rename(s:currentTagsFile, "old-tags")
    set tags=./old-tags,old-tags
    
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
    set tags=./tags,tags
    call delete("./old-tags")
endfunction
" Command to make tags file inside vim
command! Mkctags silent exe '!ctags -R' | silent exe 'redraw!'

" Toggle Netrw window open and close with the same key
function! ToggleNetrw()
    let b:windowpos = winsaveview() " Save current position to go back to
    
    if &filetype != "netrw"
        silent Explore
    else
        silent Rexplore " Return to previous file
        call winrestview(b:windowpos) " Reset view
    endif
endfunction

" Eat spaces (or any other char) for abbreviations
function! Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction

"}}}

"{{{ " Custom Plugin Configuration Options
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_banner = 0 " Get rid of banner in netrw
let g:netrw_liststyle = 3 " Set netrw to open in tree setup
let g:netrw_keepdir = 0 " Netrw will change working directory every new file

" Set lightline theme and settings
let g:lightline = {
      \ 'colorscheme' : 'jellybeans',
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitQuickDiff', 'gitbranch', 'readonly', 'filename', 'modified'] ],
      \   'right': [ ['lineinfo'], ['fileformat', 'fileencoding', 'filetype'] ],
      \ },
      \ 'component': {
      \  'lineinfo': "%{line('.') . '/' . line('$')}",
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'gitQuickDiff': 'GitQuickDiff',
      \ },
      \ }
" Sees what changes have occurred in the current file
function! GitQuickDiff()
  if !get(g:, 'gitgutter_enabled', 0)
    return ''
  endif
  let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
  if (l:added == 0) && (l:modified == 0) && (l:removed == 0)
      return '' | silent call lighline#update()
  endif 
  return printf('+%d ~%d -%d', l:added, l:modified, l:removed) | silent call lighline#update()
endfunction

let g:indent_guides_enable_on_vim_startup = 1 " Enable vim indent guides at startup
let g:indent_guides_start_level = 2 " Set the level at which the indent guides start
let g:indent_guides_guide_size = 1 " Set the width of the indent guides

let g:SuperTabDefaultCompletionType = "context" " Set Super Tab to be context aware
let g:SuperTabContextDefaultCompletionType = "<c-n>" " Set the default mode for when there is no set context

" Stop pear tree from hiding closing bracket till after leaving insert mode (breaks . command)
let g:pear_tree_repeatable_expand = 0

" Change the default Git Gutter characters
let g:gitgutter_sign_added ='▌'
let g:gitgutter_sign_modified ='▌'
let g:gitgutter_sign_removed = '▌'
let g:gitgutter_sign_removed_first_line = '▌'
let g:gitgutter_sign_removed_above_and_below = '▌'
let g:gitgutter_sign_modified_removed = '▌'
" Set the sign column to be the same color as the line number
highlight! link SignColumn LineNr
" Set the color of the git gutter icons
highlight GitGutterAdd guifg=#70b950
highlight GitGutterChange guifg=#8fbfdc
highlight GitGutterDelete guifg=#902020

"}}}
