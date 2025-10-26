#!/usr/bin/env bash

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
