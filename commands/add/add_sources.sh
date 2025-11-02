#!/usr/bin/env bash

format_github_plugin() {
  local plugin=$1
  local plugin_manager=$2

  # Jika sudah format username/repo, pakai langsung
  if [[ "$plugin" =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]]; then
    local user_name="${plugin%/*}"
    local repo_name="${plugin#*/}"
  else
    # Extract dari URL
    local repo_name=$(basename "$plugin" .git)
    local user_name=$(basename "$(dirname "$plugin")")
  fi

  case "$plugin_manager" in
    "vim-plug")
      echo "Plug '$user_name/$repo_name'"
      ;;
    "packer.nvim")
      echo "use '$user_name/$repo_name'"
      ;;
    "lazy.nvim")
      echo "{ '$user_name/$repo_name' }"
      ;;
  esac
}

format_git_plugin() {
  local plugin=$1
  local plugin_manager=$2

  case "$plugin_manager" in
    "vim-plug")
      echo "Plug '$plugin'"
      ;;
    "packer.nvim")
      echo "use '$plugin'"
      ;;
    "lazy.nvim")
      echo "{ '$plugin' }"
      ;;
  esac
}

format_local_plugin() {
  local plugin=$1
  local plugin_manager=$2

  case "$plugin_manager" in
    "vim-plug")
      echo "Plug '$plugin'"
      ;;
    "packer.nvim")
      echo "use '$plugin'"
      ;;
    "lazy.nvim")
      echo "{ '$plugin' }"
      ;;
  esac
}

validate_plugin_source() {
  local plugin=$1
  local plugin_type=$2

  case "$plugin_type" in
    "local")
      if [ ! -d "$plugin" ]; then
        print_error "Local plugin directory not found: $plugin"
        return 1
      fi
      ;;
    "git" | "github")
      local test_url="$plugin"
      if [[ "$plugin_type" == "github" ]] && [[ "$plugin" =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]]; then
        test_url="https://github.com/${plugin}.git"
      fi

      if ! git ls-remote "$test_url" &> /dev/null; then
        print_error "Repository not accessible: $plugin"
        return 1
      fi
      ;;
  esac

  return 0
}
