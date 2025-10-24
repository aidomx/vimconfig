#!/bin/bash
# vcfg - Vim Configuration Manager
# Version: 1.0.0
# Description: A command-line tool to manage Vim plugins easily

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration paths
VIM_CONFIG_DIR="${HOME}/.local/vim"
PLUGINS_FILE="${VIM_CONFIG_DIR}/core/plugins.vim"
VIM_PLUGINS_DIR="${HOME}/.vim/plugged"

# Version
VCFG_VERSION="1.0.0"

# ============================================
# Utility Functions
# ============================================

print_success() {
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

print_header() {
  echo -e "${CYAN}$(printf '=%.0s' {1..58})${NC}"
  echo -e "${WHITE}$1${NC}"
  echo -e "${CYAN}$(printf '=%.0s' {1..58})${NC}"
}

spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# ============================================
# Core Functions
# ============================================

vcfg_version() {
  echo -e "${CYAN}vcfg${NC} version ${GREEN}${VCFG_VERSION}${NC}"
}

vcfg_help() {
  echo -e "${CYAN}vcfg${NC} - Vim Configuration Manager"
  echo ""
  echo -e "${WHITE}USAGE:${NC}"
  echo "  vcfg <command> [arguments]"
  echo ""
  echo -e "${WHITE}COMMANDS:${NC}"
  echo -e "  ${GREEN}add${NC} <plugin>        Add a new plugin (e.g., 'tpope/vim-fugitive')"
  echo -e "  ${GREEN}remove${NC} <plugin>     Remove a plugin completely"
  echo -e "  ${GREEN}disable${NC} <plugin>    Disable a plugin (comment it out)"
  echo -e "  ${GREEN}enable${NC} <plugin>     Enable a disabled plugin"
  echo -e "  ${GREEN}list${NC}                List all installed plugins"
  echo -e "  ${GREEN}search${NC} <query>      Search for plugins on GitHub"
  echo -e "  ${GREEN}update${NC}              Update all plugins"
  echo -e "  ${GREEN}clean${NC}               Remove unused plugins"
  echo -e "  ${GREEN}info${NC} <plugin>       Show plugin information"
  echo ""
  echo -e "${WHITE}OPTIONS:${NC}"
  echo -e "  ${GREEN}--version${NC}           Show version information"
  echo -e "  ${GREEN}--help${NC}              Show this help message"
  echo ""
  echo -e "${WHITE}EXAMPLES:${NC}"
  echo "  vcfg add preservim/nerdtree"
  echo "  vcfg remove vim-airline"
  echo "  vcfg disable coc.nvim"
  echo "  vcfg search fuzzy"
  echo "  vcfg list"
  echo ""
  echo -e "${WHITE}PLUGIN FORMAT:${NC}"
  echo -e "  Full format: ${CYAN}username/repository${NC}"
  echo -e "  Short format: ${CYAN}plugin-name${NC} (will search for exact match)"
  echo ""
}

check_vim_config() {
  if [ ! -d "$VIM_CONFIG_DIR" ]; then
    print_error "Vim configuration directory not found: $VIM_CONFIG_DIR"
    exit 1
  fi

  if [ ! -f "$PLUGINS_FILE" ]; then
    print_error "Plugins file not found: $PLUGINS_FILE"
    exit 1
  fi
}

vcfg_add() {
  local plugin=$1

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to add"
    echo "Usage: vcfg add <username/repository>"
    exit 1
  fi

  check_vim_config

  # Check if plugin already exists
  if grep -q "Plug '${plugin}'" "$PLUGINS_FILE" 2> /dev/null; then
    print_warning "Plugin '${plugin}' is already in the configuration"
    exit 0
  fi

  print_info "Adding plugin: ${CYAN}${plugin}${NC}"

  # Add plugin before the call plug#end() line
  sed -i "/call plug#end()/i Plug '${plugin}'" "$PLUGINS_FILE"

  print_success "Plugin added to configuration"

  # Install the plugin
  print_info "Installing plugin..."
  vim -u "$HOME/.vimrc" -c 'PlugInstall' -c 'qa!' > /dev/null 2>&1 &
  local vim_pid=$!

  spinner $vim_pid
  wait $vim_pid

  print_success "Plugin '${GREEN}${plugin}${NC}' installed successfully!"
  print_info "Restart Vim to use the new plugin"
}

vcfg_remove() {
  local plugin=$1

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to remove"
    echo "Usage: vcfg remove <plugin-name>"
    exit 1
  fi

  check_vim_config

  # Search for plugin line
  local plugin_line=$(grep -n "Plug.*${plugin}" "$PLUGINS_FILE" | head -n 1)

  if [ -z "$plugin_line" ]; then
    print_error "Plugin '${plugin}' not found in configuration"
    exit 1
  fi

  print_warning "Removing plugin: ${CYAN}${plugin}${NC}"

  # Remove from plugins.vim
  sed -i "/Plug.*${plugin}/d" "$PLUGINS_FILE"

  print_success "Plugin removed from configuration"

  # Clean unused plugins
  print_info "Cleaning unused plugins..."
  vim -u "$HOME/.vimrc" -c 'PlugClean!' -c 'qa!' > /dev/null 2>&1 &
  local vim_pid=$!

  spinner $vim_pid
  wait $vim_pid

  print_success "Plugin '${GREEN}${plugin}${NC}' removed successfully!"
}

vcfg_disable() {
  local plugin=$1

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to disable"
    echo "Usage: vcfg disable <plugin-name>"
    exit 1
  fi

  check_vim_config

  # Check if plugin exists and is not already commented
  if ! grep -q "^Plug.*${plugin}" "$PLUGINS_FILE" 2> /dev/null; then
    if grep -q "^\".*Plug.*${plugin}" "$PLUGINS_FILE" 2> /dev/null; then
      print_warning "Plugin '${plugin}' is already disabled"
      exit 0
    else
      print_error "Plugin '${plugin}' not found in configuration"
      exit 1
    fi
  fi

  print_info "Disabling plugin: ${CYAN}${plugin}${NC}"

  # Comment out the plugin line
  sed -i "s/^Plug.*${plugin}/\" &/" "$PLUGINS_FILE"

  print_success "Plugin '${GREEN}${plugin}${NC}' disabled successfully!"
  print_info "Restart Vim to apply changes"
}

vcfg_enable() {
  local plugin=$1

  if [ -z "$plugin" ]; then
    print_error "Please specify a plugin to enable"
    echo "Usage: vcfg enable <plugin-name>"
    exit 1
  fi

  check_vim_config

  # Check if plugin exists and is commented
  if ! grep -q "^\".*Plug.*${plugin}" "$PLUGINS_FILE" 2> /dev/null; then
    if grep -q "^Plug.*${plugin}" "$PLUGINS_FILE" 2> /dev/null; then
      print_warning "Plugin '${plugin}' is already enabled"
      exit 0
    else
      print_error "Plugin '${plugin}' not found in configuration"
      exit 1
    fi
  fi

  print_info "Enabling plugin: ${CYAN}${plugin}${NC}"

  # Uncomment the plugin line
  sed -i "s/^\" Plug.*${plugin}/Plug '${plugin}'/" "$PLUGINS_FILE"

  print_success "Plugin '${GREEN}${plugin}${NC}' enabled successfully!"

  # Install if not already installed
  print_info "Installing plugin if needed..."
  vim -u "$HOME/.vimrc" -c 'PlugInstall' -c 'qa!' > /dev/null 2>&1 &
  local vim_pid=$!

  spinner $vim_pid
  wait $vim_pid

  print_info "Restart Vim to use the plugin"
}

vcfg_list() {
  check_vim_config

  print_header "Installed Plugins"

  local count_enabled=0
  local count_disabled=0
  local count_installed=0

  # Read from plugins.vim - simplified approach
  while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines
    [ -z "$line" ] && continue

    # Check for active plugins
    if echo "$line" | grep -q "^[[:space:]]*Plug "; then
      local plugin=$(echo "$line" | sed "s/.*Plug[[:space:]]*'\([^']*\)'.*/\1/")

      if [ ! -z "$plugin" ] && [ "$plugin" != "$line" ]; then
        local plugin_name="${plugin##*/}"
        local install_status=""

        # Check if actually installed in .vim/plugged
        if [ -d "${VIM_PLUGINS_DIR}/${plugin_name}" ]; then
          install_status=" ${CYAN}[installed]${NC}"
          count_installed=$((count_installed + 1))
        else
          install_status=" ${RED}[not installed]${NC}"
        fi

        echo -e "  ${GREEN}✓${NC} ${WHITE}${plugin}${NC}${install_status}"
        count_enabled=$((count_enabled + 1))
      fi
    # Check for disabled plugins (commented out)
    elif echo "$line" | grep -q "^[[:space:]]*\".*Plug "; then
      local plugin=$(echo "$line" | sed "s/.*Plug[[:space:]]*'\([^']*\)'.*/\1/")

      if [ ! -z "$plugin" ] && [ "$plugin" != "$line" ]; then
        echo -e "  ${YELLOW}⊘${NC} ${WHITE}${plugin}${NC} ${YELLOW}(disabled)${NC}"
        count_disabled=$((count_disabled + 1))
      fi
    fi
  done < "$PLUGINS_FILE"

  echo ""

  # Show summary
  local total=$((count_enabled + count_disabled))
  print_info "Summary:"
  echo -e "  ${GREEN}Enabled:${NC}     ${count_enabled}"
  echo -e "  ${YELLOW}Disabled:${NC}    ${count_disabled}"
  echo -e "  ${CYAN}Installed:${NC}   ${count_installed}"
  echo -e "  ${WHITE}Total:${NC}       ${total}"

  # Show orphaned plugins (installed but not in config)
  if [ -d "$VIM_PLUGINS_DIR" ] && [ "$(ls -A $VIM_PLUGINS_DIR 2> /dev/null)" ]; then
    echo ""
    print_info "Checking for orphaned plugins..."

    local orphaned=0
    for plugin_dir in "$VIM_PLUGINS_DIR"/*; do
      [ ! -d "$plugin_dir" ] && continue

      local plugin_name=$(basename "$plugin_dir")

      # Check if this plugin exists in config
      if ! grep -q "Plug.*${plugin_name}" "$PLUGINS_FILE" 2> /dev/null; then
        if [ $orphaned -eq 0 ]; then
          echo ""
          echo -e "${RED}Orphaned plugins (not in config):${NC}"
        fi
        echo -e "  ${RED}✗${NC} ${plugin_name}"
        orphaned=$((orphaned++))
      fi
    done

    if [ $orphaned -gt 0 ]; then
      echo ""
      print_warning "Found ${orphaned} orphaned plugin(s)"
      print_info "Run '${CYAN}vcfg clean${NC}' to remove them"
    fi
  fi
}

vcfg_search() {
  local query=$1
  local page=${2:-1}      # Default page 1
  local per_page=${3:-20} # Default 20 results

  if [ -z "$query" ]; then
    print_error "Please specify a search query"
    echo "Usage: vcfg search <query>"
    echo "       vcfg search <query> <page> <per_page>"
    return 1
  fi

  print_header "Searching for: ${CYAN}${query}${NC} (Page $page)"

  if ! command -v curl &> /dev/null; then
    print_error "curl is required for search functionality"
    return 1
  fi

  print_info "Searching GitHub repositories..."

  # URL encode dan siapkan query variants
  local encoded_query
  encoded_query=$(echo "$query" | sed 's/ /+/g')
  local lowercase_query=$(echo "$query" | tr '[:upper:]' '[:lower:]')
  local uppercase_query=$(echo "$query" | tr '[:lower:]' '[:upper:]')

  # Split query untuk mencari username/repo pattern
  local username=""
  local repo_name=""
  if [[ "$query" =~ / ]]; then
    username=$(echo "$query" | cut -d'/' -f1)
    repo_name=$(echo "$query" | cut -d'/' -f2)
  elif [[ "$query" =~ ^[0-9]+$ ]]; then
    print_warning "Query '$query' is invalid"
    return 0
  fi

  # Comprehensive search variants - lebih dalam dan flexible
  local api_urls=(
    # Exact username/repo search jika ada pattern username/repo
    "https://api.github.com/search/repositories?q=${encoded_query}&sort=stars&order=desc&page=${page}&per_page=${per_page}"

    # User-specific searches
    "https://api.github.com/search/repositories?q=user:${username}+${repo_name}&sort=stars&order=desc&page=${page}&per_page=${per_page}"

    # Case variations
    "https://api.github.com/search/repositories?q=${lowercase_query}+vim&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${uppercase_query}+vim&sort=stars&order=desc&page=${page}&per_page=${per_page}"

    # Vim/Neovim specific dengan berbagai kombinasi
    "https://api.github.com/search/repositories?q=${encoded_query}+vim+plugin&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+vim+config&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+vim+theme&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+vim+colorscheme&sort=stars&order=desc&page=${page}&per_page=${per_page}"

    # Neovim specific
    "https://api.github.com/search/repositories?q=${encoded_query}+neovim+plugin&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+neovim+config&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+nvim+plugin&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+nvim+config&sort=stars&order=desc&page=${page}&per_page=${per_page}"

    # Generic plugin searches
    "https://api.github.com/search/repositories?q=${encoded_query}+plugin&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+configuration&sort=stars&order=desc&page=${page}&per_page=${per_page}"

    # Description-based searches
    "https://api.github.com/search/repositories?q=${encoded_query}+in:description+vim&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+in:name+vim&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+in:readme+vim&sort=stars&order=desc&page=${page}&per_page=${per_page}"

    # Topic-based searches
    "https://api.github.com/search/repositories?q=${encoded_query}+topic:vim&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+topic:neovim&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+topic:vim-plugin&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+topic:nvim-plugin&sort=stars&order=desc&page=${page}&per_page=${per_page}"
  )

  local response=""
  local api_url=""
  local found_results=0
  local used_url=""

  # Coba setiap variant query sampai dapat hasil
  for api_url in "${api_urls[@]}"; do
    # Skip URL yang kosong atau invalid
    if [[ -z "$api_url" || "$api_url" == "https://api.github.com/search/repositories?q=+"* ]]; then
      continue
    fi

    if [ "${VCFG_DEBUG:-false}" = "true" ]; then
      echo "DEBUG: Trying API URL: $api_url" >&2
    fi

    response=$(curl -s --max-time 10 "$api_url")

    if [ $? -eq 0 ] && [ -n "$response" ]; then
      # Check for API errors
      if echo "$response" | grep -q '"message"' && ! echo "$response" | grep -q '"items"'; then
        local error_msg=$(echo "$response" | sed -n 's/.*"message": "\([^"]*\)".*/\1/p')
        if [ "${VCFG_DEBUG:-false}" = "true" ]; then
          echo "DEBUG: API Error: $error_msg" >&2
        fi
        continue
      fi

      # Check if we have results
      if command -v jq &> /dev/null; then
        local total_count=$(echo "$response" | jq -r '.total_count // 0')
        if [ -n "$total_count" ] && [ "$total_count" -gt 0 ]; then
          found_results=1
          used_url="$api_url"
          break
        fi
      else
        local total_count=$(echo "$response" | grep -o '"total_count":[0-9]*' | head -1 | cut -d: -f2)
        if [ -n "$total_count" ] && [ "$total_count" -gt 0 ]; then
          found_results=1
          used_url="$api_url"
          break
        fi
      fi
    fi
    response=""
  done

  if [ "${VCFG_DEBUG:-false}" = "true" ] && [ -n "$used_url" ]; then
    echo "DEBUG: Used API URL: $used_url" >&2
  fi

  if [ $found_results -eq 0 ] || [ -z "$response" ]; then
    print_warning "No results found for '${query}'"
    echo ""
    print_info "Search tips:"
    echo -e "  - Try: ${CYAN}vcfg search 'username/repository'${NC} (exact match)"
    echo -e "  - Try: ${CYAN}vcfg search 'plugin-name vim'${NC}"
    echo "  - Use specific terms like 'theme', 'colorscheme', 'lsp'"
    echo "  - Check spelling or use different keywords"
    return 0
  fi

  # Check for API errors in the final response
  if echo "$response" | grep -q '"message"' && ! echo "$response" | grep -q '"items"'; then
    local error_msg
    error_msg=$(echo "$response" | sed -n 's/.*"message": "\([^"]*\)".*/\1/p')
    print_error "GitHub API error: ${error_msg}"
    return 1
  fi

  # Parse response dan format output
  local output
  if [[ "$page" =~ [a-zA-Z] ]]; then
    print_warning "Page '$page' must contain number only"
    return 0
  fi

  output=$(format_search_results "$response" "$query" "$page" "$per_page")

  # Tampilkan dengan less untuk interactive scrolling
  echo "$output" | less -R -X -F -K

  # Show follow-up instructions after less exits
  if [ $? -eq 0 ]; then
    echo ""
    print_info "Navigation tips:"
    echo -e "  - Press ${CYAN}q${NC} to quit"
    echo -e "  - Use ${CYAN}arrow keys${NC}, ${CYAN}Page Up/Down${NC} to scroll"
    echo -e "  - Press ${CYAN}/${NC} to search within results"
    echo ""
    print_info "To see more results: ${CYAN}vcfg search '$query' $((page + 1))${NC}"
    print_info "To install: ${CYAN}vcfg add <username/repository>${NC}"
  fi
}

# Fungsi helper untuk format hasil pencarian
format_search_results() {
  local response="$1"
  local query="$2"
  local page="$3"
  local per_page="$4"

  local total_count=0
  local output=""

  # Get total count
  if command -v jq &> /dev/null; then
    total_count=$(echo "$response" | jq -r '.total_count // 0')
  else
    total_count=$(echo "$response" | grep -o '"total_count":[0-9]*' | head -1 | cut -d: -f2)
    total_count=${total_count:-0}
  fi

  # Header
  output+="${BOLD}Search results for: ${CYAN}${query}${NC}${BOLD}\n"
  output+="Page: ${page} | Results: ${total_count} total${NC}\n"
  output+="$(printf '=%.0s' {1..58})\n\n"

  # Parse results
  if command -v jq &> /dev/null; then
    output+=$(echo "$response" | jq -r '.items[] | "\(.full_name)|\(.stargazers_count)|\(.description // "No description")"' \
      | {
        local count=$(((page - 1) * per_page + 1))
        while IFS='|' read -r repo stars desc; do
          local line=""
          line+="${GREEN}$(printf "%2d" $count).${NC} ${CYAN}$(printf "%-40s" "$repo")${NC}\n"
          line+="   ${YELLOW}⭐${NC} ${WHITE}$stars${NC} stars\n"

          if [ "$desc" = "No description" ] || [ "$desc" = "null" ] || [ -z "$desc" ]; then
            line+="   ${GRAY}No description available${NC}\n"
          else
            local short_desc
            if [ ${#desc} -gt 80 ]; then
              short_desc="${desc:0:77}..."
            else
              short_desc="$desc"
            fi
            line+="   $(echo "$short_desc" | fold -sw 78 | sed '2,$s/^/   /')\n"
          fi
          line+="\n"
          printf "%s" "$line"
          count=$((count + 1))
        done
      })
  else
    output+=$(echo "$response" | grep -E '"full_name"|"description"|"stargazers_count"' \
      | sed 's/.*"full_name": "\([^"]*\)".*/\1/; 
           s/.*"stargazers_count": \([0-9]*\).*/\1/;
           s/.*"description": "\([^"]*\)".*/\1/;' \
      | paste - - - \
      | {
        local count=$(((page - 1) * per_page + 1))
        while IFS=$'\t' read -r repo stars desc; do
          local line=""
          line+="${GREEN}$(printf "%2d" $count).${NC} ${CYAN}$(printf "%-40s" "$repo")${NC}\n"
          line+="   ${YELLOW}⭐${NC} ${WHITE}$stars${NC} stars\n"

          if [ "$desc" = "null" ] || [ -z "$desc" ]; then
            line+="   ${GRAY}No description available${NC}\n"
          else
            local short_desc
            if [ ${#desc} -gt 80 ]; then
              short_desc="${desc:0:77}..."
            else
              short_desc="$desc"
            fi
            line+="   $(echo "$short_desc" | fold -sw 78 | sed '2,$s/^/   /')\n"
          fi
          line+="\n"
          printf "%s" "$line"
          count=$((count + 1))
        done
      })
  fi

  # Footer
  output+="\n$(printf '=%.0s' {1..58})\n"
  output+="${BOLD}Navigation:${NC}\n"
  output+="  - Press ${GREEN}q${NC} to quit\n"
  output+="  - Use ${GREEN}arrow keys${NC} or ${GREEN}Page Up/Down${NC} to scroll\n"
  output+="  - Press ${GREEN}/${NC} to search within results\n"
  output+="\n"

  if [ $total_count -gt $((page * per_page)) ]; then
    output+="${BOLD}More results available!${NC}\n"
    output+="Run: ${CYAN}vcfg search '$query' $((page + 1))${NC}\n"
  fi

  echo -e "$output"
}

# Fungsi untuk search dengan interactive mode
vcfg_search_interactive() {
  local query=$1
  local page=1
  local per_page=20

  while true; do
    clear
    vcfg_search "$query" "$page" "$per_page"

    echo ""
    read -p "Press: [n]ext page, [p]revious page, [q]uit, or enter page number: " choice

    case "$choice" in
      n | N)
        page=$((page + 1))
        ;;
      p | P)
        if [ $page -gt 1 ]; then
          page=$((page - 1))
        else
          echo "Already on first page!"
          sleep 1
        fi
        ;;
      q | Q)
        break
        ;;
      [0-9]*)
        if [ "$choice" -gt 0 ]; then
          page="$choice"
        else
          echo "Invalid page number!"
          sleep 1
        fi
        ;;
      *)
        echo "Invalid choice!"
        sleep 1
        ;;
    esac
  done
}

