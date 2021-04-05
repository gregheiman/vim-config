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
Plug 'lifepillar/vim-mucomplete' " Extend Vim's completion
Plug 'dense-analysis/ale' " Asynchronous linting and fixing
Plug 'natebosch/vim-lsc' " Simple LSP support
Plug 'nathanaelkane/vim-indent-guides' " Add indent guides
Plug 'tmsvg/pear-tree' " Add auto pair support for delimiters
if has('nvim') | Plug 'norcalli/nvim-colorizer.lua' | endif " Show colors represented by color codes
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
        set guifont=Iosevka:h11
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
set completeopt=menuone,noinsert,noselect " Configure completion menu to work as expected
set pumheight=25 " Set maximum height for popup menu

set number " Show line numbers

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

set noswapfile " Don't create swap files

let g:tex_flavor='latex' " Set the global tex flavor

"}}}

"{{{ " Auto Commands
" Autocmd to check whether vimrc needs to be updated
" Only runs if vim version >= 8.0 as it uses async features
if (v:version >= 80 && has("job") && has("timers")) || has('nvim')
    augroup CheckVimrc
        autocmd!
        autocmd VimEnter * call functions#GitFetchVimrc()
    augroup END
endif

" Set the working directory to the git directory if there is one present
" otherwise set the working directory to the directory of the current file
augroup SetWorkingDirectory
    autocmd!
    autocmd BufEnter * call functions#SetWorkingDirectory()
augroup END

augroup Autosave
    autocmd!
    " Call autosave
    autocmd CursorHold,CursorHoldI,CursorMoved,CursorMovedI,InsertLeave,InsertEnter,BufLeave,VimLeave * call functions#Autosave()
    if (v:version >= 80 && has("job")) || has('nvim')
        autocmd BufWritePost * if glob("./tags") != "" | call functions#UpdateTagsFile() | endif " Update tags file if one is present
    endif 
augroup END

augroup SaveSessionIfExistsUponExit
    autocmd!
    autocmd VimLeave * if glob("./Session.vim") != "" | silent mksession! | endif " Autosave session.vim file if it exists
augroup END

augroup MakeFiles
    autocmd!
    " Automatically open quickfix window and refocus last window if errors are present after a :make command
    autocmd QuickFixCmdPost *make* cwindow
    autocmd QuickFixCmdPost <C-w><C-p>
augroup END

"}}}

"{{{ " Custom Keybindings and Commands
""""""""""""""""""""""""""""""""""""""""""
" Toggle Netrw
nnoremap <silent> <C-e> :call functions#ToggleNetrw()<CR>
inoremap <silent> <C-e> <Esc>:call functions#ToggleNetrw()<CR>

" Determine how to open vimrc before opening with F5
nnoremap <silent> <F5> :call functions#CheckHowToOpenVimrc()<CR>
inoremap <silent> <F5> <Esc>:call functions#CheckHowToOpenVimrc()<CR>

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
nnoremap <silent> <leader>bg :call functions#GoToSpecifiedBuffer()<CR>
" buffer list
nnoremap <leader>bl :buffers<CR>

" Local replace all instances of a variable using Vim
nnoremap <leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Auto jump back to the last spelling mistake and fix it
inoremap <silent> <C-s> <c-g>u<Esc>mm[s1z=`m<Esc>:delm m<CR>a<c-g>u

" Jump forward and backward to placeholders in abbreviations
inoremap <C-j> <Esc>/<++><CR><Esc>cf>
inoremap <C-k> <Esc>?<++><CR><Esc>cf>

" Command to make tags file inside vim
command! Mkctags silent exe '!ctags -R' | silent exe 'redraw!'

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
let g:lightline = { 'colorscheme' : 'jellybeans',
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
" Show summary of changes in the current file 
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

let g:indent_guides_enable_on_vim_startup = 1 " Enable indent guides at startup
let g:indent_guides_start_level = 2 " Set the level at which the indent guides start
let g:indent_guides_guide_size = 1 " Set the width of the indent guides

let g:mucomplete#enable_auto_at_startup = 1 " Auto open completion menu
let g:mucomplete#completion_delay = 700 " Delay mucomplete to let LSP work
let g:mucomplete#reopen_immediately = 0 " Delay mucomplete to let LSP work
inoremap <silent> <plug>(MUcompleteFwdKey) <right>
imap <right> <plug>(MUcompleteCycFwd)
inoremap <silent> <plug>(MUcompleteBwdKey) <left>
imap <left> <plug>(MUcompleteCycBwd)

" Stop pear tree from hiding closing bracket till after leaving insert mode (breaks . command)
let g:pear_tree_repeatable_expand = 0

if has('nvim') " Load colorizer for every filetype 
    lua require'colorizer'.setup() 
endif

" Git Gutter Customization
let g:gitgutter_sign_added ='▌'
let g:gitgutter_sign_modified ='▌'
let g:gitgutter_sign_removed = '▌'
let g:gitgutter_sign_removed_first_line = '▌'
let g:gitgutter_sign_removed_above_and_below = '▌'
let g:gitgutter_sign_modified_removed = '▌'
highlight! link SignColumn LineNr
highlight GitGutterAdd guifg=#70b950
highlight GitGutterChange guifg=#8fbfdc
highlight GitGutterDelete guifg=#902020

" ALE Customization
highlight ALEErrorSign guifg=#902020
highlight ALEWarningSign guifg=#fad06a

" Vim-lsc Customization
let g:lsc_auto_map = v:true " Override keybindings when vim-lsc is enabled for buffer
let g:lsc_enable_diagnostics = v:false " ALE has better linting
let g:lsc_server_commands = {
    \ 'cpp': {
        \ 'command': 'clangd --background-index --cross-file-rename --header-insertion=iwyu',
        \ 'suppress_stderr': v:true,
    \},
    \ 'tex': {
        \ 'command': 'texlab',
    \},
    \ 'python': {
        \ 'command' : 'pyls',
    \},
    \ 'java': {
        \ 'command': '~/Programs/jdt_language_server -data' . getcwd(),
        \ 'supress_stderr': v:true,
        \ 'log_level': 'Warning',
    \},
\}

"}}}
