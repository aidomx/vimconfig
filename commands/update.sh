#!/usr/bin/env bash

vcfg_cmd_update() {
  local plugin_manager=$(detect_plugin_manager)

  print_header "Updating Plugins"

  case "$plugin_manager" in
  "vim-plug")
    update_vimplug_plugins
    ;;
  "packer.nvim")
    update_packer_plugins
    ;;
  "lazy.nvim")
    update_lazy_plugins
    ;;
  *)
    print_error "Unsupported plugin manager: $plugin_manager"
    return 1
    ;;
  esac
}

update_vimplug_plugins() {
  check_vim_config

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
  done <"$PLUGINS_FILE"

  local total=${#plugins[@]}

  if [ $total -eq 0 ]; then
    print_warning "No plugins found to update"
    return
  fi

  print_info "Found ${total} plugin(s) to update"
  echo ""

  local current=0 updated=0 failed=0

  for plugin in "${plugins[@]}"; do
    current=$((current + 1))
    local plugin_name="${plugin##*/}"
    local plugin_dir="${VIM_PLUGINS_DIR}/${plugin_name}"

    # Update plugin if directory exists
    if [ -d "$plugin_dir" ]; then
      if [ -d "$plugin_dir/.git" ]; then
        cd "$plugin_dir"

        local message=$(printf "${CYAN}[%2d/%2d]${NC} ${YELLOW}(Updating)${NC} %-16s" $current $total $plugin_name)

        (git pull --quiet 2>&1) &
        local pid=$!
        progress bar $pid "${message}" 16
        wait $pid || {
          failed=$((failed + 1))
        }

        updated=$((updated + 1))
        cd - >/dev/null 2>&1
      fi
    fi
  done

  # Clear progress line and show results
  printf "\r%-80s\r" " "

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

update_packer_plugins() {
  print_info "Updating plugins via packer.nvim..."

  nvim --headless -c 'PackerSync' -c 'qa!' >/dev/null 2>&1 &
  local pid=$!
  spinner "$pid" "Updating packer.nvim plugins"
  wait "$pid" 2>/dev/null || true

  print_success "Packer plugins updated successfully!"
}

update_lazy_plugins() {
  print_info "Updating plugins via lazy.nvim..."

  nvim --headless -c 'Lazy update' -c 'qa!' >/dev/null 2>&1 &
  local pid=$!
  spinner "$pid" "Updating lazy.nvim plugins"
  wait "$pid" 2>/dev/null || true

  print_success "Lazy plugins updated successfully!"
}
