#!/usr/bin/env bash

print_success() { echo -e "${GREEN}✓${NC} $*"; }
print_error()   { echo -e "${RED}✗${NC} $*" >&2; }
print_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
print_info()    { echo -e "${BLUE}ℹ${NC} $*"; }

print_header() {
  local title="$*"
  echo -e "${CYAN}$(printf '=%.0s' {1..58})${NC}"
  echo -e "${WHITE}${title}${NC}"
  echo -e "${CYAN}$(printf '=%.0s' {1..58})${NC}"
}
