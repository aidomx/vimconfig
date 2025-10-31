#!/usr/bin/env bash

vcfg_cmd_install() {
  # Hanya untuk first-time installation via vcfg command
  if [ -d "$INSTALL_DIR" ]; then
    print_error "Vim configuration already installed at: $INSTALL_DIR"
    echo ""
    echo -e "It looks like you already have vcfg installed!"
    echo ""
    echo -e "If you want to:"
    echo -e "  ${CYAN}• Update plugins:${NC}        vcfg update"
    echo -e "  ${CYAN}• Reinstall completely:${NC}  vcfg reinstall"
    echo -e "  ${CYAN}• Update system:${NC}         vcfg system-update"
    echo -e "  ${CYAN}• Check system health:${NC}   vcfg doctor"
    echo ""
    echo -e "For fresh installation on a new system, use:"
    echo -e "  ${CYAN}curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash${NC}"
    echo ""
    return 1
  fi

  # Jika sampai sini, berarti first-time installation via vcfg command
  # (jarang terjadi, tapi handle untuk completeness)
  print_header "First-time Vim Configuration Installation via vcfg"

  # Pre-installation checks
  check_dependencies

  # Installation steps
  clone_repository
  setup_vimrc
  install_plugin_manager
  install_plugins
  install_vcfg

  # Optional setup
  setup_optional_tools

  # Completion
  show_next_steps
}

check_existing_installation() {
  if [ -d "$INSTALL_DIR" ]; then
    echo ""
    print_warning "Existing installation found at: $INSTALL_DIR"
    echo ""
    echo -e "Choose an option:"
    echo -e "  ${GREEN}1${NC}) Backup and reinstall (recommended)"
    echo -e "  ${YELLOW}2${NC}) Update existing installation"
    echo -e "  ${RED}3${NC}) Cancel installation"
    echo ""

    read -p "Enter your choice [1-3]: " choice

    case $choice in
      1)
        backup_existing
        return 0
        ;;
      2)
        update_existing
        exit 0
        ;;
      3)
        print_info "Installation cancelled"
        exit 0
        ;;
      *)
        print_error "Invalid choice"
        exit 1
        ;;
    esac
  fi
}

install_plugins() {
  print_header "Installing Plugins"

  print_info "This may take a few minutes..."
  echo ""
  cleanup_plugins

  # Install berdasarkan plugin manager
  if [ -f "${HOME}/.vim/autoload/plug.vim" ] || [ -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    # vim-plug dengan simple percentage
    print_info "Installing plugins via vim-plug..."

    vim -c 'PlugInstall --sync' -c 'qa!' > /dev/null 2>&1 &
    local vim_pid=$!

    show_percentage_progress $vim_pid "vim-plug plugins"
    wait $vim_pid
    print_success "Plugins installed via vim-plug"

  elif [ -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    # packer.nvim
    print_info "Installing plugins via packer.nvim..."

    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null 2>&1 &
    local nvim_pid=$!

    show_percentage_progress $nvim_pid "packer.nvim plugins"
    wait $nvim_pid
    print_success "Plugins installed via packer.nvim"

  elif [ -d "${HOME}/.local/share/nvim/lazy/lazy.nvim" ]; then
    # lazy.nvim
    print_info "Installing plugins via lazy.nvim..."

    nvim --headless -c 'Lazy sync' -c 'qa!' > /dev/null 2>&1 &
    local lazy_pid=$!

    show_percentage_progress $lazy_pid "lazy.nvim plugins"
    wait $lazy_pid
    print_success "Plugins installed via lazy.nvim"

  else
    print_warning "No plugin manager detected, skipping plugin installation"
  fi

  echo ""
}

install_vcfg() {
  print_header "Installing vcfg Tool"

  local vcfg_source="${INSTALL_DIR}/vcfg.sh"

  if [ ! -f "$vcfg_source" ]; then
    print_error "vcfg.sh not found in repository"
    return 1
  fi

  print_info "Installing vcfg to ${VCFG_BIN}..."

  # Check if we can write to /usr/bin
  if [ -w "/usr/bin" ]; then
    cp "$vcfg_source" "$VCFG_BIN"
    chmod +x "$VCFG_BIN"
  else
    # Need sudo
    if command -v sudo &> /dev/null; then
      sudo cp "$vcfg_source" "$VCFG_BIN"
      sudo chmod +x "$VCFG_BIN"
    else
      print_warning "Cannot install to /usr/bin (no sudo available)"
      print_info "You can manually copy: cp $vcfg_source $VCFG_BIN"
      return 1
    fi
  fi

  # Verify installation
  if command -v vcfg &> /dev/null; then
    print_success "vcfg installed successfully"
    vcfg --version
  else
    print_error "vcfg installation failed"
    return 1
  fi
}

install_optional_packages() {
  print_info "Installing optional packages..."

  # Detect package manager and install
  if [ -f /data/data/com.termux/files/usr/bin/pkg ]; then
    # Termux
    print_info "Detected Termux environment"
    pkg install -y nodejs python
    pip install black flake8 autopep8
  elif command -v pacman &> /dev/null; then
    # Arch Linux
    print_info "Detected Arch Linux"
    sudo pacman -S --noconfirm nodejs npm python-pip
    pip install black flake8 autopep8
  elif command -v apt-get &> /dev/null; then
    # Debian/Ubuntu
    print_info "Detected Debian/Ubuntu"
    sudo apt-get update
    sudo apt-get install -y nodejs npm python3-pip
    pip3 install black flake8 autopep8
  else
    print_warning "Could not detect package manager"
    print_info "Please install optional tools manually"
  fi

  print_success "Optional tools installed"
}

show_next_steps() {
  print_header "Installation Complete!"

  echo ""
  echo -e "${GREEN}✓ Vim configuration installed successfully!${NC}"
  echo ""

  # Tampilkan info berdasarkan plugin manager
  if [ -f "${HOME}/.vim/autoload/plug.vim" ]; then
    echo -e "  ${CYAN}Plugin Manager:${NC} vim-plug"
    echo -e "  ${CYAN}Manage plugins:${NC} :PlugInstall, :PlugUpdate"
  elif [ -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    echo -e "  ${CYAN}Plugin Manager:${NC} packer.nvim"
    echo -e "  ${CYAN}Manage plugins:${NC} :PackerSync, :PackerUpdate"
  elif [ -d "${HOME}/.local/share/nvim/lazy/lazy.nvim" ]; then
    echo -e "  ${CYAN}Plugin Manager:${NC} lazy.nvim"
    echo -e "  ${CYAN}Manage plugins:${NC} :Lazy sync, :Lazy update"
  fi

  echo ""
  echo -e "${WHITE}Next Steps:${NC}"
  echo ""
  echo -e "  ${YELLOW}vim${NC} (or ${YELLOW}nvim${NC}) - Start with new configuration"
  echo ""
  echo -e "${WHITE}Management Commands:${NC}"
  echo -e "  ${CYAN}vcfg update${NC}        - Update plugins"
  echo -e "  ${CYAN}vcfg system-update${NC} - Update configuration"
  echo -e "  ${CYAN}vcfg doctor${NC}        - Check system health"
  echo -e "  ${CYAN}vcfg help${NC}          - Show all commands"
  echo ""

  echo -e "${WHITE}Enjoy coding! 🚀${NC}"
  echo ""
}
