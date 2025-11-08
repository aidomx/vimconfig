#!/usr/bin/env bash

progress() {
  local progress_type=${1:-"percent"}
  shift

  case "${progress_type}" in
    "bar")
      progress_bar "$@"
      ;;
    "percent" | "percentage")
      progress_percentage "$@"
      ;;
    "spinner")
      progress_spinner "$@"
      ;;
    "dots")
      progress_dots "$@"
      ;;
    *)
      echo "Invalid progress type: $progress_type"
      echo "Available: bar, percent, spinner, dots"
      return 1
      ;;
  esac
}

progress_bar() {
  local pid=$1
  local message=${2:-"Processing"}
  local width=${3:-40}
  local max_duration=${4:-60}

  local duration=0
  local filled=0

  while [[ $duration -lt $max_duration ]] && kill -0 "$pid" > /dev/null 2>&1; do
    filled=$((duration * width / max_duration))
    local empty=$((width - filled))

    local bar="["
    for ((i = 0; i < filled; i++)); do bar+="█"; done
    for ((i = 0; i < empty; i++)); do bar+="░"; done
    bar+="]"

    local percent=$((duration * 100 / max_duration))
    echo -ne "\r${CYAN}${message}${NC} ${bar} ${percent}%"

    sleep 1
    duration=$((duration + 1))
  done

  # Ensure 100% at the end
  local full_bar="["
  for ((i = 0; i < width; i++)); do full_bar+="█"; done
  full_bar+="]"

  echo -ne "\r${CYAN}${message}${NC} ${full_bar} 100%"
  echo ""
}

progress_percentage() {
  local pid=$1
  local message=${2:-"Processing"}
  local max_duration=${3:-60}

  local duration=0

  while [[ $duration -lt $max_duration ]] && kill -0 "$pid" > /dev/null 2>&1; do
    local percent=$((duration * 100 / max_duration))
    [[ $percent -gt 100 ]] && percent=100

    echo -ne "\r${CYAN}${message}${NC}: ${percent}%"
    sleep 1
    duration=$((duration + 1))
  done

  echo -ne "\r${CYAN}${message}${NC}: 100%"
  echo ""
}

progress_spinner() {
  local pid=$1
  local message=${2:-"Processing"}
  local delay=0.1
  local spinstr='⣷⣯⣟⡿⢿⣻⣽⣾'
  local spin_count=${#spinstr}
  local index=0

  while kill -0 "$pid" > /dev/null 2>&1; do
    local spin_char="${spinstr:index:1}"
    printf "\r${CYAN}${message}${NC} [%s] " "$spin_char"

    index=$(((index + 1) % spin_count))
    sleep $delay
  done

  printf "\r${CYAN}${message}${NC} [✓]"
  echo ""
}

progress_dots() {
  local pid=$1
  local message=${2:-"Processing"}
  local delay=1
  local dot_count=0
  local max_dots=3

  while kill -0 "$pid" > /dev/null 2>&1; do
    local dots=""
    for ((i = 0; i < dot_count; i++)); do dots+="."; done
    for ((i = dot_count; i < max_dots; i++)); do dots+=" "; done

    printf "\r${CYAN}${message}${NC} [%s]" "$dots"

    dot_count=$(((dot_count + 1) % (max_dots + 1)))
    sleep $delay
  done

  printf "\r${CYAN}${message}${NC} [done]"
  echo ""
}

# Legacy function untuk backward compatibility
show_percentage_progress() {
  progress "percent" "$@"
}

spinner() {
  progress "spinner" "$@"
}
