" Set omnifunc
set omnifunc=xmlcomplete#Complete

" Auto close xml brackets
let b:pear_tree_pairs = {
    \ '<*>': {'closer': '</*>', 'until': '\W'}
    \ }
