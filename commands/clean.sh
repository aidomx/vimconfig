#!/usr/bin/env bash

vcfg_cmd_clean() {
  local plugin_manager=$(detect_plugin_manager)

  print_header "Cleaning Unused Plugins"

  case "$plugin_manager" in
    "vim-plug")
      clean_vimplug_plugins
      ;;
    "packer.nvim")
      clean_packer_plugins
      ;;
    "lazy.nvim")
      clean_lazy_plugins
      ;;
    *)
      print_error "Unsupported plugin manager: $plugin_manager"
      return 1
      ;;
  esac
}

clean_vimplug_plugins() {
  check_vim_config
  print_info "Removing unused plugins..."

  vim -c 'PlugClean!' -c 'qa!' > /dev/null 2>&1 &
  local vim_pid=$!
  spinner $vim_pid "Cleaning vim-plug plugins"
  wait $vim_pid

  print_success "Cleanup completed!"
}

clean_packer_plugins() {
  print_info "Cleaning unused plugins via packer.nvim..."

  nvim --headless -c 'PackerClean' -c 'qa!' > /dev/null 2>&1 &
  local pid=$!
  spinner "$pid" "Cleaning packer.nvim plugins"
  wait "$pid" 2> /dev/null || true

  print_success "Packer cleanup completed!"
}

clean_lazy_plugins() {
  print_info "Cleaning unused plugins via lazy.nvim..."

  nvim --headless -c 'Lazy clean' -c 'qa!' > /dev/null 2>&1 &
  local pid=$!
  spinner "$pid" "Cleaning lazy.nvim plugins"
  wait "$pid" 2> /dev/null || true

  print_success "Lazy cleanup completed!"
}

cleanup_plugins() {
  if [[ $IS_REMOTE -eq 0 ]]; then
    # Hanya tanya konfirmasi jika bukan remote execution
    read -p "Clean existing plugins for fresh installation? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      print_info "Skipping plugin cleanup"
      return
    fi
  fi

  print_info "Cleaning up existing plugins for fresh installation..."

  # Clean vim-plug
  if [ -d "${HOME}/.vim/plugged" ]; then
    rm -rf "${HOME}/.vim/plugged"
    print_success "Cleaned vim-plug plugins"
  fi

  # Clean packer.nvim
  if [ -d "${HOME}/.local/share/nvim/site/pack/packer" ]; then
    rm -rf "${HOME}/.local/share/nvim/site/pack/packer"
    print_success "Cleaned packer.nvim plugins"
  fi

  # Clean lazy.nvim
  if [ -d "${HOME}/.local/share/nvim/lazy" ]; then
    rm -rf "${HOME}/.local/share/nvim/lazy"
    print_success "Cleaned lazy.nvim plugins"
  fi

  # Clean coc.nvim cache
  if [ -d "${HOME}/.config/coc" ]; then
    rm -rf "${HOME}/.config/coc"
    print_success "Cleaned coc.nvim cache"
  fi

  echo ""
}
