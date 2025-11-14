#!/usr/bin/env bash

# Load language modules
for lang_file in "${VCFG_ROOT}/commands/language"/*.sh; do
  source "$lang_file"
done

vcfg_cmd_language() {
  if [ $# -gt 0 ]; then
    case "$1" in
    list | -l) list_language "$2" ;;
    add | -a) add_language "$2" ;;
    disable) disable_language "$2" ;;
    enable) enable_language "$2" ;;
    info) info_language "$2" ;;
    remove | -r) remove_language "$2" ;;
    edit | -e) edit_language_file "$2" ;;
    esac
    return 1
  fi
  interactive_language
}
