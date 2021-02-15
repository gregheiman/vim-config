""""""""""""""""""""""""""""""""""""""""""
" Vimrc
" <zo> opens the fold
" <zc> closes the fold
" <za> toggles the fold
" <zd> deletes the entire fold
""""""""""""""""""""""""""""""""""""""""""
"{{{ " Plugins Section
""""""""""""""""""""""""""""""""""""""""""
" START Vim Plug Configuration 
""""""""""""""""""""""""""""""""""""""""""
" Checks if vim-plug is installed and if not automatically installs it
if has('win32') || has ('win64')
    " Chocolatey default install location
    if empty(glob('~/vimfiles/autoload/plug.vim')) 
        silent !curl -fLo ~/vimfiles/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
elseif has('unix')
    if has('mac') || has('macunix')
        if empty(glob('~/.vim/autoload/plug.vim'))
            silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
    else
        " Linux distributions
        if empty(glob('~/.vim/autoload/plug.vim'))
            silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
    endif
endif

" Disable file type for vim plug
filetype off                  " required

" Check for OS system in order to start vim-plug in
if has('win32') || has('win64')
    let g:plugDirectory = '~/vimfiles/plugged'
elseif has('unix')
    if has('macunix') || has('mac')
        let g:plugDirectory = '~/.vim/plugged'
    else
        " Linux distributions
        let g:plugDirectory = '~/.vim/plugged'     
    endif
endif

call plug#begin(plugDirectory)

