#!/usr/bin/env bash

install_coc_extensions() {
  local coc_file=$1
  local extensions=$(check_coc_extensions "$coc_file")

  echo ""
  check_coc_extensions_access "$@"

  local total=$(echo "$extensions" | grep -c .)
  local count=0

  # Install extensions with progress
  (
    while IFS= read -r extension; do
      if [ -n "$extension" ]; then
        local ext_dir="node_modules/${extension}"

        if [ ! -d "$ext_dir" ]; then
          npm install "$extension" --save --no-package-lock > /dev/null 2>&1
        fi
        count=$((count + 1))
      fi
    done <<< "$extensions"
  ) > /dev/null 2>&1 &

  local pid=$!
  progress "percent" $pid "Installing $total extensions"
  wait $pid

  # Verify installations
  echo ""
  verify_coc_installations "$extensions"
}

sync_install_coc_extensions() {
  local coc_file=${1:-}
  local extensions=$(check_coc_extensions "$coc_file")
  check_coc_extensions_access
  # Create package.json if not exists
  [ ! -f "package.json" ] && echo '{"dependencies":{}}' > package.json

  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      local ext_dir="node_modules/${extension}"

      if [ ! -d "$ext_dir" ]; then
        (npm install "$extension" --save --no-package-lock) > /dev/null 2>&1 &
        local pid=$!
        progress "percent" "$pid" " - Installed extension"
        wait "$pid"
      fi
    fi
  done <<< "$extensions"
  echo ""
}

sync_uninstall_coc_extensions() {
  local extensions="${1:-}"

  check_coc_extensions_access

  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      local ext_dir="node_modules/${extension}"

      if [ -d "$ext_dir" ]; then
        (npm uninstall "$extension") > /dev/null 2>&1 &
        local pid=$!
        progress "percent" "$pid" " - Removing extensions"
        wait "$pid"
      fi
    fi
  done <<< "$extensions"
  echo ""
}

list_coc_update() {
  local coc_file=$1
  local extensions=$(extract_coc_extensions "$coc_file")

  if [ -z "$extensions" ]; then
    print_warning "No Coc extensions found in configuration"
    return 0
  fi

  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      local status
      local size="node_modules/${extension}"
      if is_coc_extension_installed "$extension"; then
        status="${GREEN}[installed]${NC} ($(du -sh $size | awk -F' ' {'print $1'}))"
      else
        status="${YELLOW}[not installed]${NC}"
      fi

      echo -e "   ${CYAN}•${NC} ${extension} ${status}"
    fi
  done <<< "$extensions"
  echo ""
}

verify_coc_update() {
  local extensions=$1
  local installed_count=0
  local total_count=0

  echo ""

  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      local ext_dir="node_modules/${extension}"
      total_count=$((total_count + 1))
      if is_coc_extension_installed "$extension"; then
        echo -e "   ${CYAN}•${NC} $extension - ${CYAN}[update]${NC} ($(du -sh $ext_dir | awk -F' ' {'print $1'}))"
        installed_count=$((installed_count + 1))
      else
        echo -e "   ${RED}✗${NC} $extension"
      fi
    fi
  done <<< "$extensions"

  echo ""
  if [ $installed_count -eq $total_count ]; then
    print_info "$installed_count/$total_count extensions updated"
  else
    print_warning "$installed_count/$total_count extensions updated"
  fi
}

verify_coc_installations() {
  local extensions=$1
  local installed_count=0
  local total_count=0

  print_info "Verifying extensions:"
  echo ""

  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      total_count=$((total_count + 1))
      if is_coc_extension_installed "$extension"; then
        echo -e " • $extension - ${CYAN}[installed]${NC}"
        installed_count=$((installed_count + 1))
      else
        echo -e " ${RED}✗${NC} $extension"
      fi
    fi
  done <<< "$extensions"

  echo ""
  if [ $installed_count -eq $total_count ]; then
    print_info "$installed_count/$total_count extensions installed"
  else
    print_warning "$installed_count/$total_count extensions installed"
  fi
}
