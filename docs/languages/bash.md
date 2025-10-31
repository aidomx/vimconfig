# Bash/Shell Scripting Guide

Quick guide for Bash shell scripting.

## 🚀 Setup

### Prerequisites

```bash
# Usually pre-installed, but if needed:
# Termux
pkg install bash

# Install tools
pkg install shfmt shellcheck  # Termux
sudo pacman -S shfmt shellcheck  # Arch
sudo apt install shfmt shellcheck  # Ubuntu
```

## 📝 Bash Basics

### Key Mappings

| Shortcut     | Action                  |
| ------------ | ----------------------- |
| `<leader>bx` | Make executable and run |
| `<leader>br` | Run script              |
| `<leader>bc` | Syntax check            |
| `<leader>bt` | Run shellcheck          |
| `<leader>bf` | Format with shfmt       |

### Hello World

```bash
#!/bin/bash
# hello.sh

echo "Hello, World!"
```

Make executable and run:

```bash
chmod +x hello.sh
./hello.sh

# Or in Vim
<leader>bx
```

### Variables

```bash
#!/bin/bash

# Variables
name="Alice"
age=25
readonly PI=3.14

# Command substitution
current_date=$(date)
files=$(ls)

# Arrays
fruits=("apple" "banana" "orange")
echo "${fruits[0]}"  # apple
echo "${fruits[@]}"  # all elements
echo "${#fruits[@]}" # length

# Special variables
echo $0  # Script name
echo $1  # First argument
echo $#  # Number of arguments
echo $@  # All arguments
echo $?  # Exit status of last command
```

### Conditionals

```bash
#!/bin/bash

# If statement
if [ "$age" -gt 18 ]; then
    echo "Adult"
elif [ "$age" -eq 18 ]; then
    echo "Just turned adult"
else
    echo "Minor"
fi

# File checks
if [ -f "file.txt" ]; then
    echo "File exists"
fi

if [ -d "directory" ]; then
    echo "Directory exists"
fi

# String comparison
if [ "$name" == "Alice" ]; then
    echo "Hello Alice"
fi

# Logical operators
if [ "$age" -gt 18 ] && [ "$name" == "Alice" ]; then
    echo "Adult Alice"
fi
```

### Loops

```bash
#!/bin/bash

# For loop
for i in {1..5}; do
    echo "Number: $i"
done

# For loop with array
fruits=("apple" "banana" "orange")
for fruit in "${fruits[@]}"; do
    echo "Fruit: $fruit"
done

# While loop
counter=0
while [ $counter -lt 5 ]; do
    echo "Counter: $counter"
    ((counter++))
done

# Read file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < file.txt
```

### Functions

```bash
#!/bin/bash

# Basic function
greet() {
    echo "Hello, $1!"
}

greet "Alice"

# Function with return
add() {
    local a=$1
    local b=$2
    echo $((a + b))
}

result=$(add 10 20)
echo "Sum: $result"

# Function with multiple returns
divide() {
    if [ $2 -eq 0 ]; then
        return 1  # Error
    fi
    echo $(($1 / $2))
    return 0  # Success
}

if result=$(divide 10 2); then
    echo "Result: $result"
else
    echo "Error: Division by zero"
fi
```

### Input/Output

```bash
#!/bin/bash

# Read input
echo "Enter your name:"
read name
echo "Hello, $name"

# Read with prompt
read -p "Enter your age: " age

# Read password (hidden)
read -sp "Enter password: " password
echo

# Redirect output
echo "Log entry" > log.txt    # Overwrite
echo "Another entry" >> log.txt  # Append

# Redirect stderr
command 2> error.log
command &> all.log  # Both stdout and stderr
```

### Common Patterns

```bash
#!/bin/bash

# Check if command exists
if command -v git &> /dev/null; then
    echo "Git is installed"
fi

# Default value
name=${1:-"Guest"}  # Use $1 or "Guest" if not set

# String operations
text="Hello World"
echo ${text:0:5}      # Hello (substring)
echo ${text/World/Bash}  # Hello Bash (replace)
echo ${#text}         # 11 (length)

# File operations
filename="/path/to/file.txt"
echo ${filename##*/}   # file.txt (basename)
echo ${filename%/*}    # /path/to (dirname)
echo ${filename%.txt}  # /path/to/file (remove extension)

# Case statement
case "$1" in
    start)
        echo "Starting..."
        ;;
    stop)
        echo "Stopping..."
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
```

## 🎯 Practical Scripts

### Backup Script

```bash
#!/bin/bash
# backup.sh

SOURCE_DIR="$HOME/Documents"
BACKUP_DIR="$HOME/Backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backup_${DATE}.tar.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create backup
echo "Creating backup..."
tar -czf "${BACKUP_DIR}/${BACKUP_FILE}" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo "Backup created: ${BACKUP_FILE}"
else
    echo "Backup failed!"
    exit 1
fi

# Remove old backups (keep last 5)
cd "$BACKUP_DIR"
ls -t backup_*.tar.gz | tail -n +6 | xargs rm -f
```

### System Info Script

```bash
#!/bin/bash
# sysinfo.sh

echo "=== System Information ==="
echo "Hostname: $(hostname)"
echo "OS: $(uname -s)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "User: $(whoami)"
echo "Date: $(date)"
echo

echo "=== Disk Usage ==="
df -h | grep -v tmpfs

echo
echo "=== Memory Usage ==="
free -h

echo
echo "=== CPU Info ==="
lscpu | grep "Model name"
```

### File Processor

```bash
#!/bin/bash
# process_files.sh

# Check arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

DIR="$1"

# Check if directory exists
if [ ! -d "$DIR" ]; then
    echo "Error: Directory not found"
    exit 1
fi

# Process files
echo "Processing files in: $DIR"
file_count=0

for file in "$DIR"/*.txt; do
    if [ -f "$file" ]; then
        echo "Processing: $(basename "$file")"
        # Do something with the file
        ((file_count++))
    fi
done

echo "Total files processed: $file_count"
```

## 🔍 Debugging

### Set Options

```bash
#!/bin/bash

# Exit on error
set -e

# Exit on undefined variable
set -u

# Print commands before execution
set -x

# Combine all
set -euxo pipefail
```

### Error Handling

```bash
#!/bin/bash

# Trap errors
trap 'echo "Error on line $LINENO"' ERR

# Trap exit
trap 'echo "Cleanup"; rm -f /tmp/temp_file' EXIT

# Function for errors
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Usage
[ -f "file.txt" ] || error_exit "File not found"
```

## ✅ Best Practices

```bash
#!/bin/bash
# Good practices

# Always use quotes
name="John Doe"
echo "$name"  # Good
echo $name    # Bad (word splitting)

# Use [[ ]] instead of [ ]
if [[ "$var" == "value" ]]; then
    echo "Match"
fi

# Use $() instead of backticks
result=$(command)  # Good
result=`command`   # Old style

# Check command success
if command; then
    echo "Success"
else
    echo "Failed"
fi

# Use functions for reusable code
main() {
    # Main logic here
    echo "Running main"
}

# Call main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

## 📚 Resources

- Bash Manual: [Bash manual](https://www.gnu.org/software/bash/manual/)
- ShellCheck: [ShellCheck](https://www.shellcheck.net/)
- Bash Guide: [Bash Guide](https://mywiki.wooledge.org/BashGuide)

---

[← Back to Languages](../README.md#language-support)
