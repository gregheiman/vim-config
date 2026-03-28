setlocal path^=src/**,app/**,lib/**,components/**,pages/**,utils/**,hooks/**,store/**,services/**,types/**
setlocal wildignore+=**/node_modules/**,**/dist/**,**/build/**,**/.next/**,**/.cache/**

setlocal include=
  \^\s*import\s\+.\{-\}\s*from\s*['"]\|
  \^\s*import(\s*['"]\|
  \^\s*\(const\|let\|var\)\s.\{-\}=\s*require(\s*['"]\|
  \^\s*\(const\|let\|var\)\s.\{-\}=\s*require\.resolve(\s*['"]

" Strip the module specifier delimiters so includeexpr receives the bare path.
setlocal includeexpr=substitute(v:fname,'[''\"]\+','','g')

setlocal suffixesadd=.js,.jsx,.ts,.tsx,.mjs,.cjs,.json,.vue
