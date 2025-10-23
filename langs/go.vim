" ---------------------------
" Go Development
" ---------------------------

" Go specific settings
autocmd FileType go setlocal shiftwidth=4 tabstop=4 noexpandtab

" vim-go configuration
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1

" Go shortcuts
autocmd FileType go nnoremap <buffer> <leader>gb :GoBuild<CR>
autocmd FileType go nnoremap <buffer> <leader>gr :GoRun<CR>
autocmd FileType go nnoremap <buffer> <leader>gt :GoTest<CR>
