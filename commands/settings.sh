#!/usr/bin/env bash

vcfg_cmd_set() {
  if [ $# -eq 0 ]; then
    print_error "Usage: vcfg set <setting> [value]"
    echo ""
    echo "Examples:"
    echo "  vcfg set number                  # Enable line numbers"
    echo "  vcfg set nonumber               # Disable line numbers"
    echo "  vcfg set tabstop 4              # Set tab to 4 spaces"
    echo "  vcfg set syntax on              # Enable syntax highlighting"
    echo "  vcfg set -e                     # Open settings in editor"
    echo "  vcfg set list                   # Show available settings"
    echo ""
    echo "Run 'vcfg set list' to see all available settings"
    return 1
  fi

  local setting=$1
  local value=${2:-}
  local settings_file="${VCFG_ROOT:-$HOME/.config/vim}/core/settings.vim"

  if [ ! -f "$settings_file" ]; then
    print_error "Settings file not found: $settings_file"
    return 1
  fi

  case "$setting" in
    "-e" | "--edit")
      edit_settings_file "$settings_file"
      ;;
    "list")
      show_available_settings
      ;;
    "show" | "current")
      show_current_settings "$settings_file"
      ;;
    "number" | "nonumber")
      toggle_setting "number" "$setting" "$settings_file"
      ;;
    "relativenumber" | "norelativenumber")
      toggle_setting "relativenumber" "$setting" "$settings_file"
      ;;
    "syntax" | "nosyntax")
      toggle_setting "syntax" "$setting" "$settings_file"
      ;;
    "cursorline" | "nocursorline")
      toggle_setting "cursorline" "$setting" "$settings_file"
      ;;
    "hlsearch" | "nohlsearch")
      toggle_setting "hlsearch" "$setting" "$settings_file"
      ;;
    "incsearch" | "noincsearch")
      toggle_setting "incsearch" "$setting" "$settings_file"
      ;;
    "ignorecase" | "noignorecase")
      toggle_setting "ignorecase" "$setting" "$settings_file"
      ;;
    "smartcase" | "nosmartcase")
      toggle_setting "smartcase" "$setting" "$settings_file"
      ;;
    "tabstop")
      if [ -z "$value" ] || ! [[ "$value" =~ ^[0-9]+$ ]]; then
        print_error "Usage: vcfg set tabstop <number>"
        return 1
      fi
      set_numeric_setting "tabstop" "$value" "$settings_file"
      ;;
    "shiftwidth")
      if [ -z "$value" ] || ! [[ "$value" =~ ^[0-9]+$ ]]; then
        print_error "Usage: vcfg set shiftwidth <number>"
        return 1
      fi
      set_numeric_setting "shiftwidth" "$value" "$settings_file"
      ;;
    "expandtab" | "noexpandtab")
      toggle_setting "expandtab" "$setting" "$settings_file"
      ;;
    *)
      print_error "Unknown setting: $setting"
      echo "Run 'vcfg set list' to see available settings"
      return 1
      ;;
  esac
}

edit_settings_file() {
  local settings_file=$1
  local editor="${EDITOR:-vim}"

  print_info "Opening settings file in editor: $settings_file"
  echo ""
  echo -e "${CYAN}Quick tips:${NC}"
  echo "  • Use 'set option' to enable a setting"
  echo "  • Use 'set nooption' to disable a setting"
  echo "  • Use 'set option=value' for numeric values"
  echo "  • Save and quit to apply changes"
  echo ""

  # Backup before editing
  local backup_dir="${VCFG_ROOT:-$HOME/.config/vim}/backups"
  mkdir -p "$backup_dir"
  local backup_file="${backup_dir}/settings.$(date +%Y%m%d_%H%M%S).vim"
  cp "$settings_file" "$backup_file"
  print_success "Backup created: $(basename "$backup_file")"

  # Open in editor
  $editor "$settings_file"

  # Verify the file still exists and is readable
  if [ ! -f "$settings_file" ]; then
    print_error "Settings file was deleted! Restoring from backup..."
    cp "$backup_file" "$settings_file"
    return 1
  fi

  print_success "Settings updated successfully!"
  echo -e "Run ${CYAN}vcfg set show${NC} to view current settings"
}

