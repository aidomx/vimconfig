#!/usr/bin/env bash

vcfg_cmd_system_update() {
  print_header "Updating Vim Configuration System"

  if [ ! -d "$INSTALL_DIR" ]; then
    print_error "Vim configuration not found. Run 'vcfg install' first."
    return 1
  fi

  # Update the configuration repository
  cd "$INSTALL_DIR"

  print_info "Pulling latest changes from repository..."
  if git pull --rebase origin main; then
    print_success "Configuration updated successfully"

    # Update vcfg tool jika ada perubahan
    if [ -f "$INSTALL_DIR/vcfg.sh" ]; then
      install_vcfg
    fi

    print_success "System update completed!"
    echo ""
    print_info "You may want to also update your plugins: ${CYAN}vcfg update${NC}"
  else
    print_error "Failed to update configuration"
    return 1
  fi
}
