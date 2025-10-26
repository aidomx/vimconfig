#!/usr/bin/env bash

setup_optional_tools() {
  print_header "Optional Tools"

  echo ""
  echo -e "Would you like to install recommended tools?"
  echo -e "  - Node.js (for web development)"
  echo -e "  - Python packages (black, flake8)"
  echo -e "  - Go (for Go development)"
  echo ""

  read -p "Install optional tools? [y/N]: " install_tools

  if [[ "$install_tools" =~ ^[Yy]$ ]]; then
    install_optional_packages
  else
    print_info "Skipping optional tools"
    print_info "You can install them later manually"
  fi
}
