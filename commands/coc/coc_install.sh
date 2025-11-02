#!/usr/bin/env bash

install_coc_extensions() {
  local coc_file=$1

  print_header "Installing Coc Extensions"

  local extensions=$(extract_coc_extensions "$coc_file")

  if [ -z "$extensions" ]; then
    print_warning "No extensions to install"
    return 0
  fi

  for extension in "${extensions[@]}"; do
    print_info "Found ${#extension} extensions to install"
  done
  echo ""

  local coc_extensions_dir="${VCFG_COC_EXTENSIONS:-${HOME}/.config/coc/extensions}"
  mkdir -p "$coc_extensions_dir"

  cd "$coc_extensions_dir" || {
    print_error "Cannot access Coc extensions directory"
    return 1
  }

  # Create package.json if not exists
  [ ! -f "package.json" ] && echo '{"dependencies":{}}' > package.json

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
  show_percentage_progress $pid "Installing $total extensions"
  wait $pid

  # Verify installations
  echo ""
  verify_coc_installations "$extensions"
}

update_coc_extensions() {
  local coc_file=$1

  print_header "Updating Coc Extensions"

  local coc_extensions_dir="${VCFG_COC_EXTENSIONS:-${HOME}/.config/coc/extensions}"

  if [ ! -d "$coc_extensions_dir" ]; then
    print_warning "No Coc extensions directory found"
    return 0
  fi

  cd "$coc_extensions_dir" || {
    print_error "Cannot access Coc extensions directory"
    return 1
  }

  print_info "Updating all Coc extensions..."

  # Show progress for update process
  (npm update > /dev/null 2>&1) &
  local pid=$!
  show_percentage_progress $pid "Updating extensions"
  wait $pid

  print_success "Coc extensions updated successfully"
}

verify_coc_installations() {
  local extensions=$1
  local installed_count=0
  local total_count=0

  echo -e "${CYAN}Verifying installations:${NC}"
  echo ""

  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      total_count=$((total_count + 1))
      if is_coc_extension_installed "$extension"; then
        echo -e "  ${GREEN}✓${NC} $extension - installed"
        installed_count=$((installed_count + 1))
      else
        echo -e "  ${RED}✗${NC} $extension - not installed"
      fi
    fi
  done <<< "$extensions"

  echo ""
  if [ $installed_count -eq $total_count ]; then
    print_success "All $installed_count extensions installed"
  else
    print_warning "$installed_count/$total_count extensions installed"
  fi
}
