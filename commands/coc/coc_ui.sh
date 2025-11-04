#!/usr/bin/env bash

edit_coc_file() {
  local coc_file=$1
  local editor="${EDITOR:-vim}"

  print_info "Opening coc.vim in editor: $coc_file"
  echo ""
  echo -e "${CYAN}Quick tips:${NC}"
  echo "  • Add extensions to g:coc_global_extensions array"
  echo "  • Use single quotes for extension names"
  echo "  • Each extension on its own line with backslash"
  echo "  • Save and quit to apply changes"
  echo ""

  $editor "$coc_file"

  print_success "Coc configuration updated!"
}

list_coc_extensions() {
  local coc_file=$1
  local extensions=$(extract_coc_extensions "$coc_file")

  if [ -z "$extensions" ]; then
    print_warning "No Coc extensions found in configuration"
    return 0
  fi

  check_coc_extensions_access
  local count=0
  local ext_size

  print_info "List of Coc extensions"
  echo ""
  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      local ext_dir="node_modules/${extension}"
      local name="$extension"
      local size="$(du -sh $ext_dir | awk -F' ' {'print $1'})"
      local status

      if is_coc_extension_installed "$extension"; then
        status="$(echo -e "${CYAN}instaled${NC}")"
      else
        status="$(echo -e "${RED}not instaled${NC}")"
      fi

      echo -e "  ${CYAN}-${NC} Name    : $name"
      echo -e "  ${CYAN}-${NC} Size    : $size"
      echo -e "  ${CYAN}-${NC} Status  : $status"
      echo ""
      count=$((count + 1))
      ext_size=$(du -sh "node_modules" | awk -F' ' {'print $1'})
    fi
  done <<< "$extensions"

  echo ""
  print_info "Total extensions      : $count"
  print_info "Total size extensions : $ext_size"

  echo ""
  echo -e "Run ${CYAN}vcfg help coc${NC} for detail information"
}

show_coc_extensions() {
  local coc_file=$1

  print_info "Current Coc Extensions:"
  echo ""

  local extensions=$(extract_coc_extensions "$coc_file")

  if [ -z "$extensions" ]; then
    print_warning "No Coc extensions configured"
    return 0
  fi

  check_coc_extensions_access
  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      local ext_dir="node_modules/${extension}"
      local name="$extension"
      local size="$(du -sh $ext_dir | awk -F' ' {'print $1'})"
      local status

      if is_coc_extension_installed "$extension"; then
        status="$(echo -e "${CYAN}instaled${NC}")"
      else
        status="$(echo -e "${RED}not instaled${NC}")"
      fi

      echo -e "  ${CYAN}-${NC} Name    : $name"
      echo -e "  ${CYAN}-${NC} Size    : $size"
      echo -e "  ${CYAN}-${NC} Status  : $status"
      echo ""
    fi
  done <<< "$extensions"

  print_info "Run ${CYAN}vcfg help coc${NC} for detail information"
}
