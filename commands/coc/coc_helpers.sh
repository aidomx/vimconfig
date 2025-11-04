#!/usr/bin/env bash

ensure_coc_file() {
  local coc_file=$1

  if [ ! -f "$coc_file" ]; then
    print_info "Creating coc.vim configuration..."

    cat > "$coc_file" << 'EOF'
" ========================
" Coc.nvim Configuration
" ========================

" Global extensions - add your extensions here
let g:coc_global_extensions = []

" Coc settings
" Use `:CocConfig` to customize Coc settings
EOF

    print_success "Created coc.vim at: $coc_file"
  fi
}

reset_coc_extensions() {
  cat > "$temp_file" << EOF
" ========================
" Coc.nvim Configuration
" ========================

" Global extensions - add your extensions here
let g:coc_global_extensions = []

" Coc settings
" Use \`:CocConfig\` to customize Coc settings
EOF
}

extract_coc_extensions() {
  local coc_file=$1
  grep -A 20 "let g:coc_global_extensions" "$coc_file" \
    | grep -E "\\s*'[^']+'" \
    | sed "s/.*'\([^']*\)'.*/\1/" \
    | grep -v "^$"
}

is_coc_extension_installed() {
  local extension=$1
  local coc_extensions_dir="${VCFG_COC_EXTENSIONS:-${HOME}/.config/coc/extensions}"
  local ext_dir="${coc_extensions_dir}/node_modules/${extension}"

  [ -d "$ext_dir" ]
}

rebuild_coc_file() {
  local coc_file=$1
  local extensions=$2

  local temp_file=$(mktemp)
  local extensions_content=""
  local count=0
  local total=$(echo "$extensions" | grep -c .)

  while IFS= read -r ext; do
    if [ -n "$ext" ]; then
      count=$((count + 1))
      if [[ $count -eq $total ]]; then
        extensions_content="${extensions_content}  \\ '${ext}'"$'\n'
      else
        extensions_content="${extensions_content}  \\ '${ext}',"$'\n'
      fi
    fi
  done <<< "$extensions"

  cat > "$temp_file" << EOF
" ========================
" Coc.nvim Configuration
" ========================

" Global extensions - add your extensions here
let g:coc_global_extensions = [
${extensions_content}  \\ ]

" Coc settings
" Use \`:CocConfig\` to customize Coc settings
EOF

  if [ "$total" -eq 0 ]; then
    reset_coc_extensions
  fi
  mv "$temp_file" "$coc_file"
}
