#!/usr/bin/env bash

detect_plugin_manager() {
  if [ -f "${HOME}/.vim/autoload/plug.vim" ] || [ -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    echo "vim-plug"
  elif [ -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    echo "packer.nvim"
  elif [ -d "${HOME}/.local/share/nvim/lazy/lazy.nvim" ]; then
    echo "lazy.nvim"
  else
    echo "unknown"
  fi
}

get_plugin_config_file() {
  local manager=$1
  case "$manager" in
    "vim-plug")
      echo "$VCFG_PLUGINS_FILE"
      ;;
    "packer.nvim")
      echo "${HOME}/.config/nvim/lua/plugins.lua"
      ;;
    "lazy.nvim")
      echo "${HOME}/.config/nvim/lazy.lua"
      ;;
    *)
      echo ""
      ;;
  esac
}

get_plugin_manager_name() {
  local manager=$1
  case "$manager" in
    "vim-plug") echo "vim-plug" ;;
    "packer.nvim") echo "packer.nvim" ;;
    "lazy.nvim") echo "lazy.nvim" ;;
    *) echo "unknown" ;;
  esac
}
