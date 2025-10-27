#!/usr/bin/env bash

vcfg_cmd_disable() {
  local plugin=$1

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to disable"
    echo "Usage: vcfg disable <plugin-name>"
    echo "       vcfg disable slow_plugins"
    return 1
  fi

  # Special case: disable slow plugins
  if [ "$plugin" = "slow_plugins" ]; then
    disable_slow_plugins
    return 0
  fi

  local plugin_manager=$(detect_plugin_manager)
  local config_file=$(get_plugin_config_file "$plugin_manager")

  if [ -z "$config_file" ] || [ ! -f "$config_file" ]; then
    print_error "No plugin manager configuration found"
    return 1
  fi

  print_info "Disabling plugin: ${CYAN}${plugin}${NC} in ${plugin_manager}"

  # Disable based on plugin manager
  case "$plugin_manager" in
    "vim-plug")
      disable_vimplug_plugin "$plugin" "$config_file"
      ;;
    "packer.nvim")
      disable_packer_plugin "$plugin" "$config_file"
      ;;
    "lazy.nvim")
      disable_lazy_plugin "$plugin" "$config_file"
      ;;
    *)
      print_error "Unsupported plugin manager: $plugin_manager"
      return 1
      ;;
  esac

  print_success "Plugin '${GREEN}${plugin}${NC}' disabled successfully!"
  print_info "Restart Vim/Neovim for changes to take effect"
}

disable_slow_plugins() {
  print_header "Disabling Slow Plugins"

  echo -e "${YELLOW}This will identify and disable plugins that may slow down Vim startup.${NC}"
  echo ""

  # List of commonly slow plugins (bisa disesuaikan)
  local slow_plugins=(
    "neoclide/coc.nvim"
    "phpactor/phpactor"
    "fatih/vim-go"
    "dense-analysis/ale"
    "ycm-core/YouCompleteMe"
    "prabirshrestha/async.vim"
    "prabirshrestha/vim-lsp"
    "jackguo380/vim-lsp-cxx-highlight"
    "octol/vim-cpp-enhanced-highlight"
    "bfrg/vim-cpp-modern"
    "vim-syntastic/syntastic"
    "ervandew/supertab"
    "Shougo/deoplete.nvim"
    "Shougo/neco-vim"
    "maralla/completor.vim"
  )

  local enabled_slow_plugins=()
  local plugin_manager=$(detect_plugin_manager)
  local config_file=$(get_plugin_config_file "$plugin_manager")

  if [ -z "$config_file" ] || [ ! -f "$config_file" ]; then
    print_error "No plugin manager configuration found"
    return 1
  fi

  print_info "Scanning for potentially slow plugins..."
  echo ""

  # Check which slow plugins are enabled
  for plugin in "${slow_plugins[@]}"; do
    local plugin_name="${plugin##*/}"

    case "$plugin_manager" in
      "vim-plug")
        if grep -q "^Plug.*${plugin}" "$config_file" 2> /dev/null; then
          enabled_slow_plugins+=("$plugin")
        fi
        ;;
      "packer.nvim")
        if grep -q "^[^--].*use.*${plugin}" "$config_file" 2> /dev/null; then
          enabled_slow_plugins+=("$plugin")
        fi
        ;;
      "lazy.nvim")
        if grep -q "^[^--].*{.*${plugin}.*}" "$config_file" 2> /dev/null; then
          enabled_slow_plugins+=("$plugin")
        fi
        ;;
    esac
  done

  if [ ${#enabled_slow_plugins[@]} -eq 0 ]; then
    print_success "No known slow plugins found enabled!"
    echo ""
    print_info "Your configuration looks optimized for speed."
    return 0
  fi

  echo -e "${YELLOW}Found ${#enabled_slow_plugins[@]} potentially slow plugins:${NC}"
  echo ""

  for plugin in "${enabled_slow_plugins[@]}"; do
    echo -e "  ${RED}●${NC} ${plugin}"
  done

  echo ""
  echo -e "${YELLOW}These plugins may slow down Vim startup:${NC}"
  echo -e "  ${CYAN}•${NC} Language servers (coc.nvim, phpactor, vim-go)"
  echo -e "  ${CYAN}•${NC} Heavy linters (ale, syntastic)"
  echo -e "  ${CYAN}•${NC} Complex completion engines (YouCompleteMe, deoplete)"
  echo -e "  ${CYAN}•${NC} Advanced syntax highlighters"
  echo ""

  read -p "Disable all these plugins? (y/N): " confirm

  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    print_info "No plugins were disabled."
    echo ""
    print_info "You can disable individual plugins with: ${CYAN}vcfg disable <plugin-name>${NC}"
    return 0
  fi

  # Disable all detected slow plugins
  local disabled_count=0
  for plugin in "${enabled_slow_plugins[@]}"; do
    case "$plugin_manager" in
      "vim-plug")
        disable_vimplug_plugin "$plugin" "$config_file"
        ;;
      "packer.nvim")
        disable_packer_plugin "$plugin" "$config_file"
        ;;
      "lazy.nvim")
        disable_lazy_plugin "$plugin" "$config_file"
        ;;
    esac
    disabled_count=$((disabled_count + 1))
  done

  print_success "Disabled ${disabled_count} slow plugins!"
  echo ""
  print_info "Restart Vim/Neovim to see the improvement in startup time."
  echo ""
  print_info "You can re-enable plugins later with: ${CYAN}vcfg enable <plugin-name>${NC}"
}

# Fungsi disable yang sudah ada (tetap dipertahankan)
disable_vimplug_plugin() {
  local plugin=$1
  local config_file=$2
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')

  if grep -q "^Plug.*${plugin}" "$config_file" 2> /dev/null; then
    # Comment out the plugin line
    sed -i "s/^\\(Plug.*${plugin_escaped}\\)/\" \\1/" "$config_file"
    print_success "Disabled: ${plugin}"
  else
    print_warning "Plugin '${plugin}' is already disabled or not found"
  fi
}

disable_packer_plugin() {
  local plugin=$1
  local config_file=$2
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')

  if grep -q "^[^--].*use.*${plugin}" "$config_file" 2> /dev/null; then
    # Comment out the use statement
    sed -i "s/^\\(.*use.*${plugin_escaped}.*\\)/-- \\1/" "$config_file"
    print_success "Disabled: ${plugin}"
  else
    print_warning "Plugin '${plugin}' is already disabled or not found"
  fi
}

disable_lazy_plugin() {
  local plugin=$1
  local config_file=$2
  local plugin_escaped=$(echo "$plugin" | sed 's/\//\\\//g')

  if grep -q "^[^--].*{.*${plugin}.*}" "$config_file" 2> /dev/null; then
    # Comment out the plugin entry
    sed -i "s/^\\(.*{.*${plugin_escaped}.*}.*\\)/-- \\1/" "$config_file"
    print_success "Disabled: ${plugin}"
  else
    print_warning "Plugin '${plugin}' is already disabled or not found"
  fi
}
