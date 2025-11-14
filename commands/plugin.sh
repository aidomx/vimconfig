#!/usr/bin/env bash

# Load plugin modules
for plugin_file in "${VCFG_ROOT}/commands/plugin"/*.sh; do
  source "$plugin_file"
done

vcfg_cmd_plugin() {
  if [ $# -gt 0 ]; then
    case "$1" in
    list | -l) vcfg_cmd_list ;;
    add | -a) vcfg_cmd_add "$2" ;;
    disable) vcfg_cmd_disable "$2" ;;
    enable) vcfg_cmd_enable "$2" ;;
    info) vcfg_cmd_info "$2" ;;
    remove | -r) vcfg_cmd_remove "$2" ;;
    search | -s) vcfg_cmd_search "$2" ;;
    update | -u) vcfg_cmd_update ;;
    edit | -e) edit_plugin_file ;;
    esac
    return 1
  fi

  interactive_plugin_manager
}
