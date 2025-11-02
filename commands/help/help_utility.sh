#!/usr/bin/env bash

help_utility_commands() {
  echo -e "${WHITE}UTILITY COMMANDS:${NC}"
  echo -e "  ${GREEN}search${NC} <query>        Search plugins"
  echo -e "  ${GREEN}install${NC}               Install/update vcfg"
  echo -e "  ${GREEN}doctor${NC}                System health check"
  echo -e "  ${GREEN}backup${NC} [output]       Backup configuration"
  echo -e "  ${GREEN}restore${NC} <file>        Restore from backup"
  echo -e "  ${GREEN}version${NC}               Show version"
  echo -e "  ${GREEN}help${NC}                  Show this help"
}

help_utility_detailed() {
  case "$1" in
    backup)
      echo -e "${CYAN}vcfg backup${NC} - Backup Vim configuration"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg backup [output-file]"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Creates a complete backup of your Vim configuration including:"
      echo "  • VCFG configuration files"
      echo "  • .vimrc"
      echo "  • Installed plugins"
      echo "  • Coc extensions and settings"
      echo "  • Neovim configuration (if exists)"
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vcfg backup                          # Auto-generated filename"
      echo "  vcfg backup ~/vim-backup.tar.gz      # Custom location"
      echo "  vcfg backup ./backup-$(date +%Y%m%d).tar.gz"
      ;;

    restore)
      echo -e "${CYAN}vcfg restore${NC} - Restore Vim configuration"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg restore <backup-file>"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Restores Vim configuration from a previous backup."
      echo "  Creates a backup of current configuration before restoring."
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vcfg restore ~/vim-backup.tar.gz"
      echo "  vcfg restore ./my-backup-20231201.tar.gz"
      echo ""
      echo -e "${WHITE}WARNING:${NC}"
      echo "  This will overwrite your current configuration!"
      ;;
  esac
}
