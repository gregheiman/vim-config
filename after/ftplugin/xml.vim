if exists("g:loaded_pear_tree")
    " Auto close xml brackets
    let b:pear_tree_pairs = {
        \ '<*>': {'closer': '</*>', 'until': '\W'}
        \ }
endif

if matchstr(expand("%:t"), "pom.xml")
    setlocal path^=src/main/java/**,src/test/java/**,src/main/resources/**,src/test/resources/**
endif
