" ---------------------------
" Vim Specific Configuration  
" ---------------------------

" Vim-exclusive settings
set ttymouse=xterm2

" Better compatibility for older Vim
if !has('patch-8.1.1')
  set nomodeline
endif

" Vim-specific performance tweaks
set regexpengine=1
set ttyfast
