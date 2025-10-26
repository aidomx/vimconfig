#!/usr/bin/env bash

vcfg_cmd_enable() {
  local plugin=$1
  
  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to enable"
    echo "Usage: vcfg enable <plugin-name>"
    exit 1
  fi
  
  check_vim_config
  
  # Escape forward slashes untuk sed
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')
  
  # Check if plugin exists and is commented
  if ! grep -q "^\".*Plug.*${plugin}" "$PLUGINS_FILE" 2> /dev/null; then
    if grep -q "^Plug.*${plugin}" "$PLUGINS_FILE" 2> /dev/null; then
      print_warning "Plugin '${plugin}' is already enabled"
      exit 0
    else
      print_error "Plugin '${plugin}' not found in configuration"
      exit 1
    fi
  fi
  
  print_info "Enabling plugin: ${CYAN}${plugin}${NC}"
  
  # Uncomment the plugin line - gunakan delimiter yang berbeda (#)
  sed -i "s#^\" \\(Plug.*${plugin_escaped}\\)#\\1#" "$PLUGINS_FILE"
  
  print_success "Plugin '${GREEN}${plugin}${NC}' enabled successfully!"
  
  # Install if not already installed
  print_info "Installing plugin if needed..."
  vim -c 'PlugInstall' -c 'qa!' > /dev/null 2>&1 &
  local vim_pid=$!
  
  spinner $vim_pid
  wait $vim_pid
  
  print_info "Restart Vim to use the plugin"
}
