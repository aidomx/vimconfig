#!/usr/bin/env bash

vcfg_cmd_list() {
  check_vim_config || return 1
  print_header "Installed Plugins"

  local count_enabled=0
  local count_disabled=0
  local count_installed=0

  # Read from plugins.vim - simplified approach
  while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines
    [ -z "$line" ] && continue

    # Check for active plugins
    if echo "$line" | grep -q "^[[:space:]]*Plug "; then
      local plugin=$(echo "$line" | sed "s/.*Plug[[:space:]]*'\([^']*\)'.*/\1/")

      if [ ! -z "$plugin" ] && [ "$plugin" != "$line" ]; then
        local plugin_name="${plugin##*/}"
        local install_status=""

        # Check if actually installed in .vim/plugged
        if [ -d "${VIM_PLUGINS_DIR}/${plugin_name}" ]; then
          install_status=" ${CYAN}[installed]${NC}"
          count_installed=$((count_installed + 1))
        else
          install_status=" ${RED}[not installed]${NC}"
        fi

        echo -e "  ${GREEN}✓${NC} ${WHITE}${plugin}${NC}${install_status}"
        count_enabled=$((count_enabled + 1))
      fi
    # Check for disabled plugins (commented out)
    elif echo "$line" | grep -q "^[[:space:]]*\".*Plug "; then
      local plugin=$(echo "$line" | sed "s/.*Plug[[:space:]]*'\([^']*\)'.*/\1/")

      if [ ! -z "$plugin" ] && [ "$plugin" != "$line" ]; then
        echo -e "  ${YELLOW}⊘${NC} ${WHITE}${plugin}${NC} ${YELLOW}(disabled)${NC}"
        count_disabled=$((count_disabled + 1))
      fi
    fi
  done < "$PLUGINS_FILE"

  echo ""

  # Show summary
  local total=$((count_enabled + count_disabled))
  # print_info "Summary: enabled=${count_enabled} disabled=${count_disabled} installed=${count_installed} total=${total}"

  print_info "Summary:"
  echo -e "  ${GREEN}Enabled:${NC}     ${count_enabled}"
  echo -e "  ${YELLOW}Disabled:${NC}    ${count_disabled}"
  echo -e "  ${CYAN}Installed:${NC}   ${count_installed}"
  echo -e "  ${WHITE}Total:${NC}       ${total}"

  # Show orphaned plugins (installed but not in config)
  if [ -d "$VIM_PLUGINS_DIR" ] && [ "$(ls -A $VIM_PLUGINS_DIR 2> /dev/null)" ]; then
    echo ""
    print_info "Checking for orphaned plugins..."

    local orphaned=0
    for plugin_dir in "$VIM_PLUGINS_DIR"/*; do
      [ ! -d "$plugin_dir" ] && continue

      local plugin_name=$(basename "$plugin_dir")

      # Check if this plugin exists in config
      if ! grep -q "Plug.*${plugin_name}" "$PLUGINS_FILE" 2> /dev/null; then
        if [ $orphaned -eq 0 ]; then
          echo ""
          echo -e "${RED}Orphaned plugins (not in config):${NC}"
        fi
        echo -e "  ${RED}✗${NC} ${plugin_name}"
        orphaned=$((orphaned++))
      fi
    done

    if [ $orphaned -gt 0 ]; then
      echo ""
      print_warning "Found ${orphaned} orphaned plugin(s)"
      print_info "Run '${CYAN}vcfg clean${NC}' to remove them"
    fi
  fi
}
