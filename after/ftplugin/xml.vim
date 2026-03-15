if exists("g:loaded_pear_tree")
    " Auto close xml brackets
    let b:pear_tree_pairs = {
        \ '<*>': {'closer': '</*>', 'until': '\W'}
        \ }
endif
