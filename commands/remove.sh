vcfg_cmd_remove() {
  local plugin=$1

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to remove"
    echo "Usage: vcfg remove <plugin-name>"
    return 1
  fi

  local plugin_manager=$(detect_plugin_manager)
  local config_file=$(get_plugin_config_file "$plugin_manager")

  if [ -z "$config_file" ] || [ ! -f "$config_file" ]; then
    print_error "No plugin manager configuration found"
    return 1
  fi

  # Create backup sebelum modifikasi
  local backup_file="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$config_file" "$backup_file"
  print_info "Backup created: $backup_file"

  if ! plugin_exists "$plugin" "$config_file"; then
    print_error "Plugin '${plugin}' not found in configuration"
    return 1
  fi

  print_warning "Removing plugin: ${CYAN}${plugin}${NC} from ${plugin_manager}"

  # Remove plugin
  case "$plugin_manager" in
    "vim-plug")
      remove_from_vimplug "$plugin" "$config_file"
      ;;
    "packer.nvim")
      remove_from_packer "$plugin" "$config_file"
      ;;
    "lazy.nvim")
      remove_from_lazy "$plugin" "$config_file"
      ;;
    *)
      print_error "Unsupported plugin manager: $plugin_manager"
      return 1
      ;;
  esac

  # Verify removal
  if plugin_exists "$plugin" "$config_file"; then
    print_error "Failed to remove plugin '${plugin}'"
    print_info "Restoring from backup..."
    cp "$backup_file" "$config_file"
    return 1
  fi

  # Clean unused plugins
  clean_plugins "$plugin_manager"

  # Remove backup if successful
  rm -f "$backup_file"

  print_success "Plugin '${GREEN}${plugin}${NC}' removed successfully!"
}

remove_from_vimplug() {
  local plugin=$1
  local config_file=$2
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')

  # Remove plugin line dan juga commented version jika ada
  sed -i "/\" Plug.*${plugin_escaped}/d; /Plug.*${plugin_escaped}/d" "$config_file"
}

remove_from_packer() {
  local plugin=$1
  local config_file=$2
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')

  # Remove use statement untuk plugin
  sed -i "/use.*${plugin_escaped}/d" "$config_file"

  # Clean up empty lines dan formatting
  sed -i '/^[[:space:]]*$/d' "$config_file"
}

remove_from_lazy() {
  local plugin=$1
  local config_file=$2
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')

  # Remove plugin entry
  sed -i "/{.*${plugin_escaped}.*}/d" "$config_file"

  # Clean up formatting
  sed -i '/^[[:space:]]*$/d' "$config_file"
  sed -i 's/,\s*$//' "$config_file"
}
