#!/usr/bin/env bash

help_mappings_commands() {
  echo -e "${WHITE}MAPPING COMMANDS:${NC}"
  echo -e "  ${GREEN}editmap${NC}               Interactive mapping editor"
  echo -e "  ${GREEN}editmap list${NC}          Show mappings"
  echo -e "  ${GREEN}editmap add${NC} <k> <a>   Add mapping"
  echo -e "  ${GREEN}editmap remove${NC} <pat>  Remove mapping"
  echo -e "  ${GREEN}editmap search${NC} <pat>  Search mappings"
}

help_mappings_detailed() {
  case "$1" in
    editmap)
      echo -e "${CYAN}vcfg editmap${NC} - Manage Vim mappings"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg editmap                    # Interactive mode"
      echo "  vcfg editmap list               # Show all mappings"
      echo "  vcfg editmap add <key> <action> # Add mapping"
      echo "  vcfg editmap remove <pattern>   # Remove mapping"
      echo "  vcfg editmap search <pattern>   # Search mappings"
      echo "  vcfg editmap edit               # Open in editor"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Interactive tool for managing Vim/Neovim key mappings."
      echo "  Edit mappings without manually editing config files."
      echo ""
      echo -e "${WHITE}MAPPING TYPES:${NC}"
      echo "  Normal mode:    <leader>ff ':Files<CR>'"
      echo "  Insert mode:    i:jk '<Esc>'  (prefix with i:)"
      echo "  Visual mode:    v:<leader>y '\"+y'  (prefix with v:)"
      echo "  Visual+Select:  x:<leader>p '\"+p'  (prefix with x:)"
      ;;
  esac
}
