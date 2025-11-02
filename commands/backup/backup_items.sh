#!/usr/bin/env bash

# Configuration for backup items
get_backup_items() {
  local items=(
    "${VCFG_ROOT}"
    "${HOME}/.vimrc"
    "${HOME}/.vim/plugged"
    "${HOME}/.config/coc"
    "${HOME}/.local/share/nvim"
    "${HOME}/.local/state/nvim"
  )
  echo "${items[@]}"
}

get_backup_item_name() {
  local item=$1
  case "$item" in
    "${VCFG_ROOT}") echo "vcfg_config" ;;
    "${HOME}/.vimrc") echo "vimrc" ;;
    "${HOME}/.vim/"*) echo "vim_$(basename "$item")" ;;
    "${HOME}/.config/"*) echo "config_$(basename "$item")" ;;
    "${HOME}/.local/"*) echo "local_$(basename "$item")" ;;
    *) echo "unknown_$(basename "$item")" ;;
  esac
}

filter_existing_items() {
  local items=("$@")
  local existing_items=()

  for item in "${items[@]}"; do
    if [ -e "$item" ]; then
      existing_items+=("$item")
    fi
  done

  echo "${existing_items[@]}"
}

get_backup_manifest() {
  local temp_dir=$1
  local items=("$@")

  cat > "${temp_dir}/backup_manifest.txt" << EOF
VCFG Backup Manifest
===================

Created: $(date)
VCFG Version: ${VCFG_VERSION}
Backup ID: $(date +%Y%m%d_%H%M%S)

Included Items:
EOF

  for item in "${items[@]}"; do
    if [ -e "$item" ]; then
      local size=$(du -sh "$item" 2> /dev/null | cut -f1 || echo "unknown")
      echo "- $(get_backup_item_name "$item") | $item | Size: $size" >> "${temp_dir}/backup_manifest.txt"
    fi
  done
}
