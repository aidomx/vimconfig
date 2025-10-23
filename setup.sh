#!/bin/bash
echo "Setting up modular Vim configuration..."

# Create symlink from .vimrc to modular config
ln -sf ~/.local/vim/init.vim ~/.vimrc

# Install vim-plug if not exists
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  echo "Installing vim-plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "Setup complete! Open Vim and run :PlugInstall"
