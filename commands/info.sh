#!/usr/bin/env bash

vcfg_cmd_info() {
  local plugin=$1

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin name"
    echo "Usage: vcfg info <plugin-name>"
    return 1
  fi

  local plugin_manager=$(detect_plugin_manager)
  local config_file=$(get_plugin_config_file "$plugin_manager")

  if [ -z "$config_file" ] || [ ! -f "$config_file" ]; then
    print_error "No plugin manager configuration found"
    return 1
  fi

  case "$plugin_manager" in
  "vim-plug")
    info_vimplug_plugin "$plugin" "$config_file"
    ;;
  "packer.nvim")
    info_packer_plugin "$plugin" "$config_file"
    ;;
  "lazy.nvim")
    info_lazy_plugin "$plugin" "$config_file"
    ;;
  *)
    print_error "Unsupported plugin manager: $plugin_manager"
    return 1
    ;;
  esac
}

info_vimplug_plugin() {
  local plugin=$1
  local config_file=$2
  local plugin_line=$(grep "Plug.*${plugin}" "$config_file" | head -n 1)

  if [ -z "$plugin_line" ]; then
    print_error "Plugin '${plugin}' not found in configuration"
    return 1
  fi

  local full_name=$(echo "$plugin_line" | sed -n "s/.*Plug '\([^']*\)'.*/\1/p")
  local is_disabled=$(echo "$plugin_line" | grep -q "^\"" && echo "Yes" || echo "No")
  local plugins_dir="${HOME}/.vim/plugged/"

  print_header "Plugin Information (vim-plug)"

  printf "${WHITE}%-12s :${NC} ${CYAN}%s${NC}\n" "Name" "${full_name}"
  printf "${WHITE}%-12s :${NC} %s\n" "Disabled" "${is_disabled}"

  local plugins_path="${plugins_dir}${full_name##*/}"
  [[ "${full_name##*/}" == "fzf" ]] && plugins_path="${HOME}/.${full_name##*/}"

  local status path current_branch last_commit

  if [[ -d "${plugins_path}" ]]; then
    status="Installed"
    path="${plugins_path}"
    printf "${WHITE}%-12s :${NC} ${GREEN}%s${NC}\n" "Status" "Installed"
    printf "${WHITE}%-12s :${NC} %s\n" "Path" "${plugins_path}"

    # Get local git info
    if [ -d "$plugins_path/.git" ]; then
      cd "$plugins_path"
      current_branch=$(git branch --show-current 2>/dev/null)
      last_commit=$(git log -1 --format="%h %s" 2>/dev/null)
      cd - >/dev/null 2>&1

      if [ ! -z "$current_branch" ]; then
        printf "${WHITE}%-12s :${NC} %s\n" "Branch" "${current_branch}"
      fi
      if [ ! -z "$last_commit" ]; then
        printf "${WHITE}%-12s :${NC} %s\n" "Last commit" "${last_commit}"
      fi
    fi
  else
    printf "${WHITE}%-12s :${NC} ${YELLOW}%s${NC}\n" "Status" "Not installed"
  fi

  echo # Empty line for separation
  show_github_info "$full_name"
}

info_packer_plugin() {
  local plugin=$1
  local config_file=$2

  local plugin_line=$(grep "use.*${plugin}" "$config_file" | head -n 1)

  if [ -z "$plugin_line" ]; then
    print_error "Plugin '${plugin}' not found in configuration"
    return 1
  fi

  local full_name=$(echo "$plugin_line" | sed -n "s/.*use '\([^']*\)'.*/\1/p")
  local is_disabled=$(echo "$plugin_line" | grep -q "^--" && echo "Yes" || echo "No")
  local plugins_dir="${HOME}/.local/share/nvim/site/pack/packer"

  print_header "Plugin Information (packer.nvim)"
  printf "${WHITE}%-12s :${NC} ${CYAN}%s${NC}\n" "Name" "${full_name}"
  printf "${WHITE}%-12s :${NC} %s\n" "Disabled" "${is_disabled}"

  # Packer stores plugins in start/ and opt/ directories
  local plugin_dirs=(
    "${plugins_dir}/start/${full_name##*/}"
    "${plugins_dir}/opt/${full_name##*/}"
  )

  local installed_dir=""
  for dir in "${plugin_dirs[@]}"; do
    if [ -d "$dir" ]; then
      installed_dir="$dir"
      break
    fi
  done

  if [ ! -z "$installed_dir" ]; then
    printf "${WHITE}%-12s :${NC} ${GREEN}%s${NC}\n" "Status" "Installed"
    printf "${WHITE}%-12s :${NC} %s\n" "Path" "${installed_dir}"
    printf "${WHITE}%-12s :${NC} %s\n" "Type" "${installed_dir##*/}" # start or opt

    # Get local git info
    if [ -d "$installed_dir/.git" ]; then
      cd "$installed_dir"
      local current_branch=$(git branch --show-current 2>/dev/null)
      local last_commit=$(git log -1 --format="%h %s" 2>/dev/null)
      cd - >/dev/null 2>&1

      if [ ! -z "$current_branch" ]; then
        printf "${WHITE}%-12s :${NC} %s\n" "Branch" "${current_branch}"
      fi
      if [ ! -z "$last_commit" ]; then
        printf "${WHITE}%-12s :${NC} %s\n" "Last commit" "${last_commit}"
      fi
    fi
  else
    printf "${WHITE}%-12s :${NC} ${YELLOW}%s${NC}\n" "Status" "Not installed"
  fi

  echo # Empty line for separation
  show_github_info "$full_name"
}

