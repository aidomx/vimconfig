#!/usr/bin/env bash

add_language() {
  local lang="${1}"
  local lang_file="${VCFG_LANGS_DIR}/${lang}.vim"

  if grep -q "#define LANGUAGE" "$VCFG_INIT" && grep -q "#enddef LANGUAGE" "$VCFG_INIT"; then
    if grep -q "runtime! langs/$lang.vim" "$VCFG_INIT"; then
      print_warning "Configuration ${CYAN}$lang${NC} is already exists"
      return 0
    fi

    tmp_file=$(mktemp)
    awk -v lang="$lang" '
    /#enddef LANGUAGE/ && !added {
    print "runtime! " "langs/" lang ".vim"
    added=1
  }
{ print }
    ' "$VCFG_INIT" >"$tmp_file" && mv "$tmp_file" "$VCFG_INIT"

    if [ -f "$lang_file" ]; then
      print_warning "Added to configuration is successfully but language file: ${CYAN}$lang_file${NC} is already exists"
    else
      touch "$lang_file"
      print_success "Added new language ${CYAN}$lang_file${NC} is successfully"
    fi
  else
    cat >>"$VCFG_INIT" <<EOF
" Load language configurations
" Don't remove 'define LANGUAGE' and 'enddef LANGUAGE' from comment
" #define LANGUAGE
runtime! langs/${lang}.vim
" #enddef LANGUAGE
EOF
    # Buat file bahasa
    touch "$lang_file"
    print_success "Added new language ${CYAN}$lang${NC} with new section"
  fi
}

disable_language() {
  local lang="${1}"
  local lang_pattern="runtime! langs/${lang}.vim"

  if [[ ! -f "$VCFG_INIT" ]]; then
    print_error "Configuration file $VCFG_INIT not found"
    return 1
  fi

  if ! grep -q "$lang_pattern" "$VCFG_INIT"; then
    print_warning "Language ${CYAN}$lang${NC} not found"
    return 0
  fi

  if grep -q "$lang_pattern" "$VCFG_INIT" || grep -q "^[^\"].*$lang_pattern" "$VCFG_INIT"; then
    tmp_file=$(mktemp)
    awk -v pattern="$lang_pattern" '
      $0 ~ pattern && !/^"/ {
        $0 = "\" " $0
      }
      { print }
    ' "$VCFG_INIT" >"$tmp_file" && mv "$tmp_file" "$VCFG_INIT"

    print_success "Language ${CYAN}$lang${NC} disabled successfully"
  else
    print_warning "Language ${CYAN}$lang${NC} is already disabled"
  fi
}

enable_language() {
  local lang="${1}"

  if [[ ! -f "$VCFG_INIT" ]]; then
    print_error "Configuration file $VCFG_INIT not found"
    return 1
  fi

  if grep -q "^\" *runtime! langs/${lang}.vim" "$VCFG_INIT"; then
    tmp_file=$(mktemp)
    awk -v lang="$lang" '
      /^" *runtime! langs\/.*\.vim/ {
        if (index($0, "langs/" lang ".vim") > 0) {
          sub(/^" */, "")
        }
      }
      { print }
    ' "$VCFG_INIT" >"$tmp_file" && mv "$tmp_file" "$VCFG_INIT"

    print_success "Language ${CYAN}$lang${NC} enabled successfully"
  elif grep -q "^runtime! langs/${lang}.vim" "$VCFG_INIT"; then
    print_warning "Language ${CYAN}$lang${NC} is already enabled"
  else
    print_error "Language ${CYAN}$lang${NC} not found in configuration"
    return 1
  fi
}

info_language() {
  local lang="${1}"
  local lang_file="${VCFG_LANGS_DIR}/${lang}.vim"

  if [[ ! -f "$lang_file" ]]; then
    print_error "Language ${CYAN}$lang${NC} not found"
    return 1
  fi

  local status="Disabled"
  if grep -q "^runtime! langs/${lang}.vim" "$VCFG_INIT"; then
    status="${GREEN}Enabled${NC}"
  elif grep -q "^\" *runtime! langs/${lang}.vim" "$VCFG_INIT"; then
    status="${YELLOW}Disabled${NC}"
  else
    status="${RED}Not in config${NC}"
  fi

  local file_size=$(stat -f%z "$lang_file" 2>/dev/null || stat -c%s "$lang_file" 2>/dev/null)
  local line_count=$(wc -l <"$lang_file")
  local created_date=$(stat -f%SB "$lang_file" 2>/dev/null || stat -c%y "$lang_file" 2>/dev/null | cut -d' ' -f1)

  print_header "Language Information: ${CYAN}$lang${NC}"

  local info_data=(
    "Status|$(echo -e $status)"
    "File|$lang_file"
    "Size|$file_size bytes"
    "Lines|$line_count"
    "Created|$created_date"
  )

  for info in "${info_data[@]}"; do
    IFS='|' read -r label value <<<"$info"
    printf "  ${YELLOW}%-10s:${NC} %s\n" "$label" "$value"
  done

  echo ""
  print_header "File Preview"
  if [[ $line_count -gt 20 ]]; then
    echo -e "  ${GRAY}(Showing first 20 lines)${NC}"
    head -n 20 "$lang_file" | sed 's/^/  /'
    echo -e "  ${GRAY}... and $((line_count - 20)) more lines${NC}"
  else
    cat "$lang_file" | sed 's/^/  /'
  fi
}

list_language() {
  local languages=($(find "${VCFG_LANGS_DIR}" -name "*.vim"))
  local current=0
  local table_data=()

  print_header "List language of supported"
  echo ""

  for lang in "${languages[@]}"; do
    current=$((current + 1))
    table_data+=("$current|$(basename $lang)")
  done

  create_simple_table "No,Language" "${table_data[@]}"
  echo ""
  echo -e "For edit with editor : ${CYAN}edit python${NC}"
}

remove_language() {
  local lang="${1}"
  local lang_file="${VCFG_LANGS_DIR}/${lang}.vim"
  local lang_pattern="runtime! langs/${lang}.vim"

  if [[ ! -f "$VCFG_INIT" ]]; then
    print_error "Configuration file $VCFG_INIT not found"
    return 1
  fi

  if grep -q "$lang_pattern" "$VCFG_INIT"; then
    tmp_file=$(mktemp)
    awk -v pattern="$lang_pattern" '
      $0 !~ pattern { print }
    ' "$VCFG_INIT" >"$tmp_file" && mv "$tmp_file" "$VCFG_INIT"

    print_success "Language ${CYAN}$lang${NC} removed from configuration"
  else
    print_warning "Language ${CYAN}$lang${NC} not found in configuration"
  fi

  if [[ -f "$lang_file" ]]; then
    local question=$(echo -e "Delete language file ${CYAN}${lang_file}${NC}? (y/N): ")
    read -p "$question" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm -f "$lang_file"
      print_success "Language file ${CYAN}$lang_file${NC} deleted"
    else
      print_warning "Language file ${CYAN}$lang_file${NC} kept"
    fi
  fi
}