show_current_settings() {
  local settings_file=$1

  print_header "Current Settings"

  if [ ! -f "$settings_file" ]; then
    print_error "Settings file not found"
    return 1
  fi

  # Extract and display current settings in a nice format
  echo -e "${WHITE}Current configuration:${NC}"
  echo ""

  # Basic settings
  local basic_settings=$(grep "^set" "$settings_file" | head -20)
  if [ -n "$basic_settings" ]; then
    echo -e "${CYAN}Basic Settings:${NC}"
    echo "$basic_settings" | while read -r line; do
      echo "  $line"
    done
    echo ""
  fi

  # Search settings
  local search_settings=$(grep -E "set (no)?(hlsearch|incsearch|ignorecase|smartcase)" "$settings_file")
  if [ -n "$search_settings" ]; then
    echo -e "${CYAN}Search Settings:${NC}"
    echo "$search_settings" | while read -r line; do
      echo "  $line"
    done
    echo ""
  fi

  # Indentation settings
  local indent_settings=$(grep -E "set (tabstop|shiftwidth|expandtab)" "$settings_file")
  if [ -n "$indent_settings" ]; then
    echo -e "${CYAN}Indentation Settings:${NC}"
    echo "$indent_settings" | while read -r line; do
      echo "  $line"
    done
    echo ""
  fi

  print_info "Total settings: $(grep -c "^set" "$settings_file" 2> /dev/null || echo 0)"
}

show_available_settings() {
  print_header "Available Settings"

  echo -e "${WHITE}Basic UI:${NC}"
  echo "  number|nonumber           - Line numbers"
  echo "  relativenumber|norelativenumber - Relative line numbers"
  echo "  cursorline|nocursorline   - Highlight current line"
  echo "  syntax|nosyntax           - Syntax highlighting"
  echo ""

  echo -e "${WHITE}Indentation:${NC}"
  echo "  tabstop <n>               - Spaces per tab (e.g., vcfg set tabstop 4)"
  echo "  shiftwidth <n>            - Indent size (e.g., vcfg set shiftwidth 2)"
  echo "  expandtab|noexpandtab     - Use spaces instead of tabs"
  echo ""

  echo -e "${WHITE}Search:${NC}"
  echo "  hlsearch|nohlsearch       - Highlight search results"
  echo "  incsearch|noincsearch     - Incremental search"
  echo "  ignorecase|noignorecase   - Case insensitive search"
  echo "  smartcase|nosmartcase     - Smart case search"
  echo ""

  echo -e "${WHITE}Editor:${NC}"
  echo "  -e, --edit                - Open settings in editor"
  echo "  show, current             - Show current settings"
  echo "  list                      - Show this help"
  echo ""

  print_info "Usage: vcfg set <setting> [value]"
}

toggle_setting() {
  local setting_name=$1
  local setting_value=$2
  local settings_file=$3

  # Convert to Vim format
  local vim_setting="set ${setting_value}"

  # Check if setting already exists
  if grep -q "^[[:space:]]*set[[:space:]]\+${setting_name}" "$settings_file" 2> /dev/null; then
    # Replace existing setting
    sed -i "s/^[[:space:]]*set[[:space:]]\+${setting_name}.*/$vim_setting/" "$settings_file"
    print_success "Updated: $vim_setting"
  else
    # Add new setting at the end of basic settings section
    sed -i "/^\" ---------------------------$/a $vim_setting" "$settings_file"
    print_success "Added: $vim_setting"
  fi
}

set_numeric_setting() {
  local setting_name=$1
  local value=$2
  local settings_file=$3

  local vim_setting="set ${setting_name}=${value}"

  # Check if setting already exists
  if grep -q "^[[:space:]]*set[[:space:]]\+${setting_name}=" "$settings_file" 2> /dev/null; then
    # Replace existing setting
    sed -i "s/^[[:space:]]*set[[:space:]]\+${setting_name}=.*/$vim_setting/" "$settings_file"
    print_success "Updated: $vim_setting"
  else
    # Add new setting
    sed -i "/^\" ---------------------------$/a $vim_setting" "$settings_file"
    print_success "Added: $vim_setting"
  fi
}
