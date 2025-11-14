#!/usr/bin/env bash

vcfg_cmd_editmap() {
  # Jika ada subcommand, langsung execute
  if [ $# -gt 0 ]; then
    case "$1" in
    list | ls)
      list_mappings
      ;;
    add)
      shift
      if [ $# -eq 2 ]; then
        add_mapping "$1" "$2"
      else
        print_error "Usage: vcfg editmap add <key> <action>"
        echo "Example: vcfg editmap add '<leader>ff' ':Files<CR>'"
        return 1
      fi
      ;;
    remove | rm)
      shift
      if [ $# -eq 1 ]; then
        remove_mapping "$1"
      else
        print_error "Usage: vcfg editmap remove <key-pattern>"
        return 1
      fi
      ;;
    search)
      shift
      if [ $# -eq 1 ]; then
        search_mappings "$1"
      else
        print_error "Usage: vcfg editmap search <pattern>"
        return 1
      fi
      ;;
    edit)
      edit_mappings_file
      ;;
    help | h)
      show_mapping_help
      ;;
    *)
      print_error "Unknown subcommand: $1"
      echo "Usage: vcfg editmap <list|add|remove|search|edit|help>"
      return 1
      ;;
    esac
    return 0
  fi

  # Jika tidak ada args, masuk ke REPL mode
  interactive_mapping_editor
}

interactive_mapping_editor() {
  local mappings_file="${VCFG_MAPPINGS_FILE}"

  if [ ! -f "$mappings_file" ]; then
    print_error "Mappings file not found: $mappings_file"
    return 1
  fi

  print_header "Interactive Mapping Editor"
  echo -e "${WHITE}Editing: ${CYAN}${mappings_file}${NC}"
  echo ""
  echo -e "${YELLOW}Available commands:${NC}"
  echo -e "  ${GREEN}list${NC}    - Show current mappings"
  echo -e "  ${GREEN}add${NC}     - Add new mapping"
  echo -e "  ${GREEN}remove${NC}  - Remove mapping"
  echo -e "  ${GREEN}search${NC}  - Search mappings"
  echo -e "  ${GREEN}edit${NC}    - Open in editor"
  echo -e "  ${GREEN}help${NC}    - Show help"
  echo -e "  ${GREEN}quit${NC}    - Exit"
  echo ""

  while true; do
    read -p "$(echo -e "${CYAN}map> ${NC}")" command

    case "$command" in
    list | l)
      list_mappings
      ;;
    add | a)
      add_mapping_interactive
      ;;
    remove | r)
      remove_mapping_interactive
      ;;
    search | s)
      search_mappings_interactive
      ;;
    edit | e)
      edit_mappings_file
      ;;
    quit | q)
      print_info "Goodbye!"
      break
      ;;
    help | h)
      show_mapping_help
      ;;
    "")
      # Do nothing on empty input
      ;;
    *)
      # Try to execute as direct command
      if [[ "$command" =~ ^(list|add|remove|search|edit) ]]; then
        eval "vcfg_cmd_editmap $command"
      else
        print_error "Unknown command: $command"
        echo "Type 'help' for available commands"
      fi
      ;;
    esac
  done
}

list_mappings() {
  local mappings_file="${VIM_CONFIG_DIR}/core/mappings.vim"

  print_header "Current Mappings"

  if [ ! -f "$mappings_file" ]; then
    print_error "Mappings file not found"
    return 1
  fi

  local count=0
  while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^[[:space:]]*\" ]] && continue
    [[ -z "$line" ]] && continue

    # Match mapping lines
    if [[ "$line" =~ ^[[:space:]]*(noremap|map|nmap|imap|vmap|xmap|smap|omap|nnoremap|inoremap|vnoremap|xnoremap|snoremap|onoremap) ]]; then
      count=$((count + 1))
      local cmd=$(echo "$line" | sed -n 's/^[[:space:]]*\([a-z]*\)[[:space:]]*\(.*\)/\1/p')
      local mapping=$(echo "$line" | sed -n 's/^[[:space:]]*[a-z]*[[:space:]]*\([^[:space:]]*\)[[:space:]]*\(.*\)/\1/p')
      local action=$(echo "$line" | sed -n 's/^[[:space:]]*[a-z]*[[:space:]]*[^[:space:]]*[[:space:]]*\(.*\)/\1/p')

      echo -e "  ${CYAN}${cmd}${NC} ${GREEN}${mapping}${NC} → ${YELLOW}${action}${NC}"
    fi
  done <"$mappings_file"

  if [ $count -eq 0 ]; then
    print_warning "No mappings found"
  else
    echo ""
    print_info "Total mappings: $count"
  fi
}

