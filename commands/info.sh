#!/usr/bin/env bash

vcfg_cmd_info() {
  local plugin=$1

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin name"
    echo "Usage: vcfg info <plugin-name>"
    exit 1
  fi

  check_vim_config

  local plugin_line=$(grep "Plug.*${plugin}" "$PLUGINS_FILE" | head -n 1)

  if [ -z "$plugin_line" ]; then
    print_error "Plugin '${plugin}' not found in configuration"
    exit 1
  fi

  local full_name=$(echo "$plugin_line" | sed -n "s/.*Plug '\([^']*\)'.*/\1/p")
  local is_disabled=$(echo "$plugin_line" | grep -q "^\"" && echo "Yes" || echo "No")

  print_header "Plugin Information"
  echo -e "${WHITE}Name:${NC}     ${CYAN}${full_name}${NC}"
  echo -e "${WHITE}Disabled:${NC} ${is_disabled}"

  if [ -d "${VIM_PLUGINS_DIR}/${full_name##*/}" ]; then
    echo -e "${WHITE}Status:${NC}   ${GREEN}Installed${NC}"
    echo -e "${WHITE}Path:${NC}     ${VIM_PLUGINS_DIR}/${full_name##*/}"
  else
    echo -e "${WHITE}Status:${NC}   ${YELLOW}Not installed${NC}"
  fi

  # Try to get GitHub info if curl is available
  if command -v curl &> /dev/null && [[ "$full_name" =~ / ]]; then
    local github_info=$(curl -s "https://api.github.com/repos/${full_name}")
    local description=$(echo "$github_info" | grep '"description"' | sed 's/.*"description": "\(.*\)",/\1/')
    local stars=$(echo "$github_info" | grep '"stargazers_count"' | sed 's/.*"stargazers_count": \([0-9]*\).*/\1/')

    if [ ! -z "$description" ]; then
      echo -e "${WHITE}Description:${NC} ${description}"
    fi
    if [ ! -z "$stars" ]; then
      echo -e "${WHITE}Stars:${NC}    ${WHITE}★${NC} ${stars}"
    fi
  fi
}
