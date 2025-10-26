" ---------------------------
" Web Development - Dengan Formatting Otomatis
" ---------------------------

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

" ---------------------------
" Auto-Formatting dengan ALE
" ---------------------------

" Aktifkan fixer otomatis
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'javascriptreact': ['prettier'],
\   'typescriptreact': ['prettier'],
\   'html': ['prettier'],
\   'css': ['prettier'],
\   'json': ['prettier'],
\   'markdown': ['prettier'],
\   'yaml': ['prettier']
\}

" Hanya gunakan Prettier (bukan ESLint untuk formatting)
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_typescript_prettier_use_local_config = 1

" Auto-fix on save
let g:ale_fix_on_save = 1

" Prettier configuration
let g:ale_javascript_prettier_options = '--print-width 80 --jsx-bracket-same-line false --bracket-same-line false'
let g:ale_typescript_prettier_options = '--print-width 80 --jsx-bracket-same-line false --bracket-same-line false'

" ---------------------------
" ATAU: Auto-Formatting dengan Neoformat
" ---------------------------

" Uncomment jika prefer Neoformat
" let g:neoformat_enabled_javascript = ['prettier']
" let g:neoformat_enabled_typescript = ['prettier']
" let g:neoformat_enabled_html = ['prettier']
" let g:neoformat_enabled_css = ['prettier']
" 
" autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.html,*.css,*.json,*.md,*.yaml,*.yml Neoformat

" ---------------------------
" Manual Formatting Commands (backup)
" ---------------------------

" Manual Prettier command
command! -nargs=0 Prettier :ALEFix
" ATAU: command! -nargs=0 Prettier :Neoformat

" Shortcut manual
nnoremap <leader>p :ALEFix<CR>
" ATAU: nnoremap <leader>p :Neoformat<CR>

" ---------------------------
" Language-specific configurations
" ---------------------------

" JavaScript/TypeScript
let g:javascript_plugin_jsdoc = 1
let g:typescript_indent_disable = 1

" HTML
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" Markdown
let g:markdown_fenced_languages = ['javascript', 'typescript', 'php', 'python', 'go', 'c', 'cpp', 'bash', 'html', 'css']

" ---------------------------
" Development Helpers
" ---------------------------

" Open in browser
nnoremap <leader>bb :!xdg-open %<CR><CR>

" JavaScript console log
nnoremap <leader>cl console.log('<C-r><C-w>:', <C-r><C-w>);<Esc>
inoremap <leader>cl console.log();<Left><Left>
