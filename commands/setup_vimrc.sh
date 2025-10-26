#!/usr/bin/env bash

setup_vimrc() {
  print_info "Setting up Vim configuration..."

  # Always backup existing .vimrc
  if [ -f "$VIMRC_PATH" ] && [ ! -L "$VIMRC_PATH" ]; then
    local backup_path="${VIMRC_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$VIMRC_PATH" "$backup_path"
    print_success "Backed up existing .vimrc to $backup_path"

    # Tanya user apakah mau replace atau append
    echo ""
    echo -e "Choose .vimrc setup:"
    echo -e "  ${GREEN}1${NC}) Replace with clean .vimrc (recommended)"
    echo -e "  ${YELLOW}2${NC}) Add source to existing .vimrc"
    echo -e "  ${RED}3${NC}) Keep existing .vimrc (manual setup)"
    echo ""

    read -p "Enter your choice [1-3]: " choice

    case $choice in
      1)
        create_clean_vimrc
        ;;
      2)
        append_to_vimrc
        ;;
      3)
        print_info "Keeping existing .vimrc - you'll need to manually source our config"
        return 0
        ;;
      *)
        print_error "Invalid choice, using clean setup"
        create_clean_vimrc
        ;;
    esac
  else
    create_clean_vimrc
  fi
}

create_clean_vimrc() {
  cat > "$VIMRC_PATH" << 'EOF'
" Vim configuration - main config in ~/.config/vim/init.vim

if filereadable(expand('~/.config/vim/init.vim'))
  source ~/.config/vim/init.vim
endif
EOF
  print_success "Created clean .vimrc"
}

append_to_vimrc() {
  # Cek jika sudah ada source
  if grep -q "~/.config/vim/init.vim" "$VIMRC_PATH"; then
    print_success "Configuration already sourced in .vimrc"
    return 0
  fi

  # Tambahkan ke akhir file
  echo "" >> "$VIMRC_PATH"
  echo "\" Source custom Vim configuration" >> "$VIMRC_PATH"
  echo "if filereadable(expand('~/.config/vim/init.vim'))" >> "$VIMRC_PATH"
  echo "  source ~/.config/vim/init.vim" >> "$VIMRC_PATH"
  echo "endif" >> "$VIMRC_PATH"

  print_success "Added source to existing .vimrc"
}
