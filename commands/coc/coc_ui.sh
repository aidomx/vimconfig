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
  local total_size=0

  print_info "List of Coc extensions"
  echo ""

  # Prepare data for table
  local table_data=()

  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      local ext_dir="node_modules/${extension}"
      local name="$extension"
      local size="0K"
      local status
      local size_bytes=0

      if is_coc_extension_installed "$extension"; then
        status="${GREEN}installed${NC}"
        if [ -d "$ext_dir" ]; then
          size_bytes=$(du -sk "$ext_dir" | awk '{print $1}')
          size="$(du -sh "$ext_dir" | awk '{print $1}')"
        fi
      else
        status="${RED}not installed${NC}"
      fi

      status=$(echo -e "$status")
      # Add to table data
      table_data+=("$name|$size|$status")

      count=$((count + 1))
      total_size=$((total_size + size_bytes))
    fi
  done <<< "$extensions"

  # Create table
  create_simple_table "Name,Size,Status" "${table_data[@]}"

  # Konversi total size
  local total_size_human=""
  if [ $total_size -ge 1048576 ]; then
    total_size_human=$(echo "scale=1; $total_size/1048576" | bc)G
  elif [ $total_size -ge 1024 ]; then
    total_size_human=$(echo "scale=1; $total_size/1024" | bc)M
  else
    total_size_human="${total_size}K"
  fi

  echo ""
  print_info "Total extensions      : $count"
  print_info "Total size extensions : $total_size_human"

  echo ""
  echo -e "Run ${CYAN}vcfg help coc${NC} for detail information"
}

show_coc_extensions() {
  local coc_file=$1
  local range_param=${2:-} # Bisa berupa "5" atau "2:4"

  print_info "Current Coc Extensions:"
  echo ""

  local extensions=$(extract_coc_extensions "$coc_file")

  if [ -z "$extensions" ]; then
    print_warning "No Coc extensions configured"
    return 0
  fi

  check_coc_extensions_access
  local count=0
  local total_size=0
  local displayed_count=0
  local start_row=1
  local end_row=""

  # Parse range parameter
  if [[ "$range_param" == *:* ]]; then
    # Format: start:end
    start_row=$(echo "$range_param" | cut -d: -f1)
    end_row=$(echo "$range_param" | cut -d: -f2)
  elif [ -n "$range_param" ]; then
    # Format: single number (limit dari awal)
    start_row=1
    end_row="$range_param"
  fi

  # Prepare data for table
  local table_data=()
  local current_row=0

  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      current_row=$((current_row + 1))

      # Cek apakah row ini dalam range yang diminta
      if [ -n "$end_row" ]; then
        if [ $current_row -lt $start_row ] || [ $current_row -gt $end_row ]; then
          continue
        fi
      fi

      local ext_dir="node_modules/${extension}"
      local name="$extension"
      local size="0K"
      local status
      local size_bytes=0

      if is_coc_extension_installed "$extension"; then
        status="${GREEN}installed${NC}"
        if [ -d "$ext_dir" ]; then
          size_bytes=$(du -sk "$ext_dir" | awk '{print $1}')
          size="$(du -sh "$ext_dir" 2> /dev/null | awk '{print $1}')"
        fi
      else
        status="${RED}not installed${NC}"
      fi

      status=$(echo -e "$status")
      table_data+=("$name|$size|$status")

      count=$((count + 1))
      displayed_count=$((displayed_count + 1))
      total_size=$((total_size + size_bytes))
    fi
  done <<< "$extensions"

  # Create simple table
  if [ ${#table_data[@]} -gt 0 ]; then
    create_simple_table "Name,Size,Status" "${table_data[@]}"
  else
    print_warning "No extensions found in the specified range"
  fi
  echo ""

  # Konversi total size
  local total_size_human=""
  if [ $total_size -ge 1048576 ]; then
    total_size_human=$(echo "scale=1; $total_size/1048576" | bc)G
  elif [ $total_size -ge 1024 ]; then
    total_size_human=$(echo "scale=1; $total_size/1024" | bc)M
  else
    total_size_human="${total_size}K"
  fi

  # Tampilkan info range jika digunakan
  if [ -n "$range_param" ]; then
    local total_extensions=$(echo "$extensions" | wc -l)
    if [[ "$range_param" == *:* ]]; then
      echo ""
      print_info "Showing rows $start_row to $end_row of $total_extensions extensions"
    else
      echo ""
      print_info "Showing first $displayed_count of $total_extensions extensions"
    fi
  fi

  echo ""
  print_info "Total extensions shown : $displayed_count"
  print_info "Total size extensions  : $total_size_human"
  echo ""

  print_info "Run ${CYAN}vcfg help coc${NC} for detail information"
}
