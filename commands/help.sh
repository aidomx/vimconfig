#!/usr/bin/env bash

vcfg_cmd_help() {
  if [ $# -eq 0 ]; then
    # General help (default)
    echo -e "${CYAN}vcfg${NC} - Vim Configuration Manager"
    echo ""
    echo -e "${WHITE}USAGE:${NC}"
    echo "  vcfg <command> [arguments]"
    echo ""
    echo -e "${WHITE}CORE COMMANDS:${NC}"
    echo -e "  ${GREEN}add${NC} <plugin>          Add new plugin"
    echo -e "  ${GREEN}remove${NC} <plugin>       Remove plugin"
    echo -e "  ${GREEN}enable${NC} <plugin>       Enable disabled plugin"
    echo -e "  ${GREEN}disable${NC} <plugin>      Disable plugin"
    echo -e "  ${GREEN}list${NC}                  List all plugins"
    echo -e "  ${GREEN}info${NC} <plugin>         Show plugin info"
    echo -e "  ${GREEN}update${NC}                Update all plugins"
    echo -e "  ${GREEN}clean${NC}                 Clean unused plugins"
    echo ""
    echo -e "${WHITE}MAPPING COMMANDS:${NC}"
    echo -e "  ${GREEN}editmap${NC}               Interactive mapping editor"
    echo -e "  ${GREEN}editmap list${NC}          Show mappings"
    echo -e "  ${GREEN}editmap add${NC} <k> <a>   Add mapping"
    echo -e "  ${GREEN}editmap remove${NC} <pat>  Remove mapping"
    echo -e "  ${GREEN}editmap search${NC} <pat>  Search mappings"
    echo ""
    echo -e "${WHITE}UTILITY COMMANDS:${NC}"
    echo -e "  ${GREEN}search${NC} <query>        Search plugins"
    echo -e "  ${GREEN}install${NC}               Install/update vcfg"
    echo -e "  ${GREEN}doctor${NC}                System health check"
    echo -e "  ${GREEN}version${NC}               Show version"
    echo -e "  ${GREEN}help${NC}                  Show this help"
    echo ""
    echo -e "${WHITE}EXAMPLES:${NC}"
    echo "  vcfg add tpope/vim-fugitive"
    echo "  vcfg editmap add '<leader>ff' ':Files<CR>'"
    echo "  vcfg list"
    echo "  vcfg doctor"
    echo ""
    echo -e "Run ${CYAN}vcfg help <command>${NC} for detailed help"

    return 0
  fi

  local command=$1

  # Jika ada specific command, show detailed help
  case "$command" in
    add)
      echo -e "${CYAN}vcfg add${NC} - Add new plugin"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg add <username/repository>"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Adds a new plugin to your configuration and installs it automatically."
      echo "  Supports multiple plugin managers (vim-plug, packer.nvim, lazy.nvim)."
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vcfg add tpope/vim-fugitive"
      echo "  vcfg add preservim/nerdtree"
      echo "  vcfg add junegunn/fzf.vim"
      echo ""
      echo -e "${WHITE}SUPPORTED FORMATS:${NC}"
      echo "  • GitHub: username/repository"
      echo "  • GitLab: gitlab.com/username/repository"
      echo "  • Any valid git URL"
      ;;

    remove | rm)
      echo -e "${CYAN}vcfg remove${NC} - Remove plugin completely"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg remove <plugin-name>"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Removes a plugin from configuration and deletes its files."
      echo "  Also cleans up any orphaned plugin directories."
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vcfg remove vim-airline"
      echo "  vcfg remove coc.nvim"
      echo "  vcfg remove nerdtree"
      echo ""
      echo -e "${WHITE}NOTE:${NC}"
      echo "  This action cannot be undone. The plugin will be completely removed."
      ;;

    enable)
      echo -e "${CYAN}vcfg enable${NC} - Enable disabled plugin"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg enable <plugin-name>"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Enables a previously disabled plugin by uncommenting it in configuration."
      echo "  If the plugin is not installed, it will be installed automatically."
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vcfg enable coc.nvim"
      echo "  vcfg enable vim-airline"
      echo ""
      echo -e "${WHITE}NOTE:${NC}"
      echo "  Only works with commented plugins. Use 'vcfg add' for new plugins."
      ;;

      # Di vcfg_cmd_help, bagian disable:
    disable)
      echo -e "${CYAN}vcfg disable${NC} - Disable plugin"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg disable <plugin-name>"
      echo "  vcfg disable slow_plugins"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Disables a plugin by commenting it out in configuration."
      echo "  The plugin files are kept intact, just not loaded."
      echo ""
      echo -e "${WHITE}SPECIAL COMMAND:${NC}"
      echo "  vcfg disable slow_plugins - Disable known slow plugins to improve startup time"
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vcfg disable coc.nvim"
      echo "  vcfg disable vim-airline"
      echo "  vcfg disable slow_plugins"
      echo ""
      echo -e "${WHITE}NOTE:${NC}"
      echo "  Useful for temporarily disabling plugins without removing them."
      ;;

    install)
      echo -e "${CYAN}vcfg install${NC} - First-time installation (via vcfg)"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg install"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  First-time installation of Vim configuration using vcfg command."
      echo "  Note: Most users should use the standalone installer instead."
      echo ""
      echo -e "${WHITE}STANDALONE INSTALLER:${NC}"
      echo "  curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash"
      echo ""
      echo -e "${WHITE}NOTE:${NC}"
      echo "  This command is mainly for completeness. Use the curl command for new installations."
      ;;

    list | ls)
      echo -e "${CYAN}vcfg list${NC} - List installed plugins"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg list"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Shows all plugins in your configuration with their current status."
      echo "  Detects orphaned plugins (installed but not in config)."
      echo ""
      echo -e "${WHITE}FEATURES:${NC}"
      echo "  • Shows enabled/disabled status"
      echo "  • Shows installation status"
      echo "  • Detects orphaned plugins"
      echo "  • Works with all plugin managers"
      echo "  • Color-coded output for easy reading"
      ;;

    info)
      echo -e "${CYAN}vcfg info${NC} - Show plugin information"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg info <plugin-name>"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Shows detailed information about a plugin including:"
      echo "  - Installation status and path"
      echo "  - GitHub stars and description"
      echo "  - Last commit and branch"
      echo "  - Plugin manager specific info"
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vcfg info coc.nvim"
      echo "  vcfg info vim-airline"
      echo "  vcfg info nerdtree"
      ;;

    update | up)
      echo -e "${CYAN}vcfg update${NC} - Update all plugins"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg update"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Updates all installed plugins to their latest versions."
      echo "  Uses the appropriate command for your plugin manager."
      echo ""
      echo -e "${WHITE}SUPPORTED MANAGERS:${NC}"
      echo "  • vim-plug: PlugUpdate"
      echo "  • packer.nvim: PackerSync"
      echo "  • lazy.nvim: Lazy update"
      echo ""
      echo -e "${WHITE}NOTE:${NC}"
      echo "  Some plugins may require Vim/Neovim restart after update."
      ;;

    system-update)
      echo -e "${CYAN}vcfg system-update${NC} - Update configuration system"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg system-update"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Updates the vcfg system and configuration files."
      echo "  Pulls latest changes from the repository."
      ;;

    reinstall)
      echo -e "${CYAN}vcfg reinstall${NC} - Complete reinstall"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg reinstall"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Completely reinstalls Vim configuration from scratch."
      echo "  Backs up existing configuration first."
      echo ""
      echo -e "${WHITE}WARNING:${NC}"
      echo "  This will remove your current setup and reinstall fresh."
      ;;

    clean)
      echo -e "${CYAN}vcfg clean${NC} - Clean unused plugins"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg clean"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Removes plugins that are no longer in your configuration."
      echo "  Useful for cleaning up after removing plugins."
      echo ""
      echo -e "${WHITE}SUPPORTED MANAGERS:${NC}"
      echo "  • vim-plug: PlugClean!"
      echo "  • packer.nvim: PackerClean"
      echo "  • lazy.nvim: Lazy clean"
      ;;

    search)
      echo -e "${CYAN}vcfg search${NC} - Search for plugins on GitHub"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg search <query>"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Searches GitHub for Vim/Neovim plugins matching your query."
      echo "  Shows results with stars, description, and installation command."
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vcfg search fuzzy finder"
      echo "  vcfg search syntax highlight"
      echo "  vcfg search lsp"
      echo ""
      echo -e "${WHITE}NOTE:${NC}"
      echo "  Requires internet connection and GitHub API access."
      ;;

    editmap)
      echo -e "${CYAN}vcfg editmap${NC} - Manage Vim mappings"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg editmap                    # Interactive mode"
      echo "  vcfg editmap list               # Show all mappings"
      echo "  vcfg editmap add <key> <action> # Add mapping"
      echo "  vcfg editmap remove <pattern>   # Remove mapping"
      echo "  vcfg editmap search <pattern>   # Search mappings"
      echo "  vcfg editmap edit               # Open in editor"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Interactive tool for managing Vim/Neovim key mappings."
      echo "  Edit mappings without manually editing config files."
      echo ""
      echo -e "${WHITE}MAPPING TYPES:${NC}"
      echo "  Normal mode:    <leader>ff ':Files<CR>'"
      echo "  Insert mode:    i:jk '<Esc>'  (prefix with i:)"
      echo "  Visual mode:    v:<leader>y '\"+y'  (prefix with v:)"
      echo "  Visual+Select:  x:<leader>p '\"+p'  (prefix with x:)"
      echo ""
      echo -e "${WHITE}EXAMPLES:${NC}"
      echo "  vcfg editmap add '<leader>ff' ':Files<CR>'"
      echo "  vcfg editmap add 'i:jk' '<Esc>'"
      echo "  vcfg editmap add 'v:<leader>y' '\"+y'"
      echo "  vcfg editmap remove '<leader>ff'"
      echo "  vcfg editmap search 'leader'"
      ;;

    install)
      echo -e "${CYAN}vcfg install${NC} - Install/update vcfg system"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg install"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Installs or updates the vcfg system and dependencies."
      echo "  Sets up plugin manager and initial configuration."
      echo ""
      echo -e "${WHITE}FEATURES:${NC}"
      echo "  • Installs vim-plug/packer.nvim/lazy.nvim"
      echo "  • Sets up configuration structure"
      echo "  • Installs initial plugins"
      echo "  • Creates necessary directories"
      ;;

    doctor)
      echo -e "${CYAN}vcfg doctor${NC} - System health check"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg doctor"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Checks your system for potential issues and missing dependencies."
      echo "  Provides recommendations for fixing detected problems."
      echo ""
      echo -e "${WHITE}CHECKS PERFORMED:${NC}"
      echo "  • Vim/Neovim installation"
      echo "  • Plugin manager status"
      echo "  • Required tools (git, curl)"
      echo "  • Configuration file structure"
      echo "  • Plugin installation status"
      ;;

    version | --version | -v)
      echo -e "${CYAN}vcfg version${NC} - Show version information"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg version"
      echo "  vcfg --version"
      echo "  vcfg -v"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Shows version information for vcfg and detected plugin managers."
      ;;

    help | --help | -h)
      echo -e "${CYAN}vcfg help${NC} - Show help information"
      echo ""
      echo -e "${WHITE}USAGE:${NC}"
      echo "  vcfg help"
      echo "  vcfg help <command>"
      echo "  vcfg --help"
      echo "  vcfg -h"
      echo ""
      echo -e "${WHITE}DESCRIPTION:${NC}"
      echo "  Shows general help or detailed help for specific commands."
      ;;

    *)
      print_error "No detailed help available for: $command"
      echo ""
      echo -e "Run ${CYAN}vcfg help${NC} to see all available commands."
      echo -e "Run ${CYAN}vcfg help <command>${NC} for detailed help on a specific command."
      return 1
      ;;
  esac

  return 0
}
