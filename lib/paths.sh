#!/usr/bin/env bash

# VCFG Path Configuration
setup_vcfg_paths() {
  # Determine VCFG_ROOT
  if [ -n "${VCFG_ROOT}" ]; then
    # Use explicit VCFG_ROOT
    export VCFG_ROOT="${VCFG_ROOT}"
  elif [ -d "${HOME}/.config/vim" ]; then
    # Default installation location
    export VCFG_ROOT="${HOME}/.config/vim"
  elif [ -d "${HOME}/.local/vim" ]; then
    # Fallback to old location
    export VCFG_ROOT="${HOME}/.local/vim"
  else
    # Current script location (development)
    export VCFG_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  fi

  # Core directories
  export VCFG_CORE_DIR="${VCFG_ROOT}/core"
  export VCFG_COMMANDS_DIR="${VCFG_ROOT}/commands"
  export VCFG_LIB_DIR="${VCFG_ROOT}/lib"
  export VCFG_DOCS_DIR="${VCFG_ROOT}/docs"

  # Core files
  export VCFG_SETTINGS_FILE="${VCFG_CORE_DIR}/settings.vim"
  export VCFG_PLUGINS_FILE="${VCFG_CORE_DIR}/plugins.vim"
  export VCFG_MAPPINGS_FILE="${VCFG_CORE_DIR}/mappings.vim"

  # Default files (templates)
  export VCFG_SETTINGS_DEFAULT="${VCFG_CORE_DIR}/settings.default.vim"
  export VCFG_PLUGINS_DEFAULT="${VCFG_CORE_DIR}/plugins.default.vim"
  export VCFG_MAPPINGS_DEFAULT="${VCFG_CORE_DIR}/mappings.default.vim"

  # coc paths
  export VCFG_COC_DIR="${HOME}/.config/coc"
  export VCFG_COC_EXTENSIONS="${VCFG_COC_DIR}/extensions"

  # User data
  export VCFG_DATA_DIR="${HOME}/.local/share/vcfg"
  export VCFG_BACKUP_DIR="${VCFG_DATA_DIR}/backups"

  # Internet connection
  export VCFG_INTERNET_CONNECTION=${VCFG_INTERNET_CONNECTION:-0}

  # Create directories if they don't exist
  mkdir -p "${VCFG_DATA_DIR}" "${VCFG_BACKUP_DIR}"
}

# Initialize paths
setup_vcfg_paths

# Utility functions
get_vcfg_root() {
  echo "${VCFG_ROOT}"
}

get_core_file() {
  local file_type=$1
  case "$file_type" in
    "settings") echo "${VCFG_SETTINGS_FILE}" ;;
    "plugins") echo "${VCFG_PLUGINS_FILE}" ;;
    "mappings") echo "${VCFG_MAPPINGS_FILE}" ;;
    *) echo "" ;;
  esac
}

get_default_file() {
  local file_type=$1
  case "$file_type" in
    "settings") echo "${VCFG_SETTINGS_DEFAULT}" ;;
    "plugins") echo "${VCFG_PLUGINS_DEFAULT}" ;;
    "mappings") echo "${VCFG_MAPPINGS_DEFAULT}" ;;
    *) echo "" ;;
  esac
}

backup_config_file() {
  local file_path=$1
  local backup_name=$(basename "$file_path")
  local timestamp=$(date +%Y%m%d_%H%M%S)
  local backup_file="${VCFG_BACKUP_DIR}/${backup_name}.${timestamp}.bak"

  if [ -f "$file_path" ]; then
    cp "$file_path" "$backup_file"
    echo "$backup_file"
  else
    echo ""
  fi
}
