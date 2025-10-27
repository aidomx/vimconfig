#!/usr/bin/env bash

vcfg_cmd_reinstall() {
  print_header "Reinstalling Vim Configuration"

  if [ ! -d "$INSTALL_DIR" ]; then
    print_error "Vim configuration not found. Run 'vcfg install' first."
    return 1
  fi

  print_warning "This will remove your current configuration and reinstall fresh"
  echo ""
  echo -e "${RED}This action will:${NC}"
  echo -e "  • Backup current configuration to ${INSTALL_DIR}.backup.*"
  echo -e "  • Remove all installed plugins"
  echo -e "  • Reinstall everything from scratch"
  echo ""

  read -p "Are you sure you want to continue? (y/N): " confirm

  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    print_info "Reinstall cancelled"
    return 0
  fi

  # Create backup
  backup_existing

  # Remove current installation
  rm -rf "$INSTALL_DIR"

  # Reinstall fresh
  print_info "Starting fresh installation..."
  clone_repository
  setup_vimrc
  install_plugin_manager
  install_plugins
  install_vcfg

  print_success "Reinstall completed successfully!"
  echo ""
  print_info "Your previous configuration was backed up to:"
  find "${HOME}/.config/vim" -name "*.backup.*" -type d 2> /dev/null | head -1
}
