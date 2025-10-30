#!/usr/bin/env bash

vcfg_cmd_coc() {
  if [ $# -eq 0 ]; then
    show_coc_help
    return 1
  fi

  local subcommand=$1
  shift
  local extension="$*"

  # Get editor once for all subcommands
  local editor
  editor=$(get_editor_installed) || return 1

  case "$subcommand" in
    install | add)
      if [ -z "$extension" ]; then
        print_error "Please specify Coc extension to install"
        echo "Usage: vcfg coc install <extension>"
        echo "Example: vcfg coc install coc-tsserver"
        return 1
      fi
      install_coc_extension "$extension" "$editor"
      ;;
    list | ls)
      list_coc_extensions "$editor"
      ;;
    uninstall | remove)
      if [ -z "$extension" ]; then
        print_error "Please specify Coc extension to remove"
        echo "Usage: vcfg coc remove <extension>"
        return 1
      fi
      remove_coc_extension "$extension" "$editor"
      ;;
    update | up)
      update_coc_extensions "$editor"
      ;;
    config)
      open_coc_config
      ;;
    search)
      search_coc_extensions "$extension"
      ;;
    *)
      show_coc_help
      ;;
  esac
}

list_coc_extensions() {
  local editor=$1
  print_header "Installed Coc Extensions"

  # Check if Coc.nvim is installed
  if [ ! -d "${HOME}/.vim/plugged/coc.nvim" ] \
    && [ ! -d "${HOME}/.config/coc" ]; then
    print_error "Coc.nvim is not installed"
    echo ""
    print_info "Install Coc.nvim with: ${CYAN}vcfg add neoclide/coc.nvim${NC}"
    return 1
  fi

  print_info "Fetching installed extensions using $editor..."

  case "$editor" in
    "nvim")
      # list_coc_extensions_nvim
      ;;
    "vim")
      list_coc_extensions_vim
      ;;
    *)
      print_error "Unsupported editor: $editor"
      return 1
      ;;
  esac
}

list_coc_extensions_nvim() {
  local extensions
  extensions=$(nvim --headless -c "
    if exists('*CocAction')
      let exts = CocAction('extensionStats')
      if !empty(exts)
        for ext in exts
          echo ext.id . '|' . (get(ext, 'version', 'unknown')) . '|' . (ext.state == 'activated' ? 'active' : 'inactive')
        endfor
      else
        echo 'NO_EXTENSIONS'
      endif
    else
      echo 'COC_NOT_LOADED'
    endif
    quit
  " 2> /dev/null)

  handle_coc_extensions_result "$extensions"
}

coc_action() {
  echo "GetExtensionsCoc()"
  #echo "
  #if exists('*CocAction')
  #let exts = CocAction('extensionStats')
  #if !empty(exts)
  #for ext in exts
  #echo ext.id . '|' . (get(ext, 'version', 'unknown')) . '|' . (ext.state == 'activated' ? 'active' : 'inactive')
  #endfor
  #else
  #echo 'NO_EXTENSIONS'
  #endif
  #else
  #echo 'COC_NOT_LOADED'
  #endif
  #quit"
}

list_coc_extensions_vim() {
  echo "list extensions"
  # handle_coc_extensions_result "$extensions"
}

handle_coc_extensions_result() {
  local extensions="$1"

  case "$extensions" in
    "COC_NOT_LOADED")
      print_error "Coc.nvim is not properly loaded"
      echo ""
      print_info "Make sure Coc.nvim is installed and Vim is restarted"
      return 1
      ;;
    "NO_EXTENSIONS")
      print_warning "No Coc extensions installed"
      echo ""
      print_info "Install extensions with: ${CYAN}vcfg coc install <extension>${NC}"
      echo ""
      show_popular_coc_extensions
      return 0
      ;;
    "")
      print_error "Failed to fetch extensions"
      return 1
      ;;
    *)
      echo $extensions
      # display_coc_extensions "$extensions"
      ;;
  esac
}

