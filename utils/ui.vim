" ---------------------------
" UI and Theme Configuration
" ---------------------------

" Colorscheme (after plug#end)
silent! colorscheme gruvbox
" silent! colorscheme seoul256   " alternative: uncomment to try seoul256

" Airline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme = 'gruvbox'

" Git gutter (shows git changes in gutter)
let g:gitgutter_sign_added = '│'
let g:gitgutter_sign_modified = '│'
let g:gitgutter_sign_removed = '│'
let g:gitgutter_sign_removed_first_line = '│'
let g:gitgutter_sign_modified_removed = '│'

" NERDTree configuration
let NERDTreeShowHidden=1
let g:ackprg = 'ag --nogroup --nocolor --column'
