" Color syntax highlighting.
syntax on

" autocmd BufNewFile,BufRead *.py: Run the following on opening or reading a Python file.
" tabstop=4: Existing tabs count for four columns.
" softtabstop=4: hitting tab will fill in up to the appropriate amount.
" shiftwidth=4: >> and << will indent four columns.
" textwidth=79: Lines are maximum 80 characters.
" expandtab: Tabs are spaces.
" autoindent: Copy indent from preceding line.
" smartindent: Indent after colon.

autocmd BufNewFile,BufRead *.py 
    \ set tabstop=4 | 
    \ set softtabstop=4 | 
    \ set shiftwidth=4 | 
    \ set textwidth=79 | 
    \ set expandtab | 
    \ set autoindent | 
    \ set smartindent
