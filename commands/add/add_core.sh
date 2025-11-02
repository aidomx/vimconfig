#!/usr/bin/env bash

add_plugin_to_config() {
  local plugin=$1
  local plugin_type=$2
  local plugin_manager=$3
  local config_file=$4

  local plugin_line=$(format_plugin_for_manager "$plugin" "$plugin_type" "$plugin_manager")

  case "$plugin_manager" in
    "vim-plug")
      add_to_vimplug "$plugin_line" "$config_file"
      ;;
    "packer.nvim")
      add_to_packer "$plugin_line" "$config_file"
      ;;
    "lazy.nvim")
      add_to_lazy "$plugin_line" "$config_file"
      ;;
    *)
      print_error "Unsupported plugin manager: $plugin_manager"
      return 1
      ;;
  esac
}

show_plugin_info() {
  local plugin=$1
  local plugin_type=$2
  local plugin_manager=$3

  local display_name=$(get_plugin_display_name "$plugin" "$plugin_type")

  print_info "Adding plugin:"
  echo -e "  ${CYAN}Source:${NC} $plugin"
  echo -e "  ${CYAN}Type:${NC} $plugin_type"
  echo -e "  ${CYAN}Manager:${NC} $plugin_manager"
  echo -e "  ${CYAN}Display:${NC} $display_name"
  echo ""
}