vcfg_update() {
  check_vim_config

  print_header "Updating Plugins"

  # Get list of plugins
  local plugins=()
  while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] && continue

    if echo "$line" | grep -q "^[[:space:]]*Plug "; then
      local plugin=$(echo "$line" | sed "s/.*Plug[[:space:]]*'\([^']*\)'.*/\1/")
      if [ ! -z "$plugin" ] && [ "$plugin" != "$line" ]; then
        plugins+=("$plugin")
      fi
    fi
  done < "$PLUGINS_FILE"

  local total=${#plugins[@]}

  if [ $total -eq 0 ]; then
    print_warning "No plugins found to update"
    return
  fi

  print_info "Found ${total} plugin(s) to update"
  echo ""

  local current=0
  local updated=0
  local failed=0

  for plugin in "${plugins[@]}"; do
    current=$((current + 1))
    local plugin_name="${plugin##*/}"
    local plugin_dir="${VIM_PLUGINS_DIR}/${plugin_name}"

    # Calculate percentage
    local percent=$((current * 100 / total))

    # Progress bar (20 chars width)
    local filled=$((percent / 5))
    local empty=$((20 - filled))
    local bar=$(printf "%${filled}s" | tr ' ' '#')
    local space=$(printf "%${empty}s" | tr ' ' '-')

    # Display progress
    printf "\r[${GREEN}${bar}${NC}${space}] ${percent}%% - Updating: ${CYAN}%-40s${NC}" "$plugin_name"

    # Update plugin if directory exists
    if [ -d "$plugin_dir" ]; then
      if [ -d "$plugin_dir/.git" ]; then
        cd "$plugin_dir"
        local output=$(git pull --quiet 2>&1)
        local exit_code=$?

        if [ $exit_code -eq 0 ]; then
          if echo "$output" | grep -q "Already up to date"; then
            # No update needed
            :
          else
            updated=$((updated + 1))
          fi
        else
          failed=$((failed + 1))
        fi
        cd - > /dev/null 2>&1
      fi
    fi
  done

  # Clear progress line and show results
  printf "\r%-80s\r" " "

  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  if [ $updated -gt 0 ]; then
    print_success "Updated: ${updated} plugin(s)"
  fi

  if [ $failed -gt 0 ]; then
    print_error "Failed: ${failed} plugin(s)"
  fi

  if [ $updated -eq 0 ] && [ $failed -eq 0 ]; then
    print_info "All plugins are up to date!"
  fi

  print_info "Run 'vim +PlugUpdate' for detailed update information"
}

