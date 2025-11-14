#!/usr/bin/env bash

interactive_plugin_manager() {
  ! [ -f "$VCFG_PLUGINS_FILE" ] && print_error "Plugins file not found: ${VCFG_PLUGINS_FILE}" | return 1

  print_header "Interactive Plugin Manager"
  echo -e "${WHITE}Editing: ${CYAN}${VCFG_PLUGINS_FILE}${NC}"
  echo ""
  echo -e "${YELLOW}Available commands:${NC}"
  echo -e "  ${GREEN}add${NC}     <plugin>  - Add new plugin"
  echo -e "  ${GREEN}remove${NC}  <plugin>  - Remove plugin"
  echo -e "  ${GREEN}enable${NC}  <plugin>  - Enable disabled plugin"
  echo -e "  ${GREEN}disable${NC} <plugin>  - Disable plugin"
  echo -e "  ${GREEN}list${NC}              - List all plugins"
  echo -e "  ${GREEN}info${NC}    <plugin>  - Show plugin info"
  echo -e "  ${GREEN}update${NC}            - Update all plugins"
  echo -e "  ${GREEN}edit${NC}              - Open in editor"
  echo -e "  ${GREEN}help${NC}              - Show help"
  echo -e "  ${GREEN}quit${NC}              - Exit"
  echo ""

  while true; do
    read -p "$(echo -e "${BLUE}>> ${NC}")" command

    local cmd=$(echo "$command" | awk -F' ' {'print $1'})
    local args=$(echo "$command" | awk -F' ' {'print $2'})

    case "$cmd" in
    list | -l) vcfg_cmd_list ;;
    add | -a) vcfg_cmd_add "$args" ;;
    disable) vcfg_cmd_disable "$args" ;;
    enable) vcfg_cmd_enable "$args" ;;
    info) vcfg_cmd_info "$args" ;;
    remove | -r) vcfg_cmd_remove "$args" ;;
    search | -s) vcfg_cmd_search "$args" ;;
    update | -u) vcfg_cmd_update ;;
    edit | -e) edit_plugin_file ;;
    quit | q)
      print_info "Goodbye!"
      break
      ;;
    help | h)
      show_plugin_help
      ;;
    "")
      # Do nothing on empty input
      ;;
    *)
      # Try to execute as direct command
      if [[ "$command" =~ ^(add|disable|edit|enable|info|list|remove|search|update) ]]; then
        eval "vcfg_cmd_plugins $command"
      else
        print_error "Unknown command: $command"
        echo "Type 'help' for available commands"
      fi
      ;;
    esac
  done
}

edit_plugin_file() {
  local plugins_file="${VCFG_PLUGINS_FILE}"

  print_info "Opening plugins file in editor..."

  if [ -n "$EDITOR" ]; then
    $EDITOR "$plugins_file"
  elif command -v nvim >/dev/null; then
    nvim "$plugins_file"
  elif command -v vim >/dev/null; then
    vim "$plugins_file"
  else
    vi "$plugins_file"
  fi
}

show_plugin_help() {
  echo -e "${WHITE}PLUGINS COMMANDS:${NC}"
  echo -e "  ${GREEN}add${NC}     <plugin>  - Add new plugin"
  echo -e "  ${GREEN}remove${NC}  <plugin>  - Remove plugin"
  echo -e "  ${GREEN}enable${NC}  <plugin>  - Enable disabled plugin"
  echo -e "  ${GREEN}disable${NC} <plugin>  - Disable plugin"
  echo -e "  ${GREEN}list${NC}              - List all plugins"
  echo -e "  ${GREEN}info${NC}    <plugin>  - Show plugin info"
  echo -e "  ${GREEN}update${NC}            - Update all plugins"
  echo -e "  ${GREEN}edit${NC}              - Open in editor"
  echo -e "  ${GREEN}help${NC}              - Show help"
  echo -e "  ${GREEN}quit${NC}              - Exit"
  echo ""
}
