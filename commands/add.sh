#!/usr/bin/env bash

vcfg_cmd_add() {
  local plugin=$1
  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to add"
    echo "Usage: vcfg add <username/repository>"
    return 1
  fi

  # Auto-detect plugin manager and config file
  local plugin_manager=$(detect_plugin_manager)
  local config_file=$(get_plugin_config_file "$plugin_manager")

  if [ -z "$config_file" ] || [ ! -f "$config_file" ]; then
    print_error "No plugin manager configuration found"
    return 1
  fi

  # Check if plugin exists
  if plugin_exists "$plugin" "$config_file"; then
    print_warning "Plugin '${plugin}' already exists in configuration"
    return 0
  fi

  print_info "Adding plugin '${CYAN}${plugin}${NC}' to ${plugin_manager}"

  # Add plugin based on manager
  case "$plugin_manager" in
    "vim-plug")
      add_to_vimplug "$plugin" "$config_file"
      ;;
    "packer.nvim")
      add_to_packer "$plugin" "$config_file"
      ;;
    "lazy.nvim")
      add_to_lazy "$plugin" "$config_file"
      ;;
    *)
      print_error "Unsupported plugin manager: $plugin_manager"
      return 1
      ;;
  esac

  # Install the plugin
  install_with_manager "$plugin" "$plugin_manager"
}

add_to_vimplug() {
  local plugin=$1
  local config_file=$2
  sed -i "/call plug#end()/i Plug '${plugin}'" "$config_file" || {
    print_error "Failed to modify $config_file"
    return 1
  }
  print_success "Plugin added to vim-plug configuration"
}

add_to_packer() {
  local plugin=$1
  local config_file=$2
  sed -i "/end)/i \ \ use '${plugin}'" "$config_file" || {
    print_error "Failed to modify packer config"
    return 1
  }
  print_success "Plugin added to packer.nvim configuration"
}

add_to_lazy() {
  local plugin=$1
  local config_file=$2
  sed -i "/^}$/i \ \ { \"${plugin}\" }," "$config_file" || {
    print_error "Failed to modify lazy config"
    return 1
  }
  print_success "Plugin added to lazy.nvim configuration"
}
