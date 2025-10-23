" ---------------------------
" PHP/Laravel Development
" ---------------------------

" PHP specific settings
autocmd FileType php setlocal shiftwidth=4 tabstop=4
autocmd FileType php setlocal commentstring=//\ %s

" PHP Actor configuration
let g:phpactorPhpBin = 'php'
let g:phpactorBranch = 'master'

" Blade templates
autocmd BufRead,BufNewFile *.blade.php set filetype=blade

" Laravel specific mappings
autocmd FileType php nnoremap <buffer> <leader>lt :!php artisan test<CR>
autocmd FileType php nnoremap <buffer> <leader>lm :!php artisan make:
