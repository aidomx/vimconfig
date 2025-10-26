" ---------------------------
" Basic Completion Configuration
" ---------------------------

" Copilot settings (jika masih digunakan)
let g:copilot_no_tab_map = v:true
let g:copilot_enabled = v:false

" ---------------------------
" Built-in Vim Completion
" ---------------------------

" Tab to navigate completion menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Enter to confirm completion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Ctrl+Space untuk trigger completion (fallback ke built-in)
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

" ---------------------------
" Basic LSP/Linting (jika pakai ALE)
" ---------------------------

function! ALEGetStatusLine() abort
  if exists('*ale#statusline#Count')
    let l:count = ale#statusline#Count(bufnr('%'))
    if l:count > 0
      return '⚠️ ' . l:count
    endif
  endif
  return ''
endfunction

" ---------------------------
" Navigation & Definitions
" ---------------------------

" Basic tag navigation (butuh ctags)
nmap <silent> gd <C-]>
nmap <silent> gy :tjump <C-r><C-w><CR>
nmap <silent> gr :tags<CR>

" Grep-based references
nmap <silent> gi :grep! "\b<C-r><C-w>\b"<CR>:copen<CR>

" Format with built-in formatters atau external tools
nmap <leader>f gg=G
xmap <leader>f =

" ---------------------------
" Status Line
" ---------------------------

set statusline=%<%f\ %h%m%r%{ALEGetStatusLine()}%=%-14.(%l,%c%V%)\ %P
set laststatus=2

" ---------------------------
" Auto-close preview window
" ---------------------------

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