add_mapping() {
  local key=$1
  local action=$2
  local mappings_file="${VIM_CONFIG_DIR}/core/mappings.vim"

  # Validate and determine map type
  local map_cmd="nnoremap"
  if [[ "$key" =~ ^i: ]]; then
    map_cmd="inoremap"
    key="${key#i:}"
  elif [[ "$key" =~ ^v: ]]; then
    map_cmd="vnoremap"
    key="${key#v:}"
  elif [[ "$key" =~ ^x: ]]; then
    map_cmd="xnoremap"
    key="${key#x:}"
  fi

  # Add the mapping
  echo "$map_cmd $key $action" >>"$mappings_file"
  print_success "Added mapping: ${CYAN}$map_cmd${NC} ${GREEN}$key${NC} → ${YELLOW}$action${NC}"

  print_info "Restart Vim or run :source $mappings_file to apply"
}

add_mapping_interactive() {
  echo ""
  echo -e "${YELLOW}Add New Mapping${NC}"
  echo ""

  read -p "$(echo -e "Map type ${CYAN}(n=normal, i=insert, v=visual, x=visual+select, default: n)${NC}: ")" map_type
  read -p "$(echo -e "Key sequence ${CYAN}(e.g., <leader>ff)${NC}: ")" key
  read -p "$(echo -e "Action ${CYAN}(e.g., :Files<CR>)${NC}: ")" action

  # Set map type
  case "$map_type" in
  i | I) map_cmd="inoremap" ;;
  v | V) map_cmd="vnoremap" ;;
  x | X) map_cmd="xnoremap" ;;
  *) map_cmd="nnoremap" ;;
  esac

  if [ -z "$key" ] || [ -z "$action" ]; then
    print_error "Key and action cannot be empty"
    return 1
  fi

  local mappings_file="${VIM_CONFIG_DIR}/core/mappings.vim"
  echo "$map_cmd $key $action" >>"$mappings_file"

  print_success "Added: ${CYAN}$map_cmd${NC} ${GREEN}$key${NC} → ${YELLOW}$action${NC}"
}

remove_mapping() {
  local pattern=$1
  local mappings_file="${VIM_CONFIG_DIR}/core/mappings.vim"

  # Create backup
  cp "$mappings_file" "${mappings_file}.backup.$$"

  # Count matches before removal
  local match_count=$(grep -c "$pattern" "$mappings_file" 2>/dev/null || echo 0)

  if [ $match_count -gt 0 ]; then
    # Show what will be removed
    echo -e "${YELLOW}Removing the following mappings:${NC}"
    grep "$pattern" "$mappings_file" | while read -r line; do
      echo -e "  ${RED}✗${NC} $line"
    done

    # Confirm removal
    read -p "$(echo -e "Confirm removal? ${RED}(y/N)${NC}: ")" confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      sed -i "/$pattern/d" "$mappings_file"
      print_success "Removed $match_count mapping(s) matching: $pattern"
    else
      print_info "Removal cancelled"
    fi
  else
    print_error "No mappings found matching: $pattern"
  fi

  # Cleanup backup
  rm -f "${mappings_file}.backup.$$"
}

