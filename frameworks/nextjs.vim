" ---------------------------
" Next.js Framework
" ---------------------------

" Next.js development server
command! NextDev execute '!npm run dev'
command! NextBuild execute '!npm run build'
command! NextStart execute '!npm start'

" Next.js specific mappings
nnoremap <leader>nd :NextDev<CR>
nnoremap <leader>nb :NextBuild<CR>
nnoremap <leader>ns :NextStart<CR>

" Next.js file recognition
autocmd BufRead,BufNewFile *.page.tsx,*.page.jsx,*.layout.tsx,*.layout.jsx set filetype=typescriptreact
