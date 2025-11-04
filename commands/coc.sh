#!/usr/bin/env bash

# Load coc modules
for coc_file in "${VCFG_ROOT}/commands/coc"/*.sh; do
  source "$coc_file"
done

vcfg_cmd_coc() {
  if [ $# -eq 0 ]; then
    print_error "Usage: vcfg coc <command> [extension]"
    echo ""
    echo "Commands:"
    echo "  list                      - List installed Coc extensions"
    echo "  add <extension>           - Add Coc extension"
    echo "  remove <extension>        - Remove Coc extension"
    # echo "  install                   - Install all extensions"
    echo "  update                    - Update all extensions"
    echo "  -e, --edit                - Edit coc.vim manually"
    echo "  show                      - Show current extensions"
    echo ""
    echo "Examples:"
    echo "  vcfg coc add coc-eslint"
    echo "  vcfg coc remove coc-python"
    echo "  vcfg coc list"
    return 1
  fi

  local command=$1
  local extension=${2:-}
  local coc_file="${VCFG_ROOT:-$HOME/.config/vim}/core/coc.vim"

  ensure_coc_file "$coc_file"

  case "$command" in
    "list") list_coc_extensions "$coc_file" ;;
    "add" | "install" | "-i")
      [ -z "$extension" ] && print_error "Usage: vcfg coc add <extension>" && return 1
      add_coc_extension "$extension" "$coc_file"
      ;;
    "remove" | "rm")
      [ -z "$extension" ] && print_error "Usage: vcfg coc remove <extension>" && return 1
      remove_coc_extension "$extension" "$coc_file"
      ;;
    # "install") install_coc_extensions "$coc_file" ;;
    "update" | "-u") update_coc_extensions "$coc_file" ;;
    "-e" | "--edit") edit_coc_file "$coc_file" ;;

    "show" | "-s")
      local param1="${2:-}"
      local param2="${3:-}"

      # Jika tidak ada parameter, tampilkan semua
      if [ -z "$param1" ]; then
        show_coc_extensions "$coc_file"
      # Jika ada dua parameter angka (range atau specific rows)
      elif [ -n "$param1" ] && [ -n "$param2" ]; then
        if [[ "$param1" =~ ^[0-9]+$ ]] && [[ "$param2" =~ ^[0-9]+$ ]] && [ "$param1" -gt 0 ] && [ "$param2" -gt 0 ]; then
          # Jika param1 > param2, swap
          if [ "$param1" -gt "$param2" ]; then
            local temp="$param1"
            param1="$param2"
            param2="$temp"
          fi
          show_coc_extensions "$coc_file" "$param1:$param2"
        else
          print_warning "Invalid range: '$param1 $param2'. Showing all extensions."
          show_coc_extensions "$coc_file"
        fi
      # Jika satu parameter (limit atau single row)
      else
        if [[ "$param1" =~ ^[0-9]+$ ]] && [ "$param1" -gt 0 ]; then
          show_coc_extensions "$coc_file" "$param1"
        else
          print_warning "Invalid parameter: '$param1'. Showing all extensions."
          show_coc_extensions "$coc_file"
        fi
      fi
      ;;

    *)
      print_error "Unknown command: $command"
      echo "Run 'vcfg coc' for usage information"
      return 1
      ;;
  esac
}
