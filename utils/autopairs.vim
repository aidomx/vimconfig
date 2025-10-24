" ============================================
" Auto-pairs Configuration
" File: utils/autopairs.vim or add to init.vim
" ============================================

" Option 1: Disable auto-pairing for quotes completely
let g:AutoPairsShortcutToggle = '<leader>ap'
let g:AutoPairs = {'(':')', '[':']', '{':'}'}

" Option 2: Disable only double quotes
" let g:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'"}

" Option 3: Disable only single quotes
" let g:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"'}

" Option 4: Smart pairing - only pair when typing opening quote
" This allows you to type closing quote without auto-pairing
let g:AutoPairsMapCR = 1
let g:AutoPairsMapSpace = 1

" Option 5: Disable auto-pairs for specific filetypes
augroup DisableAutoPairsForFileTypes
    autocmd!
    autocmd FileType vim,sh,bash let b:AutoPairs = {'(':')', '[':']', '{':'}'}
augroup END

" Quick toggle mapping
" Press <leader>ap to toggle auto-pairs on/off
nnoremap <leader>ap :call AutoPairsToggle()<CR>

" Custom function to selectively disable quotes
function! SmartQuotes()
    " Check if there's text after cursor
    let line = getline('.')
    let col = col('.')
    let after = strpart(line, col - 1)
    
    " If there's already text after cursor, don't auto-pair
    if after =~ '^\S'
        return '"'
    else
        return '""' . "\<Left>"
    endif
endfunction

" Uncomment to use smart quotes function
" inoremap <expr> " SmartQuotes()

" Comment for disable or go to core/plugins.vim
" and uncomment this:
" Plug 'Raimondi/delimitMate'
"
" After comment, run with :PlugInstall
let delimitMate_autoclose = 1
let delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_quotes = ""  " Disable quote pairing
