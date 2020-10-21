""""""""""""""""""""""""""""""""""""""""""
" Greg's Configuration
""""""""""""""""""""""""""""""""""""""""""
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
map <Space> <Leader>

" Enable a fuzzy finder esque system for files
set path=.,/usr/include,,.
set path+=**
set wildmenu

" Disable the mode display below statusline
set noshowmode

" Languages in which to disable polyglot
" Needs to be before you load polyglot
let g:polyglot_disabled = ['Python', 'markdown', 'Java']

" Plugins section
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
Plug 'Yggdroot/indentLine'
" Auto closing"
Plug 'jiangmiao/auto-pairs'
" Auto close html and xml tags
Plug 'alvan/vim-closetag', { 'for': ['html', 'phtml', 'xhtml', 'javascript', 'jsx', 'xml'] }
" Easily surround and change quotes
Plug 'tpope/vim-surround'
" Preview Markdown files in browser
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'], 'on': ['MarkdownPreview'] }
" Better commenting
Plug 'preservim/nerdcommenter'
" Automatically set project directory (Works with Fugitive)
Plug 'airblade/vim-rooter'
" Add multiple cursors to Vim
Plug 'terryma/vim-multiple-cursors'

""""""""""""""""""""""" 
" Generic Programming Support 
"""""""""""""""""""""""
" Code completion (Requires Node.js)
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Pretty complete language pack for better syntax highlighting
Plug 'sheerun/vim-polyglot'
" Add support for running commands asynchronously
Plug 'skywind3000/asyncrun.vim', { 'on': [ 'AsyncRun' ] }

"""""""""""""""""""""" 
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
" Presents tags in a bar to the side (Requires Universal-Ctags)
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" Gruvbox theme"
Plug 'morhetz/gruvbox'
" Rainbow brackets and parenthesis
Plug 'junegunn/rainbow_parentheses.vim', { 'on': 'RainbowParentheses' }

" OSX backspace fix
set backspace=indent,eol,start

call plug#end()            " required
filetype plugin indent on    " required
"""" END Vim Plug Configuration 

"""""""""""""""""""""""""""""""""""""
" Vim Config Settings
"""""""""""""""""""""""""""""""""""""
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

" Show linenumbers
set number relativenumber
set ruler

" Set Proper 4 Space Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" Always display the status line
set laststatus=2

" Enable highlighting of the current line
set cursorline

" True colors support for terminal
set termguicolors     

" Set color theme
colorscheme gruvbox
set background=dark

" Autorun RainbowParentheses command upon opening a file
autocmd BufRead * RainbowParentheses

" Automatically save Session.vim it one exists
function! SaveSessionIfExistsUponExit()
    if glob('./Session.vim') != ""
        " If Session.vim exists save before exiting
        silent mksession!
    endif
endfunction

autocmd VimLeave * call SaveSessionIfExistsUponExit()

" Sets the default splits to be to the right and below from default
set splitright splitbelow


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

" Finds the direcotry that the .vimrc is in
" Safe for symbolic links
" Needs to be outside of function in order to work correctly
let s:vimrclocation = fnamemodify(resolve(expand('<sfile>:p')), ':h')
function! CheckIfVimrcHasGitPull()
    " Change to the vim git directory
    silent execute("lcd " . s:vimrclocation) 
    
    "Execute a git fetch to update the tree
    silent execute("AsyncRun -post=execute(SetGitPullVariables()) git fetch")
    return 
endfunction 

" Set the variables for checking if the Vimrc needs to be updated
function! SetGitPullVariables()
    silent execute("lcd " . s:vimrclocation)

    " Set an upstream and local variable that is a hash returned by git
    let l:upstream = system("git rev-parse @{u}")
    let l:local = system("git rev-parse @")
    
    " If the hashes match then the vimrc is updated 
    if l:local ==? l:upstream
        echohl title | echom "Vimrc is up to date" | echohl None
    elseif l:local !=? l:upstream 
        " Otherwise you need to update your vimrc
        echohl WarningMsg | echom "You need to update your Vimrc" | echohl None
    else 
        echohl Error | echom "Unable to confirm wether you need to update your Vimrc" | echohl None
    endif
    
    " Go back to the original startup directory
    silent execute("lcd ~")
    return
