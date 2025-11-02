#!/usr/bin/env bash

list_coc_extensions() {
  local coc_file=$1

  print_header "Coc Extensions"

  local extensions=$(extract_coc_extensions "$coc_file")

  if [ -z "$extensions" ]; then
    print_warning "No Coc extensions found in configuration"
    return 0
  fi

  echo -e "${WHITE}Configured extensions:${NC}"
  echo ""

  local count=0
  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      local status
      if is_coc_extension_installed "$extension"; then
        status="${GREEN}[installed]${NC}"
      else
        status="${YELLOW}[not installed]${NC}"
      fi

      echo -e "  ${CYAN}•${NC} ${extension} ${status}"
      count=$((count + 1))
    fi
  done <<< "$extensions"

  echo ""
  print_info "Total extensions: $count"
  echo ""
  echo -e "Run ${CYAN}vcfg coc install${NC} to install all extensions"
}

add_coc_extension() {
  local extension=$1
  local coc_file=$2

  if grep -q "'$extension'" "$coc_file"; then
    print_warning "Extension already exists: $extension"
    return 0
  fi

  print_info "Adding extension: $extension"

  # Show progress for rebuild process
  (
    local current_extensions=$(extract_coc_extensions "$coc_file")
    local all_extensions=$(echo "$current_extensions"$'\n'"$extension" | grep -v '^$' | sort | uniq)
    rebuild_coc_file "$coc_file" "$all_extensions"
  ) > /dev/null 2>&1 &

  local pid=$!
  show_percentage_progress $pid "Adding $extension"
  wait $pid

  print_success "Added Coc extension: $extension"

  echo ""
  echo -e "${CYAN}Updated extensions:${NC}"
  extract_coc_extensions "$coc_file" | while read -r ext; do
    echo "  • $ext"
  done
}

remove_coc_extension() {
  local extension=$1
  local coc_file=$2

  if ! grep -q "'$extension'" "$coc_file" 2> /dev/null; then
    print_warning "Extension not found: $extension"
    return 0
  fi

  print_info "Removing extension: $extension"

  # Show progress for rebuild process
  (
    local current_extensions=$(extract_coc_extensions "$coc_file")
    local remaining_extensions=$(echo "$current_extensions" | grep -v "^${extension}$")
    rebuild_coc_file "$coc_file" "$remaining_extensions"
  ) > /dev/null 2>&1 &

  local pid=$!
  show_percentage_progress $pid "Removing $extension"
  wait $pid

  print_success "Removed Coc extension: $extension"
}
