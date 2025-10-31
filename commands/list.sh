#!/usr/bin/env bash

vcfg_cmd_list() {
  local plugin_manager=$(detect_plugin_manager)

  case "$plugin_manager" in
    "vim-plug")
      list_vimplug_plugins
      ;;
    "packer.nvim")
      list_packer_plugins
      ;;
    "lazy.nvim")
      list_lazy_plugins
      ;;
    *)
      print_error "Unsupported plugin manager: $plugin_manager"
      return 1
      ;;
  esac
}

list_vimplug_plugins() {
  check_vim_config || return 1
  print_header "Installed Plugins (vim-plug)"

  local count_enabled=0
  local count_disabled=0
  local count_installed=0
  local plugins_dir="${HOME}/.vim/plugged"

  # Read from plugins.vim
  while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] && continue

    # Check for active plugins
    if echo "$line" | grep -q "^[[:space:]]*Plug "; then
      local plugin=$(echo "$line" | sed "s/.*Plug[[:space:]]*'\([^']*\)'.*/\1/")

      if [ ! -z "$plugin" ] && [ "$plugin" != "$line" ]; then
        local plugin_name="${plugin##*/}"
        local install_status=""

        # Special case for fzf (installed in custom directory)
        if [[ "$plugin_name" == "fzf" ]]; then
          if command -v fzf 2 > /dev/null &> 1; then
            install_status=" ${CYAN}[installed]${NC}"
            count_installed=$((count_installed + 1))
          else
            install_status=" ${RED}[not installed]${NC}"
          fi
        # Standard plugin check
        elif [ -d "${plugins_dir}/${plugin_name}" ]; then
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
  print_info "Summary:"
  echo -e "  ${GREEN}Enabled:${NC}     ${count_enabled}"
  echo -e "  ${YELLOW}Disabled:${NC}    ${count_disabled}"
  echo -e "  ${CYAN}Installed:${NC}   ${count_installed}"
  echo -e "  ${WHITE}Total:${NC}       $((count_enabled + count_disabled))"

  # Check for orphaned plugins
  check_orphaned_plugins "$plugins_dir" "$PLUGINS_FILE" "vim-plug"
}

list_packer_plugins() {
  local config_file="${HOME}/.config/nvim/lua/plugins.lua"
  local plugins_dir="${HOME}/.local/share/nvim/site/pack/packer"

  if [ ! -f "$config_file" ]; then
    print_error "packer.nvim config not found: $config_file"
    return 1
  fi

  print_header "Installed Plugins (packer.nvim)"

  local count_enabled=0
  local count_disabled=0
  local count_installed=0

  # Read from packer config
  while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] && continue

    # Check for enabled plugins
    if echo "$line" | grep -q "^[[:space:]]*use "; then
      local plugin=$(echo "$line" | sed "s/.*use '\([^']*\)'.*/\1/")

      if [ ! -z "$plugin" ] && [ "$plugin" != "$line" ]; then
        local plugin_name="${plugin##*/}"
        local install_status=""
        local plugin_type=""

        # Check if installed in start/ or opt/
        if [ -d "${plugins_dir}/start/${plugin_name}" ]; then
          install_status=" ${CYAN}[installed]${NC}"
          plugin_type=" (start)"
          count_installed=$((count_installed + 1))
        elif [ -d "${plugins_dir}/opt/${plugin_name}" ]; then
          install_status=" ${CYAN}[installed]${NC}"
          plugin_type=" (opt)"
          count_installed=$((count_installed + 1))
        else
          install_status=" ${RED}[not installed]${NC}"
        fi

        echo -e "  ${GREEN}✓${NC} ${WHITE}${plugin}${NC}${plugin_type}${install_status}"
        count_enabled=$((count_enabled + 1))
      fi
    # Check for disabled plugins (commented out)
    elif echo "$line" | grep -q "^[[:space:]]*--.*use "; then
      local plugin=$(echo "$line" | sed "s/.*use '\([^']*\)'.*/\1/")

      if [ ! -z "$plugin" ] && [ "$plugin" != "$line" ]; then
        echo -e "  ${YELLOW}⊘${NC} ${WHITE}${plugin}${NC} ${YELLOW}(disabled)${NC}"
        count_disabled=$((count_disabled + 1))
      fi
    fi
  done < "$config_file"

  echo ""
  print_info "Summary:"
  echo -e "  ${GREEN}Enabled:${NC}     ${count_enabled}"
  echo -e "  ${YELLOW}Disabled:${NC}    ${count_disabled}"
  echo -e "  ${CYAN}Installed:${NC}   ${count_installed}"
  echo -e "  ${WHITE}Total:${NC}       $((count_enabled + count_disabled))"

  # Check for orphaned plugins
  check_orphaned_plugins "$plugins_dir" "$config_file" "packer.nvim"
}

