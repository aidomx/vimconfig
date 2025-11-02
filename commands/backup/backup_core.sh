#!/usr/bin/env bash

create_backup_archive() {
  local output_file=$1

  local temp_dir=$(mktemp -d)
  local items=($(get_backup_items))
  local existing_items=($(filter_existing_items "${items[@]}"))

  # Create manifest
  get_backup_manifest "$temp_dir" "${existing_items[@]}"

  # Copy items to temp directory
  for item in "${existing_items[@]}"; do
    if [ -e "$item" ]; then
      local backup_name=$(get_backup_item_name "$item")
      cp -r "$item" "${temp_dir}/${backup_name}" 2> /dev/null || true
    fi
  done

  # Create tar archive
  cd "$temp_dir" && tar -czf "$output_file" ./

  # Cleanup
  rm -rf "$temp_dir"
}

restore_backup_archive() {
  local backup_file=$1

  local temp_dir=$(mktemp -d)

  # Extract to temporary directory
  cd "$temp_dir" && tar -xzf "$backup_file"

  # Restore items to their original locations
  for item in *; do
    case "$item" in
      "vcfg_config")
        rm -rf "${VCFG_ROOT}"
        cp -r "$item" "${VCFG_ROOT}"
        ;;
      "vimrc")
        cp "$item" "${HOME}/.vimrc"
        ;;
      "vim_"*)
        mkdir -p "${HOME}/.vim"
        cp -r "$item" "${HOME}/.vim/${item#vim_}"
        ;;
      "config_"*)
        mkdir -p "${HOME}/.config"
        cp -r "$item" "${HOME}/.config/${item#config_}"
        ;;
      "local_"*)
        mkdir -p "${HOME}/.local"
        cp -r "$item" "${HOME}/.local/${item#local_}"
        ;;
    esac
  done

  # Cleanup
  rm -rf "$temp_dir"
}
