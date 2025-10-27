#!/usr/bin/env bash

vcfg_cmd_doctor() {
  print_header "Vim Configuration Doctor"
  echo -e "${WHITE}Checking your Vim/Neovim setup for potential issues...${NC}"
  echo ""

  local total_checks=0
  local passed_checks=0
  local warning_checks=0
  local failed_checks=0

  # 1. Check Vim/Neovim Installation
  print_section "Editor Installation"
  check_vim_installation
  check_neovim_installation

  # 2. Check Plugin Managers
  print_section "Plugin Managers"
  check_plugin_managers

  # 3. Check Dependencies
  print_section "Dependencies"
  check_doctor_dependencies

  # 4. Check Configuration Files
  print_section "Configuration Files"
  check_config_files

  # 5. Check Plugin Health
  print_section "Plugin Health"
  check_plugin_health

  # 6. Check Performance
  print_section "Performance"
  check_performance

  # Summary
  print_section "Summary"
  echo -e "${WHITE}Total checks:${NC} $total_checks"
  echo -e "${GREEN}Passed:${NC} $passed_checks"
  echo -e "${YELLOW}Warnings:${NC} $warning_checks"
  echo -e "${RED}Failed:${NC} $failed_checks"
  echo ""

  if [ $failed_checks -eq 0 ] && [ $warning_checks -eq 0 ]; then
    print_success "🎉 Your Vim configuration is healthy!"
  elif [ $failed_checks -eq 0 ]; then
    print_warning "⚠️  Your configuration has some warnings but should work fine"
  else
    print_error "❌ Your configuration has issues that need attention"
  fi

  # Show recommendations
  if [ $failed_checks -gt 0 ] || [ $warning_checks -gt 0 ]; then
    show_recommendations
  fi
}

print_section() {
  local title=$1
  echo -e "${CYAN}$(printf "━%.0s" {1..58})${NC}"
  echo -e "${BOLD}${WHITE}$title${NC}"
  echo -e "${CYAN}$(printf "━%.0s" {1..58})${NC}"
  echo ""
}

check_vim_installation() {
  total_checks=$((total_checks + 1))
  if command -v vim &> /dev/null; then
    local vim_version=$(vim --version | head -1 | sed 's/.*version //')
    print_success "Vim installed: $vim_version"
    passed_checks=$((passed_checks + 1))
  else
    print_error "Vim not installed"
    failed_checks=$((failed_checks + 1))
  fi
}

check_neovim_installation() {
  total_checks=$((total_checks + 1))
  if command -v nvim &> /dev/null; then
    local nvim_version=$(nvim --version | head -1 | sed 's/.*version //')
    print_success "Neovim installed: $nvim_version"
    passed_checks=$((passed_checks + 1))
  else
    print_warning "Neovim not installed (optional)"
    warning_checks=$((warning_checks + 1))
  fi
}

