" ---------------------------
" Web Development (JavaScript/TypeScript/HTML/CSS)
" ---------------------------

" Neoformat auto-formatting
autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.html,*.css,*.json,*.md,*.yaml,*.yml Neoformat

" Filetype specific settings
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

" React/JSX specific
autocmd FileType javascriptreact setlocal shiftwidth=2 tabstop=2
autocmd FileType typescriptreact setlocal shiftwidth=2 tabstop=2

" Neoformat configuration
let g:neoformat_try_formatprg = 1
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_javascriptreact = ['prettier']
let g:neoformat_enabled_typescriptreact = ['prettier']
let g:neoformat_enabled_html = ['prettier']
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_enabled_json = ['prettier']
let g:neoformat_enabled_markdown = ['prettier']
let g:neoformat_enabled_yaml = ['prettier']

" Prettier config for Neoformat
let g:neoformat_javascript_prettier = {
    \ 'exe': 'npx',
    \ 'args': ['--no-install', 'prettier', '--stdin-filepath', '"%:p"', '--print-width', '80', '--jsx-bracket-same-line', 'false'],
    \ 'stdin': 1,
    \ }

let g:neoformat_typescript_prettier = {
    \ 'exe': 'npx', 
    \ 'args': ['--no-install', 'prettier', '--stdin-filepath', '"%:p"', '--print-width', '80', '--jsx-bracket-same-line', 'false', '--parser', 'typescript'],
    \ 'stdin': 1,
    \ }

" Manual Prettier command (backup)
command! -nargs=0 Prettier :Neoformat

" Manual formatting shortcut
nnoremap <leader>p :Neoformat<CR>
vnoremap <leader>p :Neoformat<CR>

" Markdown configuration
let g:markdown_fenced_languages = ['javascript', 'typescript', 'php', 'python', 'go', 'c', 'cpp', 'bash', 'html', 'css']

" ---------------------------
" Performance Optimizations for JS/TS
" ---------------------------
autocmd FileType javascript,typescript,javascriptreact,typescriptreact
    \ setlocal synmaxcol=200 |
    \ setlocal foldmethod=manual
