#!/usr/bin/env bash

vcfg_cmd_add() {
  local plugin=$1
  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to add"
    echo "Usage: vcfg add <username/repository>"
    return 1
  fi

  check_vim_config || return 1

  if grep -q "Plug '${plugin}'" "$PLUGINS_FILE" 2>/dev/null; then
    print_warning "Plugin '${plugin}' is already in the configuration"
    return 0
  fi

  print_info "Adding plugin: ${plugin}"
  # Insert before call plug#end()
  sed -i "/call plug#end()/i Plug '${plugin}'" "$PLUGINS_FILE" || {
    print_error "Failed to modify $PLUGINS_FILE"
    return 1
  }
  print_success "Plugin added to configuration"

  # Install async with spinner
  local pid
  pid=$(run_vim_pluginstall)
  spinner "$pid"
  wait "$pid" 2>/dev/null || true
  print_success "Plugin ${plugin} installed (or installation attempted)"
}
