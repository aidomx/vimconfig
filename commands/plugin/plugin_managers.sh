#!/usr/bin/env bash

install_plugin_manager() {
  print_header "Plugin Manager Setup"

  # Deteksi environment
  local is_neovim=0
  local is_vim=0
  local is_termux=0

  command -v nvim &> /dev/null && is_neovim=1
  command -v vim &> /dev/null && is_vim=1
  [ -n "$TERMUX_VERSION" ] && is_termux=1

  # Deteksi existing managers
  local existing_managers=()
  [ -f "${HOME}/.vim/autoload/plug.vim" ] && existing_managers+=("vim-plug")
  [ -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ] && existing_managers+=("packer.nvim")
  [ -d "${HOME}/.local/share/nvim/lazy/lazy.nvim" ] && existing_managers+=("lazy.nvim")

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
    1) install_vim_plug "$is_neovim" "$is_vim" "$is_termux" ;;
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
  local is_neovim=$1 is_vim=$2 is_termux=$3

  print_info "Installing vim-plug..."

  # Install untuk Vim/Termux
  if { [ "$is_vim" = "1" ] || [ "$is_termux" = "1" ]; } && [ ! -f "${HOME}/.vim/autoload/plug.vim" ]; then
    (curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim) &
    local pid=$!
    show_percentage_progress $pid "Installing vim-plug for Vim"
    wait $pid
    print_success "vim-plug installed for Vim"
  fi

  # Install untuk Neovim
  if [ "$is_neovim" = "1" ] && [ ! -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    (curl -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim) &
    local pid=$!
    show_percentage_progress $pid "Installing vim-plug for Neovim"
    wait $pid
    print_success "vim-plug installed for Neovim"
  fi
}

install_packer() {
  print_info "Installing packer.nvim..."

  local packer_path="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"

  if [ ! -d "$packer_path" ]; then
    (git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packer_path") &
    local pid=$!
    show_percentage_progress $pid "Installing packer.nvim"
    wait $pid
    print_success "packer.nvim installed"

    generate_packer_config
  else
    print_warning "packer.nvim already installed"
  fi
}

install_lazy_nvim() {
  print_info "Installing lazy.nvim..."

  local lazy_path="${HOME}/.local/share/nvim/lazy/lazy.nvim"

  if [ ! -d "$lazy_path" ]; then
    (git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git "$lazy_path") &
    local pid=$!
    show_percentage_progress $pid "Installing lazy.nvim"
    wait $pid
    print_success "lazy.nvim installed"

    generate_lazy_config
  else
    print_warning "lazy.nvim already installed"
  fi
}

generate_packer_config() {
  local nvim_config_dir="${HOME}/.config/nvim"
  local lua_config_dir="${nvim_config_dir}/lua"
  local packer_config="${lua_config_dir}/plugins.lua"

  mkdir -p "$lua_config_dir"

  cat > "$packer_config" << 'EOF'
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
end)
EOF

  print_success "Generated packer.nvim config"
}

generate_lazy_config() {
  local nvim_config_dir="${HOME}/.config/nvim"
  local lazy_config="${nvim_config_dir}/lazy.lua"

  cat > "$lazy_config" << 'EOF'
return {
  { "morhetz/gruvbox" },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lualine/lualine.nvim" },
}
EOF

  print_success "Generated lazy.nvim config"
}