install_coc_extension() {
  local extension=$1
  local editor=$2

  print_info "Installing Coc extension: $extension using $editor"

  # Validate extension name
  if [[ ! "$extension" =~ ^coc- ]]; then
    print_warning "Extension name should start with 'coc-'. Adding prefix..."
    extension="coc-${extension}"
    print_info "Using: $extension"
  fi

  case "$editor" in
    "nvim")
      nvim --headless -c "CocInstall $extension" -c "qa!" 2> /dev/null &
      ;;
    "vim")
      vim --not-a-term -c "CocInstall $extension" -c "qa!" 2> /dev/null &
      ;;
  esac

  local pid=$!
  spinner $pid "Installing $extension"

  if wait $pid; then
    print_success "Coc extension '$extension' installed successfully"
    show_extension_info "$extension"
  else
    print_error "Failed to install Coc extension '$extension'"
    print_info "Check if the extension name is correct: ${CYAN}vcfg coc search ${extension#coc-}${NC}"
  fi
}

remove_coc_extension() {
  local extension=$1
  local editor=$2

  print_info "Removing Coc extension: $extension using $editor"

  # Validate extension name
  if [[ ! "$extension" =~ ^coc- ]]; then
    extension="coc-${extension}"
    print_info "Using: $extension"
  fi

  # Confirm removal
  read -p "Are you sure you want to remove $extension? (y/N): " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    print_info "Removal cancelled"
    return 0
  fi

  case "$editor" in
    "nvim")
      nvim --headless -c "CocUninstall $extension" -c "qa!" 2> /dev/null &
      ;;
    "vim")
      vim --not-a-term -c "CocUninstall $extension" -c "qa!" 2> /dev/null &
      ;;
  esac

  local pid=$!
  spinner $pid "Removing $extension"

  if wait $pid; then
    print_success "Coc extension '$extension' removed successfully"
  else
    print_error "Failed to remove Coc extension '$extension'"
    print_info "The extension might not be installed"
  fi
}

update_coc_extensions() {
  local editor=$1
  print_header "Updating Coc Extensions using $editor"

  print_info "Checking for updates..."

  local outdated
  case "$editor" in
    "nvim")
      outdated=$(nvim --headless -c "
        let outdated = CocAction('outdatedExtensions')
        if !empty(outdated)
          for ext in outdated
            echo ext.name . '|' . ext.current . '->' . ext.latest
          endfor
        else
          echo 'UP_TO_DATE'
        endif
        quit
      " 2> /dev/null)
      ;;
    "vim")
      outdated=$(vim --not-a-term -c "
        let outdated = CocAction('outdatedExtensions')
        if !empty(outdated)
          for ext in outdated
            echo ext.name . '|' . ext.current . '->' . ext.latest
          endfor
        else
          echo 'UP_TO_DATE'
        endif
        quit
      " 2> /dev/null)
      ;;
  esac

  if [ "$outdated" = "UP_TO_DATE" ]; then
    print_success "All Coc extensions are up to date!"
    return 0
  fi

  if [ -n "$outdated" ]; then
    echo ""
    echo -e "${YELLOW}Outdated extensions:${NC}"
    echo "$outdated" | while IFS='|' read -r name versions; do
      echo -e "  ${CYAN}$name${NC} ${GRAY}$versions${NC}"
    done
    echo ""
  fi

  print_info "Updating all extensions..."

  case "$editor" in
    "nvim")
      nvim --headless -c "CocUpdate" -c "qa!" 2> /dev/null &
      ;;
    "vim")
      vim --not-a-term -c "CocUpdate" -c "qa!" 2> /dev/null &
      ;;
  esac

  local pid=$!
  spinner $pid "Updating extensions"

  if wait $pid; then
    print_success "Coc extensions updated successfully"
    local updated_count=$(echo "$outdated" | grep -c '|' || echo 0)
    if [ "$updated_count" -gt 0 ]; then
      echo ""
      print_success "Updated $updated_count extensions"
    fi
  else
    print_error "Failed to update Coc extensions"
  fi
}

