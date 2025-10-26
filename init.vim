" Plugin Manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"  Load plugins declarations
source ~/.local/vim/core/plugins.vim

" Main Vim configuration file for Termux/HP
" Modular structure for full-stack development

" Set runtime path to include local vim config
set runtimepath^=~/.local/vim

" Load modular configuration
runtime! core/plugins.vim
runtime! core/settings.vim
runtime! utils/termux.vim
runtime! utils/ui.vim

" Load language configurations
runtime! langs/web.vim
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
runtime! utils/completion.vim
" runtime! utils/formating.vim
runtime! core/mappings.vim
