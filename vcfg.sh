#!/usr/bin/env bash

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
  # Each command file defines vcfg_cmd_<name>
  source "$f"
done

VCFG_VERSION="1.0.0"

main() {
  if [ $# -eq 0 ]; then
    vcfg_cmd_help || true
    exit 0
  fi

  local cmd=$1; shift

  case "${cmd}" in
    add)      vcfg_cmd_add "$@" ;;
    remove)   vcfg_cmd_remove "$@" ;;
    enable)   vcfg_cmd_enable "$@" ;;
    disable)  vcfg_cmd_disable "$@" ;;
    list)     vcfg_cmd_list "$@" ;;
    search)   vcfg_cmd_search "$@" ;;
    update)   vcfg_cmd_update "$@" ;;
    clean)    vcfg_cmd_clean "$@" ;;
    info)     vcfg_cmd_info "$@" ;;
    install)  vcfg_cmd_install "$@" ;;
    --version|-v) vcfg_cmd_version $VCFG_VERSION ;;
    --help|-h|help) vcfg_cmd_help ;;
    *) print_error "Unknown command: ${cmd}" ; exit 1 ;;
  esac
}

main "$@"
