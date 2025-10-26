#!/use/bin/env bash

vcfg_banner() {
  echo -e "${CYAN}"
  cat << "EOF"
 _   ___            ____             __ _
| | | (_)_ __ ___  / ___|___  _ __  / _(_) __ _
| | | | | '_ ` _ \| |   / _ \| '_ \| |_| |/ _` |
| |_| | | | | | | | |__| (_) | | | |  _| | (_| |
 \___/|_|_| |_| |_|\____\___/|_| |_|_| |_|\__, |
                                          |___/
EOF
  echo -e "${NC}"
  echo -e "${WHITE}Full-Stack Development Environment${NC}"
  echo -e "${CYAN}$(printf '━%.0s' {1..58})${NC}"
  echo ""
}