check_plugin_managers() {
  local managers_found=0

  # Check vim-plug
  total_checks=$((total_checks + 1))
  if [ -f "${HOME}/.vim/autoload/plug.vim" ] || [ -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    print_success "vim-plug installed"
    managers_found=$((managers_found + 1))
    passed_checks=$((passed_checks + 1))
  else
    print_warning "vim-plug not installed"
    warning_checks=$((warning_checks + 1))
  fi

  # Check packer.nvim
  total_checks=$((total_checks + 1))
  if [ -d "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    print_success "packer.nvim installed"
    managers_found=$((managers_found + 1))
    passed_checks=$((passed_checks + 1))
  else
    print_info "packer.nvim not installed"
  fi

  # Check lazy.nvim
  total_checks=$((total_checks + 1))
  if [ -d "${HOME}/.local/share/nvim/lazy/lazy.nvim" ]; then
    print_success "lazy.nvim installed"
    managers_found=$((managers_found + 1))
    passed_checks=$((passed_checks + 1))
  else
    print_info "lazy.nvim not installed"
  fi

  # Overall plugin manager status
  total_checks=$((total_checks + 1))
  if [ $managers_found -gt 0 ]; then
    print_success "Plugin manager detected ($managers_found found)"
    passed_checks=$((passed_checks + 1))
  else
    print_error "No plugin manager installed"
    failed_checks=$((failed_checks + 1))
  fi
}

check_doctor_dependencies() {
  local deps=("git" "curl" "wget")

  for dep in "${deps[@]}"; do
    total_checks=$((total_checks + 1))
    if command -v "$dep" &> /dev/null; then
      local version=$("$dep" --version 2> /dev/null | head -1)
      print_success "$dep: installed"
      passed_checks=$((passed_checks + 1))
    else
      print_error "$dep: not installed"
      failed_checks=$((failed_checks + 1))
    fi
  done

  # Optional dependencies
  local optional_deps=("node" "python3" "npm" "pip3" "jq")

  for dep in "${optional_deps[@]}"; do
    total_checks=$((total_checks + 1))
    if command -v "$dep" &> /dev/null; then
      print_success "$dep: installed"
      passed_checks=$((passed_checks + 1))
    else
      print_info "$dep: not installed (optional)"
    fi
  done
}

check_config_files() {
  local config_files=(
    "${HOME}/.vimrc"
    "${HOME}/.config/nvim/init.vim"
    "${HOME}/.config/nvim/init.lua"
    "${VIM_CONFIG_DIR}/init.vim"
    "${VIM_CONFIG_DIR}/core/plugins.vim"
    "${VIM_CONFIG_DIR}/core/settings.vim"
    "${VIM_CONFIG_DIR}/core/mappings.vim"
  )

  for file in "${config_files[@]}"; do
    total_checks=$((total_checks + 1))
    if [ -f "$file" ]; then
      print_success "Config: $(basename "$file")"
      passed_checks=$((passed_checks + 1))

      # Check if file is readable
      if [ -r "$file" ]; then
        # Check for syntax errors in Vim files
        if [[ "$file" == *.vim ]]; then
          check_vim_syntax "$file"
        fi
      else
        print_warning "Config: $(basename "$file") not readable"
        warning_checks=$((warning_checks + 1))
      fi
    else
      if [[ "$file" == *".vimrc"* ]] || [[ "$file" == *"init.vim"* ]] || [[ "$file" == *"plugins.vim"* ]]; then
        print_error "Config: $(basename "$file") missing"
        failed_checks=$((failed_checks + 1))
      else
        print_info "Config: $(basename "$file") not found (optional)"
      fi
    fi
  done
}

check_vim_syntax() {
  local file=$1
  local filename=$(basename "$file")

  if command -v vim &> /dev/null; then
    # Skip files yang complex (seperti init.vim utama)
    case "$filename" in
      "init.vim" | ".vimrc")
        # File utama mungkin punya complex logic, skip detailed check
        print_info "Syntax: $filename (basic check only)"
        return 0
        ;;
    esac

    # Untuk file config modular, check syntax dengan method yang lebih safe
    local syntax_check
    syntax_check=$(vim -u NONE -i NONE -N -c "
      try
        source $file
        echo 'VALID'
      catch
        echo 'ERROR: ' . v:exception
      endtry
      quit
    " 2>&1 | grep -E "(VALID|ERROR:)")

    if echo "$syntax_check" | grep -q "VALID"; then
      print_success "Syntax: $filename valid"
      passed_checks=$((passed_checks + 1))
    else
      local error_msg=$(echo "$syntax_check" | sed 's/ERROR: //')
      print_error "Syntax: $filename has issues"
      if [ -n "$error_msg" ]; then
        echo -e "       ${GRAY}${error_msg}${NC}"
      fi
      failed_checks=$((failed_checks + 1))
    fi
  fi
}

check_plugin_health() {
  local plugin_manager=$(detect_plugin_manager)

  case "$plugin_manager" in
    "vim-plug")
      check_vimplug_health
      ;;
    "packer.nvim")
      check_packer_health
      ;;
    "lazy.nvim")
      check_lazy_health
      ;;
    *)
      print_info "No active plugin manager detected for health check"
      ;;
  esac
}

