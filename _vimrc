""""""""""""""""""""""""""""
" Greg's Configuration
""""""""""""""""""""""""""""
"Required
set nocompatible

"Enable syntax, the mouse, and no line wrapping
syntax on
set mouse=a
set nowrap

"Enable ligatures
set renderoptions=type:directx
set encoding=utf8

" Map leader to space
let mapleader =" "

"Make finding files easy
set path=.,/usr/include,,.
set path+=**
set wildmenu

"""""""""""""""""""""""""""""
" START Vim Plug Configuration 
"""""""""""""""""""""""""""""
" Disable file type for vim plug
filetype off                  " required

call plug#begin('~/.vim/bundle')

"""""""""""""""""""""""
" Utility
"""""""""""""""""""""""
"Add indent guides
Plug 'Yggdroot/indentLine'
"Fantastic Commenting
Plug 'scrooloose/nerdcommenter'
"Multiple line cursors"
Plug 'terryma/vim-multiple-cursors'
"Auto closing"
Plug 'jiangmiao/auto-pairs'

""""""""""""""""""""""" 
" Generic Programming Support 
"""""""""""""""""""""""
"Asyncronous lint engine
Plug 'w0rp/ale'
" Code completion
Plug 'valloric/youcompleteme'
" Database support
Plug 'tpope/vim-dadbod'

""""""""""""""""""""""" 
" Git Support
"""""""""""""""""""""""
"General git wrapper
Plug 'tpope/vim-fugitive'
"Git icons in gutter
Plug 'airblade/vim-gitgutter'

"""""""""""""""""""""""
" Theme / Interface
"""""""""""""""""""""""
"Side file tree
Plug 'scrooloose/nerdtree'
"Improved status bar
Plug 'itchyny/lightline.vim'
"Adds a tagbar to the side
Plug 'majutsushi/tagbar'
"Gruvbox theme"
Plug 'morhetz/gruvbox'
"Rainbow brackets and parenthesis
Plug 'junegunn/rainbow_parentheses.vim'
"Ayu theme
Plug 'ayu-theme/ayu-vim'
"Onedark theme
Plug 'joshdick/onedark.vim'

" OSX stupid backspace fix
set backspace=indent,eol,start

call plug#end()            " required
filetype plugin indent on    " required
"""" END Vim Plug Configuration 

"""""""""""""""""""""""""""""""""""""
" Configuration Section
"""""""""""""""""""""""""""""""""""""
"Set Font
set guifont=Fira_Code:h10

" Show linenumbers
set number
set ruler

" Set Proper Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" Always display the status line
set laststatus=2

" Enable Elite mode
let g:elite_mode=1

" Enable highlighting of the current line
set cursorline

" Set lightline theme
let g:lightline = {
      \ 'colorscheme' : 'onedark',
      \ }

" true colors support
set termguicolors     

" set ayu theme to the middle mirage style
let ayucolor="mirage" 

" Set color theme
colorscheme Onedark
set background=dark

" Let ale complete
let g:ale_completion_enabled = 1

" Ale fix files on save
let g:ale_fix_on_save = 1

" Autorun RainbowParentheses command on startup
autocmd VimEnter * RainbowParentheses

" Multiple line cursor configuration
let g:multi_cursor_use_default_mapping=0

" Default mapping for muliple cursor
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" Set keybind for NERDTREE to Ctrl+o"
map <C-o> :NERDTreeToggle<CR>

" Set file highlighting for NERDTREE"
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

" Start vim fullscreen"
au GUIEnter * simalt ~x

" TAGBAR keybinding"
nmap <F8> :TagbarToggle<CR>

" Set keybindings for creating java classes and running java programs
autocmd Filetype java set makeprg=javac\ %
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
map <F9> :make<Return>:copen<Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>
map <F12> :!start cmd /k "cd %:~:h:s?src?bin? & java %:r"

" Run ctags -R command with F5"
map <F5> :!start cmd /k "cd %:~:h:s?src?bin? & ctags -R"

" Run the current python file in seperate terminal"
map <F8> :!python %

" Open up the _vimrc file in a serperate vertical buffer
map <F7> :e C:/Users/Greg/Vim/_vimrc

" Keybinding for tabing inside of visual mode selection
vmap <Tab> >gv
vmap <S-Tab> <gv

"  Sets the curretly open windows path to the active path"
autocmd BufEnter * lcd %:p:h

"Sets the default splits to be to the right and below from default
set splitbelow splitright

"Change split navigation keys
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k	
map <C-l> <C-w>l

" Map next, previous, and delete buffer to leader p and leader n and leader d
map <leader>n :bn<cr>
map <leader>p :bp<cr>
map <leader>d :bd<cr>  