remove_mapping_interactive() {
  echo ""
  list_mappings
  echo ""
  read -p "$(echo -e "Enter key pattern to remove ${CYAN}(e.g., <leader>ff)${NC}: ")" pattern

  if [ -z "$pattern" ]; then
    print_error "Pattern cannot be empty"
    return 1
  fi

  remove_mapping "$pattern"
}

search_mappings() {
  local pattern=$1
  local mappings_file="${VIM_CONFIG_DIR}/core/mappings.vim"

  print_header "Matching: '$pattern'"

  local count=0
  while IFS= read -r line; do
    if echo "$line" | grep -q "$pattern" && [[ ! "$line" =~ ^[[:space:]]*\" ]]; then
      count=$((count + 1))
      local cmd=$(echo "$line" | sed -n 's/^[[:space:]]*\([a-z]*\)[[:space:]]*\(.*\)/\1/p')
      local mapping=$(echo "$line" | sed -n 's/^[[:space:]]*[a-z]*[[:space:]]*\([^[:space:]]*\)[[:space:]]*\(.*\)/\1/p')
      local action=$(echo "$line" | sed -n 's/^[[:space:]]*[a-z]*[[:space:]]*[^[:space:]]*[[:space:]]*\(.*\)/\1/p')

      echo -e "  ${CYAN}${cmd}${NC} ${GREEN}${mapping}${NC} → ${YELLOW}${action}${NC}"
    fi
  done <"$mappings_file"

  if [ $count -eq 0 ]; then
    print_warning "No mappings found matching: '$pattern'"
  else
    echo ""
    print_info "Found $count matching mapping(s)"
  fi
}

search_mappings_interactive() {
  echo ""
  read -p "$(echo -e "Enter search pattern ${CYAN}(e.g., leader, <C-, Files)${NC}: ")" pattern

  if [ -z "$pattern" ]; then
    print_error "Search pattern cannot be empty"
    return 1
  fi

  search_mappings "$pattern"
}

edit_mappings_file() {
  local mappings_file="${VIM_CONFIG_DIR}/core/mappings.vim"

  print_info "Opening mappings file in editor..."

  if [ -n "$EDITOR" ]; then
    $EDITOR "$mappings_file"
  elif command -v nvim >/dev/null; then
    nvim "$mappings_file"
  elif command -v vim >/dev/null; then
    vim "$mappings_file"
  else
    vi "$mappings_file"
  fi
}

show_mapping_help() {
  echo -e "${YELLOW}Mapping Help:${NC}"
  echo ""
  echo -e "${CYAN}Map Types:${NC}"
  echo -e "  ${GREEN}nnoremap${NC} - Normal mode (recommended)"
  echo -e "  ${GREEN}inoremap${NC} - Insert mode"
  echo -e "  ${GREEN}vnoremap${NC} - Visual mode"
  echo -e "  ${GREEN}xnoremap${NC} - Visual mode (character-wise)"
  echo ""
  echo -e "${CYAN}Common Key Sequences:${NC}"
  echo -e "  ${GREEN}<leader>${NC}   - Leader key (usually space or ,)"
  echo -e "  ${GREEN}<CR>${NC}      - Enter/Return"
  echo -e "  ${GREEN}<Esc>${NC}     - Escape"
  echo -e "  ${GREEN}<Tab>${NC}     - Tab"
  echo -e "  ${GREEN}<S-Tab>${NC}   - Shift+Tab"
  echo -e "  ${GREEN}<C-x>${NC}     - Ctrl+x"
  echo ""
  echo -e "${CYAN}Usage Examples:${NC}"
  echo -e "  ${YELLOW}vcfg editmap list${NC}"
  echo -e "  ${YELLOW}vcfg editmap add '<leader>ff' ':Files<CR>'${NC}"
  echo -e "  ${YELLOW}vcfg editmap remove '<leader>ff'${NC}"
  echo -e "  ${YELLOW}vcfg editmap search 'leader'${NC}"
  echo ""
  echo -e "${CYAN}Interactive Mode:${NC}"
  echo -e "  Just run ${YELLOW}vcfg editmap${NC} without arguments"
}
