" ---------------------------
" Completion Configuration
" ---------------------------

" Copilot settings (must be before plugins load)
let g:copilot_no_tab_map = v:true
let g:copilot_enabled = v:false

" helper: check backspace
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! ALEGetStatusLine() abort
  if exists('*ale#statusline#Count')
    let l:count = ale#statusline#Count(bufnr('%'))
    if l:count > 0
      return '⚠️ ' . l:count
    endif
  endif
  return ''
endfunction

" Tab: navigate completion items
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Ctrl+P untuk navigate backward (ganti Shift-Tab)
inoremap <silent><expr> <C-P>
      \ coc#pum#visible() ? coc#pum#prev(1) :
      \ "\<C-h>"

" Enter untuk confirm completion
inoremap <silent><expr> <CR>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ "\<CR>"

" Ctrl+Space untuk trigger completion
inoremap <silent><expr> <C-Space> coc#refresh()

" Coc configuration
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Coc highlights
highlight! link CocErrorSign DiagnosticError
highlight! link CocWarningSign DiagnosticWarn
highlight! link CocInfoSign DiagnosticInfo
highlight! link CocHintSign DiagnosticHint

" Auto-close preview window when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Status line enhancements
set statusline=%<%f\ %h%m%r%{coc#status()}%{get(b:,'coc_current_function','')}%#ErrorMsg#%{ALEGetStatusLine()}%*%=%-14.(%l,%c%V%)\ %P
set laststatus=2
