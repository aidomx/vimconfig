" ---------------------------
" Neovim Specific Configuration
" ---------------------------

" Neovim exclusive settings
set termguicolors
set mouse=a

" Better terminal integration
tnoremap <Esc> <C-\><C-n>

" Terminal commands
command! Term :split | terminal
command! VTerm :vsplit | terminal

" Native LSP setup (optional)
if filereadable(expand('~/.config/vim/core/nvim-lsp.vim'))
  runtime! core/nvim-lsp.vim
endif

" Performance optimizations for Neovim
set updatetime=300
set redrawtime=10000

" Load Neovim-specific plugins
if !g:is_termux
  " Tree-sitter etc (jika mau)
endif
