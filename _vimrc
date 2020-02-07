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
map <Space> <Leader>

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
"Multiple line cursors"
Plug 'terryma/vim-multiple-cursors'
"Auto closing"
Plug 'jiangmiao/auto-pairs'

""""""""""""""""""""""" 
" Generic Programming Support 
"""""""""""""""""""""""
" Asyncronous lint engine
Plug 'w0rp/ale'
" Code completion (Requires Node.js)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Database support
Plug 'tpope/vim-dadbod'
" Pretty complete language pack for better syntax highlighting
Plug 'sheerun/vim-polyglot'

"""""""""""""""""""""" 
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
"Adds a tagbar to the side (Requires CTags)
Plug 'majutsushi/tagbar'
"Gruvbox theme"
Plug 'morhetz/gruvbox'
"Rainbow brackets and parenthesis
Plug 'junegunn/rainbow_parentheses.vim'
"Ayu theme
Plug 'ayu-theme/ayu-vim'
"Onedark theme
Plug 'joshdick/onedark.vim'

" OSX backspace fix
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

" Set lightline theme and settings
let g:lightline = {
      \ 'colorscheme' : 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" true colors support
set termguicolors     

" set ayu theme to the middle mirage style
let ayucolor="mirage" 
" Set color theme
colorscheme gruvbox
set background=dark

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

" Start vim fullscreen"
au GUIEnter * simalt ~x

" TAGBAR keybinding"
nmap <F6> :TagbarToggle<CR>

" Open up the _vimrc file in a serperate vertical buffer
map <F5> :vsp C:/Users/Greg/Vim/_vimrc<CR>

" Keybinding for tabing inside of visual mode selection
vmap <Tab> >gv
vmap <S-Tab> <gv

" Keybinding for quick refactoring
nnoremap <leader>r gD:%s/<C-R>///gc<left><left><left>

"  Sets the curretly open windows path to the current files path
autocmd BufEnter * lcd %:p:h

"Sets the default splits to be to the right and below from default
set splitright splitbelow

"Change split navigation keys
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k	
map <C-l> <C-w>l

" Map next, previous, and delete buffer to leader p and leader n and leader d
map <leader>n :bn<cr>
map <leader>p :bp<cr>
map <leader>d :bd<cr>

" Add syntax highlighting for java functions
let g:java_highlight_functions = 1

""""""""""""""""""""""""""""""""
" CoC Config
""""""""""""""""""""""""""""""""
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