""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""
" Utility
"""""""""""""""""""""""
" Add indent guides
Plug 'nathanaelkane/vim-indent-guides'
" Add snippet support
Plug 'sirver/UltiSnips'
" Add auto pair support for delimiters
Plug 'tmsvg/pear-tree'

""""""""""""""""""""""" 
" Generic Programming Support 
"""""""""""""""""""""""
" Allow builtin Vim completion with tab
Plug 'ervandew/supertab'
" Adds LATEX Utilities
Plug 'lervag/vimtex', { 'for': ['tex'] }

""""""""""""""""""""""" 
" Git Support
"""""""""""""""""""""""
" General git wrapper
Plug 'tpope/vim-fugitive'
" Git icons in gutter
Plug 'airblade/vim-gitgutter'

"""""""""""""""""""""""
" Theme / Interface
"""""""""""""""""""""""
" Side file tree
Plug 'preservim/nerdtree', { 'on': [ 'NERDTree', 'NERDTreeToggle' ] }
" Improved status bar
Plug 'itchyny/lightline.vim'
" Seoul-256 Theme"
Plug 'junegunn/seoul256.vim'

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
set renderoptions=type:directx
set encoding=utf-8

" Map leader to space
let mapleader = "\<Space>"

" Enable a fuzzy finder esque system for files
set path=.,/usr/include,,.
set path+=**
set wildmenu

" Disable the mode display below statusline
set noshowmode

" OSX backspace fix
set backspace=indent,eol,start

" Set fold method
set foldmethod=marker

" Set Font and size
if has('win32') || has('win64')
    if glob("C:/DELL") != ""
        " Set the font for my Dell XPS 13
        set guifont=Fira_Code:h8
    else
        " Set the font for my desktop
        set guifont=Fira_Code:h10
    endif
elseif has('unix')
    if has('macunix') || has('mac')
        set guifont=Fira_Code:h12
    else
        " Linux distributions
        set guifont=firacode    
    endif
endif

" Start Vim fullscreen
if has('win32') || has('win64')
    au GUIEnter * simalt ~x
elseif has('macunix') || has('mac')
    set lines=999 columns=999
endif

" Enable omnicomplete
filetype plugin on
set omnifunc=syntaxcomplete#Complete
" Stop messages in the command line
set shortmess+=c
" Configure completion menu to work as expected
set completeopt=menu,menuone,noinsert
" Have the completion menu automatically pop up as you type
function! s:skinny_insert(char)
    if !pumvisible() && !exists('s:skinny_complete') &&
            \ getline('.')[col('.') - 2].a:char =~# '\k\k'
    let s:skinny_complete = 1
    noautocmd call feedkeys("\<C-n>\<C-p>", "nt")
  endif
endfunction

augroup SkinnyAutoComplete
    autocmd!
    autocmd InsertCharPre * call <SID>skinny_insert(v:char)
    autocmd CompleteDone * if exists('s:skinny_complete') | unlet s:skinny_complete | endif
augroup END

" Show linenumbers
set number relativenumber
set ruler

" Set Proper 4 Space Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" Set vim to go to the searched term
set incsearch
" Set searching to only be case sensitive when the first letter is capitalized
set ignorecase
set smartcase

" Automatically set the working directory to the current working directory
autocmd BufEnter * silent! lcd %:p:h

" Always display the status line
set laststatus=2

" Enable highlighting of the current line
set cursorline

" True colors support for terminal
if (has("termguicolors"))
    set termguicolors
else
    " If Vim doesn't support true colors set 256 colors
    set t_Co=256
endif 

" Set color theme
let g:seoul256_background = 234
colorscheme seoul256
set background=dark

" Sets the default splits to be to the right and below from default
set splitright splitbelow

" Enable Vim's built in spell check and set the proper spellcheck language
set spell spelllang=en_us

" Autocmd to check whether vimrc needs to be updated"
" Only runs if vim version >= 8.0 as it uses async features
if v:version >= 80 && has("job") && has("timers")
    autocmd VimEnter * call GitFetchVimrc()
endif

" Call autosave
autocmd CursorHold,InsertLeave,InsertEnter,BufEnter,VimLeave * call Autosave()

" Autosave session.vim file if it exists
autocmd VimLeave * call SaveSessionIfExistsUponExit()

" Automatically open quickfix window after issuing :make command
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
"}}}

"{{{ " Custom Keybindings
""""""""""""""""""""""""""""""""""""""""""
" Set keybind for NERDTREE to Ctrl+o
nnoremap <C-o> :NERDTreeToggle<CR>
inoremap <C-o> <Esc>:NERDTreeToggle<CR>

" Determine how to open vimrc before opening with F5
nnoremap <F5> :call CheckHowToOpenVimrc()<CR>
inoremap <F5> <Esc>:call CheckHowToOpenVimrc()<CR>

" Assign F12 to reload my vimrc file so I don't have to restart upon making
" changes
nnoremap <F12> :so $MYVIMRC<CR> | redraw
inoremap <F12> <Esc>:so $MYVIMRC<CR> | redraw

" Keybinding for tabbing inside of visual mode selection to automatically
" re-select the visual selection 
vnoremap > >gv 
vnoremap < <gv

" Change split navigation keys
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k   
nnoremap <C-l> <C-w>l

" Change mappings of buffer commands
" Start with <leader>b for buffer
" buffer next
nnoremap <leader>bn :bn<CR>
" buffer previous
nnoremap <leader>bp :bp<CR>
" buffer delete
nnoremap <leader>bd :bd<CR>
" buffer go to
nnoremap <leader>bg :call GoToSpecifiedBuffer()<CR>
" buffer list
nnoremap <leader>bl :buffers<CR>

" Local replace all instances of a variable using Vim
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Auto jump back to the last spelling mistake and fix it
inoremap <silent> <C-s> <c-g>u<Esc>mm[s1z=`m<Esc>:delm m<CR>a<c-g>u

" UltiSnips keybind configuration
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
"}}}

"{{{ " Custom Vim Functions
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
    " Change to the vimrc git directory
    silent execute("lcd " . s:vimrclocation) 
    
    " Execute a git fetch to update the tree
    " Run windows command in cmd and linux in shell
    if has("win32") || has("win64")
        let l:gitFetchJob = job_start("cmd git fetch", {"in_io": "null", "out_io": "null", "err_io": "null"})
    else
        let l:gitFetchJob = job_start("/bin/sh git fetch", {"in_io": "null", "out_io": "null", "err_io": "null"})
    endif 
    
    " Grab the status of the job
    let l:gitFetchJobStatus = job_status(gitFetchJob)
    " If unsuccessful let user know and stop job
    if (l:gitFetchJobStatus ==? "fail" || l:gitFetchJobStatus ==? "dead")
        echohl WarningMsg | echom "Vimrc git fetch failed with status " . l:gitFetchJobStatus | echohl None
        call job_stop(gitFetchJob)
    else
        " Otherwise stop job and run CompareUpstreamAndLocalVimrcGitStatus()
        call job_stop(gitFetchJob)
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
        echohl title | echom "Vimrc is up to date" | echohl None
    elseif l:local !=? l:upstream 
        " Otherwise you need to update your vimrc
        echohl WarningMsg | echom "You need to update your Vimrc" | echohl None
    else 
        " Otherwise something went wrong
        echohl Error | echom "Unable to confirm whether you need to update your Vimrc" | echohl None
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

" Automatically save Session.vim it one exists
function! SaveSessionIfExistsUponExit()
    if glob('./Session.vim') != ""
        " If Session.vim exists save before exiting
        silent mksession!
    endif
endfunction
"}}}

"{{{ " Custom Plugin Configuration Options
""""""""""""""""""""""""""""""""""""""""""""""""""
" Set lightline theme and settings
let g:lightline = {
      \ 'colorscheme' : 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitGutterDiff', 'gitbranch', 'readonly', 'filename', 'modified'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'gitGutterDiff': 'LightlineGitGutter',
      \ },
      \ }
"" Sees what changes have occurred in the current file
function! LightlineGitGutter()
  if !get(g:, 'gitgutter_enabled', 0) || empty(FugitiveHead())
    return ''
  endif
  let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
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

" Auto close tags with Pear Tree (Have to include the defaults)
let g:pear_tree_pairs = {
    \   '(': {'closer': ')'},
    \   '[': {'closer': ']'},
    \   '{': {'closer': '}'},
    \   "'": {'closer': "'"},
    \   '"': {'closer': '"'},
    \ '\*/': {'closer': '\*/'}
    \ }
"}}}

 "{{{ " VimTex and LaTeX Configuration
"""""""""""""""""""""""""""""""""""""""""""""
" Set the default Tex flavor
let g:tex_flavor='latex'
" Stop any sort of concealing
let g:tex_conceal = ''
" Set the viewer options for all OS's
if has('win32') || has('win64')
    let g:vimtex_view_general_viewer = 'sumatrapdf'
elseif has('macunix')
    let g:vimtex_view_general_viewer = 'skim'
else
    let g:vimtex_view_general_viewer = 'zathura'
endif
"}}}
