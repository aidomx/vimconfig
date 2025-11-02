#!/usr/bin/env bash

show_plugin_manager_info() {
  local manager=$1
  local config_file=$2

  echo -e "${WHITE}Plugin Manager:${NC} $(get_plugin_manager_name "$manager")"
  echo -e "${WHITE}Config File:${NC} $config_file"
  echo ""
}

show_plugin_operation() {
  local operation=$1
  local plugin=$2
  local manager=$3

  print_info "$operation plugin: $plugin"
  echo -e "  ${CYAN}Manager:${NC} $manager"
  echo ""
}
