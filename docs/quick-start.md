# Quick Start Guide

Get started quickly with specific languages and workflows.

## 📚 Table of Contents

- [Web Development](#-web-development)
- [C/C++ Development](#-cc-development)
- [Python Development](#-python-development)
- [Go Development](#-go-development)
- [PHP/Laravel Development](#-phplarave-development)
- [Bash/Shell Scripting](#-bashshell-scripting)

## 🌐 Web Development

### Setup

```bash
# Install Node.js and npm
pkg install nodejs  # Termux
sudo pacman -S nodejs npm  # Arch

# Install global packages
npm install -g typescript prettier eslint

# Install Coc extensions
vim -c 'CocInstall coc-tsserver coc-json coc-html coc-css coc-prettier' -c 'qa'
```

### JavaScript/TypeScript Project

**1. Create new project:**

```bash
mkdir my-project && cd my-project
npm init -y
```

**2. Open with Vim:**

```bash
vim src/index.js
```

**3. Key features available:**

| Feature          | Shortcut      | Description              |
| ---------------- | ------------- | ------------------------ |
| Autocomplete     | `<Tab>`       | Smart completion         |
| Go to definition | `gd`          | Jump to definition       |
| Format code      | `<leader>fmt` | Format with Prettier     |
| Find references  | `gr`          | Find all references      |
| Rename symbol    | `<leader>rn`  | Rename variable/function |
| Show docs        | `K`           | Show documentation       |

**4. Example workflow:**

```javascript
// Type and get autocomplete
const myFunction = () => {
  // Press K on console to see docs
  console.log('Hello')
}

// Use gd to jump to myFunction definition
myFunction()

// Press <leader>fmt to format
```

### React Development

**1. Create React app:**

```bash
npx create-react-app my-app
cd my-app
vim src/App.jsx
```

**2. React shortcuts:**

| Shortcut     | Action               |
| ------------ | -------------------- |
| `<leader>nr` | Start dev server     |
| `<leader>pd` | Format with Prettier |

**3. JSX/TSX features:**

- Auto-close tags
- Component completion
- Props completion
- Import auto-complete

### Next.js Development

**1. Create Next.js app:**

```bash
npx create-next-app my-next-app
cd my-next-app
vim pages/index.js
```

**2. Next.js shortcuts:**

| Shortcut     | Action                  |
| ------------ | ----------------------- |
| `<leader>nd` | Start dev server        |
| `<leader>nb` | Build project           |
| `<leader>ns` | Start production server |

**3. Features:**

- API route completion
- Dynamic route support
- Server/Client component detection

## 🔧 C/C++ Development

### Setup

```bash
# Install compiler and tools
pkg install clang gdb cmake  # Termux
sudo pacman -S clang gcc gdb cmake  # Arch

# Install Coc extension
vim -c 'CocInstall coc-clangd' -c 'qa'
```

### C Project

**1. Create simple C program:**

```bash
vim hello.c
```

```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

**2. Compile and run:**

| Shortcut     | Action          |
| ------------ | --------------- |
| `<leader>cc` | Compile C file  |
| `<leader>cr` | Compile and run |
| `<leader>cd` | Debug with GDB  |

**3. Workflow:**

- Write code with autocomplete
- Press `<leader>cc` to compile
- Check for errors
- Press `<leader>cr` to run

### C++ Project

**1. Create C++ program:**

```bash
vim main.cpp
```

```cpp
#include <iostream>
#include <vector>

int main() {
    std::vector<int> nums = {1, 2, 3};
    for (int num : nums) {
        std::cout << num << std::endl;
    }
    return 0;
}
```

**2. C++ shortcuts:**

| Shortcut      | Action           |
| ------------- | ---------------- |
| `<leader>cpp` | Compile C++ file |
| `<leader>cpr` | Compile and run  |
| `<leader>cm`  | Run make         |

**3. Features:**

- Modern C++ syntax
- STL completion
- Header navigation
- Class/function completion

### CMake Project

**1. Create CMakeLists.txt:**

```cmake
cmake_minimum_required(VERSION 3.10)
project(MyProject)

set(CMAKE_CXX_STANDARD 17)

add_executable(myapp main.cpp)
```

**2. Build workflow:**

```bash
mkdir build && cd build
cmake ..
make
```

**3. For LSP support:**

```bash
# Generate compile_commands.json
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
ln -s build/compile_commands.json ../
```

## 🐍 Python Development

### Setup

```bash
# Install Python and tools
pkg install python  # Termux
sudo pacman -S python python-pip  # Arch

# Install formatters
pip install black flake8 autopep8

# Install Coc extension
vim -c 'CocInstall coc-pyright' -c 'qa'
```

### Python Script

**1. Create Python file:**

```bash
vim script.py
```

```python
def greet(name: str) -> str:
    """Greet a person by name."""
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(greet("World"))
```

**2. Python shortcuts:**

| Shortcut     | Action            |
| ------------ | ----------------- |
| `<leader>py` | Run Python script |
| `<leader>pf` | Format with Black |
| `<leader>pt` | Run pytest        |
| `<leader>pl` | Lint with flake8  |

**3. Workflow:**

- Write code with type hints
- Get autocomplete and docs with `K`
- Format with `<leader>pf`
- Run with `<leader>py`

### Virtual Environment

**1. Create venv:**

```bash
python -m venv venv
source venv/bin/activate
```

**2. Vim will detect venv automatically**

**3. Install packages:**

```bash
pip install requests
```

**4. Packages will be available in completion**

### Django Project

**1. Create Django project:**

```bash
django-admin startproject mysite
cd mysite
vim mysite/settings.py
```

**2. Features:**

- Django model completion
- Template tag completion
- URL pattern completion

## 🔵 Go Development

### Setup

```bash
# Install Go
pkg install golang  # Termux
sudo pacman -S go  # Arch

# Install tools
go install golang.org/x/tools/gopls@latest

# Install Coc extension
vim -c 'CocInstall coc-go' -c 'qa'
```

### Go Project

**1. Initialize module:**

```bash
mkdir myapp && cd myapp
go mod init github.com/username/myapp
vim main.go
```

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, Go!")
}
```

**2. Go shortcuts:**

| Shortcut     | Action            |
| ------------ | ----------------- |
| `<leader>gb` | Build project     |
| `<leader>gr` | Run project       |
| `<leader>gt` | Run tests         |
| `<leader>gf` | Format with gofmt |
| `<leader>gi` | Fix imports       |

**3. Workflow:**

- Write code with autocomplete
- Auto-format on save
- Build with `<leader>gb`
- Run with `<leader>gr`

### Go Testing

**1. Create test file:**

```bash
vim main_test.go
```

```go
package main

import "testing"

func TestGreet(t *testing.T) {
    result := greet("World")
    expected := "Hello, World!"
    if result != expected {
        t.Errorf("got %s, want %s", result, expected)
    }
}
```

**2. Run tests:**

- Press `<leader>gt` to run tests
- See results in Vim

## 🐘 PHP/Laravel Development

### Setup

```bash
# Install PHP and Composer
pkg install php composer  # Termux
sudo pacman -S php composer  # Arch

# Install PHP tools
composer global require phpactor/phpactor
composer global require friendsofphp/php-cs-fixer

# Install Coc extension
vim -c 'CocInstall coc-phpls' -c 'qa'
```

### Laravel Project

**1. Create Laravel project:**

```bash
composer create-project laravel/laravel my-app
cd my-app
vim routes/web.php
```

**2. Laravel shortcuts:**

| Shortcut     | Action               |
| ------------ | -------------------- |
| `<leader>la` | Run Artisan command  |
| `<leader>ls` | Start Laravel server |
| `<leader>lm` | Run migrations       |
| `<leader>lt` | Run tests            |
| `<leader>lc` | Clear cache          |

**3. Workflow example:**

```bash
# Start server
<leader>ls

# Create controller
<leader>la
# Type: make:controller UserController

# Run migrations
<leader>lm
```

### Blade Templates

**1. Open Blade file:**

```bash
vim resources/views/welcome.blade.php
```

**2. Features:**

- Blade directive completion
- Component completion
- Auto-close tags

**3. Example:**

```blade
@extends('layouts.app')

@section('content')
    <h1>{{ $title }}</h1>

    @foreach($items as $item)
        <p>{{ $item->name }}</p>
    @endforeach
@endsection
```

### PHP Testing

**1. Create test:**

```bash
php artisan make:test UserTest
vim tests/Feature/UserTest.php
```

**2. Run tests:**

- Press `<leader>lt` to run PHPUnit tests

## 🔨 Bash/Shell Scripting

### Setup

```bash
# Install shell tools
pkg install shfmt shellcheck  # Termux
sudo pacman -S shfmt shellcheck  # Arch
```

### Shell Script

**1. Create script:**

```bash
vim script.sh
```

```bash
#!/bin/bash

# Function example
greet() {
    local name=$1
    echo "Hello, $name!"
}

# Main
main() {
    greet "World"
}

main "$@"
```

**2. Bash shortcuts:**

| Shortcut     | Action                  |
| ------------ | ----------------------- |
| `<leader>bx` | Make executable and run |
| `<leader>br` | Run script              |
| `<leader>bc` | Syntax check            |
| `<leader>bt` | Run shellcheck          |
| `<leader>bf` | Format with shfmt       |

**3. Workflow:**

- Write script
- Press `<leader>bc` to check syntax
- Press `<leader>bt` to lint
- Press `<leader>bx` to run

## 🎯 General Workflow Tips

### Opening Files

```bash
# Fuzzy finder
pp

# Grep in files
gg

# File tree
tt
```

### Navigation

```bash
# Go to definition
gd

# Find references
gr

# Back from jump
<C-o>
```

### Code Actions

```bash
# Format file
<leader>fmt

# Rename symbol
<leader>rn

# Show documentation
K
```

### Git Integration

```bash
# Git status
<leader>gs

# Git commit
<leader>gc

# Git diff
<leader>gd
```

## 💡 Pro Tips

1. **Use fuzzy finder:** `pp` is faster than navigating directories
2. **Format on save:** Already enabled for most languages
3. **Split windows:** `<leader>s` for horizontal, `<leader>v` for vertical
4. **Quick save:** `<leader>w` instead of `:w<CR>`
5. **Buffer navigation:** `bb` to switch between open files
6. **Project-wide search:** `gg` to search text in all files
7. **Code folding:** `za` to toggle fold

## 🚀 Next Steps

After this quick start:

1. Explore [Key Mappings](keymappings.md) for all shortcuts
2. Check [Customization Guide](customization.md) to personalize
3. Read language-specific docs in `docs/languages/`
4. Join community discussions for tips

---

[← Back to Main README](../README.md) | [Key Mappings →](keymappings.md)
