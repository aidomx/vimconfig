#!/usr/bin/env bash

# Set strict-ish mode
set -euo pipefail

# Gunakan environment variable, default ke production
DEV_MODE="${VCFG_DEV_MODE:-0}"

# Load libs (adjust path if script installed elsewhere)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Jika production mode dan vcfg sudah terinstall, gunakan install directory
if [ $DEV_MODE -eq 0 ] && command -v vcfg > /dev/null 2>&1; then
  SCRIPT_DIR="$HOME/.config/vim"
fi

# Source libs
source "${SCRIPT_DIR}/lib/colors.sh"
source "${SCRIPT_DIR}/lib/logging.sh"
source "${SCRIPT_DIR}/lib/fs.sh"
source "${SCRIPT_DIR}/lib/execs.sh"
source "${SCRIPT_DIR}/lib/progress.sh"

# Source command implementations
for f in "${SCRIPT_DIR}/commands"/*.sh; do
  source "$f"
done

VCFG_VERSION="1.0.0"

main() {
  if [ $# -eq 0 ]; then
    vcfg_cmd_help || true
    exit 0
  fi

  local cmd=$1
  shift

  case "${cmd}" in
    add) vcfg_cmd_add "$@" ;;
    remove | rm) vcfg_cmd_remove "$@" ;;
    enable) vcfg_cmd_enable "$@" ;;
    disable) vcfg_cmd_disable "$@" ;;
    doctor) vcfg_cmd_doctor "$@" ;;
    install) vcfg_cmd_install "$@" ;;
    list | ls) vcfg_cmd_list "$@" ;;
    search) vcfg_cmd_search "$@" ;;
    update) vcfg_cmd_update "$@" ;;
    system-update) vcfg_cmd_system_update "$@" ;;
    reinstall) vcfg_cmd_reinstall "$@" ;;
    clean) vcfg_cmd_clean "$@" ;;
    info) vcfg_cmd_info "$@" ;;
    editmap) vcfg_cmd_editmap "$@" ;;
    --version | -v) vcfg_cmd_version "$VCFG_VERSION" ;;
    --help | -h | help) vcfg_cmd_help "$@" ;;
    *)
      print_error "Unknown command: ${cmd}"
      echo ""
      echo -e "Run ${CYAN}vcfg help${NC} to see available commands"
      exit 1
      ;;
  esac
}

main "$@"
