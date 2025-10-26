" ---------------------------
" Environment Detection
" ---------------------------
let g:is_vim = !has('nvim')
let g:is_neovim = has('nvim')
let g:is_termux = !empty($PREFIX) && $PREFIX =~# 'termux'

" ---------------------------
" Plugin Manager
" ---------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ---------------------------
" Main Configuration
" ---------------------------
if g:is_neovim
  set runtimepath^=~/.vim,~/.vim/after,~/.local/vim
  set packpath^=~/.vim
else
  " Set runtime path to include local vim config
  set runtimepath^=~/.local/vim
endif

" Load plugins declarations
source ~/.local/vim/core/plugins.vim

" Load core configurations
runtime! core/settings.vim
runtime! core/fonts.vim
runtime! utils/ui.vim

" Load environment-specific configurations
if g:is_termux
  runtime! utils/termux.vim
endif

" Load language configurations
runtime! langs/android.vim
runtime! langs/web-basic.vim
runtime! langs/bash.vim
runtime! langs/c.vim
runtime! langs/php.vim
runtime! langs/python.vim
runtime! langs/go.vim

" Load framework configurations
runtime! frameworks/laravel.vim
runtime! frameworks/nextjs.vim

" Load completion and mappings last
runtime! utils/autopairs.vim
runtime! utils/basic-completion.vim
runtime! core/mappings.vim

" Load Neovim specific config TERAKHIR
if g:is_neovim
  runtime! core/nvim.vim
endif
