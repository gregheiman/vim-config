"{{{ " Plugins
""""""""""""""""""""""""""""""""""""""""""
" START Vim Plug Configuration 
filetype off " REQUIRED Disable file type for vim plug.
" Check for OS system in order to start vim-plug in
if has('win32') || has('win64')
    let g:plugDirectory = '~/vimfiles/plugged'
else
    let g:plugDirectory = '~/.vim/plugged'     
endif
call plug#begin(plugDirectory) " REQUIRED
" The Big Stuff
Plug 'lifepillar/vim-mucomplete' " Extend Vim's completion
Plug 'dense-analysis/ale' " Asynchronous linting and fixing
Plug 'natebosch/vim-lsc' " Vimscript LSP client
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'tmsvg/pear-tree' " Add auto pair support for delimiters
Plug 'gruvbox-community/gruvbox' " Gruvbox theme
" The Little Additions
Plug 'junegunn/goyo.vim' " Some peace and quiet
Plug 'junegunn/limelight.vim' " Highlight only current codeblock
Plug 'tpope/vim-surround' " Easy surrounding of current selection
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
set encoding=utf-8 " Set default encoding
set path-=/usr/include " Remove /usr/include form path. Included for C langs. in ftplugin
set noshowmode " Disable the mode display below statusline
set backspace=indent,eol,start " Better backspace
set tags=./tags,tags " Set default tags file location
set omnifunc=syntaxcomplete#Complete " Enable general omnicomplete
set shortmess+=c " Stop completion messages in the command line
set completeopt=menuone,noselect " Configure completion menu to work as expected
set pumheight=25 " Set maximum height for popup menu
set number " Show line numbers
set tabstop=4 shiftwidth=4 smarttab expandtab " Set proper 4 space tabs
set incsearch nohlsearch ignorecase smartcase " Set searching to only be case sensitive when the first letter is capitalized
set splitright splitbelow " Change default vsp and sp directions
set laststatus=2 " Always display the status line
set cursorline " Enable highlighting of the current line
set spell spelllang=en_us " Enable Vim's built in spell check and set the proper spellcheck language
set noswapfile " Don't create swap files
set background=dark " Set the background to be dark. Enables dark mode on themes that support both dark and light
colorscheme gruvbox " Set color theme
let mapleader = "\<Space>" " Map leader to space
let g:tex_flavor='latex' " Set the global tex flavor
let b:m1=matchadd('ErrorMsg', '\%>80v.\+', -1) " Highlight characters past 80

" Set Font and size
if has('win32') || has('win64')
    set guifont=Iosevka:h11
elseif has('unix')
    set guifont=Iosevka:h12
endif

" Start Vim fullscreen
if has('win32') || has('win64') 
    autocmd GUIEnter * simalt ~x
endif

" Set true colors if supported. If not default to 256 colors
if (has("termguicolors"))
    " Fix alacritty and Vim not showing colorschemes right (Prob. a Vim issue)
    if !has('nvim') && &term == "alacritty"
        let &term = "xterm-256color"
    endif
    set termguicolors
else
    set t_Co=256
endif

if executable('rg') " Use ripgrep if available
    set grepprg=rg\ --vimgrep\ $*
    set grepformat^=%f:%l:%c:%m 
endif
"}}}

"{{{ " Auto Commands
if has("autocmd")
    " Autocmd to check whether vimrc needs to be updated
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
    augroup END
    augroup GitBranch
        autocmd!
        autocmd BufNewFile,BufReadPost,BufEnter * call functions#GetGitBranch() " Retrieve git branch for statusline
    augroup END
endif
"}}}

"{{{ " Custom Keybindings and Commands
""""""""""""""""""""""""""""""""""""""""""
" Toggle Netrw
nnoremap <silent> <C-e> :call functions#ToggleNetrw()<CR>
inoremap <silent> <C-e> <Esc>:call functions#ToggleNetrw()<CR>

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

" Project wide search
nnoremap <leader>f :call functions#DetermineGrep("<C-r><C-w>")<CR>
vnoremap <leader>f :<C-u>call functions#GrepOperator(visualmode())<CR>
" Local replace all instances of a variable using Vim
nnoremap <leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
" Project wide replace
nnoremap <leader>R :call functions#DetermineGrep("<C-r><C-w>", '1')<CR>
vnoremap <leader>R :<C-u>call functions#GrepOperator(visualmode(), '1')<CR>

