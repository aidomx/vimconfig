#!/usr/bin/env bash

add_to_vimplug() {
  local plugin_line=$1
  local config_file=$2

  # Escape slashes for sed
  local escaped_plugin=$(printf '%s\n' "$plugin_line" | sed 's/[[\.*^$()+?{|]/\\&/g')

  if sed -i "/^call plug#end()/i ${escaped_plugin}" "$config_file" 2> /dev/null; then
    print_success "Plugin added to vim-plug configuration"
    return 0
  else
    print_error "Failed to modify vim-plug configuration"
    return 1
  fi
}

add_to_packer() {
  local plugin_line=$1
  local config_file=$2

  local escaped_plugin=$(printf '%s\n' "$plugin_line" | sed 's/[[\.*^$()+?{|]/\\&/g')

  if sed -i "/^end)/i \ \ ${escaped_plugin}" "$config_file" 2> /dev/null; then
    print_success "Plugin added to packer.nvim configuration"
    return 0
  else
    print_error "Failed to modify packer.nvim configuration"
    return 1
  fi
}

add_to_lazy() {
  local plugin_line=$1
  local config_file=$2

  local escaped_plugin=$(printf '%s\n' "$plugin_line" | sed 's/[[\.*^$()+?{|]/\\&/g')

  if sed -i "/^}$/i \ \ ${escaped_plugin}," "$config_file" 2> /dev/null; then
    print_success "Plugin added to lazy.nvim configuration"
    return 0
  else
    print_error "Failed to modify lazy.nvim configuration"
    return 1
  fi
}

format_plugin_for_manager() {
  local plugin=$1
  local plugin_type=$2
  local plugin_manager=$3

  case "$plugin_type" in
    "github")
      format_github_plugin "$plugin" "$plugin_manager"
      ;;
    "git")
      format_git_plugin "$plugin" "$plugin_manager"
      ;;
    "local")
      format_local_plugin "$plugin" "$plugin_manager"
      ;;
    *)
      format_github_plugin "$plugin" "$plugin_manager"
      ;;
  esac
}