display_coc_extensions() {
  local extensions="$1"
  local count=0

  echo ""
  while IFS='|' read -r name version state; do
    if [ -n "$name" ]; then
      count=$((count + 1))
      case "$state" in
        "active")
          echo -e "  ${GREEN}●${NC} ${CYAN}$(printf "%-25s" "$name")${NC} ${GRAY}$version${NC} ${GREEN}($state)${NC}"
          ;;
        "inactive")
          echo -e "  ${YELLOW}○${NC} ${CYAN}$(printf "%-25s" "$name")${NC} ${GRAY}$version${NC} ${YELLOW}($state)${NC}"
          ;;
        *)
          echo -e "  ${GRAY}○${NC} ${CYAN}$(printf "%-25s" "$name")${NC} ${GRAY}$version${NC} ${GRAY}($state)${NC}"
          ;;
      esac
    fi
  done <<< "$extensions"

  echo ""
  if [ $count -gt 0 ]; then
    print_success "Found $count extension(s)"
    show_coc_management_help
  else
    print_warning "No extensions found"
  fi
}

show_popular_coc_extensions() {
  echo -e "${WHITE}Popular Coc extensions:${NC}"
  echo "  ${CYAN}coc-tsserver${NC}    - TypeScript/JavaScript"
  echo "  ${CYAN}coc-pyright${NC}     - Python"
  echo "  ${CYAN}coc-json${NC}        - JSON"
  echo "  ${CYAN}coc-html${NC}        - HTML"
  echo "  ${CYAN}coc-css${NC}         - CSS"
  echo "  ${CYAN}coc-prettier${NC}    - Prettier formatting"
  echo "  ${CYAN}coc-eslint${NC}      - ESLint"
  echo "  ${CYAN}coc-go${NC}          - Go"
}

show_coc_management_help() {
  echo ""
  print_info "Manage extensions with:"
  echo -e "  ${CYAN}vcfg coc install <name>${NC}    - Install new extension"
  echo -e "  ${CYAN}vcfg coc remove <name>${NC}     - Remove extension"
  echo -e "  ${CYAN}vcfg coc update${NC}            - Update all extensions"
  echo -e "  ${CYAN}vcfg coc list${NC}              - Show this list again"
}

open_coc_config() {
  print_header "Coc Configuration"

  local coc_config="${HOME}/.config/nvim/coc-settings.json"
  local example_config="${VIM_CONFIG_DIR}/utils/coc-settings.example.json"

  if [ ! -f "$coc_config" ]; then
    print_warning "Coc config file not found: $coc_config"
    echo ""

    if [ -f "$example_config" ]; then
      print_info "Creating from example configuration..."
      mkdir -p "$(dirname "$coc_config")"
      cp "$example_config" "$coc_config"
      print_success "Created default Coc configuration"
    else
      print_info "Creating empty Coc configuration..."
      mkdir -p "$(dirname "$coc_config")"
      echo "{}" > "$coc_config"
      print_success "Created empty Coc configuration"
    fi
  fi

  print_info "Opening Coc configuration: $coc_config"

  # Open in editor
  if [ -n "$EDITOR" ]; then
    $EDITOR "$coc_config"
  elif command -v nvim > /dev/null; then
    nvim "$coc_config"
  elif command -v vim > /dev/null; then
    vim "$coc_config"
  else
    vi "$coc_config"
  fi

  echo ""
  print_info "Coc configuration tips:"
  echo -e "  ${CYAN}•${NC} Restart Neovim after making changes"
  echo -e "  ${CYAN}•${NC} Use JSON format with proper syntax"
  echo -e "  ${CYAN}•${NC} Refer to Coc.nvim documentation for options"
}

