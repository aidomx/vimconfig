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
  check_existing_installation

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

# Run installer
main "$@"
