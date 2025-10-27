#!/usr/bin/env bash
# Vim Configuration Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash

# Set strict-ish mode
set -euo pipefail

# Load libs (adjust path if script installed elsewhere)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libs
# colors -> logging -> fs/execs -> spinner
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
