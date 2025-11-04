#!/usr/bin/env bash

add_coc_extension() {
  local extension=$1
  local coc_file=$2

  if grep -q "'$extension'" "$coc_file"; then
    print_warning "Extension already exists: $extension"
    return 0
  fi

  print_info "Adding extension: $extension"
  check_internet_connection

  # Show progress for rebuild process
  (
    local current_extensions=$(extract_coc_extensions "$coc_file")
    local all_extensions=$(echo "$current_extensions"$'\n'"$extension" | grep -v '^$' | sort | uniq)
    rebuild_coc_file "$coc_file" "$all_extensions"
  ) > /dev/null 2>&1 &

  local pid=$!
  progress "percent" $pid " - Adding to configuration"
  wait $pid

  sync_install_coc_extensions "$coc_file"
  verify_coc_installations "$(check_coc_extensions "$coc_file")"
}

remove_coc_extension() {
  local extension=$1
  local coc_file=$2

  if ! grep -q "'$extension'" "$coc_file" 2> /dev/null; then
    print_warning "Extension not found: $extension"
    return 0
  fi

  print_info "Removing extension: $extension"
  check_internet_connection

  (
    local current_extensions=$(extract_coc_extensions "$coc_file")
    local remaining_extensions=$(echo "$current_extensions" | grep -v "^${extension}$")
    rebuild_coc_file "$coc_file" "$remaining_extensions"
  ) > /dev/null 2>&1 &

  local pid=$!
  progress "percent" $pid " - Removing from configuration"
  wait $pid

  sync_uninstall_coc_extensions "$extension"
  verify_coc_installations "$(check_coc_extensions "$coc_file")"
}

update_coc_extensions() {
  local coc_file=$1

  check_coc_extensions_access
  print_info "Updating Coc extensions..."

  check_internet_connection

  echo -e " ${CYAN}- List Coc extension for update:${NC}"
  echo ""
  list_coc_update "$coc_file"

  # Show progress for update process
  (npm update > /dev/null 2>&1) &
  local pid=$!
  progress "percent" $pid " - Updating extensions"
  wait $pid

  verify_coc_update "$(check_coc_extensions "$coc_file")"
}