# Buat juga file contoh konfigurasi Coc
create_coc_example_config() {
  local example_config="${VIM_CONFIG_DIR}/utils/coc-settings.example.json"

  mkdir -p "$(dirname "$example_config")"

  cat > "$example_config" << 'EOF'
{
  "languageserver": {
    "ccls": {
      "command": "ccls",
      "filetypes": ["c", "cpp", "objc", "objcpp"],
      "rootPatterns": [".ccls", "compile_commands.json", ".git/", ".hg/"],
      "initializationOptions": {
        "cache": {
          "directory": "/tmp/ccls"
        }
      }
    }
  },
  "coc.preferences.formatOnSaveFiletypes": [
    "javascript",
    "typescript", 
    "typescriptreact",
    "javascriptreact",
    "json",
    "html",
    "css",
    "scss",
    "markdown",
    "python"
  ],
  "typescript.suggest.autoImports": true,
  "python.linting.enabled": true,
  "python.formatting.provider": "black",
  "suggest.noselect": false,
  "suggest.enablePreselect": true,
  "signature.target": "echo",
  "list.maxPreviewHeight": 12
}
EOF
}

search_coc_extensions() {
  local query="$*"

  if [ -z "$query" ]; then
    print_error "Please specify search query"
    echo "Usage: vcfg coc search <query>"
    echo "Examples:"
    echo "  vcfg coc search typescript"
    echo "  vcfg coc search python"
    echo "  vcfg coc search lsp"
    return 1
  fi

  query_name=$(echo "$query" | awk -F' ' {'print $2'})

  print_header "Searching Coc Extensions: ${CYAN}${query_name}${NC}"

  if ! command -v curl &> /dev/null; then
    print_error "curl is required for search functionality"
    return 1
  fi

  print_info "Searching npm registry for Coc extensions..."

  # Search npm registry for coc extensions
  local encoded_query=$(echo "$query" | sed 's/ /+/g')
  local search_url="https://registry.npmjs.com/-/v1/search?text=${encoded_query}+coc-&size=20"

  local response=$(curl -s --max-time 10 "$search_url")

  if [ -z "$response" ]; then
    print_error "Failed to search extensions"
    return 1
  fi

  # Parse JSON response
  if command -v jq &> /dev/null; then
    parse_search_results_jq "$response" "$query"
  else
    parse_search_results_basic "$response" "$query"
  fi
}

parse_search_results_jq() {
  local response="$1"
  local query="$2"
  local page_number=1

  local count=$(echo "$response" | jq -r '.objects | length')

  if [ "$count" -eq 0 ]; then
    print_warning "No Coc extensions found for: $query"
    echo ""
    print_info "Try different keywords or check spelling"
    return 0
  fi

  echo ""
  echo -e "${GREEN}Found ${count} Coc extensions:${NC}"
  echo ""

  echo "$response" | jq -r '.objects[] | "\(.package.name)|\(.package.description // "No description")|\(.package.version)|\(.package.links.npm)"' \
    | while IFS='|' read -r name desc version npm_url; do
      # Only show coc- prefixed packages
      if [[ "$name" == coc-* ]]; then
        echo -e " ${page_number}. ${CYAN}${name}${NC} ${GRAY}(${version})${NC}"
        if [ "$desc" != "No description" ] && [ -n "$desc" ]; then
          echo -e "    ${WHITE}${desc}${NC}"
        fi
        echo -e "    ${GRAY}${npm_url}${NC}"
        echo ""
        page_number=$((page_number + 1))
      fi
    done

  show_installation_help "$query"
}

