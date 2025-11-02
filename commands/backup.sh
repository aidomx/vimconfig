#!/usr/bin/env bash

# Load backup modules
for backup_file in "${VCFG_ROOT}/commands/backup"/*.sh; do
  source "$backup_file"
done

vcfg_cmd_backup() {
  local output_file="${1:-${HOME}/.vim-backup-$(date +%Y%m%d_%H%M%S).tar.gz}"
  local output_dir=$(dirname "$output_file")
  mkdir -p "$output_dir"

  show_backup_summary "$output_file"

  # Create backup with progress
  (create_backup_archive "$output_file") > /dev/null 2>&1 &
  local pid=$!
  show_percentage_progress $pid "Creating backup archive"
  wait $pid

  if [ -f "$output_file" ] && validate_backup_file "$output_file"; then
    show_backup_success "$output_file"
  else
    print_error "Backup creation failed!"
    return 1
  fi
}

vcfg_cmd_restore() {
  local backup_file=$1

  if [ -z "$backup_file" ]; then
    print_error "Usage: vcfg restore <backup-file>"
    echo ""
    echo "Examples:"
    echo "  vcfg restore ~/.vim-backup.tar.gz"
    echo "  vcfg restore ./my-backup-20231201.tar.gz"
    return 1
  fi

  if ! validate_backup_file "$backup_file"; then
    return 1
  fi

  show_restore_summary "$backup_file"

  if ! show_restore_warning; then
    print_info "Restore cancelled"
    return 0
  fi

  # Create pre-restore backup
  local restore_backup="${HOME}/.vim-restore-backup-$(date +%Y%m%d_%H%M%S).tar.gz"
  print_info "Creating pre-restore backup..."
  create_restore_backup "$restore_backup" > /dev/null

  # Restore backup
  print_info "Restoring configuration..."
  (restore_backup_archive "$backup_file") > /dev/null 2>&1 &
  local pid=$!
  show_percentage_progress $pid "Restoring configuration"
  wait $pid

  show_restore_success "$restore_backup"
}
