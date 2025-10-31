#!/usr/bin/env bash

show_percentage_progress() {
  local pid=$1
  local message=$2
  local duration=0
  local max_duration=60 # maximum 60 seconds

  while [[ $duration -lt $max_duration ]] && kill -0 $pid 2> /dev/null; do
    local percent=$((duration * 100 / max_duration))
    if [[ $percent -gt 100 ]]; then
      percent=100
    fi
    echo -ne "\r${CYAN}[PROGRESS]${NC} Installing $message: ${percent}%"
    sleep 1
    duration=$((duration + 1))
  done

  echo -ne "\r${CYAN}[PROGRESS]${NC} Installing $message: 100%"
  echo ""
}

spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while kill -0 "$pid" 2> /dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}
