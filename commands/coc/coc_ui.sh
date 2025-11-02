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

show_coc_extensions() {
  local coc_file=$1

  print_header "Current Coc Extensions"

  local extensions=$(extract_coc_extensions "$coc_file")
  local installed_count=0
  local total_count=0

  if [ -z "$extensions" ]; then
    print_warning "No Coc extensions configured"
    return 0
  fi

  while IFS= read -r extension; do
    [ -n "$extension" ] && total_count=$((total_count + 1))
    is_coc_extension_installed "$extension" && installed_count=$((installed_count + 1))
  done <<< "$extensions"

  echo -e "${WHITE}Extensions:${NC} $installed_count/$total_count installed"
  echo ""
  list_coc_extensions "$coc_file"
}