vcfg_clean() {
  check_vim_config

  print_header "Cleaning Unused Plugins"

  print_info "Removing unused plugins..."
  vim -u "$HOME/.vimrc" -c 'PlugClean!' -c 'qa!' > /dev/null 2>&1 &
  local vim_pid=$!

  spinner $vim_pid
  wait $vim_pid

  print_success "Cleanup completed!"
}

vcfg_info() {
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

# ============================================
# Installation Function
# ============================================

install_vcfg_binary() {
  print_header "Installing vcfg"

  local source_file="${VIM_CONFIG_DIR}/vcfg.sh"
  local target_file="/usr/bin/vcfg"

  if [ ! -f "$source_file" ]; then
    print_error "Source file not found: $source_file"
    exit 1
  fi

  print_info "Installing vcfg to ${target_file}..."

  if [ -w "/usr/bin" ]; then
    cp "$source_file" "$target_file"
    chmod +x "$target_file"
  else
    print_info "Requires sudo privileges"
    sudo cp "$source_file" "$target_file"
    sudo chmod +x "$target_file"
  fi

  print_success "vcfg installed successfully!"

  # Test installation
  if command -v vcfg &> /dev/null; then
    print_success "Installation verified"
    vcfg --version
  else
    print_error "Installation verification failed"
    exit 1
  fi
}

# ============================================
# Main Function
# ============================================

main() {
  local command=$1
  shift

  case "$command" in
    add)
      vcfg_add "$@"
      ;;
    remove)
      vcfg_remove "$@"
      ;;
    disable)
      vcfg_disable "$@"
      ;;
    enable)
      vcfg_enable "$@"
      ;;
    list)
      vcfg_list
      ;;
    search)
      vcfg_search "$@"
      ;;
    update)
      vcfg_update
      ;;
    clean)
      vcfg_clean
      ;;
    info)
      vcfg_info "$@"
      ;;
    --version | -v)
      vcfg_version
      ;;
    --help | -h | help)
      vcfg_help
      ;;
    install)
      install_vcfg_binary
      ;;
    *)
      if [ -z "$command" ]; then
        vcfg_help
      else
        print_error "Unknown command: $command"
        echo "Run 'vcfg --help' for usage information"
        exit 1
      fi
      ;;
  esac
}

# Run main function
main "$@"
