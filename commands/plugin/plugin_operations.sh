#!/usr/bin/env bash

install_with_manager() {
  local plugin=$1
  local manager=$2

  # print_info "Installing plugin: $plugin"

  case "$manager" in
    "vim-plug")
      (vim -c 'PlugInstall' -c 'qa!' > /dev/null 2>&1) &
      local pid=$!
      show_percentage_progress $pid "Installing with vim-plug"
      wait $pid 2> /dev/null || true
      ;;

    "packer.nvim")
      (nvim --headless -c "PackerSync" -c "qa!" > /dev/null 2>&1) &
      local pid=$!
      show_percentage_progress $pid "Installing with packer.nvim"
      wait $pid 2> /dev/null || true
      ;;

    "lazy.nvim")
      (nvim --headless -c "Lazy sync" -c "qa!" > /dev/null 2>&1) &
      local pid=$!
      show_percentage_progress $pid "Installing with lazy.nvim"
      wait $pid 2> /dev/null || true
      ;;

    *)
      print_warning "Unknown plugin manager, skipping installation"
      return 1
      ;;
  esac

  print_success "Plugin installation completed"
}

plugin_exists() {
  local plugin=$1
  local config_file=$2
  local manager=$(detect_plugin_manager)

  # Load add modules untuk normalization functions
  if [ -f "${VCFG_ROOT}/commands/add/add_detection.sh" ]; then
    source "${VCFG_ROOT}/commands/add/add_detection.sh"
  fi

  # Normalize plugin untuk comparison konsisten
  local plugin_type=$(detect_plugin_type "$plugin" "")
  local normalized_plugin=$(normalize_plugin_name "$plugin" "$plugin_type")

  # Untuk GitHub plugins, bandingkan dalam format username/repo
  local search_pattern
  case "$plugin_type" in
    "github" | "git")
      if [[ "$normalized_plugin" =~ ^https:// ]]; then
        search_pattern=$(basename "$(dirname "$normalized_plugin")")/$(basename "$normalized_plugin" .git)
      else
        search_pattern="$normalized_plugin"
      fi
      ;;
    *)
      search_pattern="$normalized_plugin"
      ;;
  esac

  case "$manager" in
    "vim-plug")
      grep -q "Plug.*${search_pattern}" "$config_file" 2> /dev/null
      ;;
    "packer.nvim")
      grep -q "use.*${search_pattern}" "$config_file" 2> /dev/null
      ;;
    "lazy.nvim")
      grep -q "\"${search_pattern}\"" "$config_file" 2> /dev/null
      ;;
    *)
      return 1
      ;;
  esac
}

update_plugins() {
  local manager=$1

  print_info "Updating plugins with $(get_plugin_manager_name "$manager")"

  case "$manager" in
    "vim-plug")
      (vim -c 'PlugUpdate' -c 'qa!' > /dev/null 2>&1) &
      local pid=$!
      show_percentage_progress $pid "Updating vim-plug plugins"
      wait $pid
      ;;

    "packer.nvim")
      (nvim --headless -c "PackerSync" -c "qa!" > /dev/null 2>&1) &
      local pid=$!
      show_percentage_progress $pid "Updating packer.nvim plugins"
      wait $pid
      ;;

    "lazy.nvim")
      (nvim --headless -c "Lazy update" -c "qa!" > /dev/null 2>&1) &
      local pid=$!
      show_percentage_progress $pid "Updating lazy.nvim plugins"
      wait $pid
      ;;
  esac

  print_success "Plugins updated successfully"
}
