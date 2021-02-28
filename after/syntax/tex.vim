" adds support for cleverref package
" \Cref, \cref, \cpageref, \labelcref, \labelcpageref
syn region texRefZone		matchgroup=texStatement start="\\Cref{"				end="}\|%stopzone\>"	contains=@texRefGroup
syn region texRefZone		matchgroup=texStatement start="\\\(label\|\)c\(page\|\)ref{"	end="}\|%stopzone\>"	contains=@texRefGroup

" adds support for listings package
syn region texZone start="\\begin{lstlisting}" end="\\end{lstlisting}\|%stopzone\>"
syn match texInputFile  "\\lstinputlisting\s*\(\[.*\]\)\={.\{-}}" contains=texStatement,texInputCurlies,texInputFileOpt
syn match texZone "\\lstinline\s*\(\[.*\]\)\={.\{-}}"

syntax match helpText /^.*: .*/
syntax match secNum /^\S\+\(\.\S\+\)\?\s*/ contained conceal
syntax match secLine /^\S\+\t.\+/ contains=secNum
syntax match mainSecLine /^[^\.]\+\t.*/ contains=secNum
syntax match ssubSecLine /^[^\.]\+\.[^\.]\+\.[^\.]\+\t.*/ contains=secNum
highlight link helpText		PreProc
highlight link secNum		Number
highlight link mainSecLine	Title
highlight link ssubSecLine	Comment
