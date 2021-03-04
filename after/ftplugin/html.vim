" Auto close brackets in html files (must include defaults)
let b:pear_tree_pairs = {
\ '(': {'closer': ')'},
\ '[': {'closer': ']'},
\ '{': {'closer': '}'},
\ "'": {'closer': "'"},
\ '"': {'closer': '"'},
\ '<*>': {'closer': '</*>', 'until': '\W', 'not_like': '/$'},
\ }
