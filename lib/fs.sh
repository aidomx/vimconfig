#!/usr/bin/env bash

VIM_CONFIG_DIR="${HOME}/.config/vim"
PLUGINS_FILE="${VIM_CONFIG_DIR}/core/plugins.vim"
VIM_PLUGINS_DIR="${HOME}/.vim/plugged"

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
