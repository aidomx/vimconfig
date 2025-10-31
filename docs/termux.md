# Termux Optimization Guide

Complete guide for using Vim on Termux (Android).

## 📚 Table of Contents

- [Initial Setup](#-initial-setup)
- [Keyboard Configuration](#-keyboard-configuration)
- [Touch & Mouse Support](#-touch--mouse-support)
- [Storage Access](#-storage-access)
- [Performance Optimization](#-performance-optimization)
- [Battery Management](#-battery-management)
- [Termux-Specific Mappings](#-termux-specific-mappings)
- [Common Issues](#-common-issues)

## 🚀 Initial Setup

### Install Termux

1. **Download Termux:**
   - F-Droid (Recommended): https://f-droid.org/en/packages/com.termux/
   - Not from Play Store (outdated)

2. **Update packages:**

```bash
pkg update && pkg upgrade
```

3. **Install essential packages:**

```bash
pkg install vim-python nodejs git curl
```

### Install Vim Configuration

```bash
# Automated installation
curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash

# Or manual
pkg install vim-python nodejs git
git clone https://github.com/aidomx/vimconfig.git ~/.config/vim
if filereadable(expand('~/.config/vim/init.vim'))
    source ~/.config/vim/init.vim
endif
```

### Storage Setup

```bash
# Grant storage access
termux-setup-storage

# Access shared storage
cd ~/storage/shared

# Create symlinks for easy access
ln -s ~/storage/shared/Documents ~/docs
ln -s ~/storage/shared/Download ~/downloads
```

## ⌨️ Keyboard Configuration

### Install Better Keyboard

**Recommended: Hacker's Keyboard**

- Download from F-Droid or Play Store
- Provides: Esc, Tab, Ctrl, Alt, Arrow keys

**Alternative: Unexpected Keyboard**

- More customizable
- Swipe gestures support

### Termux Extra Keys

Edit `~/.termux/termux.properties`:

```properties
# Basic extra keys
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]

# Advanced layout
extra-keys = [ \
 ['ESC', '|', '/', '~', 'UP', '`', '-'], \
 ['TAB', 'CTRL', 'ALT', 'LEFT', 'DOWN', 'RIGHT', '$'] \
]

# Minimal layout
extra-keys = [['ESC', 'TAB', 'CTRL', 'ALT', '/', '-', 'UP', 'DOWN']]
```

After editing, reload:

```bash
termux-reload-settings
```

### Custom Key Mappings

Since some keys are hard to press on mobile, add alternatives:

```vim
" ~/.config/vim/utils/termux-keys.vim

" Alternative Escape
inoremap jk <Esc>
inoremap kj <Esc>

" Quick save (easier than :w)
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Quick quit
nnoremap <C-q> :q<CR>

" Alternative leader mappings
nnoremap <Space><Space> :

" Window navigation (easier on touch)
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Buffer navigation
nnoremap <C-Tab> :bnext<CR>
nnoremap <C-S-Tab> :bprev<CR>

" Visual mode selection
vnoremap <C-c> "+y
nnoremap <C-v> "+p
```

### Volume Keys as Extra Keys

```properties
# In termux.properties
volume-keys = volume
```

Now:

- Volume Up = Page Up
- Volume Down = Page Down

## 🖱️ Touch & Mouse Support

### Enable Mouse Support

```vim
" In settings.vim or custom.vim
set mouse=a

" Better scrolling
set ttymouse=sgr

" Scroll multiple lines
noremap <ScrollWheelUp> 3<C-Y>
noremap <ScrollWheelDown> 3<C-E>
```

### Touch Gestures

```vim
" Double tap to save
nnoremap <2-LeftMouse> :w<CR>

" Long press for context menu
nnoremap <RightMouse> :popup PopUp<CR>

" Pinch zoom (font size)
nnoremap <C-ScrollWheelUp> :set guifont=*<CR>
nnoremap <C-ScrollWheelDown> :set guifont=*<CR>
```

### Touch-Friendly UI

```vim
" Larger hit targets
set lines=30        " More visible lines
set columns=80      " Wider view

" Clearer cursor
set cursorline
hi CursorLine ctermbg=236

" Better visibility
set number
set relativenumber
```

## 💾 Storage Access

### Access Android Directories

```bash
# Home directory in Termux
~/

# Android shared storage
~/storage/shared/

# Common directories
~/storage/shared/Documents
~/storage/shared/Download
~/storage/shared/DCIM
~/storage/shared/Music
```

### Quick Access Setup

```bash
# Create shortcuts in .bashrc
echo 'alias docs="cd ~/storage/shared/Documents"' >> ~/.bashrc
echo 'alias dl="cd ~/storage/shared/Download"' >> ~/.bashrc
echo 'alias projects="cd ~/storage/shared/Projects"' >> ~/.bashrc

source ~/.bashrc
```

### Vim Bookmarks for Android Dirs

```vim
" Add to custom.vim
nnoremap <leader>fd :edit ~/storage/shared/Documents/<CR>
nnoremap <leader>fl :edit ~/storage/shared/Download/<CR>
nnoremap <leader>fp :edit ~/storage/shared/Projects/<CR>
```

### File Manager Integration

```vim
" Open file in external app
command! OpenExternal !termux-open %

nnoremap <leader>oe :OpenExternal<CR>
```

## ⚡ Performance Optimization

### Termux-Specific Settings

```vim
" ~/.config/vim/utils/termux.vim

" Faster rendering
set lazyredraw
set ttyfast

" Reduce resource usage
set updatetime=1000
set history=100

" Disable heavy features
set nocursorline
let g:airline#extensions#tabline#enabled = 0

" Limit syntax complexity
syntax sync minlines=64 maxlines=128

" Faster diff
set diffopt+=internal,algorithm:patience
```

### Lightweight Plugin Set

```bash
# Disable heavy plugins for mobile
vcfg disable copilot.vim
vcfg disable vim-gitgutter
vcfg disable nerdcommenter

# Use lighter alternatives
# Instead of coc.nvim, consider vim-lsp (lighter)
```

### Optimize Coc for Mobile

```json
// ~/.config/vim/coc-settings.json
{
  "suggest.maxCompleteItemCount": 15,
  "suggest.timeout": 800,
  "diagnostic.virtualText": false,
  "diagnostic.refreshOnInsertMode": false,
  "codeLens.enable": false,
  "workspace.maxFileSize": 1
}
```

## 🔋 Battery Management

### Power Saving Mode

```vim
" ~/.config/vim/utils/battery-save.vim

" Battery saving settings
if exists('$TERMUX_BATTERY_SAVE')
    " Reduce updates
    set updatetime=5000

    " Disable auto-features
    set noautowrite
    set noautochdir

    " Disable git integration
    let g:gitgutter_enabled = 0

    " Disable Coc
    let g:coc_start_at_startup = 0

    " Minimal UI
    set noshowmode
    set noruler
    set laststatus=0
endif
```

Activate battery save mode:

```bash
export TERMUX_BATTERY_SAVE=1
vim myfile.txt
```

### Wake Lock Management

```bash
# Prevent screen sleep during long operations
termux-wake-lock

# Release wake lock
termux-wake-unlock

# Auto wake-lock for Vim
alias vim='termux-wake-lock && vim'
```

### Battery-Friendly Workflow

```vim
" Manual save instead of auto-save
set noautowrite

" Longer write delay
set updatetime=2000

" Disable continuous features
let g:coc_disable_startup_warning = 1
let g:coc_start_at_startup = 0

" Start Coc manually when needed
nnoremap <leader>cs :CocStart<CR>
```

## 🎯 Termux-Specific Mappings

### Essential Mobile Mappings

```vim
" ~/.config/vim/utils/termux.vim

" === Quick Actions ===
" Two-key escape
inoremap jk <Esc>
inoremap kj <Esc>

" Quick save
nnoremap <leader>s :w<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Quick quit
nnoremap <leader>q :q<CR>
nnoremap <C-q> :q<CR>

" === Navigation ===
" Easier window switching
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Buffer navigation
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprev<CR>

" === Editing ===
" Undo/Redo (easier to reach)
nnoremap <leader>u u
nnoremap <leader>r <C-r>

" === File Operations ===
" Open file explorer
nnoremap <leader>e :NERDTreeToggle<CR>

" Fuzzy finder
nnoremap <leader>f :Files<CR>

" === Termux Functions ===
" Share file via Termux
command! Share !termux-share %
nnoremap <leader>ts :Share<CR>

" Open in external app
command! Open !termux-open %
nnoremap <leader>to :Open<CR>

" Copy to clipboard
vnoremap <leader>y :!termux-clipboard-set<CR>

" Paste from clipboard
nnoremap <leader>p :r !termux-clipboard-get<CR>
```

### Touch-Optimized Commands

```vim
" Easier commands (no shift needed)
nnoremap ; :
nnoremap : ;

" Quick command palette
nnoremap <leader><leader> :

" Common commands
nnoremap <leader>w :w<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>q :q<CR>
```

## 🔧 Common Issues

### Keyboard Issues

**Problem: Ctrl/Alt keys not working**

Solution:

```bash
# Use Hacker's Keyboard
# Or remap in Vim
nnoremap <leader>c <C-c>
nnoremap <leader>v <C-v>
```

**Problem: Escape key missing**

Solution:

```vim
" Alternative escape sequences
inoremap jk <Esc>
inoremap kj <Esc>
cnoremap jk <C-c>
```

### Display Issues

**Problem: Colors look wrong**

Solution:

```vim
set termguicolors
set t_Co=256

" Or disable true colors
set notermguicolors
```

**Problem: Screen flickering**

Solution:

```vim
set lazyredraw
set ttyfast
```

### Performance Issues

**Problem: Vim is slow**

Solution:

```bash
# Run doctor
vcfg doctor

# Disable heavy plugins
vcfg disable slow_plugins

# Use performance mode
vim -c "let g:performance_mode=1" file.txt
```

### Storage Issues

**Problem: Can't access SD card**

Solution:

```bash
# Grant storage permission
termux-setup-storage

# Restart Termux
exit
# Open Termux again
```

**Problem: Permission denied**

Solution:

```bash
# Check permissions
ls -la ~/storage

# Re-grant permissions
termux-setup-storage
```

### Battery Drain

**Problem: Termux drains battery**

Solution:

```bash
# Enable battery optimization
# Settings > Apps > Termux > Battery > Optimize

# Use wake lock wisely
termux-wake-unlock

# Enable doze mode
```

## 📱 Termux API Integration

### Install Termux:API

```bash
# Install from F-Droid
pkg install termux-api
```

### Useful API Commands

```vim
" Share file
nnoremap <leader>sh :!termux-share %<CR>

" Take photo and insert path
nnoremap <leader>ph :r!termux-camera-photo -c 0<CR>

" Get location
nnoremap <leader>loc :r!termux-location<CR>

" Text to speech
vnoremap <leader>tts :!termux-tts-speak<CR>

" Vibrate
nnoremap <leader>vib :!termux-vibrate -d 100<CR>

" Toast notification
command! -nargs=1 Toast !termux-toast <args>
nnoremap <leader>not :Toast "Saved!"<CR>:w<CR>
```

## 🎨 Termux Styling

### Install Termux:Styling

Download from F-Droid for:

- Color schemes
- Font options
- UI customization

### Recommended Fonts

- Fira Code
- JetBrains Mono
- Source Code Pro
- Cascadia Code

### Custom Colors

```bash
# Create color scheme
mkdir -p ~/.termux
vim ~/.termux/colors.properties
```

```properties
# Gruvbox Dark
background=#282828
foreground=#ebdbb2
cursor=#ebdbb2

color0=#282828
color1=#cc241d
color2=#98971a
color3=#d79921
color4=#458588
color5=#b16286
color6=#689d6a
color7=#a89984
```

Reload settings:

```bash
termux-reload-settings
```

## 💡 Pro Tips for Termux

1. **Use proot-distro for full Linux:**

```bash
pkg install proot-distro
proot-distro install arch
proot-distro login arch
```

2. **Set up SSH server:**

```bash
pkg install openssh
sshd
# Access from PC: ssh user@phone_ip -p 8022
```

3. **Run in background:**

```bash
# Use Termux:Boot to start on device boot
```

4. **Sync with cloud:**

```bash
pkg install rclone
rclone config
# Sync Vim config to cloud
```

5. **Use floating window:**
   - Termux:Float from F-Droid
   - Edit code while browsing

## 🎯 Recommended Termux Workflow

```bash
# 1. Morning setup
cd ~/projects/myproject
tmux new -s work

# 2. Split terminal
tmux split-window -h

# 3. Left pane: Vim
vim

# 4. Right pane: commands
# Run builds, tests, etc

# 5. Detach when switching apps
Ctrl+b d

# 6. Reattach later
tmux attach -t work
```

---

[← Back to Main README](../README.md) | [Performance Guide →](performance.md)
