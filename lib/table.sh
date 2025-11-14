#!/usr/bin/env bash

# Table utility functions
# Usage: create_table [headers] [data] [options]

# Function to create a simple table with borders
# Arguments: header1,header2,header3 data_line1 data_line2 ...
create_table() {
  local headers=()
  local data=()
  local colors=()
  local i=0
  local no_border=false

  # Parse arguments
  for arg in "$@"; do
    if [[ "$arg" == "--color" ]]; then
      continue
    elif [[ "$arg" == "--no-border" ]]; then
      no_border=true
    elif [[ ${#headers[@]} -eq 0 ]]; then
      # First argument is headers (comma separated)
      IFS=',' read -ra headers <<<"$arg"
    else
      # Rest are data lines
      data+=("$arg")
    fi
  done

  local col_count=${#headers[@]}
  local col_widths=()

  # Calculate column widths
  for ((i = 0; i < col_count; i++)); do
    local max_length=${#headers[i]}
    for line in "${data[@]}"; do
      IFS='|' read -ra fields <<<"$line"
      if [[ ${#fields[i]} -gt $max_length ]]; then
        max_length=${#fields[i]}
      fi
    done
    col_widths[i]=$((max_length + 2))
  done

  # Print table header
  if [[ "$no_border" != "true" ]]; then
    print_table_top_border "${col_widths[@]}"
  fi

  print_table_row "${headers[@]}" "${col_widths[@]}"

  if [[ "$no_border" != "true" ]]; then
    print_table_header_separator "${col_widths[@]}"
  fi

  # Print table data
  for line in "${data[@]}"; do
    IFS='|' read -ra fields <<<"$line"
    print_table_row "${fields[@]}" "${col_widths[@]}"
  done

  if [[ "$no_border" != "true" ]]; then
    print_table_bottom_border "${col_widths[@]}"
  fi
}

print_table_top_border() {
  local widths=("$@")
  echo -n "┌"
  for ((i = 0; i < ${#widths[@]}; i++)); do
    for ((j = 0; j < ${widths[i]}; j++)); do
      echo -n "─"
    done
    if [ $i -lt $((${#widths[@]} - 1)) ]; then
      echo -n "┬"
    fi
  done
  echo "┐"
}

print_table_header_separator() {
  local widths=("$@")
  echo -n "├"
  for ((i = 0; i < ${#widths[@]}; i++)); do
    for ((j = 0; j < ${widths[i]}; j++)); do
      echo -n "─"
    done
    if [ $i -lt $((${#widths[@]} - 1)) ]; then
      echo -n "┼"
    fi
  done
  echo "┤"
}

print_table_bottom_border() {
  local widths=("$@")
  echo -n "└"
  for ((i = 0; i < ${#widths[@]}; i++)); do
    for ((j = 0; j < ${widths[i]}; j++)); do
      echo -n "─"
    done
    if [ $i -lt $((${#widths[@]} - 1)) ]; then
      echo -n "┴"
    fi
  done
  echo "┘"
}

print_table_row() {
  local fields=()
  local widths=()
  local i=0

  # Separate fields and widths
  for arg in "$@"; do
    if [ $i -lt $(($# - ${#widths[@]})) ]; then
      fields+=("$arg")
    else
      widths+=("$arg")
    fi
    ((i++))
  done

  echo -n "│"
  for ((i = 0; i < ${#fields[@]}; i++)); do
    printf " %-${widths[i]}s │" "${fields[i]}"
  done
  echo
}

create_simple_table() {
  local headers=()
  local data=()

  # Parse headers (comma separated first argument)
  IFS=',' read -ra headers <<<"$1"
  shift

  # Rest are data lines
  data=("$@")

  local col_count=${#headers[@]}
  local col_widths=()

  # Calculate column widths
  for ((i = 0; i < col_count; i++)); do
    local max_length=${#headers[i]}
    for line in "${data[@]}"; do
      IFS='|' read -ra fields <<<"$line"
      # Remove color codes for accurate length calculation
      local clean_field=$(echo -n "${fields[i]}" | sed 's/\x1b\[[0-9;]*m//g')
      local field_length=${#clean_field}
      if [[ $field_length -gt $max_length ]]; then
        max_length=$field_length
      fi
    done
    col_widths[i]=$max_length
  done

  # Print header
  echo -n " "
  for ((i = 0; i < col_count; i++)); do
    printf "%-${col_widths[i]}s" "${headers[i]}"
    if [ $i -lt $((col_count - 1)) ]; then
      echo -n " | "
    fi
  done
  echo

  # Print separator
  echo -n " "
  for ((i = 0; i < col_count; i++)); do
    for ((j = 0; j < ${col_widths[i]}; j++)); do
      echo -n "─"
    done
    if [ $i -lt $((col_count - 1)) ]; then
      echo -n "─┼─"
    fi
  done
  echo

  # Print data
  for line in "${data[@]}"; do
    IFS='|' read -ra fields <<<"$line"
    echo -n " "
    for ((i = 0; i < col_count; i++)); do
      printf "%-${col_widths[i]}s" "$(echo -ne ${fields[i]})"
      if [ $i -lt $((col_count - 1)) ]; then
        echo -n " | "
      fi
    done
    echo
  done
}

create_vertical_table() {
  local data=()
  local max_key_length=0
  local max_value_length=0

  # Parse semua argumen sebagai data key|value
  for arg in "$@"; do
    data+=("$arg")

    # Hitung panjang maksimum untuk key dan value
    IFS='|' read -ra parts <<<"$arg"
    local key="${parts[0]}"
    local value="${parts[1]}"

    if [[ ${#key} -gt $max_key_length ]]; then
      max_key_length=${#key}
    fi

    if [[ ${#value} -gt $max_value_length ]]; then
      max_value_length=${#value}
    fi
  done

  # Print setiap baris
  for line in "${data[@]}"; do
    IFS='|' read -ra parts <<<"$line"
    local key="${parts[0]}"
    local value="${parts[1]}"

    printf "| %-${max_key_length}s | %-${max_value_length}s |\n" "$key" "$value"
  done
}

create_vertical_table_with_border() {
  local data=()
  local max_key_length=0
  local max_value_length=0

  # Parse data dan hitung panjang maksimum
  for arg in "$@"; do
    data+=("$arg")

    IFS='|' read -ra parts <<<"$arg"
    local key="${parts[0]}"
    local value="${parts[1]}"

    if [[ ${#key} -gt $max_key_length ]]; then
      max_key_length=${#key}
    fi

    if [[ ${#value} -gt $max_value_length ]]; then
      max_value_length=${#value}
    fi
  done

  local total_width=$((max_key_length + max_value_length + 7)) # +7 untuk pipes dan spasi

  # Print top border
  printf "┌%*s┐\n" $((total_width - 2)) "" | tr ' ' '─'

  # Print data rows
  for line in "${data[@]}"; do
    IFS='|' read -ra parts <<<"$line"
    local key="${parts[0]}"
    local value="${parts[1]}"

    printf "│ %-${max_key_length}s │ %-${max_value_length}s │\n" "$key" "$value"
  done

  # Print bottom border
  printf "└%*s┘\n" $((total_width - 2)) "" | tr ' ' '─'
}
