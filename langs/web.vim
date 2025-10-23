" ---------------------------
" Web Development (JavaScript/TypeScript/HTML/CSS)
" ---------------------------

" Prettier helper using CocAction
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.html,*.css,*.json,*.md,*.yaml,*.yml Prettier

" Filetype specific settings
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2

" React/JSX specific
autocmd FileType javascriptreact setlocal shiftwidth=2 tabstop=2
autocmd FileType typescriptreact setlocal shiftwidth=2 tabstop=2

" Prettier config
let g:prettier#exec_cmd_path = "npx --no-install prettier"
let g:prettier#config#print_width = 80
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#bracket_same_line = 'false'

" Markdown configuration
let g:markdown_fenced_languages = ['javascript', 'typescript', 'php', 'python', 'go', 'c', 'cpp', 'bash', 'html', 'css']
