#!/usr/bin/env bash

# Load help modules
for help_file in "${VCFG_ROOT}/commands/help"/*.sh; do
  source "$help_file"
done

show_general_help() {
  echo ""
  echo -e "${WHITE}USAGE:${NC}"
  echo "  vcfg <command> [arguments]"
  echo ""
  help_core_commands
  echo ""
  help_settings_commands
  echo ""
  help_mappings_commands
  echo ""
  help_utility_commands
  echo ""
  help_examples
  echo ""
  echo -e "Run ${CYAN}vcfg help <command>${NC} for detailed help"
}

show_detailed_help() {
  local command=${1:-}

  if [ -n "$command" ]; then
    # Try each help module
    help_core_detailed "$command"
    help_settings_detailed "$command"
    help_mappings_detailed "$command"
    help_utility_detailed "$command"
    help_coc_detailed "$command"
  else
    # If no module handled it
    print_error "No detailed help available for: $command"
    echo ""
    echo -e "Run ${CYAN}vcfg help${NC} to see all available commands."
    return 1
  fi
}

vcfg_cmd_help() {
  if [ $# -eq 0 ]; then
    # General help (default)
    echo -e "${CYAN}vcfg${NC} - Vim Configuration Manager"
    show_general_help
    return 0
  fi

  show_detailed_help "$1"
}
