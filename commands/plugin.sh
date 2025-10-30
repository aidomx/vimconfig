#!/usr/bin/env bash

detect_plugin_manager() {
  if [ -f "${HOME}/.vim/autoload/plug.vim" ] || [ -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    echo "vim-plug"
  elif [ -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    echo "packer.nvim"
  elif [ -d "${HOME}/.local/share/nvim/lazy/lazy.nvim" ]; then
    echo "lazy.nvim"
  else
    echo "unknown"
  fi
}

get_plugin_config_file() {
  local manager=$1
  case "$manager" in
    "vim-plug")
      echo "$PLUGINS_FILE"
      ;;
    "packer.nvim")
      echo "${HOME}/.config/nvim/lua/plugins.lua"
      ;;
    "lazy.nvim")
      echo "${HOME}/.config/nvim/lazy.lua"
      ;;
    *)
      echo ""
      ;;
  esac
}

install_with_manager() {
  local plugin=$1
  local manager=$2

  print_info "Installing plugin: $plugin"

  case "$manager" in
    "vim-plug")
      vim -c 'PlugInstall' -c 'qa!' > /dev/null 2>&1 &
      local pid=$!
      spinner "$pid" "Installing $plugin with vim-plug"
      wait "$pid" 2> /dev/null || true
      ;;

    "packer.nvim")
      nvim --headless -c "PackerSync" -c "qa!" > /dev/null 2>&1 &
      local pid=$!
      spinner "$pid" "Installing $plugin with packer"
      wait "$pid" 2> /dev/null || true
      ;;

    "lazy.nvim")
      nvim --headless -c "Lazy sync" -c "qa!" > /dev/null 2>&1 &
      local pid=$!
      spinner "$pid" "Installing $plugin with lazy"
      wait "$pid" 2> /dev/null || true
      ;;

    *)
      print_warning "Unknown plugin manager, skipping installation"
      return 1
      ;;
  esac

  print_success "Plugin $plugin installation completed"
}

plugin_exists() {
  local plugin=$1
  local config_file=$2
  local manager=$(detect_plugin_manager)

  case "$manager" in
    "vim-plug")
      grep -q "Plug.*${plugin}" "$config_file" 2> /dev/null
      ;;
    "packer.nvim")
      grep -q "use.*${plugin}" "$config_file" 2> /dev/null
      ;;
    "lazy.nvim")
      grep -q "\"${plugin}\"" "$config_file" 2> /dev/null
      ;;
    *)
      return 1
      ;;
  esac
}

install_plugin_manager() {
  print_header "Plugin Manager Setup"

  # Deteksi environment
  local is_neovim=0
  local is_vim=0
  local is_termux=0
  
  if command -v nvim &> /dev/null; then
    is_neovim=1
  fi
  
  if command -v vim &> /dev/null; then
    is_vim=1
  fi
  
  if [ -n "$TERMUX_VERSION" ]; then
    is_termux=1
  fi

  # Deteksi plugin manager yang sudah terinstall
  local existing_managers=()

  if [ -f "${HOME}/.vim/autoload/plug.vim" ]; then
    existing_managers+=("vim-plug")
  fi

  if [ -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    existing_managers+=("packer.nvim")
  fi

  if [ -d "${HOME}/.config/nvim/lazy-lock.json" ] || [ -d "${HOME}/.local/share/nvim/lazy" ]; then
    existing_managers+=("lazy.nvim")
  fi

  # Tampilkan opsi
  echo ""
  echo -e "${WHITE}Available Plugin Managers:${NC}"
  echo ""

  if [ ${#existing_managers[@]} -gt 0 ]; then
    echo -e "  ${GREEN}Existing managers detected:${NC} ${existing_managers[*]}"
    echo ""
  fi

  echo -e "  ${CYAN}1${NC}) Vim-plug (compatible with Vim & Neovim)"
  echo -e "  ${CYAN}2${NC}) Packer.nvim (Neovim only)"
  echo -e "  ${CYAN}3${NC}) Lazy.nvim (Neovim only, modern)"
  echo -e "  ${CYAN}4${NC}) Skip - use existing manager"
  echo ""

  read -p "Choose plugin manager [1-4]: " choice

  case $choice in
    1)
      install_vim_plug "$is_neovim" "$is_vim" "$is_termux"
      ;;
    2)
      if [ "$is_neovim" = "1" ]; then
        install_packer
      else
        print_error "Packer.nvim requires Neovim"
        install_vim_plug "$is_neovim" "$is_vim" "$is_termux"
      fi
      ;;
    3)
      if [ "$is_neovim" = "1" ]; then
        install_lazy_nvim
      else
        print_error "Lazy.nvim requires Neovim"
        install_vim_plug "$is_neovim" "$is_vim" "$is_termux"
      fi
      ;;
    4)
      print_info "Using existing plugin manager"
      return 0
      ;;
    *)
      print_warning "Invalid choice, using vim-plug"
      install_vim_plug "$is_neovim" "$is_vim" "$is_termux"
      ;;
  esac
}

install_vim_plug() {
  local is_neovim=$1
  local is_vim=$2
  local is_termux=$3
  
  print_info "Installing vim-plug..."

  local plug_vim_path="${HOME}/.vim/autoload/plug.vim"
  local plug_nvim_path="${HOME}/.local/share/nvim/site/autoload/plug.vim"

  # Install untuk Vim
  if [ "$is_vim" = "1" ] || [ "$is_termux" = "1" ]; then
    if [ ! -f "$plug_vim_path" ]; then
      curl -fLo "$plug_vim_path" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      print_success "vim-plug installed for Vim"
    else
      print_warning "vim-plug already installed for Vim"
    fi
  fi

  # Install untuk Neovim
  if [ "$is_neovim" = "1" ]; then
    if [ ! -f "$plug_nvim_path" ]; then
      curl -fLo "$plug_nvim_path" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      print_success "vim-plug installed for Neovim"
    else
      print_warning "vim-plug already installed for Neovim"
    fi
  fi
}

install_packer() {
  print_info "Installing packer.nvim..."

  local packer_path="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"

  if [ ! -d "$packer_path" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
      "$packer_path"
    print_success "packer.nvim installed"
  else
    print_warning "packer.nvim already installed"
  fi

  # Generate basic packer config
  generate_packer_config
}

install_lazy_nvim() {
  print_info "Installing lazy.nvim..."

  local lazy_path="${HOME}/.local/share/nvim/lazy/lazy.nvim"

  if [ ! -d "$lazy_path" ]; then
    git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git \
      "$lazy_path"
    print_success "lazy.nvim installed"
  else
    print_warning "lazy.nvim already installed"
  fi

  # Generate basic lazy config
  generate_lazy_config
}

generate_packer_config() {
  local nvim_config_dir="${HOME}/.config/nvim"
  local lua_config_dir="${nvim_config_dir}/lua"
  local packer_config="${lua_config_dir}/plugins.lua"

  mkdir -p "$lua_config_dir"

  cat > "$packer_config" << 'EOF'
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Your plugins here
  use 'morhetz/gruvbox'
  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'

  -- Add more plugins as needed
end)
EOF

  print_success "Generated packer.nvim config"
}

generate_lazy_config() {
  local nvim_config_dir="${HOME}/.config/nvim"
  local lazy_config="${nvim_config_dir}/lazy.lua"

  cat > "$lazy_config" << 'EOF'
return {
  -- Your plugins here
  { "morhetz/gruvbox" },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lualine/lualine.nvim" },
}
EOF

  print_success "Generated lazy.nvim config"
}