endfunction

" Autocmd to check wether vimrc needs to be updated"
autocmd VimEnter * call CheckIfVimrcHasGitPull()

autocmd CursorHold,InsertLeave,InsertEnter,BufEnter * call Autosave()

""""""""""""""""""""""""""""""""""""""""""
" Custom Keybindings
""""""""""""""""""""""""""""""""""""""""""
" Set keybind for NERDTREE to Ctrl+o
map <C-o> :NERDTreeToggle<CR>

" Tagbar toggle keybinding to F6
map <F6> :TagbarToggle<CR>

" Determine how to open vimrc before opening with F5
map <F5> :call CheckHowToOpenVimrc()<CR>

" Assign F7 to run the current python file
autocmd FileType python nnoremap <F7> :update<CR>:!python %<CR>

" Assign F8 to compile the current c++ file with Clang
autocmd FileType cpp nnoremap <F8> :update<CR>:silent AsyncRun -mode=terminal -focus=0 -rows=20 -post=echom\ "%:t\ Finished\ Compiling" clang++ -Wall % -o %:r.exe<CR>
" Assign F9 to run the current c++ file's executable that Clang created
autocmd FileType cpp nnoremap <F9> :update<CR>:!%:r.exe<CR>

" Assign F12 to reload my vimrc file so I don't have to restart upon making
" changes
map <F12> :so $MYVIMRC<CR>

" Keybinding for tabbing inside of visual mode selection
vnoremap <Tab> >gv 
vnoremap <S-Tab> <gv

" Change split navigation keys
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k	
map <C-l> <C-w>l

" Map next, previous, and delete buffer to leader p and leader n and leader d
map <leader>n :bn<cr>
map <leader>p :bp<cr>
map <leader>d :bd<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Plugin Config Options
""""""""""""""""""""""""""""""""""""""""""""""""""
" Set lightline theme and settings
let g:lightline = {
      \ 'colorscheme' : 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitGutterDiff', 'gitbranch', 'readonly', 'filename', 'modified'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'gitGutterDiff': 'LightlineGitGutter',
      \ },
      \ }
" Sees what changes have occurred in the current file
function! LightlineGitGutter()
  if !get(g:, 'gitgutter_enabled', 0) || empty(FugitiveHead())
    return ''
  endif
  let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
endfunction

" Set the patterns for rooter
let g:rooter_patterns = ['.git', '.idea', 'src']
" Set non-project directories to go to the files current directory
let g:rooter_change_directory_for_non_project_files = 'current'
" Rooter won't echo the current working directory
let g:rooter_silent_chdir = 1
" Rooter won't resolve symbolic links by default
let g:rooter_resolve_links = 1

" Setup fugitive's Gfetch and Gpush commands to use AsyncRun
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Closetag Config
""""""""""""""""""""""""""""""""""""""""""""""""""
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml,javascript'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filetypes = 'xhtml,jsx,javascript'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

"""""""""""""""""""""""""""""""""""""""""""""""
" COC Config
""""""""""""""""""""""""""""""""""""""""""""""
" COC List of Extensions
let g:coc_global_extensions = [
    \ "coc-python", 
    \ "coc-java", 
    \ "coc-clangd", 
    \ "coc-xml", 
    \ "coc-vimlsp", 
    \ "coc-spell-checker", 
    \ "coc-highlight", 
    \ "coc-tsserver", 
    \ "coc-markdownlint", 
    \ "coc-eslint",
    \ "coc-json",
    \ ]
" Next and previous selection are <C-J> and <C-K> respectively
" For statusline integration with other plugins, checkout `:h coc-status`

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
nmap <silent> <C-TAB> <Plug>(coc-range-select)
xmap <silent> <C-TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Use command Prettier for Prettier support
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>d  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>a  :<C-u>CocList commands<cr>
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

" Remap for rename current word
nnoremap <silent> <space>rn <Plug>(coc-rename)
