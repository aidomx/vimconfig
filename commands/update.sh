#!/usr/bin/env bash

vcfg_cmd_update() {
  check_vim_config

  print_header "Updating Plugins"

  # Get list of plugins
  local plugins=()
  while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] && continue

    if echo "$line" | grep -q "^[[:space:]]*Plug "; then
      local plugin=$(echo "$line" | sed "s/.*Plug[[:space:]]*'\([^']*\)'.*/\1/")
      if [ ! -z "$plugin" ] && [ "$plugin" != "$line" ]; then
        plugins+=("$plugin")
      fi
    fi
  done < "$PLUGINS_FILE"

  local total=${#plugins[@]}

  if [ $total -eq 0 ]; then
    print_warning "No plugins found to update"
    return
  fi

  print_info "Found ${total} plugin(s) to update"
  echo ""

  local current=0
  local updated=0
  local failed=0

  for plugin in "${plugins[@]}"; do
    current=$((current + 1))
    local plugin_name="${plugin##*/}"
    local plugin_dir="${VIM_PLUGINS_DIR}/${plugin_name}"

    # Calculate percentage
    local percent=$((current * 100 / total))

    # Progress bar (20 chars width)
    local filled=$((percent / 5))
    local empty=$((20 - filled))
    local bar=$(printf "%${filled}s" | tr ' ' '#')
    local space=$(printf "%${empty}s" | tr ' ' '-')

    # Display progress
    printf "\r[${GREEN}${bar}${NC}${space}] ${percent}%% - Updating: ${CYAN}%-40s${NC}" "$plugin_name"

    # Update plugin if directory exists
    if [ -d "$plugin_dir" ]; then
      if [ -d "$plugin_dir/.git" ]; then
        cd "$plugin_dir"
        local output=$(git pull --quiet 2>&1)
        local exit_code=$?

        if [ $exit_code -eq 0 ]; then
          if echo "$output" | grep -q "Already up to date"; then
            # No update needed
            :
          else
            updated=$((updated + 1))
          fi
        else
          failed=$((failed + 1))
        fi
        cd - > /dev/null 2>&1
      fi
    fi
  done

  # Clear progress line and show results
  printf "\r%-80s\r" " "                                   
  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  if [ $updated -gt 0 ]; then
    print_success "Updated: ${updated} plugin(s)"
  fi

  if [ $failed -gt 0 ]; then
    print_error "Failed: ${failed} plugin(s)"
  fi                                                       
  if [ $updated -eq 0 ] && [ $failed -eq 0 ]; then
    print_info "All plugins are up to date!"
  fi

  print_info "Run 'vim +PlugUpdate' for detailed update information"
}
