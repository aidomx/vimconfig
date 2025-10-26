#!/usr/bin/env bash

clone_repository() {
  print_header "Installing Vim Configuration"

  print_info "Cloning repository..."

  if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
  fi

  git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"

  print_success "Repository cloned successfully"
}
