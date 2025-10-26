#!/usr/bin/env bash

check_dependencies() {
  print_header "Checking Dependencies"

  local missing_deps=()

  # Essential dependencies
  local deps=("git" "curl" "vim")

  for dep in "${deps[@]}"; do
    if command -v "$dep" &> /dev/null; then
      echo -ne " "
      print_success "$dep is installed"
    else
      echo -ne " "
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
