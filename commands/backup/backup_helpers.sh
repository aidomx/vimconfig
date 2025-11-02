#!/usr/bin/env bash

validate_backup_file() {
  local backup_file=$1

  if [ ! -f "$backup_file" ]; then
    print_error "Backup file not found: $backup_file"
    return 1
  fi

  if ! tar -tzf "$backup_file" > /dev/null 2>&1; then
    print_error "Invalid backup file (not a valid tar archive): $backup_file"
    return 1
  fi

  return 0
}

create_restore_backup() {
  local backup_file=$1
  local items=($(get_backup_items))
  local existing_items=($(filter_existing_items "${items[@]}"))

  if [ ${#existing_items[@]} -eq 0 ]; then
    return 0
  fi

  (
    tar -czf "$backup_file" "${existing_items[@]}" 2> /dev/null || true
  ) > /dev/null 2>&1

  echo "$backup_file"
}

get_backup_info() {
  local backup_file=$1
  local info=()

  info+=("File: $backup_file")
  info+=("Size: $(du -h "$backup_file" | cut -f1)")
  info+=("Date: $(stat -c %y "$backup_file" 2> /dev/null || stat -f %Sm "$backup_file")")
  info+=("Items: $(tar -tzf "$backup_file" | grep -v '/$' | wc -l)")

  printf '%s\n' "${info[@]}"
}

extract_backup_preview() {
  local backup_file=$1
  local limit=${2:-8}

  tar -tzf "$backup_file" | head -$limit
}

get_total_backup_items() {
  local backup_file=$1
  tar -tzf "$backup_file" | wc -l
}

backup_existing() {
  local backup_dir="${INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"

  print_info "Creating backup at: $backup_dir"

  # Backup config directory
  if [ -d "$INSTALL_DIR" ]; then
    mv "$INSTALL_DIR" "$backup_dir"
    print_success "Backed up config directory"
  else
    print_warning "Config directory not found: $INSTALL_DIR"
  fi

  # Cek jika .vimrc adalah milik kita (meng-source config kita)
  if [ -f "$VIMRC_PATH" ] && [ ! -L "$VIMRC_PATH" ]; then
    if grep -q "~/.config/vim/init.vim" "$VIMRC_PATH"; then
      local vimrc_backup="${VIMRC_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
      cp "$VIMRC_PATH" "$vimrc_backup"
      print_success "Backed up our .vimrc to $vimrc_backup"

      # Hapus .vimrc kita karena akan dibuat baru
      rm "$VIMRC_PATH"
      print_info "Removed our .vimrc (will be recreated)"
    else
      print_info "Preserving existing .vimrc (not part of our configuration)"
    fi
  fi

  print_success "Backup completed"
}

update_existing() {
  print_header "Updating Existing Installation"

  # Pastikan kita di directory yang benar
  if [ ! -d "$INSTALL_DIR" ]; then
    print_error "Installation directory not found: $INSTALL_DIR"
    exit 1
  fi

  cd "$INSTALL_DIR"

  print_info "Fetching latest changes..."
  git fetch origin

  print_info "Pulling updates..."
  git pull origin main

  print_success "Configuration updated successfully!"

  # Update vcfg jika needed
  if [ -f "$INSTALL_DIR/vcfg.sh" ]; then
    print_info "Updating vcfg..."
    install_vcfg
  fi

  # Update .vimrc jika itu milik kita
  if [ -f "$VIMRC_PATH" ] && grep -q "~/.config/vim/init.vim" "$VIMRC_PATH"; then
    print_info "Our .vimrc is already set up correctly"
  else
    print_warning "Our .vimrc setup may need update"
    setup_vimrc
  fi

  print_success "Update completed!"
}