check_vimplug_health() {
  total_checks=$((total_checks + 1))
  local plugins_dir="${HOME}/.vim/plugged"

  if [ -d "$plugins_dir" ]; then
    local plugin_count=$(find "$plugins_dir" -maxdepth 1 -type d | wc -l)
    plugin_count=$((plugin_count - 1)) # subtract the directory itself

    if [ $plugin_count -gt 0 ]; then
      print_success "Plugins: $plugin_count installed"
      passed_checks=$((passed_checks + 1))

      # Check for broken plugins
      local broken_plugins=0
      for plugin_dir in "$plugins_dir"/*; do
        if [ -d "$plugin_dir" ] && [ ! -d "$plugin_dir/.git" ]; then
          broken_plugins=$((broken_plugins + 1))
        fi
      done

      if [ $broken_plugins -gt 0 ]; then
        total_checks=$((total_checks + 1))
        print_warning "Plugins: $broken_plugins may be broken"
        warning_checks=$((warning_checks + 1))
      fi
    else
      print_warning "Plugins: directory exists but no plugins installed"
      warning_checks=$((warning_checks + 1))
    fi
  else
    print_info "Plugins: no plugins directory found"
  fi
}

check_packer_health() {
  total_checks=$((total_checks + 1))
  local plugins_dir="${HOME}/.local/share/nvim/site/pack/packer"

  if [ -d "$plugins_dir" ]; then
    local start_count=$(find "$plugins_dir/start" -maxdepth 1 -type d 2> /dev/null | wc -l)
    local opt_count=$(find "$plugins_dir/opt" -maxdepth 1 -type d 2> /dev/null | wc -l)
    local total_count=$((start_count + opt_count - 2)) # subtract the directories themselves

    if [ $total_count -gt 0 ]; then
      print_success "Packer: $total_count plugins ($start_count start, $opt_count opt)"
      passed_checks=$((passed_checks + 1))
    else
      print_warning "Packer: no plugins installed"
      warning_checks=$((warning_checks + 1))
    fi
  else
    print_info "Packer: no plugins directory found"
  fi
}

check_lazy_health() {
  total_checks=$((total_checks + 1))
  local plugins_dir="${HOME}/.local/share/nvim/lazy"

  if [ -d "$plugins_dir" ]; then
    local plugin_count=$(find "$plugins_dir" -maxdepth 1 -type d | wc -l)
    plugin_count=$((plugin_count - 1)) # subtract the directory itself

    if [ $plugin_count -gt 0 ]; then
      print_success "Lazy: $plugin_count plugins installed"
      passed_checks=$((passed_checks + 1))
    else
      print_warning "Lazy: no plugins installed"
      warning_checks=$((warning_checks + 1))
    fi
  else
    print_info "Lazy: no plugins directory found"
  fi
}

check_performance() {
  # Check Vim startup time
  total_checks=$((total_checks + 1))
  if command -v vim &> /dev/null; then
    local start_time=$(date +%s%3N)
    vim --startuptime /tmp/vim_startup.log +q 2> /dev/null
    local end_time=$(date +%s%3N)
    local startup_time=$((end_time - start_time))

    if [ $startup_time -lt 1000 ]; then
      print_success "Performance: startup ${startup_time}ms (fast)"
      passed_checks=$((passed_checks + 1))
    elif [ $startup_time -lt 3000 ]; then
      print_warning "Performance: startup ${startup_time}ms (moderate)"
      warning_checks=$((warning_checks + 1))
    else
      print_error "Performance: startup ${startup_time}ms (slow)"
      failed_checks=$((failed_checks + 1))
    fi
    rm -f /tmp/vim_startup.log
  else
    print_info "Performance: cannot test (Vim not installed)"
  fi

  # Check disk space for plugins
  total_checks=$((total_checks + 1))
  local plugin_dirs=(
    "${HOME}/.vim/plugged"
    "${HOME}/.local/share/nvim/site/pack"
    "${HOME}/.local/share/nvim/lazy"
  )

  local total_size=0
  for dir in "${plugin_dirs[@]}"; do
    if [ -d "$dir" ]; then
      local size=$(du -s "$dir" 2> /dev/null | cut -f1)
      total_size=$((total_size + size))
    fi
  done

  local size_mb=$((total_size / 1024))
  if [ $size_mb -lt 500 ]; then
    print_success "Disk: plugins use ${size_mb}MB"
    passed_checks=$((passed_checks + 1))
  elif [ $size_mb -lt 1000 ]; then
    print_warning "Disk: plugins use ${size_mb}MB (large)"
    warning_checks=$((warning_checks + 1))
  else
    print_error "Disk: plugins use ${size_mb}MB (very large)"
    failed_checks=$((failed_checks + 1))
  fi
}

show_recommendations() {
  print_section "Recommendations"

  if command -v vim &> /dev/null && ! vim --version | grep -q "+python3"; then
    echo -e "  ${YELLOW}•${NC} Consider installing Vim with Python3 support for better plugin compatibility"
  fi

  if [ ! -f "${HOME}/.vim/autoload/plug.vim" ] && [ ! -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    echo -e "  ${YELLOW}•${NC} Install a plugin manager: ${CYAN}vcfg install${NC}"
  fi

  if ! command -v git &> /dev/null; then
    echo -e "  ${RED}•${NC} Install git: ${CYAN}sudo apt install git${NC} (Ubuntu/Debian)"
  fi

  if ! command -v curl &> /dev/null; then
    echo -e "  ${RED}•${NC} Install curl: ${CYAN}sudo apt install curl${NC} (Ubuntu/Debian)"
  fi

  # Check if using slow startup time
  if command -v vim &> /dev/null; then
    local start_time=$(date +%s%3N)
    vim --startuptime /tmp/vim_startup.log +q 2> /dev/null
    local end_time=$(date +%s%3N)
    local startup_time=$((end_time - start_time))

    if [ $startup_time -gt 2000 ]; then
      echo -e "  ${YELLOW}•${NC} Optimize startup time: ${CYAN}vcfg disable slow_plugins${NC}"
      echo -e "  ${YELLOW}•${NC} Check startup profile: ${CYAN}vim --startuptime startup.log${NC}"
    fi
    rm -f /tmp/vim_startup.log
  fi

  echo ""
  print_info "Run specific commands to fix issues:"
  echo -e "  ${CYAN}vcfg install${NC}    - Install missing components"
  echo -e "  ${CYAN}vcfg update${NC}     - Update plugins and manager"
  echo -e "  ${CYAN}vcfg clean${NC}      - Remove unused plugins"
  echo -e "  ${CYAN}vcfg doctor${NC}     - Run this check again"
}
