" Set Neovim to load .vimrc
if has('win64') || has('win32')
	set runtimepath^=~/vimfiles runtimepath+=~/vimfiles/after
else
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
endif
let &packpath = &runtimepath
if has('win64') || has('win32')
	source ~/vimfiles/.vimrc 
else
	source ~/.vimrc
endif
