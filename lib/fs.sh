#!/usr/bin/env bash

# Load paths first to ensure consistency
if [ -f "$(dirname "${BASH_SOURCE[0]}")/paths.sh" ]; then
  source "$(dirname "${BASH_SOURCE[0]}")/paths.sh"
fi

# Editor configuration
EDITOR=vim

# These will be set by paths.sh, but provide defaults for backward compatibility
: ${VIM_CONFIG_DIR:="${HOME}/.config/vim"}
: ${PLUGINS_FILE:="${VIM_CONFIG_DIR}/core/plugins.vim"}
: ${VIM_PLUGINS_DIR:="${HOME}/.vim/plugged"}

# Other configuration (unchanged)
REPO_URL="https://github.com/aidomx/vimconfig.git"
INSTALL_DIR="${VIM_CONFIG_DIR}"
VIMRC_PATH="${HOME}/.vimrc"
VCFG_BIN="/usr/bin/vcfg"
TERMUX_VERSION="0.119.0-beta.3"

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

check_text_editor() {
  if command -v vim &> /dev/null; then
    echo "vim"
    return 0
  elif command -v nvim &> /dev/null; then
    echo "nvim"
    return 0
  else
    print_error "No text editor found (Vim or Neovim)"
    return 1
  fi
}

get_editor_installed() {
  local editor=$(check_text_editor)
  if [ $? -ne 0 ]; then
    return 1
  fi
  echo "$editor"
}
