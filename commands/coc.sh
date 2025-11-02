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
    echo "  install                   - Install all extensions"
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
    "add")
      [ -z "$extension" ] && print_error "Usage: vcfg coc add <extension>" && return 1
      add_coc_extension "$extension" "$coc_file"
      ;;
    "remove" | "rm")
      [ -z "$extension" ] && print_error "Usage: vcfg coc remove <extension>" && return 1
      remove_coc_extension "$extension" "$coc_file"
      ;;
    "install") install_coc_extensions "$coc_file" ;;
    "update") update_coc_extensions "$coc_file" ;;
    "-e" | "--edit") edit_coc_file "$coc_file" ;;
    "show") show_coc_extensions "$coc_file" ;;
    *)
      print_error "Unknown command: $command"
      echo "Run 'vcfg coc' for usage information"
      return 1
      ;;
  esac
}
