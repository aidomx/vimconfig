#!/bin/bash
# Vim Configuration Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/aidomx/vimconfig.git"
INSTALL_DIR="${HOME}/.local/vim"
VIMRC_PATH="${HOME}/.vimrc"
VCFG_BIN="/usr/bin/vcfg"

# ============================================
# Utility Functions
# ============================================

print_success() {
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

print_header() {
  echo ""
  echo -e "${CYAN}================================${NC}"
  echo -e "${WHITE}$1${NC}"
  echo -e "${CYAN}================================${NC}"
}

print_banner() {
  echo -e "${CYAN}"
  cat << "EOF"
 _   ___            ____             __ _       
| | | (_)_ __ ___  / ___|___  _ __  / _(_) __ _ 
| | | | | '_ ` _ \| |   / _ \| '_ \| |_| |/ _` |
| |_| | | | | | | | |__| (_) | | | |  _| | (_| |
 \___/|_|_| |_| |_|\____\___/|_| |_|_| |_|\__, |
                                          |___/ 
EOF
  echo -e "${NC}"
  echo -e "${WHITE}Full-Stack Development Environment${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

# ============================================
# Check Functions
# ============================================

check_dependencies() {
  print_header "Checking Dependencies"

  local missing_deps=()

  # Essential dependencies
  local deps=("git" "curl" "vim")

  for dep in "${deps[@]}"; do
    if command -v "$dep" &> /dev/null; then
      print_success "$dep is installed"
    else
      print_error "$dep is not installed"
      missing_deps+=("$dep")
    fi
  done

  if [ ${#missing_deps[@]} -gt 0 ]; then
    echo ""
    print_error "Missing dependencies: ${missing_deps[*]}"
    echo ""
    print_info "Please install missing dependencies first:"
    echo ""

    # Detect OS and show appropriate install command
    if [ -f /data/data/com.termux/files/usr/bin/pkg ]; then
      echo -e "  ${CYAN}pkg install ${missing_deps[*]}${NC}"
    elif command -v pacman &> /dev/null; then
      echo -e "  ${CYAN}sudo pacman -S ${missing_deps[*]}${NC}"
    elif command -v apt-get &> /dev/null; then
      echo -e "  ${CYAN}sudo apt-get install ${missing_deps[*]}${NC}"
    elif command -v yum &> /dev/null; then
      echo -e "  ${CYAN}sudo yum install ${missing_deps[*]}${NC}"
    else
      echo -e "  Install: ${missing_deps[*]}"
    fi

    exit 1
  fi
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

backup_existing() {
  local backup_dir="${INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"

  print_info "Creating backup at: $backup_dir"
  mv "$INSTALL_DIR" "$backup_dir"

  if [ -f "$VIMRC_PATH" ] && [ ! -L "$VIMRC_PATH" ]; then
    cp "$VIMRC_PATH" "${VIMRC_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
    print_success "Backed up existing .vimrc"
  fi

  print_success "Backup created successfully"
}

update_existing() {
  print_header "Updating Existing Installation"

  cd "$INSTALL_DIR"

  print_info "Fetching latest changes..."
  git fetch origin

  print_info "Pulling updates..."
  git pull origin main

  print_success "Configuration updated successfully!"

  # Update vcfg if needed
  if [ -f "$INSTALL_DIR/vcfg.sh" ]; then
    print_info "Updating vcfg..."
    install_vcfg
  fi

  print_success "Update completed!"
}

# ============================================
# Installation Functions
# ============================================

clone_repository() {
  print_header "Installing Vim Configuration"

  print_info "Cloning repository..."

  if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
  fi

  git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"

  print_success "Repository cloned successfully"
}

setup_vimrc() {
  print_info "Setting up .vimrc..."

  # Remove existing .vimrc if it's a regular file
  if [ -f "$VIMRC_PATH" ] && [ ! -L "$VIMRC_PATH" ]; then
    rm -f "$VIMRC_PATH"
  fi

  # Create symlink
  ln -sf "${INSTALL_DIR}/init.vim" "$VIMRC_PATH"

  print_success ".vimrc symlink created"
}

install_vim_plug() {
  print_header "Installing Vim-Plug"

  local plug_path="${HOME}/.vim/autoload/plug.vim"

  if [ -f "$plug_path" ]; then
    print_warning "Vim-Plug already installed"
    return
  fi

  print_info "Downloading vim-plug..."

  curl -fLo "$plug_path" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  print_success "Vim-Plug installed successfully"
}

install_plugins() {
  print_header "Installing Vim Plugins"

  print_info "This may take a few minutes..."
  echo ""

  # Install plugins silently
  vim -u "$VIMRC_PATH" -c 'PlugInstall' -c 'qa!' > /dev/null 2>&1

  print_success "Plugins installed successfully"
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

# ============================================
# Post-Installation
# ============================================

show_next_steps() {
  print_header "Installation Complete!"

  echo ""
  echo -e "${GREEN}✓ Vim configuration installed successfully!${NC}"
  echo ""
  echo -e "${WHITE}Next Steps:${NC}"
  echo ""
  echo -e "  ${CYAN}1.${NC} Open Vim to start using your new configuration:"
  echo -e "     ${YELLOW}vim${NC}"
  echo ""
  echo -e "  ${CYAN}2.${NC} Use vcfg to manage plugins:"
  echo -e "     ${YELLOW}vcfg list${NC}          - List all plugins"
  echo -e "     ${YELLOW}vcfg add <plugin>${NC}  - Add new plugin"
  echo -e "     ${YELLOW}vcfg update${NC}        - Update all plugins"
  echo -e "     ${YELLOW}vcfg --help${NC}        - Show all commands"
  echo ""
  echo -e "  ${CYAN}3.${NC} Install Coc extensions (optional):"
  echo -e "     Open Vim and run:"
  echo -e "     ${YELLOW}:CocInstall coc-tsserver coc-json coc-prettier${NC}"
  echo ""
  echo -e "${WHITE}Documentation:${NC}"
  echo -e "  ${BLUE}https://github.com/aidomx/vimconfig${NC}"
  echo ""
  echo -e "${WHITE}Enjoy coding! 🚀${NC}"
  echo ""
}

# ============================================
# Main Installation Flow
# ============================================

main() {
  clear
  print_banner

  # Pre-installation checks
  check_dependencies
  check_existing_installation

  # Installation steps
  clone_repository
  setup_vimrc
  install_vim_plug
  install_plugins
  install_vcfg

  # Optional setup
  setup_optional_tools

  # Completion
  show_next_steps
}

# Run installer
main "$@"
