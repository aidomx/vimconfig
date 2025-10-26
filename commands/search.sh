#!/usr/bin/env bash

vcfg_cmd_search() {
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