list_lazy_plugins() {
  local config_file="${HOME}/.config/nvim/lazy.lua"
  local plugins_dir="${HOME}/.local/share/nvim/lazy"

  if [ ! -f "$config_file" ]; then
    print_error "lazy.nvim config not found: $config_file"
    return 1
  fi

  print_header "Installed Plugins (lazy.nvim)"

  local count_enabled=0
  local count_disabled=0
  local count_installed=0

  # Read from lazy config
  while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] && continue

    # Check for enabled plugins
    if echo "$line" | grep -q "^[[:space:]]*{.*\"" && echo "$line" | grep -q "}"; then
      local plugin=$(echo "$line" | sed 's/.*"\([^"]*\)".*/\1/')

      if [ ! -z "$plugin" ] && [[ "$plugin" =~ / ]]; then
        local plugin_name="${plugin##*/}"
        local install_status=""

        if [ -d "${plugins_dir}/${plugin_name}" ]; then
          install_status=" ${CYAN}[installed]${NC}"
          count_installed=$((count_installed + 1))
        else
          install_status=" ${RED}[not installed]${NC}"
        fi

        echo -e "  ${GREEN}✓${NC} ${WHITE}${plugin}${NC}${install_status}"
        count_enabled=$((count_enabled + 1))
      fi
    # Check for disabled plugins (commented out)
    elif echo "$line" | grep -q "^[[:space:]]*--.*{.*\""; then
      local plugin=$(echo "$line" | sed 's/.*"\([^"]*\)".*/\1/')

      if [ ! -z "$plugin" ] && [[ "$plugin" =~ / ]]; then
        echo -e "  ${YELLOW}⊘${NC} ${WHITE}${plugin}${NC} ${YELLOW}(disabled)${NC}"
        count_disabled=$((count_disabled + 1))
      fi
    fi
  done < "$config_file"

  echo ""
  print_info "Summary:"
  echo -e "  ${GREEN}Enabled:${NC}     ${count_enabled}"
  echo -e "  ${YELLOW}Disabled:${NC}    ${count_disabled}"
  echo -e "  ${CYAN}Installed:${NC}   ${count_installed}"
  echo -e "  ${WHITE}Total:${NC}       $((count_enabled + count_disabled))"

  # Check for orphaned plugins
  check_orphaned_plugins "$plugins_dir" "$config_file" "lazy.nvim"
}

check_orphaned_plugins() {
  local plugins_dir=$1
  local config_file=$2
  local manager=$3

  if [ -d "$plugins_dir" ] && [ "$(ls -A "$plugins_dir" 2> /dev/null)" ]; then
    echo ""
    print_info "Checking for orphaned plugins..."

    local orphaned=0

    # Different directory structures for different managers
    case "$manager" in
      "vim-plug")
        check_vimplug_orphaned "$plugins_dir" "$config_file"
        ;;
      "packer.nvim")
        check_packer_orphaned "$plugins_dir" "$config_file"
        ;;
      "lazy.nvim")
        check_lazy_orphaned "$plugins_dir" "$config_file"
        ;;
    esac
  fi
}

check_vimplug_orphaned() {
  local plugins_dir=$1
  local config_file=$2
  local orphaned=0

  for plugin_dir in "$plugins_dir"/*; do
    [ ! -d "$plugin_dir" ] && continue

    local plugin_name=$(basename "$plugin_dir")

    if ! grep -q "Plug.*${plugin_name}" "$config_file" 2> /dev/null; then
      if [ $orphaned -eq 0 ]; then
        echo ""
        echo -e "${RED}Orphaned plugins (not in config):${NC}"
      fi
      echo -e "  ${RED}✗${NC} ${plugin_name}"
      orphaned=$((orphaned + 1))
    fi
  done

  if [ $orphaned -gt 0 ]; then
    echo ""
    print_warning "Found ${orphaned} orphaned plugin(s)"
    print_info "Run '${CYAN}vcfg clean${NC}' to remove them"
  fi
}

check_packer_orphaned() {
  local plugins_dir=$1
  local config_file=$2
  local orphaned=0

  # Check both start and opt directories
  for type_dir in "start" "opt"; do
    if [ -d "${plugins_dir}/${type_dir}" ]; then
      for plugin_dir in "${plugins_dir}/${type_dir}"/*; do
        [ ! -d "$plugin_dir" ] && continue

        local plugin_name=$(basename "$plugin_dir")

        if ! grep -q "use.*${plugin_name}" "$config_file" 2> /dev/null; then
          if [ $orphaned -eq 0 ]; then
            echo ""
            echo -e "${RED}Orphaned plugins (not in config):${NC}"
          fi
          echo -e "  ${RED}✗${NC} ${plugin_name} (${type_dir})"
          orphaned=$((orphaned + 1))
        fi
      done
    fi
  done

  if [ $orphaned -gt 0 ]; then
    echo ""
    print_warning "Found ${orphaned} orphaned plugin(s)"
    print_info "Run '${CYAN}vcfg clean${NC}' to remove them"
  fi
}

check_lazy_orphaned() {
  local plugins_dir=$1
  local config_file=$2
  local orphaned=0

  for plugin_dir in "$plugins_dir"/*; do
    [ ! -d "$plugin_dir" ] && continue

    local plugin_name=$(basename "$plugin_dir")

    if ! grep -q "\"${plugin_name}\"" "$config_file" 2> /dev/null; then
      if [ $orphaned -eq 0 ]; then
        echo ""
        echo -e "${RED}Orphaned plugins (not in config):${NC}"
      fi
      echo -e "  ${RED}✗${NC} ${plugin_name}"
      orphaned=$((orphaned + 1))
    fi
  done

  if [ $orphaned -gt 0 ]; then
    echo ""
    print_warning "Found ${orphaned} orphaned plugin(s)"
    print_info "Run '${CYAN}vcfg clean${NC}' to remove them"
  fi
}
