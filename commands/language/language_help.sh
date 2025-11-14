#!/usr/bin/env bash

show_language_help() {
  echo ""
  echo -e "${YELLOW}Available commands:${NC}"
  echo -e "  ${GREEN}add${NC}     <language>  - Add new language"
  echo -e "  ${GREEN}remove${NC}  <language>  - Remove language"
  echo -e "  ${GREEN}enable${NC}  <language>  - Enable disabled language"
  echo -e "  ${GREEN}disable${NC} <language>  - Disable language"
  echo -e "  ${GREEN}list${NC}                - List all language"
  echo -e "  ${GREEN}info${NC}    <language>  - Show language info"
  echo -e "  ${GREEN}edit${NC}                - Open in editor"
  echo -e "  ${GREEN}help${NC}                - Show help"
  echo -e "  ${GREEN}quit${NC}                - Exit"
  echo ""
}

detail_language_help() {
  echo -e "${CYAN}vcfg lang${NC} - Language manager and Interactive"
  echo ""
  echo -e "${WHITE}USAGE:${NC}"
  echo "  vcfg lang <command>"
  echo ""
  echo -e "${WHITE}AVAILABLE COMMAND:${NC}"
  echo -e "  ${GREEN}add${NC}     <language>  - Add new language"
  echo -e "  ${GREEN}remove${NC}  <language>  - Remove language"
  echo -e "  ${GREEN}enable${NC}  <language>  - Enable disabled language"
  echo -e "  ${GREEN}disable${NC} <language>  - Disable language"
  echo -e "  ${GREEN}list${NC}                - List all languages"
  echo -e "  ${GREEN}info${NC}    <language>  - Show language info"
  echo -e "  ${GREEN}edit${NC}                - Open in editor"
}
