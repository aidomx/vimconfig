#!/usr/bin/env bash

vcfg_cmd_reset() {
  if [ $# -gt 0 ]; then
    case "$1" in
      "-h" | "--help")
        echo "Usage: vcfg reset [option]"
        echo ""
        echo "Options:"
        echo "  settings    - Reset only settings to defaults"
        echo "  plugins     - Reset only plugins to defaults"
        echo "  mappings    - Reset only key mappings to defaults"
        echo "  all         - Reset everything (default)"
        echo ""
        echo "Examples:"
        echo "  vcfg reset              # Reset everything"
        echo "  vcfg reset settings     # Reset only settings"
        echo "  vcfg reset plugins      # Reset only plugins"
        return 0
        ;;
    esac
  fi

  local reset_type=${1:-"all"}

  case "$reset_type" in
    "settings")
      reset_settings
      ;;
    "plugins")
      reset_plugins
      ;;
    "mappings")
      reset_mappings
      ;;
    "all")
      print_header "Resetting All Configuration"
      reset_settings
      reset_plugins
      reset_mappings
      print_success "Full configuration reset complete!"
      ;;
    *)
      print_error "Invalid reset type: $reset_type"
      echo "Run 'vcfg reset --help' for usage information"
      return 1
      ;;
  esac
}

reset_settings() {
  print_info "Resetting settings to defaults..."

  if [ -f "${VCFG_SETTINGS_DEFAULT}" ]; then
    backup_config_file "${VCFG_SETTINGS_FILE}"
    cp "${VCFG_SETTINGS_DEFAULT}" "${VCFG_SETTINGS_FILE}"
    print_success "Settings reset to defaults"
  else
    print_warning "Default settings file not found, keeping current settings"
  fi
}

reset_plugins() {
  print_info "Resetting plugins to defaults..."

  if [ -f "${VCFG_PLUGINS_DEFAULT}" ]; then
    backup_config_file "${VCFG_PLUGINS_FILE}"
    cp "${VCFG_PLUGINS_DEFAULT}" "${VCFG_PLUGINS_FILE}"
    print_success "Plugins reset to defaults"
  else
    print_warning "Default plugins file not found, keeping current plugins"
  fi
}

reset_mappings() {
  print_info "Resetting key mappings to defaults..."

  if [ -f "${VCFG_MAPPINGS_DEFAULT}" ]; then
    backup_config_file "${VCFG_MAPPINGS_FILE}"
    cp "${VCFG_MAPPINGS_DEFAULT}" "${VCFG_MAPPINGS_FILE}"
    print_success "Key mappings reset to defaults"
  else
    print_warning "Default mappings file not found, keeping current mappings"
  fi
}
