#!/usr/bin/env bash

progress() {
  local type=${1:-"percent"}
  shift

  case "$type" in
  bar) progress_bar "$@" ;;
  percent*) progress_percentage "$@" ;;
  spinner) progress_spinner "$@" ;;
  dots) progress_dots "$@" ;;
  *)
    echo "Invalid progress type: $type"
    echo "Available: bar, percent, spinner, dots"
    return 1
    ;;
  esac
}

__progress_dynamic_loop() {
  local pid=$1 max=${2:-60} cb=$3
  local start=$(date +%s) duration=0 percent=0

  while [[ $percent -lt 100 ]]; do
    local now=$(date +%s)
    local delay=$(((now - start) % 4))
    percent=$((duration * 100 / max))
    ((percent > 100)) && percent=100

    if kill -0 "$pid" 2>/dev/null; then
      sleep $((delay * 2))
    else
      sleep $delay
    fi

    "$cb" "$percent"
    duration=$((duration + 1))
  done

  "$cb" 100
  echo ""
}

__progress_visual_loop() {
  local pid=$1 cb=$2 delay=${3:-1} end_mark=$4
  while kill -0 "$pid" 2>/dev/null; do
    "$cb"
    sleep "$delay"
  done
  printf "\r${CYAN}${PROGRESS_MSG}${NC} ${end_mark}\n"
}

_render_bar() {
  local percent=$1 width=${PROGRESS_WIDTH:-40}
  local filled=$((percent * width / 100))
  local empty=$((width - filled))
  local bar="["
  for ((i = 0; i < filled; i++)); do bar+="#"; done
  for ((i = 0; i < empty; i++)); do bar+="-"; done
  bar+="]"
  echo -ne "\r${CYAN}${PROGRESS_MSG}${NC} ${BLUE}${bar}${NC} ${percent}%"
}

_render_percentage() {
  local percent=$1
  echo -ne "\r${CYAN}${PROGRESS_MSG}${NC}: ${percent}%"
}

_render_spinner() {
  local spinstr='⣷⣯⣟⡿⢿⣻⣽⣾'
  local idx=$((RANDOM % ${#spinstr}))
  local char="${spinstr:idx:1}"
  printf "\r${CYAN}${PROGRESS_MSG}${NC} [%s]" "$char"
}

_render_dots() {
  local max=3
  ((dot_i = (dot_i + 1) % (max + 1)))
  local dots=""
  for ((i = 0; i < dot_i; i++)); do dots+="."; done
  for ((i = dot_i; i < max; i++)); do dots+=" "; done
  printf "\r${CYAN}${PROGRESS_MSG}${NC} [%s]" "$dots"
}

progress_bar() {
  local pid=$1 msg=${2:-"Processing"} width=${3:-40} max=${4:-60}
  PROGRESS_MSG="$msg"
  PROGRESS_WIDTH="$width"
  __progress_dynamic_loop "$pid" "$max" _render_bar
}

progress_percentage() {
  local pid=$1 msg=${2:-"Processing"} max=${3:-60}
  PROGRESS_MSG="$msg"
  __progress_dynamic_loop "$pid" "$max" _render_percentage
}

progress_spinner() {
  local pid=$1 msg=${2:-"Processing"} delay=${3:-0.1}
  local end="${PROGRESS_DONE_SPINNER:-[√]}"
  PROGRESS_MSG="$msg"
  __progress_visual_loop "$pid" _render_spinner "$delay" "$end"
}

progress_dots() {
  local pid=$1 msg=${2:-"Processing"} delay=${3:-1}
  local end="${PROGRESS_DONE_DOTS:-[done]}"
  PROGRESS_MSG="$msg" dot_i=0
  __progress_visual_loop "$pid" _render_dots "$delay" "$end"
}

# Legacy function untuk backward compatibility
show_percentage_progress() {
  progress "percent" "$@"
}

spinner() {
  progress "spinner" "$@"
}
