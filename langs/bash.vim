" ---------------------------
" Bash/Shell Script Development
" ---------------------------

" Shell script specific settings
autocmd FileType sh,bash setlocal shiftwidth=2 tabstop=2
autocmd FileType sh,bash setlocal commentstring=#\ %s
autocmd FileType sh,bash setlocal foldmethod=marker

" Shell script execution shortcuts
nnoremap <buffer> <leader>bx :!chmod +x % && ./%<CR>
nnoremap <buffer> <leader>br :!./%<CR>
nnoremap <buffer> <leader>bc :!bash -n %<CR>  " Syntax check

" Format shell scripts with shfmt (install dengan: pkg install shfmt)
let g:neoformat_enabled_bash = ['shfmt']
let g:neoformat_enabled_sh = ['shfmt']

" shfmt configuration
let g:neoformat_bash_shfmt = {
    \ 'exe': 'shfmt',
    \ 'args': ['-i', '2', '-bn', '-ci', '-sr'],
    \ 'stdin': 1,
    \ }

let g:neoformat_sh_shfmt = {
    \ 'exe': 'shfmt',
    \ 'args': ['-i', '2', '-bn', '-ci', '-sr'],
    \ 'stdin': 1,
    \ }

" Auto format shell scripts on save
autocmd BufWritePre *.sh,*.bash Neoformat

" ShellCheck integration (install dengan: pkg install shellcheck)
let g:ale_linters = get(g:, 'ale_linters', {})
let g:ale_linters['sh'] = ['shellcheck']
let g:ale_linters['bash'] = ['shellcheck']

" ALE configuration for shell scripts
let g:ale_sh_shellcheck_options = '-x'
