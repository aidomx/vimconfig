" ---------------------------
" Laravel Framework
" ---------------------------

" Blade template highlighting
autocmd BufRead,BufNewFile *.blade.php set filetype=blade

" Laravel Artisan commands
command! -nargs=+ Artisan execute '!php artisan ' . <q-args>
command! ArtisanServe execute '!php artisan serve'
command! ArtisanMigrate execute '!php artisan migrate'

" Laravel specific mappings
nnoremap <leader>la :Artisan<space>
nnoremap <leader>ls :ArtisanServe<CR>
nnoremap <leader>lm :Artisan migrate<CR>
