""""""""""""""""""""""""""""""""""""""""""
" Vimrc
" <zo> Opens the fold
" <zc> Closes the fold
" <za> Toggles the fold
" <zd> Deletes the entire fold
""""""""""""""""""""""""""""""""""""""""""
"{{{ " Plugins Section
""""""""""""""""""""""""""""""""""""""""""
" START Vim Plug Configuration 
" Checks if vim-plug is installed and if not automatically installs it
if has('win32') || has ('win64')
    " Chocolatey default install location
    if empty(glob('~/vimfiles/autoload/plug.vim')) 
        silent !curl -fLo ~/vimfiles/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
else
    " *nix distributions
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

" Disable file type for vim plug
filetype off                  " required

" Check for OS system in order to start vim-plug in
if has('win32') || has('win64')
    let g:plugDirectory = '~/vimfiles/plugged'
else
    " *nix distributions
    let g:plugDirectory = '~/.vim/plugged'     
endif

call plug#begin(plugDirectory)

""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""
" Utility
"""""""""""""""""""""""
" Add indent guides
Plug 'nathanaelkane/vim-indent-guides'
" Add auto pair support for delimiters
Plug 'tmsvg/pear-tree'

""""""""""""""""""""""" 
" Generic Programming Support 
"""""""""""""""""""""""
" Allow context aware completion with tab
Plug 'ervandew/supertab'

""""""""""""""""""""""" 
" Git Support
"""""""""""""""""""""""
" Git wrapper
Plug 'tpope/vim-fugitive'
" Git icons in gutter
Plug 'airblade/vim-gitgutter'

"""""""""""""""""""""""
" Theme / Interface
"""""""""""""""""""""""
" Improved status bar
Plug 'itchyny/lightline.vim'
" Jellybeans theme
Plug 'nanotech/jellybeans.vim'

call plug#end()            " required
filetype plugin indent on    " required
"""" END Vim Plug Configuration 
"}}}"

"{{{ " Vim Configuration Settings
"""""""""""""""""""""""""""""""""""""
" Required to not be forced into vi mode
set nocompatible

" Enable syntax, the mouse, and no line wrapping
syntax on
set mouse=a
set nowrap

" Set rendering option for brighter colors and ligatures
if !has('nvim')
    set renderoptions=type:directx
endif
set encoding=utf-8

" Map leader to space
let mapleader = "\<Space>"

" Add specific common directories for Vim to search recursively with :find
set path+=src/**,config/**
" Vim will show a menu with matches for commands
set wildmenu

" Disable the mode display below statusline
set noshowmode

" OSX backspace fix
set backspace=indent,eol,start

" Set fold method
set foldmethod=marker

" Set tags file
set tags=./tags,tags

" Set Font and size
if has('win32') || has('win64')
    if glob("C:/DELL") != ""
        " Set the font for my Dell XPS 13
        set guifont=Iosevka:h8
    else
        " Set the font for my desktop
        set guifont=Iosevka:h11
    endif 
elseif has('unix')
        " *nix distributions
        set guifont=Iosevka:h12
endif

" Start Vim fullscreen
if has('win32') || has('win64')
    au GUIEnter * simalt ~x
elseif has('macunix') || has('mac')
    set lines=999 columns=999
endif

" Enable omnicomplete
set omnifunc=syntaxcomplete#Complete
" Stop messages in the command line
set shortmess+=c
" Configure completion menu to work as expected
set completeopt=menuone,noinsert

" Show linenumbers
set number relativenumber

" Set proper 4 space tabs
set tabstop=4 shiftwidth=4 smarttab expandtab

" Set Vim to go to the searched term. Set searching to only be case sensitive when the first letter is capitalized
set incsearch nohlsearch ignorecase smartcase

" Always display the status line
set laststatus=2

" Enable highlighting of the current line
set cursorline

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

" Set color theme
colorscheme jellybeans
set background=dark

" Sets the default splits to be to the right and below from default
set splitright splitbelow

" Enable Vim's built in spell check and set the proper spellcheck language
set spell spelllang=en_us

" Set the global tex flavor
let g:tex_flavor='latex'

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
        " Update tags file if one is present
        autocmd BufWritePost * if glob("./tags") != "" | call UpdateTagsFile() | endif
    endif 
augroup END

" Autosave session.vim file if it exists
augroup SaveSessionIfExistsUponExit
    autocmd!
    autocmd VimLeave * if glob("./Session.vim") != "" | silent mksession! | endif
augroup END

augroup MakeFiles
    autocmd!
    " Automatically run the make command whenever you :write a file
    autocmd BufWritePost *.cpp,*.py,*.java silent make! | silent redraw!
    " Automatically open quickfix window after issuing :make command
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
augroup END

"}}}

"{{{ " Custom Keybindings
""""""""""""""""""""""""""""""""""""""""""
" Set keybind for NERDTREE to Ctrl+o
nnoremap <silent> <C-o> :call ToggleNetrw()<CR>
inoremap <silent> <C-o> <Esc>:call ToggleNetrw()<CR>

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
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

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
        " If the buffer is empty open vimrc fullscreen 
        e $MYVIMRC
    else
        " Otherwise open vimrc in a vertical split
        vsp $MYVIMRC
    endif
endfunction

" Autosave autocmd that makes sure the file exists before saving. Stops errors
" from being thrown
function! Autosave()
    if @% == "" || filereadable(@%) == 0 || line('$') == 1 && col('$') == 1 || &readonly || mode() == "c" || pumvisible()
        " If the file has no name, is not readable, doesn't exist, is
        " readonly, is currently in command mode, or the pum is visible don't
        " autosave"
        return
    else
        " Otherwise autosave"
        silent update
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
    " Run windows command in cmd and linux in shell
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
    if !has('nvim')
        let l:gitFetchJobStatus = job_status(gitFetchJob)
    endif

    " If unsuccessful let user know and stop job
    if !has('nvim') && (l:gitFetchJobStatus ==? "fail" || l:gitFetchJobStatus ==? "dead")
        echohl WarningMsg | redraw | echom "Vimrc git fetch failed with status " . l:gitFetchJobStatus | echohl None
        call job_stop(l:gitFetchJob)
    elseif has('nvim') && (l:gitFetchJob < 1)
        echohl WarningMsg | redraw | echom "Vimrc git fetch failed with status " . l:gitFetchJob | echohl None
        call jobstop(l:gitFetchJob)
    else
        " Otherwise stop job and run CompareUpstreamAndLocalVimrcGitStatus()
        if !has('nvim')
            call job_stop(gitFetchJob)
        else
            call jobstop(gitFetchJob)
        endif
        " Needs to be a timer because we are running a vimscript function
        " https://vi.stackexchange.com/questions/27003/how-to-start-an-async-function-in-vim-8
        let l:compareUpstreamAndLocalTimer = timer_start(0, 'CompareUpstreamAndLocalVimrcGitStatus')
    endif
    return 
endfunction 

" Compare the local and upstream Git status
function! CompareUpstreamAndLocalVimrcGitStatus(timer)
    " change to the vimrc git directory
    silent execute("lcd " . s:vimrclocation)

    " Set an upstream and local variable that is a hash returned by git
    " Upstream is the hash of the upstream commit
    let l:upstream = system("git rev-parse @{u}")
    " Local is the hash of the current local commit
    let l:local = system("git rev-parse @")
    
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

function! GoToSpecifiedBuffer()
    " show list of buffers
    execute("buffers")
    " take in user input for which buffer they would like to go to
    let l:bufferNum = input("Enter Buffer Number: ")
    " go to that buffer
    execute(":buffer " . bufferNum)
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
    exe ':lcd' . fnameescape(fnamemodify(current_file, ':h'))

    " Get the path to `.git` if we're inside a Git repo.
    " Works both when inside a worktree, or inside an internal `.git` folder.
    silent let git_dir = system('git rev-parse --git-dir')[:-2]
    " Check whether the command output starts with 'fatal'; if it does, we're not inside a Git repo.
    let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
    " If we're inside a Git repo, change the working directory to its root.
    if empty(is_not_git_dir)
        " Expand path -> Remove trailing slash -> Remove trailing `.git`.
        exe ':lcd' . fnameescape(fnamemodify(git_dir, ':p:h:h'))
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
    " Save current position to go back to
    let b:windowpos = winsaveview()
    
    if &filetype != "netrw"
        silent Explore
    else
        " Return to previous file
        silent Rexplore
        " Reset view
        call winrestview(b:windowpos)
    endif
endfunction

function! Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction
"}}}

"{{{ " Custom Plugin Configuration Options
""""""""""""""""""""""""""""""""""""""""""""""""""
" Get rid of banner in netrw
let g:netrw_banner = 0
" Set netrw to open in tree setup
let g:netrw_liststyle = 3
" Netrw will change working directory every new file
let g:netrw_keepdir = 0

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

" Enable vim indent guides at startup
let g:indent_guides_enable_on_vim_startup = 1
" Set the level at which the indent guides start
let g:indent_guides_start_level = 2
" Set the width of the indent guides
let g:indent_guides_guide_size = 1

" Set Super Tab to be context aware
let g:SuperTabDefaultCompletionType = "context"
" Set the default mode for when there is no set context
let g:SuperTabContextDefaultCompletionType = "<c-n>"

" Stop pear tree from hiding closing bracket till after leaving insert mode (breaks . command)
let g:pear_tree_repeatable_expand = 0

" Change the default Git Gutter characters
let g:gitgutter_sign_added ='██'
let g:gitgutter_sign_modified ='██'
let g:gitgutter_sign_removed = '██'
let g:gitgutter_sign_removed_first_line = '██'
let g:gitgutter_sign_removed_above_and_below = '██'
let g:gitgutter_sign_modified_removed = '██'
" Set the sign column to be the same color as the line number
highlight! link SignColumn LineNr
" Set the color of the git gutter icons
highlight GitGutterAdd guifg=#70b950
highlight GitGutterChange guifg=#8fbfdc
highlight GitGutterDelete guifg=#902020

"}}}
