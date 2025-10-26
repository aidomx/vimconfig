#!/usr/bin/env bash

vcfg_cmd_clean() {
  check_vim_config
                                                             print_header "Cleaning Unused Plugins"

  print_info "Removing unused plugins..."
  vim -c 'PlugClean[!]' -c 'qa!' > /dev/null 2>&1 &
  local vim_pid=$!

  spinner $vim_pid
  wait $vim_pid

  print_success "Cleanup completed!"
}