parse_search_results_basic() {
  local response="$1"
  local query="$2"
  local page_number=1

  # Basic parsing without jq
  local count=$(echo "$response" | grep -o '"name":"coc-[^"]*"' | sort -u | wc -l)

  if [ "$count" -eq 0 ]; then
    print_warning "No Coc extensions found for: $query"
    return 0
  fi

  echo ""
  echo -e "${GREEN}Found Coc extensions:${NC}"
  echo ""

  # Extract package names and descriptions
  echo "$response" | grep -E '"name":"coc-[^"]*"|"description":"[^"]*"' \
    | while read -r line; do
      if [[ "$line" =~ \"name\":\"(coc-[^\"]*)\" ]]; then
        name="${BASH_REMATCH[1]}"
        echo -e " ${page_number}. ${CYAN}${name}${NC}"
        page_number=$((page_number + 1))
      elif [[ "$line" =~ \"description\":\"([^\"]*)\" ]]; then
        desc="${BASH_REMATCH[1]}"
        if [ "$desc" != "null" ] && [ -n "$desc" ]; then
          echo -e "    ${WHITE}${desc}${NC}"
        fi
        echo ""
      fi
    done

  show_installation_help "$query"
}

show_installation_help() {
  local query="$1"

  echo ""
  echo -e "${GREEN}Installation Examples:${NC}"
  echo -e "  ${CYAN}vcfg coc install coc-tsserver${NC}"
  echo -e "  ${CYAN}vcfg coc install coc-pyright${NC}"
  echo -e "  ${CYAN}vcfg coc install coc-json${NC}"
  echo ""
  echo -e "${GREEN}Popular Extensions:${NC}"
  echo -e "  ${YELLOW}•${NC} ${CYAN}coc-tsserver${NC} - TypeScript/JavaScript"
  echo -e "  ${YELLOW}•${NC} ${CYAN}coc-pyright${NC} - Python"
  echo -e "  ${YELLOW}•${NC} ${CYAN}coc-clangd${NC} - C/C++"
  echo -e "  ${YELLOW}•${NC} ${CYAN}coc-go${NC} - Go"
  echo -e "  ${YELLOW}•${NC} ${CYAN}coc-html${NC} - HTML"
  echo -e "  ${YELLOW}•${NC} ${CYAN}coc-css${NC} - CSS"
}

show_extension_info() {
  local extension=$1

  # Try to get extension info from npm
  local npm_url="https://registry.npmjs.com/${extension}"
  local npm_info=$(curl -s --max-time 5 "$npm_url" 2> /dev/null)

  if [ -n "$npm_info" ]; then
    if command -v jq &> /dev/null; then
      local desc=$(echo "$npm_info" | jq -r '.description // empty')
      local version=$(echo "$npm_info" | jq -r '.["dist-tags"].latest // empty')
      local homepage=$(echo "$npm_info" | jq -r '.homepage // empty')

      if [ -n "$desc" ]; then
        echo -e "  ${WHITE}Description:${NC} $desc"
      fi
      if [ -n "$version" ]; then
        echo -e "  ${WHITE}Version:${NC} $version"
      fi
      if [ -n "$homepage" ]; then
        echo -e "  ${WHITE}Homepage:${NC} $homepage"
      fi
    fi
  fi
}

show_coc_help() {
  echo -e "${CYAN}vcfg coc${NC} - Coc.nvim Extension Manager"
  echo ""
  echo -e "${WHITE}USAGE:${NC}"
  echo "  vcfg coc install <extension>    # Install Coc extension"
  echo "  vcfg coc list                   # List installed extensions"
  echo "  vcfg coc remove <extension>     # Remove Coc extension"
  echo "  vcfg coc update                 # Update all extensions"
  echo "  vcfg coc search <query>         # Search for extensions"
  echo "  vcfg coc config                 # Open Coc configuration"
  echo ""
  echo -e "${WHITE}EXAMPLES:${NC}"
  echo "  vcfg coc install coc-tsserver"
  echo "  vcfg coc install coc-json coc-html"
  echo "  vcfg coc search typescript"
  echo "  vcfg coc search python"
  echo "  vcfg coc list"
  echo "  vcfg coc update"
  echo ""
  echo -e "${WHITE}POPULAR EXTENSIONS:${NC}"
  echo "  coc-tsserver    - TypeScript/JavaScript"
  echo "  coc-pyright     - Python"
  echo "  coc-clangd      - C/C++"
  echo "  coc-go          - Go"
  echo "  coc-html        - HTML"
  echo "  coc-css         - CSS"
  echo "  coc-json        - JSON"
  echo "  coc-prettier    - Prettier formatting"
  echo "  coc-eslint      - ESLint integration"
  echo "  coc-stylelint   - Stylelint for CSS"
}
