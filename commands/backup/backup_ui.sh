#!/usr/bin/env bash

show_backup_summary() {
  local output_file=$1
  local items=($(get_backup_items))
  local existing_items=($(filter_existing_items "${items[@]}"))

  print_header "Creating Vim Configuration Backup"

  print_info "Backup items:"
  for item in "${existing_items[@]}"; do
    echo "  • $item"
  done
  echo ""

  print_info "Output: $output_file"
}

show_restore_summary() {
  local backup_file=$1
  local backup_info=($(get_backup_info "$backup_file"))

  print_header "Restoring Vim Configuration"

  for line in "${backup_info[@]}"; do
    echo -e "  ${WHITE}${line%%:*}:${NC} ${line#*:}"
  done
  echo ""

  print_info "Backup contents preview:"
  local preview_items=($(extract_backup_preview "$backup_file" 6))
  for item in "${preview_items[@]}"; do
    echo "  • $item"
  done

  local total_items=$(get_total_backup_items "$backup_file")
  if [ $total_items -gt 6 ]; then
    echo "  ... and $((total_items - 6)) more items"
  fi
}

show_restore_warning() {
  echo ""
  print_warning "This will overwrite your current Vim configuration!"
  read -p "Continue with restore? [y/N] " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]]
}

show_backup_success() {
  local output_file=$1
  local backup_size=$(du -h "$output_file" | cut -f1)
  local total_items=$(get_total_backup_items "$output_file")

  print_success "Backup created successfully!"
  echo ""
  echo -e "${WHITE}Backup file:${NC} $output_file"
  echo -e "${WHITE}Size:${NC} $backup_size"
  echo -e "${WHITE}Items:${NC} $total_items"
  echo ""
  echo -e "To restore, run: ${CYAN}vcfg restore $output_file${NC}"
}

show_restore_success() {
  local restore_backup=$1

  print_success "Restore completed successfully!"
  echo ""
  if [ -n "$restore_backup" ] && [ -f "$restore_backup" ]; then
    echo -e "${WHITE}Pre-restore backup:${NC} $restore_backup"
    echo ""
  fi
  echo -e "Run ${CYAN}vcfg doctor${NC} to verify the restore"
  echo -e "Run ${CYAN}vcfg install${NC} to reinstall plugins if needed"
}
