#!/usr/bin/env bash

vcfg_cmd_disable() {
  local plugin=$1

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to disable"
    echo "Usage: vcfg disable <plugin-name>"
    exit 1
  fi
  check_vim_config | return 1

  # Check if plugin exists and is not already commented
  if ! grep -q "^Plug.*${plugin}" "$PLUGINS_FILE" 2> /dev/null; then
    if grep -q "^\".*Plug.*${plugin}" "$PLUGINS_FILE" 2> /dev/null; then
      print_warning "Plugin '${plugin}' is already disabled"
      exit 0
    else print_error "Plugin '${plugin}' not found in configuration"
      exit 1
    fi
  fi
  
  print_info "Disabling plugin: ${CYAN}${plugin}${NC}"
  
  # Escape forward slashes untuk sed
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')
  # Comment out the plugin line
  sed -i "s/^Plug.*${plugin_escaped}/\" &/" "$PLUGINS_FILE"

  print_success "Plugin '${GREEN}${plugin}${NC}' disabled successfully!"
  print_info "Restart Vim to apply changes"
}
