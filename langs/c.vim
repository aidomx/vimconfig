" ---------------------------
" C/C++ Development
" ---------------------------

" C/C++ compiler and debug shortcuts
nnoremap <buffer> <leader>cc :!gcc -Wall -g % -o %:r<CR>
nnoremap <buffer> <leader>cr :!./%:r<CR>
nnoremap <buffer> <leader>cpp :!g++ -std=c++17 -Wall -g % -o %:r<CR>
nnoremap <buffer> <leader>cpr :!./%:r<CR>

" C/C++ syntax enhancements
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

" ALE for C/C++ linting
let g:ale_linters = {
\   'c': ['gcc', 'clangd'],
\   'cpp': ['gcc', 'clangd'],
\}
let g:ale_fixers = {
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\}
let g:ale_c_clangformat_options = '-style=file'
let g:ale_cpp_clangformat_options = '-style=file'

" Auto format on save for C/C++
autocmd BufWritePre *.c,*.cpp,*.h,*.hpp :ALEFix

" Filetype specific settings
autocmd FileType c setlocal commentstring=//\ %s foldmethod=syntax
autocmd FileType cpp setlocal commentstring=//\ %s foldmethod=syntax
autocmd FileType c setlocal shiftwidth=2 tabstop=2
autocmd FileType cpp setlocal shiftwidth=2 tabstop=2
