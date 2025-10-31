# Key Mappings Reference

Complete keyboard shortcuts reference for the Vim configuration.

## 📚 Table of Contents

- [Global Leader Key](#global-leader-key)
- [File Navigation](#file-navigation)
- [Window Management](#window-management)
- [Tab Management](#tab-management)
- [Code Actions](#code-actions)
- [Git Integration](#git-integration)
- [Language-Specific](#language-specific-shortcuts)
- [Completion](#completion)
- [Copilot](#copilot)
- [Utility](#utility)

## 🎯 Global Leader Key

The leader key is set to **`<Space>`**

All shortcuts using `<leader>` mean pressing Space first, then the key combination.

## 📁 File Navigation

| Shortcut     | Action                | Description                 |
| ------------ | --------------------- | --------------------------- |
| `tt`         | Toggle NERDTree       | Open/close file explorer    |
| `ff`         | Find file in NERDTree | Locate current file in tree |
| `pp`         | Fuzzy file finder     | Quick file search (fzf)     |
| `bb`         | Buffer list           | Show all open buffers       |
| `gg`         | Live grep search      | Search text in all files    |
| `<leader>pf` | Project files         | Search files in git repo    |
| `<leader>pb` | Project buffers       | Search open buffers         |

## 🪟 Window Management

| Shortcut    | Action                 | Description                |
| ----------- | ---------------------- | -------------------------- |
| `<leader>s` | Toggle split view      | Split window horizontally  |
| `<leader>v` | Vertical split         | Split window vertically    |
| `<leader>m` | Maximize/restore split | Toggle window zoom         |
| `<C-h>`     | Move to left split     | Navigate to left window    |
| `<C-j>`     | Move to bottom split   | Navigate to bottom window  |
| `<C-k>`     | Move to top split      | Navigate to top window     |
| `<C-l>`     | Move to right split    | Navigate to right window   |
| `<leader>=` | Equal splits           | Make all splits equal size |
| `<leader>+` | Increase height        | Increase window height     |
| `<leader>-` | Decrease height        | Decrease window height     |
| `<leader>>` | Increase width         | Increase window width      |
| `<leader><` | Decrease width         | Decrease window width      |

## 📑 Tab Management

| Shortcut     | Action       | Description          |
| ------------ | ------------ | -------------------- |
| `<leader>to` | New tab      | Open new tab         |
| `<leader>tc` | Close tab    | Close current tab    |
| `<leader>tn` | Next tab     | Go to next tab       |
| `<leader>tp` | Previous tab | Go to previous tab   |
| `<leader>tf` | First tab    | Go to first tab      |
| `<leader>tl` | Last tab     | Go to last tab       |
| `<leader>tm` | Move tab     | Move tab to position |

## 🔧 Code Actions

| Shortcut      | Action                | Description                            |
| ------------- | --------------------- | -------------------------------------- |
| `<leader>fmt` | Format current file   | Auto-format with appropriate formatter |
| `gd`          | Go to definition      | Jump to symbol definition              |
| `gy`          | Go to type definition | Jump to type definition                |
| `gi`          | Go to implementation  | Jump to implementation                 |
| `gr`          | Find references       | Find all references                    |
| `<leader>rn`  | Rename symbol         | Rename symbol under cursor             |
| `K`           | Show documentation    | Show hover documentation               |
| `<leader>ca`  | Code action           | Show available code actions            |
| `<leader>qf`  | Quick fix             | Apply quick fix                        |
| `[d`          | Previous diagnostic   | Go to previous error                   |
| `]d`          | Next diagnostic       | Go to next error                       |
| `<leader>d`   | Show diagnostics      | Show all diagnostics                   |

## 🔀 Git Integration

| Shortcut     | Action        | Description                |
| ------------ | ------------- | -------------------------- |
| `<leader>gs` | Git status    | Show git status (fugitive) |
| `<leader>gc` | Git commit    | Commit changes             |
| `<leader>gp` | Git push      | Push to remote             |
| `<leader>gl` | Git pull      | Pull from remote           |
| `<leader>gd` | Git diff      | Show diff                  |
| `<leader>gb` | Git blame     | Show blame                 |
| `<leader>gh` | Git history   | Show file history          |
| `]c`         | Next hunk     | Jump to next change        |
| `[c`         | Previous hunk | Jump to previous change    |
| `<leader>hs` | Stage hunk    | Stage current hunk         |
| `<leader>hu` | Undo hunk     | Undo current hunk          |

## 🔤 Language-Specific Shortcuts

### C/C++

| Shortcut      | Action           | Description         |
| ------------- | ---------------- | ------------------- |
| `<leader>cc`  | Compile C file   | Compile with gcc    |
| `<leader>cr`  | Run C program    | Compile and run     |
| `<leader>cpp` | Compile C++ file | Compile with g++    |
| `<leader>cpr` | Run C++ program  | Compile and run C++ |
| `<leader>cd`  | Debug            | Start gdb debugger  |
| `<leader>cm`  | Make             | Run make command    |
| `<leader>ct`  | Run tests        | Run C/C++ tests     |

### Bash/Shell

| Shortcut     | Action                  | Description               |
| ------------ | ----------------------- | ------------------------- |
| `<leader>bx` | Make executable and run | chmod +x and execute      |
| `<leader>br` | Run script              | Execute bash script       |
| `<leader>bc` | Syntax check            | Check syntax with bash -n |
| `<leader>bt` | Test syntax             | Run shellcheck            |
| `<leader>bf` | Format script           | Format with shfmt         |

### Web Development

| Shortcut     | Action             | Description             |
| ------------ | ------------------ | ----------------------- |
| `<leader>nd` | Next.js dev server | Start Next.js dev       |
| `<leader>nb` | Next.js build      | Build Next.js project   |
| `<leader>ns` | Next.js start      | Start production server |
| `<leader>nr` | React dev          | Start React dev server  |
| `<leader>vd` | Vue dev            | Start Vue dev server    |
| `<leader>pd` | Prettier format    | Format with Prettier    |

### PHP/Laravel

| Shortcut     | Action          | Description          |
| ------------ | --------------- | -------------------- |
| `<leader>la` | Laravel Artisan | Run Artisan command  |
| `<leader>ls` | Laravel serve   | Start Laravel server |
| `<leader>lm` | Laravel migrate | Run migrations       |
| `<leader>lt` | Laravel test    | Run PHPUnit tests    |
| `<leader>lc` | Laravel cache   | Clear cache          |
| `<leader>lr` | Laravel routes  | Show routes          |

### Python

| Shortcut     | Action            | Description           |
| ------------ | ----------------- | --------------------- |
| `<leader>py` | Run Python script | Execute with python   |
| `<leader>pi` | Run interactive   | Start Python REPL     |
| `<leader>pt` | Run pytest        | Run tests with pytest |
| `<leader>pf` | Format with Black | Format code           |
| `<leader>pl` | Lint with flake8  | Check code style      |
| `<leader>pd` | Debug             | Start debugger        |

### Go

| Shortcut     | Action     | Description        |
| ------------ | ---------- | ------------------ |
| `<leader>gb` | Go build   | Build Go project   |
| `<leader>gr` | Go run     | Run Go program     |
| `<leader>gt` | Go test    | Run Go tests       |
| `<leader>gf` | Go format  | Format with gofmt  |
| `<leader>gi` | Go imports | Fix imports        |
| `<leader>gd` | Go doc     | Show documentation |

## ✨ Completion

| Shortcut    | Action                   | Description                      |
| ----------- | ------------------------ | -------------------------------- |
| `<TAB>`     | Next completion item     | Navigate down in completion list |
| `<S-TAB>`   | Previous completion item | Navigate up in completion list   |
| `<C-Space>` | Trigger completion       | Manually trigger completion      |
| `<CR>`      | Confirm completion       | Accept selected completion       |
| `<C-e>`     | Close completion         | Dismiss completion menu          |
| `<C-n>`     | Next completion          | Alternative next                 |
| `<C-p>`     | Previous completion      | Alternative previous             |

## 🤖 Copilot

| Shortcut     | Action                    | Description                  |
| ------------ | ------------------------- | ---------------------------- |
| `<C-J>`      | Accept Copilot suggestion | Accept AI suggestion         |
| `<C-K>`      | Dismiss suggestion        | Reject suggestion            |
| `<leader>cp` | Open Copilot panel        | Show alternative suggestions |
| `<leader>ce` | Enable Copilot            | Enable AI completion         |
| `<leader>cd` | Disable Copilot           | Disable AI completion        |
| `<C-]>`      | Next suggestion           | Show next alternative        |
| `<C-[>`      | Previous suggestion       | Show previous alternative    |

## 🛠️ Utility

| Shortcut          | Action              | Description               |
| ----------------- | ------------------- | ------------------------- |
| `<leader>w`       | Save file           | Write file to disk        |
| `<leader>q`       | Quit                | Quit current window       |
| `<leader>wq`      | Save and quit       | Write and quit            |
| `<leader>x`       | Save and quit (alt) | Alternative save & quit   |
| `<leader><space>` | Clear highlights    | Clear search highlights   |
| `<leader>n`       | Toggle line numbers | Show/hide line numbers    |
| `<leader>r`       | Reload config       | Reload vimrc              |
| `<leader>e`       | Show errors         | Open error list           |
| `<leader>l`       | Toggle list chars   | Show/hide invisible chars |

## 🔍 Search & Replace

| Shortcut     | Action                   | Description                  |
| ------------ | ------------------------ | ---------------------------- |
| `/`          | Search forward           | Search text forward          |
| `?`          | Search backward          | Search text backward         |
| `n`          | Next match               | Go to next search result     |
| `N`          | Previous match           | Go to previous search result |
| `*`          | Search word under cursor | Search current word forward  |
| `#`          | Search word backward     | Search current word backward |
| `<leader>h`  | No highlight             | Clear search highlight       |
| `<leader>/`  | Search in project        | Grep in all files            |
| `<leader>sr` | Search and replace       | Interactive find & replace   |

## 📋 Copy & Paste

| Shortcut    | Action                 | Description                  |
| ----------- | ---------------------- | ---------------------------- |
| `<leader>y` | Yank to clipboard      | Copy to system clipboard     |
| `<leader>p` | Paste from clipboard   | Paste from system clipboard  |
| `<leader>Y` | Yank line to clipboard | Copy whole line to clipboard |
| `<leader>P` | Paste before           | Paste before cursor          |

## 💬 Comments

| Shortcut     | Action          | Description             |
| ------------ | --------------- | ----------------------- |
| `<leader>cc` | Comment line    | Comment current line    |
| `<leader>cu` | Uncomment line  | Uncomment current line  |
| `<leader>c`  | Toggle comment  | Toggle comment          |
| `<leader>cs` | Sexy comment    | Add fancy comment block |
| `<leader>cm` | Minimal comment | Minimal comment style   |

## 🎨 Visual Mode

| Shortcut    | Action     | Description         |
| ----------- | ---------- | ------------------- |
| `<leader>a` | Select all | Select entire file  |
| `<leader>i` | Indent     | Indent selection    |
| `<leader>u` | Unindent   | Unindent selection  |
| `<leader>s` | Sort       | Sort selected lines |
| `<leader>f` | Format     | Format selection    |
| `<leader>c` | Comment    | Comment selection   |

## 🔄 Vim Surround

| Shortcut | Action                      | Description              |
| -------- | --------------------------- | ------------------------ |
| `ds"`    | Delete surrounding "        | Remove quotes            |
| `cs"'`   | Change " to '               | Change quotes            |
| `ysiw"`  | Surround word with "        | Add quotes around word   |
| `yss)`   | Surround line with ()       | Wrap line in parentheses |
| `S"`     | Surround selection (visual) | Wrap visual selection    |

## ⚡ Quick Actions

| Shortcut    | Action      | Description            |
| ----------- | ----------- | ---------------------- |
| `<leader>u` | Undo tree   | Open undo history      |
| `<leader>z` | Toggle fold | Fold/unfold code       |
| `<leader>j` | Jump to tag | Jump to ctag           |
| `<leader>k` | Go back     | Return from jump       |
| `<leader>o` | Open file   | Open file under cursor |
| `<leader>T` | Terminal    | Open terminal          |

## 🎯 Text Objects

| Shortcut | Action                 | Description                 |
| -------- | ---------------------- | --------------------------- |
| `viw`    | Select inner word      | Select word                 |
| `vaw`    | Select a word          | Select word with space      |
| `vi"`    | Select inside "        | Select text in quotes       |
| `va"`    | Select around "        | Select with quotes          |
| `vip`    | Select inner paragraph | Select paragraph            |
| `vap`    | Select a paragraph     | Select paragraph with blank |
| `vi{`    | Select inside {}       | Select code block           |
| `va{`    | Select around {}       | Select block with braces    |

## 🔧 Plugin-Specific

### NERDTree

| Shortcut (in NERDTree) | Action           | Description               |
| ---------------------- | ---------------- | ------------------------- |
| `m`                    | Menu             | Show file operations menu |
| `i`                    | Open split       | Open in horizontal split  |
| `s`                    | Open vsplit      | Open in vertical split    |
| `t`                    | Open in tab      | Open in new tab           |
| `I`                    | Toggle hidden    | Show/hide hidden files    |
| `C`                    | Change root      | Set as root directory     |
| `u`                    | Parent directory | Go up one directory       |
| `r`                    | Refresh          | Refresh current directory |
| `R`                    | Refresh root     | Refresh from root         |

### FZF (Fuzzy Finder)

| Shortcut | Action         | Description              |
| -------- | -------------- | ------------------------ |
| `<C-t>`  | Open in tab    | Open result in new tab   |
| `<C-x>`  | Open in split  | Open in horizontal split |
| `<C-v>`  | Open in vsplit | Open in vertical split   |
| `<C-u>`  | Preview up     | Scroll preview up        |
| `<C-d>`  | Preview down   | Scroll preview down      |

### Coc.nvim

| Shortcut     | Action      | Description            |
| ------------ | ----------- | ---------------------- |
| `<leader>cl` | Coc list    | Show Coc lists         |
| `<leader>co` | Coc outline | Show document outline  |
| `<leader>cs` | Coc symbols | Show workspace symbols |
| `<leader>cr` | Coc restart | Restart Coc server     |
| `<leader>ci` | Coc info    | Show Coc info          |

## 📱 Termux-Specific

Special mappings optimized for Termux on Android:

| Shortcut     | Action   | Description      |
| ------------ | -------- | ---------------- |
| `<C-z>`      | Undo     | Undo last change |
| `<C-y>`      | Redo     | Redo last undo   |
| `<C-s>`      | Save     | Quick save       |
| `<C-q>`      | Quit     | Quick quit       |
| `<C-f>`      | Find     | Quick find       |
| `<leader>kb` | Keyboard | Toggle keyboard  |

## 💡 Tips & Tricks

### Combine Motions

You can combine shortcuts with motions:

```
d2w  - Delete 2 words
c3j  - Change 3 lines down
y$   - Yank to end of line
>3k  - Indent 3 lines up
```

### Repeat Actions

```
.    - Repeat last change
@:   - Repeat last command
@@   - Repeat last macro
```

### Count Prefix

Add numbers before commands:

```
3dd  - Delete 3 lines
5j   - Move down 5 lines
10x  - Delete 10 characters
2<leader>cc - Comment 2 lines
```

### Visual Block Mode

```
<C-v>  - Start visual block
I      - Insert at block start
A      - Append at block end
<Esc>  - Apply to all lines
```

## 🔧 Customizing Mappings

To add your own mappings, edit `~/.config/vim/core/mappings.vim` or use vcfg:

```bash
# Add custom mapping
vcfg editmap add '<leader>custom' ':YourCommand<CR>'

# Edit mappings interactively
vcfg editmap
```

## 📝 Mapping Conventions

This configuration follows these conventions:

- `<leader>` - General actions (Space key)
- `<C-key>` - Control combinations (frequently used)
- `g` prefix - Go to / navigation actions
- `z` prefix - Folding actions
- `]` / `[` - Next/previous navigation
- Language prefixes:
  - `<leader>c` - C/C++ or Comments
  - `<leader>p` - Python or Project
  - `<leader>g` - Go or Git
  - `<leader>l` - Laravel/PHP
  - `<leader>n` - Next.js/Node
  - `<leader>b` - Bash/Shell

## 🚀 Quick Reference Card

Print this quick reference for easy access:

```
Leader: <Space>

Files:     tt pp bb gg
Windows:   C-hjkl <leader>s <leader>m
Tabs:      <leader>to/tc/tn/tp
Code:      gd gy gi gr K <leader>rn
Git:       <leader>gs/gc/gp/gd
Save/Quit: <leader>w/q/wq/x
```

---

[← Back to Main README](../README.md) | [Customization Guide →](customization.md)
