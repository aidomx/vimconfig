" ---------------------------
" Key mappings & helpers - TERMUX FRIENDLY
" ---------------------------

" Leader key (space lebih mudah di HP)
let mapleader = " "

" File navigation
nnoremap <silent>tt :NERDTreeToggle<CR>
nnoremap <silent>ff :NERDTreeFind<CR>
nnoremap <silent>pp :Files<CR>
nnoremap <silent>bb :Buffers<CR>
nnoremap <silent>gg :Rg<CR>

" Copilot mappings
imap <silent><script> <C-J> copilot#Accept("\<CR>")
imap <silent><script> <C-K> <Plug>(copilot-dismiss)
nmap <leader>cp :Copilot panel<CR>

" Basic convenience
nnoremap <leader>s :call ToggleSplit()<CR>
nnoremap <leader>m :call ToggleMaximizeSplit()<CR>

" Quick save dan quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>x :x<CR>

" Tab management (easier on mobile)
nnoremap <leader>to :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprevious<CR>

" Clear search highlights
nnoremap <leader><space> :nohlsearch<CR>

" Terminal mappings untuk Termux
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" ToggleSplit / ToggleMaximizeSplit helpers
let g:split_hidden = 0
function! ToggleSplit()
  if g:split_hidden == 0
    let g:last_winview = winsaveview()
    only
    let g:split_hidden = 1
  else
    execute "sp"
    call winrestview(g:last_winview)
    let g:split_hidden = 0
  endif
endfunction

let g:split_maximized = 0
function! ToggleMaximizeSplit()
  if g:split_maximized == 0
    let g:last_size = winheight(0)
    execute "resize"
    let g:split_maximized = 1
  else
    execute "resize " . g:last_size
    let g:split_maximized = 0
  endif
endfunction

" ---------------------------
" Comment Toggle dengan NERDCommenter
" ---------------------------

" Toggle comment untuk line atau visual selection
nmap <leader>c <Plug>NERDCommenterToggle
vmap <leader>c <Plug>NERDCommenterToggle
