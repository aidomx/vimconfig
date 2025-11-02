#!/usr/bin/env bash

# Load add modules
for add_file in "${VCFG_ROOT}/commands/add"/*.sh; do
  source "$add_file"
done

vcfg_cmd_add() {
  local plugin=$1
  local option=${2:-}

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to add"
    echo "Usage: vcfg add <plugin> [--local]"
    echo ""
    echo "Examples:"
    echo "  vcfg add tpope/vim-fugitive           # GitHub shorthand"
    echo "  vcfg add https://github.com/user/repo.git  # Full Git URL"
    echo "  vcfg add ~/projects/my-plugin --local # Local plugin"
    return 1
  fi

  # Auto-detect plugin manager and config file
  local plugin_manager=$(detect_plugin_manager)
  local config_file=$(get_plugin_config_file "$plugin_manager")

  if [ -z "$config_file" ] || [ ! -f "$config_file" ]; then
    print_error "No plugin manager configuration found"
    return 1
  fi

  # Detect plugin type
  local plugin_type=$(detect_plugin_type "$plugin" "$option")
  local normalized_plugin=$(normalize_plugin_name "$plugin" "$plugin_type")

  # Validate plugin source
  if ! validate_plugin_source "$normalized_plugin" "$plugin_type"; then
    return 1
  fi

  # Check if plugin exists
  if plugin_exists "$normalized_plugin" "$config_file"; then
    print_warning "Plugin already exists in configuration"
    return 0
  fi

  show_plugin_info "$normalized_plugin" "$plugin_type" "$plugin_manager"

  # Add plugin to config with progress
  (add_plugin_to_config "$normalized_plugin" "$plugin_type" "$plugin_manager" "$config_file") > /dev/null 2>&1 &
  local pid=$!
  show_percentage_progress $pid "Adding plugin to configuration"
  wait $pid

  if [ $? -eq 0 ]; then
    # Install the plugin
    # print_info "Installing plugin..."
    install_with_manager "$normalized_plugin" "$plugin_manager"

    print_success "Plugin added successfully!"
    echo ""
    echo -e "Run ${CYAN}vcfg list${NC} to see all plugins"
  else
    print_error "Failed to add plugin"
    return 1
  fi
}
