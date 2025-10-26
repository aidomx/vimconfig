" ---------------------------
" Termux-specific optimizations
" ---------------------------

" Better untuk touch screen
set mouse=a
set ttymouse=sgr

" Scroll lebih smooth di mobile
set lazyredraw
set ttyfast

" Backspace behavior
set backspace=indent,eol,start

" Timeout optimizations for mobile
set timeoutlen=1000
set ttimeoutlen=50

" Terminal colors for Termux
if $TERM_PROGRAM =~ "Termux"
  set termguicolors
  colorscheme gruvbox

  " Fix arrow keys in insert mode
  imap <Esc>OA <Esc>ki
  imap <Esc>OB <Esc>ji
  imap <Esc>OC <Esc>li
  imap <Esc>OD <Esc>hi

  " Fix arrow keys in normal mode
  map <Esc>OA k
  map <Esc>OB j
  map <Esc>OC l
  map <Esc>OD h
endif
