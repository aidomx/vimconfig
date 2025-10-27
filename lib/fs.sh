#!/usr/bin/env bash

EDITOR=vim
VIM_CONFIG_DIR="${HOME}/.config/vim"
PLUGINS_FILE="${VIM_CONFIG_DIR}/core/plugins.vim"
VIM_PLUGINS_DIR="${HOME}/.vim/plugged"

# Configuration
REPO_URL="https://github.com/aidomx/vimconfig.git"
INSTALL_DIR="${VIM_CONFIG_DIR}"
VIMRC_PATH="${HOME}/.vimrc"
VCFG_BIN="/usr/bin/vcfg"

check_vim_config() {
  if [ ! -d "$VIM_CONFIG_DIR" ]; then
    print_error "Vim configuration directory not found: $VIM_CONFIG_DIR"
    return 1
  fi
  if [ ! -f "$PLUGINS_FILE" ]; then
    print_error "Plugins file not found: $PLUGINS_FILE"
    return 1
  fi
  return 0
}
