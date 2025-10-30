#!/usr/bin/env bash
# Vim Configuration Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash

# Set strict-ish mode
set -euo pipefail

# Determine if running remotely
if [[ "${BASH_SOURCE[0]:-}" == "" ]]; then
  IS_REMOTE=1
else
  IS_REMOTE=0
fi

# For remote execution, download dependencies first
if [[ $IS_REMOTE -eq 1 ]]; then
  echo "Remote execution detected. Downloading dependencies..."

  # Create temp directory
  temp_dir=$(mktemp -d)

  # Auto-handle existing installation for remote
  if [[ -f "$HOME/.vimrc" ]] || [[ -d "$HOME/.vim/plugged" ]] || [[ -d "$HOME/.config/vim" ]]; then
    echo "Existing installation found. Creating backup..."
    backup_dir="$HOME/.vimbackup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"

    [[ -f "$HOME/.vimrc" ]] && mv "$HOME/.vimrc" "$backup_dir/"
    [[ -d "$HOME/.vim" ]] && mv "$HOME/.vim" "$backup_dir/" 2> /dev/null || true
    [[ -d "$HOME/.config/vim" ]] && mv "$HOME/.config/vim" "$backup_dir/" 2> /dev/null || true

    echo "Backup created: $backup_dir"
  fi

  # Download the entire repo
  echo "Cloning repository to temporary directory..."
  if ! git clone -q https://github.com/aidomx/vimconfig.git "$temp_dir"; then
    echo "Error: Failed to clone repository"
    exit 1
  fi

  # Change to the temp directory and re-execute the script locally
  cd "$temp_dir"
  exec bash "./install.sh"
fi

# Load libs (adjust path if script installed elsewhere)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libs
source "${SCRIPT_DIR}/lib/colors.sh"
source "${SCRIPT_DIR}/lib/logging.sh"
source "${SCRIPT_DIR}/lib/fs.sh"
source "${SCRIPT_DIR}/lib/execs.sh"
source "${SCRIPT_DIR}/lib/spinner.sh"

# Source command implementations
for f in "${SCRIPT_DIR}/commands"/*.sh; do
  source "$f"
done

# ============================================
# Main Installation Flow
# ============================================

main() {
  clear
  vcfg_banner

  # Pre-installation checks
  check_dependencies

  # For remote execution, backup already handled
  if [[ $IS_REMOTE -eq 0 ]]; then
    check_existing_installation
  fi

  # Installation steps
  clone_repository
  setup_vimrc
  install_plugin_manager
  if [[ ! -d "$HOME/.fzf" ]]; then
    print_info "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-zsh --no-fish
    print_success "fzf installed"
  else
    print_info "fzf already installed"
  fi

  install_plugins
  install_vcfg

  # Optional setup
  setup_optional_tools

  # Completion
  show_next_steps
}

# Run installer
main "$@"
