"{{{ " Plugins
""""""""""""""""""""""""""""""""""""""""""
" START Vim Plug Configuration
filetype off " REQUIRED Disable file type for vim plug.
let g:plugDirectory = '~/.vim/plugged'
call plug#begin(plugDirectory) " REQUIRED
Plug 'tpope/vim-dispatch' " Asynchronous make
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'tpope/vim-surround' " Easy surrounding of current selection
Plug 'tpope/vim-commentary' " Easy commenting of lines
Plug 'tmsvg/pear-tree' " Add auto pair support for delimiters
Plug 'lifepillar/vim-mucomplete' " Stop the Ctrl-X dance
Plug 'airblade/vim-rooter' " Auto change directory to project root
Plug 'xero/sourcerer.vim' " Theme
call plug#end() " REQUIRED
filetype plugin indent on " REQUIRED Re-enable all that filetype goodness
"""" END Vim Plug Configuration
"}}}"

"{{{ " Vim Configuration Setting
"""""""""""""""""""""""""""""""""""""
set nocompatible " Required to not be forced into vi mode
syntax on " Enable syntax highlighting
set mouse=a " Enable the mouse
set nowrap " No line wrapping
set autowriteall " Auto save on big events
set encoding=utf-8 fileformat=unix fileformats=unix,dos " Set default encoding and line ending
set path-=/usr/include " Remove /usr/include from path. Included for C langs. in ftplugin
set wildignore+=**/.git/** " Add .git directory to wildignore. Nothing inside will be found by :find
set noshowmode " Disable the mode display below statusline
set backspace=indent,eol,start " Better backspace
set tags=./tags,tags " Set default tags file location
set omnifunc=syntaxcomplete#Complete " Enable general omnicomplete
set shortmess+=c " Stop completion messages in the command line
set completeopt=menuone,noselect " Configure completion menu to work as expected
set pumheight=10 " Set maximum height for popup menu
set number " Show line numbers
set tabstop=4 shiftwidth=4 smarttab expandtab " Set proper 4 space tabs
set incsearch nohlsearch ignorecase smartcase " Set searching to only be case sensitive when the first letter is capitalized
set splitright splitbelow " Change default vsp and sp directions
set laststatus=2 " Always display the status line
set cursorline " Enable highlighting of the current line
set spell spelllang=en_us " Enable Vim's built in spell check and set the proper spell check language
set noswapfile undofile backup " No swaps. Persistent undo, create backups
set undodir=~/.vim-undo// backupdir=~/.vim-backup// " Save backups and undo files to constant location
set sessionoptions=curdir,folds,globals,options,tabpages,unix,slash " Set what is saved in session files
set colorcolumn=80 " Create line at 80 character mark
set background=dark " Set the background to be dark. Enables dark mode on themes that support both dark and light
set wildmenu " Show menu of possible candidates
set wildmode=longest:full,full

nnoremap <Nop> "\"
let mapleader = "\\"

let g:tex_flavor='latex' " Set the global tex flavor

if has('autocmd')
    augroup Highlight " Set custom highlights. Stops plugins from messing with colors
        autocmd!
        autocmd ColorScheme * highlight! link SignColumn LineNr
        autocmd ColorScheme * highlight! link StatusLine LineNr
        autocmd ColorScheme * highlight StatusLineNC cterm=reverse gui=reverse
        autocmd ColorScheme * highlight! link TabLine LineNr
    augroup END
endif
colorscheme sourcerer "Set color theme

if has("gui_running") | set guifont=JetBrains\ Mono\ Regular:h11 | endif " Set font for gui

if has('win32') || has('win64') " Start Vim fullscreen
    autocmd GUIEnter * simalt ~x
endif

" Set true colors if supported. If not default to 256 colors
if (has("termguicolors"))
    " Fix alacritty and Vim not showing colorschemes right (Prob. a Vim issue)
    if !has('nvim') && &term == "alacritty"
        let &term = "xterm-256color"
    else
        set t_Co=256
    endif
    set termguicolors
endif

if executable('rg') " Use ripgrep if available
    set grepprg=rg\ --vimgrep\ $*
    set grepformat^=%f:%l:%c:%m
endif

set clipboard+=unnamedplus " Use system clipboard
"}}}

"{{{ " Custom Keybindings and Commands
""""""""""""""""""""""""""""""""""""""""""
" Toggle Netrw
nnoremap <silent> <leader>d :Explore<CR>
command! -nargs=0 -bar Dired silent exe "Explore"

" Keybinding for tabbing visual mode selection to automatically re-select the visual selection
vnoremap > >gv
vnoremap < <gv

" Change mappings of buffer commands.
nnoremap ]b :bn<CR>
nnoremap [b :bp<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bl :buffers<CR>

" Search for visually selected text in current file
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Set bindings for jumping to errors in quickfix list
nmap <silent> ]q :cnext<CR>
nmap <silent> [q :cprev<CR>
nmap <silent> [Q :cfirst<CR>
nmap <silent> ]Q :clast<CR>

" Auto split the terminal and open it in current directory
command! -nargs=0 -bar Term let $VIM_DIR=expand('%:p:h') | silent exe 'sp' | silent exe 'term' | silent exe 'cd $VIM_DIR'
"}}}

"{{{ " Custom Plugin Configuration Options
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_banner = 0 " Get rid of banner in netrw
let g:netrw_keepdir = 0 " Netrw will change working directory every new file

" Status line
let g:currentmode={'n'  : 'NORMAL', 'v'  : 'VISUAL', 'V'  : 'V·Line',
                    \ "\<C-V>" : 'V·Block', 'i'  : 'INSERT', 'R'  : 'R',
                    \ 'Rv' : 'V·Replace', 'c'  : 'Command', 'r' : 'Replace',
                    \ 't': 'Terminal'}
set statusline= " Clear the status line
set statusline+=\ %{toupper(g:currentmode[mode()])}\ \\| " Mode
set statusline+=\ %{FugitiveHead()}\ \\| " Git branch
set statusline+=\ %t\ \\| " File name
set statusline+=\ %(\%m%r%h%w%) " Modified, Read-only, help display
set statusline+=%= " Right align
set statusline+=%Y " File format
set statusline+=\ \\|\ %{toupper(&ff)} " Line endings
set statusline+=\ \\|\ %{toupper(&enc)} " Encoding
set statusline+=\ \\|\ %l/%L " Current line/Total lines
set statusline+=\  " Extra space at the end

" MuComplete Configuration
let g:mucomplete#always_use_completeopt = 1
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 200
let g:mucomplete#reopen_immediately = 0
let g:mucomplete#chains = {
        \ 'default' : ['path', 'tags', 'omni'],
        \ 'latex'   : ['path', 'tags', 'keyp', 'uspl'],
        \ 'vim'     : ['path', 'cmd', 'keyp'],
        \ }
inoremap <silent> <plug>(MUcompleteFwdKey) <right>
imap <right> <plug>(MUcompleteCycFwd)
inoremap <silent> <plug>(MUcompleteBwdKey) <left>
imap <left> <plug>(MUcompleteCycBwd)

" Stop pear tree from hiding closing bracket till after leaving insert mode (breaks . command)
let g:pear_tree_repeatable_expand = 0
"}}}
