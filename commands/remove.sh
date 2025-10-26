#!/usr/bin/env bash

vcfg_cmd_remove() {
  local plugin=$1
  
  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to remove"
    echo "Usage: vcfg remove <plugin-name>"
    exit 1
  fi
  
  check_vim_config
  
  # Search for plugin line
  local plugin_line=$(grep -n "Plug.*${plugin}" "$PLUGINS_FILE" | head -n 1)
  
  if [ -z "$plugin_line" ]; then
    print_error "Plugin '${plugin}' not found in configuration"
    exit 1
  fi
  
  print_warning "Removing plugin: ${CYAN}${plugin}${NC}"
  
  # Escape forward slashes untuk sed
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')
  
  # Remove from plugins.vim
  sed -i "/Plug.*${plugin_escaped}/d" "$PLUGINS_FILE"
  
  print_success "Plugin removed from configuration"
  
  # Clean unused plugins
  print_info "Cleaning unused plugins..."
  vim -c 'PlugClean[!]' -c 'qa!' > /dev/null 2>&1 &
  local vim_pid=$!
  spinner $vim_pid
  wait $vim_pid
  
  print_success "Plugin '${GREEN}${plugin}${NC}' removed successfully!"
}
