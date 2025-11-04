#!/usr/bin/env bash

check_coc_extensions() {
  local coc_file=${1:-}
  local extensions=$(extract_coc_extensions "$coc_file")

  if [ -z "$extensions" ]; then
    echo -e "No extensions installed"
    return 0
  fi
  echo "$extensions"
}

check_coc_extensions_access() {
  local coc_extensions_dir="${VCFG_COC_EXTENSIONS:-${HOME}/.config/coc/extensions}"
  mkdir -p "$coc_extensions_dir"

  cd "$coc_extensions_dir" || {
    print_error "Cannot access Coc extensions directory"
    return 1
  }
}
