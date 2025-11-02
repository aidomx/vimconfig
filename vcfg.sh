#!/usr/bin/env bash

# Set strict-ish mode
set -euo pipefail

DEV_MODE="${VCFG_DEV_MODE:-0}"

# Load libs (adjust path if script installed elsewhere)
VCFG_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $DEV_MODE -eq 0 ] && command -v vcfg > /dev/null 2>&1; then
  VCFG_ROOT="$HOME/.config/vim"
fi

# Source libs
source "${VCFG_ROOT}/lib/paths.sh"
source "${VCFG_ROOT}/lib/fs.sh"
source "${VCFG_ROOT}/lib/colors.sh"
source "${VCFG_ROOT}/lib/logging.sh"
source "${VCFG_ROOT}/lib/execs.sh"
source "${VCFG_ROOT}/lib/progress.sh"

# Source command implementations
for f in "${VCFG_ROOT}/commands"/*.sh; do
  source "$f"
done

export VCFG_VERSION="1.0.0"

main() {
  if [ $# -eq 0 ]; then
    vcfg_cmd_help || true
    exit 0
  fi

  local cmd=$1
  shift

  case "${cmd}" in
    add) vcfg_cmd_add "$@" ;;
    backup) vcfg_cmd_backup "$@" ;;
    restore) vcfg_cmd_restore "$@" ;;
    remove | rm) vcfg_cmd_remove "$@" ;;
    enable) vcfg_cmd_enable "$@" ;;
    disable) vcfg_cmd_disable "$@" ;;
    doctor) vcfg_cmd_doctor "$@" ;;
    install) vcfg_cmd_install "$@" ;;
    list | ls) vcfg_cmd_list "$@" ;;
    set) vcfg_cmd_set "$@" ;;
    reset) vcfg_cmd_reset "$@" ;;
    search) vcfg_cmd_search "$@" ;;
    update) vcfg_cmd_update "$@" ;;
    system-update) vcfg_cmd_system_update "$@" ;;
    reinstall) vcfg_cmd_reinstall "$@" ;;
    clean) vcfg_cmd_clean "$@" ;;
    coc) vcfg_cmd_coc "$@" ;;
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
