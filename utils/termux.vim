" ---------------------------
" Termux-specific optimizations
" ---------------------------

" Better untuk touch screen
set mouse=a
set ttymouse=sgr

" Scroll lebih smooth di mobile
set ttyfast

" Backspace behavior
set backspace=indent,eol,start

" Timeout optimizations for mobile
set timeoutlen=500
set ttimeoutlen=50

" Terminal colors for Termux
if $TERM_PROGRAM =~ "Termux"
  set termguicolors
  colorscheme gruvbox
endif