" Auto jump back to the last spelling mistake and fix it
inoremap <silent> <C-s> <c-g>u<Esc>mm[s1z=`m<Esc>:delm m<CR>a<c-g>u

" Jump forward and backward to placeholders in abbreviations
inoremap <C-j> <Esc>/<++><CR><Esc>cf>
inoremap <C-k> <Esc>?<++><CR><Esc>cf>

" Set bindings for jumping to errors in the loclist and quickfix list
nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>
nnoremap [L :lfirst<CR>
nnoremap ]L :llast<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" Command to make tags file inside vim
command! -nargs=0 -bar Mkctags silent exe '!ctags -R' | silent exe 'redraw!'

" Eat spaces (or any other char) for abbreviations
function! Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction
"}}}

"{{{ " Custom Plugin Configuration Options
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_banner = 0 " Get rid of banner in netrw
let g:netrw_keepdir = 0 " Netrw will change working directory every new file

" Status line
highlight! link StatusLine LineNr
highlight StatusLineNC cterm=reverse gui=reverse
highlight! link TabLine LineNr
let g:currentmode={'n'  : 'NORMAL', 'v'  : 'VISUAL', 'V'  : 'V·Line', "\<C-V>" : 'V·Block',
                    \ 'i'  : 'INSERT', 'R'  : 'R', 'Rv' : 'V·Replace', 'c'  : 'Command', 'r' : 'Replace'}
set statusline= " Clear the status line
set statusline+=\ %{toupper(g:currentmode[mode()])}\ \\| " Mode
set statusline+=%{functions#GitBranchStatusLine()} " Git branch
set statusline+=\ %t\ \\| " File name
set statusline+=\ %(\%m%r%h%w%) " Modified, Read-only, help display
set statusline+=%= " Right align
set statusline+=%y " File format
set statusline+=\ \\|\ %{&enc} " Encoding
set statusline+=\ \\|\ %l/%L " Current line/Total lines
set statusline+=\  " Extra space at the end

" Mucomplete configuration
let g:mucomplete#always_use_completeopt = 1 " Respect the completeopt
let g:mucomplete#chains = {
	    \ 'default' : ['path', 'omni', 'tags', 'incl', 'dict', 'uspl'],
	    \ 'vim'     : ['path', 'cmd', 'keyp']
	    \ }
inoremap <silent> <plug>(MUcompleteFwdKey) <right>
imap <right> <plug>(MUcompleteCycFwd)
inoremap <silent> <plug>(MUcompleteBwdKey) <left>
imap <left> <plug>(MUcompleteCycBwd)

" Stop pear tree from hiding closing bracket till after leaving insert mode (breaks . command)
let g:pear_tree_repeatable_expand = 0

" Goyo customization
let g:goyo_width = 90
let g:goyo_linenr = 1 " Show line numbers
autocmd! User GoyoEnter nested execute("Limelight")
autocmd! User GoyoLeave nested execute("Limelight!")
    
" ALE Customization
highlight! link SignColumn LineNr
highlight! link ALEErrorSign GruvboxRed
highlight! link ALEWarningSign GruvboxYellow

" Vim-lsc Customization
let g:lsc_auto_map = {'defaults': v:true, 'Completion': 'omnifunc'} " Override keybindings when vim-lsc is enabled for buffer
let g:lsc_enable_autocomplete = v:false " Disable autocomplete till I hit TAB
let g:lsc_enable_diagnostics = v:false " ALE has better linting
let g:lsc_server_enabled = v:false
let g:lsc_server_commands = {
    \ 'cpp': {
        \ 'command': 'clangd --background-index --cross-file-rename --header-insertion=iwyu',
        \ 'suppress_stderr': v:true,
        \ 'enabled': v:false,
    \},
    \ 'tex': {
        \ 'command': 'texlab',
        \ 'enabled': v:false,
    \},
    \ 'python': {
        \ 'command': 'pyls',
        \ 'enabled': v:false,
    \},
    \ 'java': {
        \ 'command': '~/Programs/jdt_language_server -data' . getcwd(),
        \ 'supress_stderr': v:true,
        \ 'log_level': 'Warning',
        \ 'enabled': v:false,
    \},
\}
"}}}
