if has('win64') || has('win32')
	set runtimepath^=~/vimfiles runtimepath+=~/vimfiles/after
else
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
endif
let &packpath = &runtimepath
if has('win64') || has('win32')
	source C:/tools/vim/.vimrc
else
	source ~/.vim/.vimrc
endif