info_lazy_plugin() {
  local plugin=$1
  local config_file=$2

  local plugin_line=$(grep "\"${plugin}\"" "$config_file" | head -n 1)

  if [ -z "$plugin_line" ]; then
    print_error "Plugin '${plugin}' not found in configuration"
    return 1
  fi

  local full_name=$(echo "$plugin_line" | sed -n 's/.*"\([^"]*\)".*/\1/p')
  local is_disabled=$(echo "$plugin_line" | grep -q "^--" && echo "Yes" || echo "No")
  local plugins_dir="${HOME}/.local/share/nvim/lazy"

  print_header "Plugin Information (lazy.nvim)"
  printf "${WHITE}%-12s :${NC} ${CYAN}%s${NC}\n" "Name" "${full_name}"
  printf "${WHITE}%-12s :${NC} %s\n" "Disabled" "${is_disabled}"

  if [ -d "${plugins_dir}/${full_name##*/}" ]; then
    printf "${WHITE}%-12s :${NC} ${GREEN}%s${NC}\n" "Status" "Installed"
    printf "${WHITE}%-12s :${NC} %s\n" "Path" "${plugins_dir}/${full_name##*/}"

    # Get local git info
    local plugin_dir="${plugins_dir}/${full_name##*/}"
    if [ -d "$plugin_dir/.git" ]; then
      cd "$plugin_dir"
      local current_branch=$(git branch --show-current 2>/dev/null)
      local last_commit=$(git log -1 --format="%h %s" 2>/dev/null)
      cd - >/dev/null 2>&1

      if [ ! -z "$current_branch" ]; then
        printf "${WHITE}%-12s :${NC} %s\n" "Branch" "${current_branch}"
      fi
      if [ ! -z "$last_commit" ]; then
        printf "${WHITE}%-12s :${NC} %s\n" "Last commit" "${last_commit}"
      fi
    fi
  else
    printf "${WHITE}%-12s :${NC} ${YELLOW}%s${NC}\n" "Status" "Not installed"
  fi

  echo # Empty line for separation
  show_github_info "$full_name"
}

show_github_info() {
  local full_name=$1
  # Try to get GitHub info if curl is available
  if command -v curl &>/dev/null && [[ "$full_name" =~ / ]]; then
    print_info "Fetching GitHub information..."

    local github_info=$(curl -s "https://api.github.com/repos/${full_name}")
    local description=$(echo "$github_info" | grep '"description"' | sed 's/.*"description": "\([^"]*\)".*/\1/' | head -1)
    local stars=$(echo "$github_info" | grep '"stargazers_count"' | sed 's/.*"stargazers_count": \([0-9]*\).*/\1/' | head -1)
    local forks=$(echo "$github_info" | grep '"forks_count"' | sed 's/.*"forks_count": \([0-9]*\).*/\1/' | head -1)
    local updated=$(echo "$github_info" | grep '"updated_at"' | sed 's/.*"updated_at": "\([^"]*\)".*/\1/' | head -1)
    local license=$(echo "$github_info" | grep '"license".*"name"' | sed 's/.*"name": "\([^"]*\)".*/\1/' | head -1)

    if [ ! -z "$description" ] && [ "$description" != "null" ]; then
      printf "${WHITE}%-12s :${NC} %s\n" "Description" "${description}"
    fi
    if [ ! -z "$stars" ] && [ "$stars" != "null" ]; then
      printf "${WHITE}%-12s :${NC} ${YELLOW}★${NC} %s\n" "Stars" "${stars}"
    fi
    if [ ! -z "$forks" ] && [ "$forks" != "null" ]; then
      printf "${WHITE}%-12s :${NC} ${BLUE}⑂${NC} %s\n" "Forks" "${forks}"
    fi
    if [ ! -z "$license" ] && [ "$license" != "null" ]; then
      printf "${WHITE}%-12s :${NC} %s\n" "License" "${license}"
    fi
    if [ ! -z "$updated" ] && [ "$updated" != "null" ]; then
      local formatted_date=$(date -d "$updated" "+%Y-%m-%d" 2>/dev/null || echo "$updated")
      printf "${WHITE}%-12s :${NC} %s\n" "Updated" "${formatted_date}"
    fi
  elif [[ "$full_name" =~ / ]]; then
    printf "${WHITE}%-12s :${NC} %s\n" "GitHub" "https://github.com/${full_name}"
  fi
}
