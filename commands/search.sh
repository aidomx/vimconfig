#!/usr/bin/env bash

vcfg_cmd_search() {
  if [ $# -eq 0 ]; then
    print_error "Please specify a search query"
    echo "Usage: vcfg search <query> [page] [per_page]"
    echo ""
    echo "Examples:"
    echo "  vcfg search fuzzy finder"
    echo "  vcfg search fuzzy finder 2"
    echo "  vcfg search fuzzy finder 2 30"
    return 1
  fi

  # Default values
  local query=""
  local page=1
  local per_page=20

  # Check if last argument is a number (per_page)
  local last_arg="${@: -1}"
  if [[ "$last_arg" =~ ^[0-9]+$ ]] && [ $# -ge 3 ]; then
    per_page="$last_arg"
    # Check if second last is also number (page)
    local second_last="${@: -2:1}"
    if [[ "$second_last" =~ ^[0-9]+$ ]]; then
      page="$second_last"
      query="${*:1:$#-2}"
    else
      query="${*:1:$#-1}"
    fi
  # Check if last argument is a number (page only)
  elif [[ "$last_arg" =~ ^[0-9]+$ ]] && [ $# -ge 2 ]; then
    page="$last_arg"
    query="${*:1:$#-1}"
  else
    # All arguments are part of the query
    query="$*"
  fi

  # Trim spaces
  query=$(echo "$query" | xargs)

  if [ -z "$query" ]; then
    print_error "Query cannot be empty"
    return 1
  fi

  # Validate numbers
  if [ "$page" -lt 1 ]; then
    print_error "Page number must be at least 1"
    return 1
  fi

  if [ "$per_page" -lt 1 ] || [ "$per_page" -gt 100 ]; then
    print_error "Per page must be between 1 and 100"
    return 1
  fi

  print_header "Searching for: ${CYAN}${query}${NC} (Page $page, $per_page results per page)"

  if ! command -v curl &> /dev/null; then
    print_error "curl is required for search functionality"
    return 1
  fi

  print_info "Searching GitHub repositories..."

  # URL encode query
  local encoded_query
  encoded_query=$(echo "$query" | sed 's/ /+/g')

  # API URLs - update untuk menggunakan $per_page
  local api_urls=(
    "https://api.github.com/search/repositories?q=${encoded_query}&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+vim+plugin&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+neovim+plugin&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+in:description+vim&sort=stars&order=desc&page=${page}&per_page=${per_page}"
    "https://api.github.com/search/repositories?q=${encoded_query}+topic:vim-plugin&sort=stars&order=desc&page=${page}&per_page=${per_page}"
  )

  local response=""
  local api_url=""
  local found_results=0
  local used_url=""

  # Coba setiap variant query sampai dapat hasil
  for api_url in "${api_urls[@]}"; do
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

    # Calculate next page info
    local total_count=0
    if command -v jq &> /dev/null; then
      total_count=$(echo "$response" | jq -r '.total_count // 0')
    else
      total_count=$(echo "$response" | grep -o '"total_count":[0-9]*' | head -1 | cut -d: -f2)
      total_count=${total_count:-0}
    fi

    if [ $total_count -gt $((page * per_page)) ]; then
      print_info "To see more results: ${CYAN}vcfg search '$query' $((page + 1)) $per_page${NC}"
    fi
    print_info "To install: ${CYAN}vcfg add <username/repository>${NC}"
  fi
}

# Update juga format_search_results untuk handle per_page
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

  # Calculate result range
  local start_result=$(((page - 1) * per_page + 1))
  local end_result=$((page * per_page))
  if [ $end_result -gt $total_count ]; then
    end_result=$total_count
  fi

  # Header
  output+="${BOLD}Search results for: ${CYAN}${query}${NC}${BOLD}\n"
  output+="Page: ${page} | Results: ${start_result}-${end_result} of ${total_count}${NC}\n"
  output+="$(printf '=%.0s' {1..70})\n\n"

  # Parse results
  if command -v jq &> /dev/null; then
    output+=$(echo "$response" | jq -r '.items[] | "\(.full_name)|\(.stargazers_count)|\(.description // "No description")"' \
      | {
        local count=$start_result
        while IFS='|' read -r repo stars desc; do
          local line=""
          line+="${GREEN}$(printf "%3d" $count).${NC} ${CYAN}$(printf "%-35s" "$repo")${NC}\n"
          line+="     ${YELLOW}⭐${NC} ${WHITE}$stars${NC} stars\n"

          if [ "$desc" = "No description" ] || [ "$desc" = "null" ] || [ -z "$desc" ]; then
            line+="     ${GRAY}No description available${NC}\n"
          else
            local short_desc
            if [ ${#desc} -gt 75 ]; then
              short_desc="${desc:0:72}..."
            else
              short_desc="$desc"
            fi
            line+="     $(echo "$short_desc" | fold -sw 73 | sed '2,$s/^/     /')\n"
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
        local count=$start_result
        while IFS=$'\t' read -r repo stars desc; do
          local line=""
          line+="${GREEN}$(printf "%3d" $count).${NC} ${CYAN}$(printf "%-35s" "$repo")${NC}\n"
          line+="     ${YELLOW}⭐${NC} ${WHITE}$stars${NC} stars\n"

          if [ "$desc" = "null" ] || [ -z "$desc" ]; then
            line+="     ${GRAY}No description available${NC}\n"
          else
            local short_desc
            if [ ${#desc} -gt 75 ]; then
              short_desc="${desc:0:72}..."
            else
              short_desc="$desc"
            fi
            line+="     $(echo "$short_desc" | fold -sw 73 | sed '2,$s/^/     /')\n"
          fi
          line+="\n"
          printf "%s" "$line"
          count=$((count + 1))
        done
      })
  fi

  # Footer
  output+="\n$(printf '=%.0s' {1..70})\n"
  output+="${BOLD}Navigation:${NC}\n"
  output+="  - Press ${GREEN}q${NC} to quit\n"
  output+="  - Use ${GREEN}arrow keys${NC} or ${GREEN}Page Up/Down${NC} to scroll\n"
  output+="  - Press ${GREEN}/${NC} to search within results\n"
  output+="\n"

  if [ $total_count -gt $((page * per_page)) ]; then
    output+="${BOLD}More results available!${NC}\n"
    output+="Run: ${CYAN}vcfg search '$query' $((page + 1)) $per_page${NC}\n"
  fi

  output+="To install a plugin: ${CYAN}vcfg add username/repository${NC}\n"

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
