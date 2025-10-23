" ---------------------------
" Universal Formatting Configuration
" ---------------------------

function! FormatFile()
  let l:filetype = &filetype
  let l:filename = expand('%')

  " Prettier supported filetypes
  if index(['javascript', 'typescript', 'javascriptreact', 'typescriptreact', 
           \'html', 'css', 'json', 'markdown', 'yaml', 'yml'], l:filetype) >= 0
    call CocAction('runCommand', 'prettier.formatFile')
  
  " Shell scripts menggunakan shfmt
  elseif index(['sh', 'bash'], l:filetype) >= 0
    if executable('shfmt')
      execute 'Neoformat'
    else
      echo "shfmt not installed. Run: pkg install shfmt"
    endif
  
  " Python menggunakan black atau autopep8
  elseif l:filetype == 'python'
    if executable('black')
      execute '%!black -q -'
    elseif executable('autopep8')
      execute '%!autopep8 -'
    endif
  
  " Go menggunakan gofmt
  elseif l:filetype == 'go'
    if executable('gofmt')
      execute '%!gofmt'
    endif
  
  " C/C++ menggunakan clang-format
  elseif index(['c', 'cpp'], l:filetype) >= 0
    if executable('clang-format')
      execute '%!clang-format -style=file'
    endif
  
  " PHP menggunakan php-cs-fixer
  elseif l:filetype == 'php'
    if executable('php-cs-fixer')
      execute '!php-cs-fixer fix %'
    endif
  endif
endfunction

" Auto format on save untuk semua filetypes yang didukung
autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.html,*.css,*.json,*.md,*.yaml,*.yml,*.sh,*.bash,*.py,*.go,*.c,*.cpp,*.h,*.php call FormatFile()

" Manual formatting command
command! -nargs=0 Format call FormatFile()
nnoremap <leader>fmt :Format<CR>
