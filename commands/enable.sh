#!/usr/bin/env bash

vcfg_cmd_enable() {
  local plugin=$1

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to enable"
    echo "Usage: vcfg enable <plugin-name>"
    return 1
  fi

  local plugin_manager=$(detect_plugin_manager)
  local config_file=$(get_plugin_config_file "$plugin_manager")

  if [ -z "$config_file" ] || [ ! -f "$config_file" ]; then
    print_error "No plugin manager configuration found"
    return 1
  fi

  print_info "Enabling plugin: ${CYAN}${plugin}${NC} in ${plugin_manager}"

  # Enable based on plugin manager
  case "$plugin_manager" in
    "vim-plug")
      enable_vimplug_plugin "$plugin" "$config_file"
      ;;
    "packer.nvim")
      enable_packer_plugin "$plugin" "$config_file"
      ;;
    "lazy.nvim")
      enable_lazy_plugin "$plugin" "$config_file"
      ;;
    *)
      print_error "Unsupported plugin manager: $plugin_manager"
      return 1
      ;;
  esac

  # Install/update the plugin
  install_with_manager "$plugin" "$plugin_manager"

  print_info "Restart Vim/Neovim to use the plugin"
}

enable_vimplug_plugin() {
  local plugin=$1
  local config_file=$2
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')

  # Check if plugin is commented out
  if grep -q "^\".*Plug.*${plugin}" "$config_file" 2> /dev/null; then
    # Uncomment the plugin line
    sed -i "s#^\" \\(Plug.*${plugin_escaped}\\)#\\1#" "$config_file"
    print_success "Plugin '${GREEN}${plugin}${NC}' enabled successfully!"
  elif grep -q "^Plug.*${plugin}" "$config_file" 2> /dev/null; then
    print_warning "Plugin '${plugin}' is already enabled"
  else
    print_error "Plugin '${plugin}' not found in configuration"
    return 1
  fi
}

enable_packer_plugin() {
  local plugin=$1
  local config_file=$2
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')

  # Check if plugin is commented out
  if grep -q "--.*use.*${plugin}" "$config_file" 2> /dev/null; then
    # Uncomment the use statement
    sed -i "s/-- \\(use.*${plugin_escaped}\\)/\\1/" "$config_file"
    print_success "Plugin '${GREEN}${plugin}${NC}' enabled successfully!"
  elif grep -q "use.*${plugin}" "$config_file" 2> /dev/null; then
    print_warning "Plugin '${plugin}' is already enabled"
  else
    print_error "Plugin '${plugin}' not found in configuration"
    return 1
  fi
}

enable_lazy_plugin() {
  local plugin=$1
  local config_file=$2
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')

  # Check if plugin is commented out
  if grep -q "--.*{.*${plugin}" "$config_file" 2> /dev/null; then
    # Uncomment the plugin entry
    sed -i "s/-- \\({.*${plugin_escaped}.*}\\)/\\1/" "$config_file"
    print_success "Plugin '${GREEN}${plugin}${NC}' enabled successfully!"
  elif grep -q "{.*${plugin}.*}" "$config_file" 2> /dev/null; then
    print_warning "Plugin '${plugin}' is already enabled"
  else
    print_error "Plugin '${plugin}' not found in configuration"
    return 1
  fi
}
