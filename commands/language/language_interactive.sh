#!/usr/bin/env bash

interactive_language() {
  local lang_dir="${VCFG_LANGS_DIR}"
  local languages=($(find $lang_dir -name "*.vim"))

  for lang in "${languages[@]}"; do
    ! [ -f "$lang" ] && print_error "Languages file not found: ${lang}" | return 1
  done

  print_header "Interactive language"
  show_language_help

  while true; do
    read -p "$(echo -e "${BLUE}>> ${NC}")" command

    local cmd=$(echo "$command" | awk -F' ' {'print $1'})
    local args=$(echo "$command" | awk -F' ' {'print $2'})

    case "$cmd" in
    list | -l) list_language ;;
    add | -a) add_language "$args" ;;
    disable) disable_language "$args" ;;
    enable) enable_language "$args" ;;
    info) info_language "$args" ;;
    remove | -r) remove_language "$args" ;;
    edit | -e) edit_language_file "$args" ;;
    quit | q)
      print_info "Goodbye!"
      break
      ;;
    help | h) show_language_help ;;
    "")
      # Do nothing on empty input
      ;;
    *)
      # Try to execute as direct command
      if [[ "$command" =~ ^(add|disable|edit|enable|info|list|remove) ]]; then
        eval "vcfg_cmd_language $command"
      else
        print_error "Unknown command: $command"
        echo "Type 'help' for available commands"
      fi
      ;;
    esac
  done
}

edit_language_file() {
  local language_file="${VCFG_LANGS_DIR}/${1:-*}"
  if [ -f "$language_file" ]; then
    :
  elif [ -f "$language_file.vim" ]; then
    language_file="$language_file.vim"
  else
    print_error "Opening language file is failed : No such file $language_file"
    return
  fi

  print_info "Opening languages file in editor..."
  if [ -n "$EDITOR" ]; then
    $EDITOR "$language_file"
  elif command -v nvim >/dev/null; then
    nvim "$language_file"
  elif command -v vim >/dev/null; then
    vim "$language_file"
  else
    vi "$language_file"
  fi
}
