" ---------------------------
" Python Development
" ---------------------------

" Python specific settings
autocmd FileType python setlocal shiftwidth=2 tabstop=2
autocmd FileType python setlocal commentstring=#\ %s
autocmd FileType python setlocal foldmethod=indent

" Python syntax highlighting
let g:python_highlight_all = 1

" Python execution shortcut
nnoremap <buffer> <leader>py :!python %<CR>
