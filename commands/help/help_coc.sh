#!/usr/bin/env bash

help_coc_detailed() {
  case "$1" in
    coc)
      echo -e "${CYAN}vcfg coc${NC} - Manage Coc.nvim extensions"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg coc <command> [extension]"
      echo ""
      echo -e "${WHITE}COMMANDS:${NC}"
      echo "  list                      - List installed Coc extensions"
      echo "  add <extension>           - Add Coc extension"
      echo "  remove <extension>        - Remove Coc extension"
      # echo "  install                   - Install all extensions"
      echo "  update                    - Update all extensions"
      echo "  -e, --edit                - Edit coc.vim manually"
      echo "  show                      - Show current extensions"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Manage Coc.nvim language server extensions easily."
      echo "  Configure extensions in core/coc.vim and install them."
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vcfg coc add coc-tsserver        # Add TypeScript support"
      echo "  vcfg coc add coc-pyright         # Add Python support"
      echo "  vcfg coc remove coc-python       # Remove Python extension"
      echo "  vcfg coc list                    # List all extensions"
      # echo "  vcfg coc install                 # Install all extensions"
      echo "  vcfg coc update                  # Update extensions"
      echo ""
      echo -e "${WHITE}POPULAR EXTENSIONS:${NC}"
      echo "  • coc-tsserver      - TypeScript/JavaScript"
      echo "  • coc-pyright       - Python"
      echo "  • coc-clangd        - C/C++"
      echo "  • coc-go            - Go"
      echo "  • coc-html          - HTML"
      echo "  • coc-css           - CSS"
      echo "  • coc-json          - JSON"
      echo "  • coc-prettier      - Prettier formatting"
      ;;
  esac
}
