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

connection_test() {
  local url=$1

  if ping -q -c 1 -W 10 "$url" > /dev/null 2>&1; then

    if command -v curl > /dev/null 2>&1; then
      local response
      if response=$(curl -s --connect-timeout 10 --max-time 15 "$url" 2> /dev/null); then
        echo "$response"
        return 0
      fi
    fi

    if command -v wget > /dev/null 2>&1; then
      local response
      if response=$(wget -q -O - --timeout=10 "$url" 2> /dev/null); then
        echo "$response"
        return 0
      fi
    fi

    local domain
    if [[ "$url" =~ https?://([^/]+) ]]; then
      domain="${BASH_REMATCH[1]}"
      if ping -c 1 -W 5 "$domain" > /dev/null 2>&1; then
        echo "connected"
        return 0
      fi
    fi

    if [[ "$url" =~ https?://([^:/]+)(:([0-9]+))? ]]; then
      local host="${BASH_REMATCH[1]}"
      local port="${BASH_REMATCH[3]}"

      if [[ "$url" == https://* ]]; then
        port="${port:-443}"
      else
        port="${port:-80}"
      fi

      if timeout 5 bash -c "echo > /dev/tcp/$host/$port" 2> /dev/null; then
        echo "connected"
        return 0
      fi
    fi

    return 1
  fi
  return 1
}

check_internet_connection() {
  local url=${1:-"github.com"}

  (connection_test "$url" > /dev/null 2>&1) &
  local CHECK_PID=$!
  progress "dots" $CHECK_PID " - Checking internet connection"
  wait $CHECK_PID || {
    echo ""
    print_error "No internet connection, please check your internet, and try again!"
    return 1
  }
  return 0
}
