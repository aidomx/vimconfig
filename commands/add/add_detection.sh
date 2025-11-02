#!/usr/bin/env bash

detect_plugin_type() {
  local plugin=$1
  local is_local=$2

  # Check if it's a local plugin
  if [[ "$is_local" == "--local" ]] || [[ "$is_local" == "-l" ]]; then
    echo "local"
    return 0
  fi

  # Check if it's a GitHub shorthand (username/repo)
  #if [[ "$plugin" =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]]; then
  #echo "github"
  #return 0
  #fi

  if [[ "$plugin" =~ ^https?:// ]]; then
    echo "github"
    return 0
  fi

  # Check if it's a Git URL
  if [[ "$plugin" =~ ^git@ ]] || [[ "$plugin" =~ \.git$ ]]; then
    echo "git"
    return 0
  fi

  # Check if it's a local path
  if [[ -d "$plugin" ]]; then
    echo "local"
    return 0
  fi

  echo "github"
}

normalize_plugin_name() {
  local plugin=$1
  local plugin_type=$2

  case "$plugin_type" in
    "github")
      # Untuk GitHub shorthand, tetap pakai format username/repo
      # JANGAN diubah jadi full URL
      if [[ "$plugin" =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]]; then
        echo "$plugin"
      else
        # Kalau sudah full URL, extract username/repo
        if [[ "$plugin" =~ github.com/([^/]+)/([^/]+) ]]; then
          echo "${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
        else
          echo "$plugin"
        fi
      fi
      ;;
    "git")
      # Untuk Git URLs, kita tetap simpan format asli
      echo "$plugin"
      ;;
    "local")
      # Convert to absolute path
      if [[ "$plugin" =~ ^[^/] ]]; then
        echo "$(cd "$(dirname "$plugin")" && pwd)/$(basename "$plugin")"
      else
        echo "$plugin"
      fi
      ;;
    *)
      echo "$plugin"
      ;;
  esac
}

get_plugin_display_name() {
  local plugin=$1
  local plugin_type=$2

  case "$plugin_type" in
    "github")
      # Untuk GitHub, tampilkan username/repo
      if [[ "$plugin" =~ ^https:// ]]; then
        basename "$(dirname "$plugin")/$(basename "$plugin" .git)"
      else
        echo "$plugin"
      fi
      ;;
    "git")
      basename "$plugin" .git
      ;;
    "local")
      basename "$plugin"
      ;;
    *)
      basename "$plugin"
      ;;
  esac
}
