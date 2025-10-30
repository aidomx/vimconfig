#!/usr/bin/env bash
# Vim Configuration Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash

# Set strict-ish mode
set -euo pipefail

# Determine script directory - handle both direct execution and pipe execution
if [[ "${BASH_SOURCE[0]:-}" != "" ]]; then
  # Direct execution
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
  # Pipe execution (curl | bash)
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd 2> /dev/null || pwd)"
fi

# For remote execution, we need to download the libs first
if [[ ! -d "${SCRIPT_DIR}/lib" ]]; then
  echo "Downloading required libraries..."
  # Create temp directory for remote execution
  TEMP_DIR=$(mktemp -d)
  SCRIPT_DIR="$TEMP_DIR"

  # Download the entire repo or specific files
  # This is a simplified approach - you might need to adjust based on your repo structure
  echo "Remote execution detected. Please run the installer from a cloned repository for full functionality."
  echo "Alternatively, clone the repo first:"
  echo "git clone https://github.com/aidomx/vimconfig.git"
  echo "cd vimconfig && ./install.sh"
  exit 1
fi

# Source libs (only if they exist)
if [[ -f "${SCRIPT_DIR}/lib/colors.sh" ]]; then
  source "${SCRIPT_DIR}/lib/colors.sh"
  source "${SCRIPT_DIR}/lib/logging.sh"
  source "${SCRIPT_DIR}/lib/fs.sh"
  source "${SCRIPT_DIR}/lib/execs.sh"
  source "${SCRIPT_DIR}/lib/spinner.sh"
else
  echo "Required libraries not found. Please run from cloned repository."
  exit 1
fi

# Source command implementations
if [[ -d "${SCRIPT_DIR}/commands" ]]; then
  for f in "${SCRIPT_DIR}/commands"/*.sh; do
    [[ -f "$f" ]] && source "$f"
  done
fi

# ============================================
# Fallback function definitions
# ============================================

# Define fallback functions if sourcing failed
type vcfg_banner &> /dev/null || vcfg_banner() {
  echo "==========================================="
  echo "   Vim Configuration Installer"
  echo "==========================================="
  echo ""
}

type check_dependencies &> /dev/null || check_dependencies() {
  echo "Checking dependencies..."
  # Basic dependency checks
  if ! command -v git &> /dev/null; then
    echo "Error: git is required but not installed."
    exit 1
  fi
  if ! command -v vim &> /dev/null && ! command -v nvim &> /dev/null; then
    echo "Error: vim or nvim is required but not installed."
    exit 1
  fi
}

type check_existing_installation &> /dev/null || check_existing_installation() {
  if [[ -f "$HOME/.vimrc" ]] || [[ -d "$HOME/.vim/plugged" ]]; then
    echo "Found existing Vim configuration."
    read -p "Backup and replace? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      local backup_dir="$HOME/.vimbackup_$(date +%Y%m%d_%H%M%S)"
      mkdir -p "$backup_dir"
      [[ -f "$HOME/.vimrc" ]] && mv "$HOME/.vimrc" "$backup_dir/"
      [[ -d "$HOME/.vim/plugged" ]] && mv "$HOME/.vim/plugged" "$backup_dir/"
      echo "Backup created: $backup_dir"
    fi
  fi
}

type clone_repository &> /dev/null || clone_repository() {
  echo "Cloning vimconfig repository..."
  local target_dir="$HOME/.local/vim"
  if [[ ! -d "$target_dir" ]]; then
    git clone https://github.com/aidomx/vimconfig.git "$target_dir"
  else
    echo "Repository already exists at $target_dir"
  fi
}

type setup_vimrc &> /dev/null || setup_vimrc() {
  echo "Setting up .vimrc..."
  local vimrc_src="$HOME/.local/vim/init.vim"
  local vimrc_dest="$HOME/.vimrc"

  if [[ -f "$vimrc_src" ]]; then
    ln -sf "$vimrc_src" "$vimrc_dest"
    echo "Created symlink: $vimrc_dest -> $vimrc_src"
  else
    echo "Error: Source vimrc not found at $vimrc_src"
    exit 1
  fi
}

type install_plugin_manager &> /dev/null || install_plugin_manager() {
  echo "Installing vim-plug..."
  local plug_vim_path="$HOME/.vim/autoload/plug.vim"
  local plug_nvim_path="$HOME/.local/share/nvim/site/autoload/plug.vim"

  # Install for Vim
  if command -v vim &> /dev/null; then
    curl -fLo "$plug_vim_path" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  # Install for Neovim
  if command -v nvim &> /dev/null; then
    curl -fLo "$plug_nvim_path" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

type install_plugins &> /dev/null || install_plugins() {
  echo "Installing plugins..."
  if command -v nvim &> /dev/null; then
    nvim +PlugInstall +qall
  elif command -v vim &> /dev/null; then
    vim +PlugInstall +qall
  fi
}

type install_vcfg &> /dev/null || install_vcfg() {
  echo "Installing vcfg command..."
  local bin_dir="$HOME/.local/bin"
  local vcfg_script="$HOME/.local/vim/vcfg"

  mkdir -p "$bin_dir"
  if [[ -f "$vcfg_script" ]]; then
    chmod +x "$vcfg_script"
    ln -sf "$vcfg_script" "$bin_dir/vcfg"
    echo "Installed vcfg command to $bin_dir/vcfg"

    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$bin_dir:"* ]]; then
      echo "Add to your shell profile: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
  fi
}

type setup_optional_tools &> /dev/null || setup_optional_tools() {
  echo "Setting up optional tools..."
  # This can be interactive based on user choice
  read -p "Install optional formatters? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Run manually: $HOME/.local/vim/setup_tools.sh"
  fi
}

type show_next_steps &> /dev/null || show_next_steps() {
  echo ""
  echo "==========================================="
  echo "   Installation Complete!"
  echo "==========================================="
  echo ""
  echo "Next steps:"
  echo "1. Restart your terminal"
  echo "2. Open vim and run :PlugInstall if plugins didn't install"
  echo "3. Check out the README for key mappings and features"
  echo ""
  echo "Configuration location: $HOME/.local/vim"
  echo ""
}

# ============================================
# Main Installation Flow
# ============================================

main() {
  clear
  vcfg_banner

  # Pre-installation checks
  check_dependencies
  check_existing_installation

  # Installation steps
  clone_repository
  setup_vimrc
  install_plugin_manager
  install_plugins
  install_vcfg

  # Optional setup
  setup_optional_tools

  # Completion
  show_next_steps
}

# Run installer
main "$@"
