" Improve java syntax highlighting
let java_highlight_functions = "style"
let java_highlight_all = 1
let java_highlight_debug = 0

" Setup :find command
" Setup inefficient path that will find pretty much everything in the project
setlocal path^=src/main/java/**,src/test/java/**,src/main/resources/**,src/test/resources/**
setlocal wildignore+=**/target/**
" Proper include statement
setlocal include=^\\s*import
" Proper define statement for the beginning of functions
setlocal define=^\\s*\\(private\\\|public\\\|protected\\)\\s*\\a*\\s*
