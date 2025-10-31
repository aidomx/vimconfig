# C/C++ Development Guide

Complete guide for C and C++ development with modern features and best practices.

## 📚 Table of Contents

- [Setup](#-setup)
- [C Development](#-c-development)
- [C++ Development](#-c-development-1)
- [Build Systems](#-build-systems)
- [Debugging](#-debugging)
- [Memory Management](#-memory-management)
- [Common Workflows](#-common-workflows)
- [Best Practices](#-best-practices)

## 🚀 Setup

### Prerequisites

```bash
# Install compilers and tools
# Termux
pkg install clang gdb cmake make

# Arch Linux
sudo pacman -S clang gcc gdb cmake make

# Ubuntu/Debian
sudo apt install clang gcc gdb cmake build-essential

# Verify installation
clang --version
gcc --version
gdb --version
cmake --version
```

### Development Tools

```bash
# Formatters
# Termux
pkg install clang

# Arch
sudo pacman -S clang

# Ubuntu
sudo apt install clang-format

# Additional tools
# Termux/Arch/Ubuntu
pkg install valgrind  # Memory checker (Termux may not have this)
```

### Coc Extension

```vim
:CocInstall coc-clangd
```

### clangd Setup

```bash
# Install clangd
# Termux
pkg install clang

# Arch
sudo pacman -S clang

# Ubuntu
sudo apt install clangd

# Verify
clangd --version
```

## 📝 C Development

### Features

- Syntax highlighting
- Auto-completion
- Go to definition
- Find references
- Error detection
- Auto-formatting

### Key Mappings

| Shortcut      | Action                   |
| ------------- | ------------------------ |
| `<leader>cc`  | Compile C file           |
| `<leader>cr`  | Compile and run          |
| `<leader>cd`  | Debug with GDB           |
| `<leader>cm`  | Run make                 |
| `gd`          | Go to definition         |
| `gr`          | Find references          |
| `<leader>fmt` | Format with clang-format |
| `K`           | Show documentation       |

### Basic C Program

```c
// main.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function prototype
int add(int a, int b);
void print_array(int *arr, size_t size);

int main(int argc, char *argv[]) {
    printf("Hello, World!\n");

    // Variables
    int x = 10;
    int y = 20;
    int sum = add(x, y);
    printf("Sum: %d\n", sum);

    // Array
    int numbers[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(numbers) / sizeof(numbers[0]);
    print_array(numbers, size);

    // Dynamic memory
    int *dynamic_arr = (int *)malloc(5 * sizeof(int));
    if (dynamic_arr == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        return EXIT_FAILURE;
    }

    for (int i = 0; i < 5; i++) {
        dynamic_arr[i] = i * 10;
    }

    print_array(dynamic_arr, 5);
    free(dynamic_arr);

    return EXIT_SUCCESS;
}

int add(int a, int b) {
    return a + b;
}

void print_array(int *arr, size_t size) {
    printf("Array: ");
    for (size_t i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}
```

### Structures

```c
// student.h
#ifndef STUDENT_H
#define STUDENT_H

typedef struct {
    int id;
    char name[50];
    float gpa;
} Student;

// Function declarations
Student* create_student(int id, const char *name, float gpa);
void print_student(const Student *student);
void free_student(Student *student);

#endif // STUDENT_H
```

```c
// student.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "student.h"

Student* create_student(int id, const char *name, float gpa) {
    Student *student = (Student *)malloc(sizeof(Student));
    if (student == NULL) {
        return NULL;
    }

    student->id = id;
    strncpy(student->name, name, sizeof(student->name) - 1);
    student->name[sizeof(student->name) - 1] = '\0';
    student->gpa = gpa;

    return student;
}

void print_student(const Student *student) {
    if (student == NULL) {
        printf("Student is NULL\n");
        return;
    }

    printf("Student ID: %d\n", student->id);
    printf("Name: %s\n", student->name);
    printf("GPA: %.2f\n", student->gpa);
}

void free_student(Student *student) {
    free(student);
}
```

### File I/O

```c
#include <stdio.h>
#include <stdlib.h>

// Write to file
void write_file(const char *filename, const char *content) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        perror("Error opening file for writing");
        return;
    }

    fprintf(file, "%s", content);
    fclose(file);
}

// Read from file
char* read_file(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        perror("Error opening file for reading");
        return NULL;
    }

    // Get file size
    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    rewind(file);

    // Allocate memory
    char *content = (char *)malloc(size + 1);
    if (content == NULL) {
        fclose(file);
        return NULL;
    }

    // Read file
    size_t read_size = fread(content, 1, size, file);
    content[read_size] = '\0';

    fclose(file);
    return content;
}
```

### Compile and Run

```bash
# Compile
gcc -o program main.c student.c

# Or with warnings
gcc -Wall -Wextra -o program main.c student.c

# Run
./program

# Or in Vim
<leader>cc  # Compile
<leader>cr  # Compile and run
```

## ⚡ C++ Development

### Features

- Modern C++ syntax (C++11/14/17/20)
- STL completion
- Template support
- Class navigation
- Member function completion

### Key Mappings

| Shortcut      | Action              |
| ------------- | ------------------- |
| `<leader>cpp` | Compile C++ file    |
| `<leader>cpr` | Compile and run C++ |
| `<leader>cd`  | Debug with GDB      |
| `<leader>cm`  | Run make            |
| `gd`          | Go to definition    |
| `gr`          | Find references     |
| `<leader>fmt` | Format code         |

### Basic C++ Program

```cpp
// main.cpp
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <memory>

// Function template
template<typename T>
T add(T a, T b) {
    return a + b;
}

// Class
class Person {
private:
    std::string name;
    int age;

public:
    // Constructor
    Person(const std::string& name, int age)
        : name(name), age(age) {}

    // Getters
    std::string getName() const { return name; }
    int getAge() const { return age; }

    // Method
    void introduce() const {
        std::cout << "Hi, I'm " << name
                  << " and I'm " << age
                  << " years old.\n";
    }
};

int main() {
    std::cout << "Hello, C++!\n";

    // Auto keyword
    auto x = 10;
    auto y = 20;
    std::cout << "Sum: " << add(x, y) << "\n";

    // Vector
    std::vector<int> numbers = {1, 2, 3, 4, 5};

    // Range-based for loop
    std::cout << "Numbers: ";
    for (const auto& num : numbers) {
        std::cout << num << " ";
    }
    std::cout << "\n";

    // Lambda
    auto is_even = [](int n) { return n % 2 == 0; };

    // Algorithm
    auto count = std::count_if(
        numbers.begin(),
        numbers.end(),
        is_even
    );
    std::cout << "Even numbers: " << count << "\n";

    // Smart pointer
    auto person = std::make_unique<Person>("Alice", 25);
    person->introduce();

    return 0;
}
```

### Classes and Inheritance

```cpp
// shape.h
#ifndef SHAPE_H
#define SHAPE_H

#include <string>

class Shape {
protected:
    std::string color;

public:
    Shape(const std::string& color) : color(color) {}
    virtual ~Shape() = default;

    virtual double area() const = 0;
    virtual void display() const = 0;

    std::string getColor() const { return color; }
};

class Rectangle : public Shape {
private:
    double width;
    double height;

public:
    Rectangle(const std::string& color, double w, double h)
        : Shape(color), width(w), height(h) {}

    double area() const override {
        return width * height;
    }

    void display() const override {
        std::cout << "Rectangle: " << width << "x" << height
                  << ", Color: " << color
                  << ", Area: " << area() << "\n";
    }
};

class Circle : public Shape {
private:
    double radius;
    static constexpr double PI = 3.14159265359;

public:
    Circle(const std::string& color, double r)
        : Shape(color), radius(r) {}

    double area() const override {
        return PI * radius * radius;
    }

    void display() const override {
        std::cout << "Circle: radius=" << radius
                  << ", Color: " << color
                  << ", Area: " << area() << "\n";
    }
};

#endif // SHAPE_H
```

### STL Containers

```cpp
#include <vector>
#include <map>
#include <set>
#include <queue>
#include <stack>
#include <unordered_map>

void demonstrate_containers() {
    // Vector
    std::vector<int> vec = {1, 2, 3, 4, 5};
    vec.push_back(6);

    // Map
    std::map<std::string, int> ages;
    ages["Alice"] = 25;
    ages["Bob"] = 30;

    // Set
    std::set<int> unique_numbers = {1, 2, 2, 3, 3, 4};
    // Contains: {1, 2, 3, 4}

    // Queue
    std::queue<int> q;
    q.push(1);
    q.push(2);
    int front = q.front();
    q.pop();

    // Stack
    std::stack<int> s;
    s.push(1);
    s.push(2);
    int top = s.top();
    s.pop();

    // Unordered map (hash map)
    std::unordered_map<std::string, int> hash_map;
    hash_map["key1"] = 100;
    hash_map["key2"] = 200;
}
```

### Modern C++ Features

```cpp
#include <iostream>
#include <memory>
#include <optional>
#include <variant>
#include <string>

// Smart pointers
void smart_pointers() {
    // Unique pointer
    auto ptr1 = std::make_unique<int>(42);

    // Shared pointer
    auto ptr2 = std::make_shared<std::string>("Hello");
    auto ptr3 = ptr2; // Reference count increases

    // Weak pointer
    std::weak_ptr<std::string> weak = ptr2;
}

// Optional
std::optional<int> divide(int a, int b) {
    if (b == 0) {
        return std::nullopt;
    }
    return a / b;
}

// Variant
std::variant<int, double, std::string> value;

void use_variant() {
    value = 42;
    value = 3.14;
    value = "Hello";

    // Get value
    if (std::holds_alternative<std::string>(value)) {
        std::cout << std::get<std::string>(value) << "\n";
    }
}

// Structured bindings
void structured_bindings() {
    std::map<std::string, int> map = {{"a", 1}, {"b", 2}};

    for (const auto& [key, value] : map) {
        std::cout << key << ": " << value << "\n";
    }
}
```

### Compile and Run

```bash
# Compile with C++17
g++ -std=c++17 -o program main.cpp

# With warnings
g++ -std=c++17 -Wall -Wextra -o program main.cpp

# With optimization
g++ -std=c++17 -O2 -o program main.cpp

# Run
./program

# Or in Vim
<leader>cpp  # Compile
<leader>cpr  # Compile and run
```

## 🔨 Build Systems

### Makefile

```makefile
# Makefile
CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -std=c11
CXXFLAGS = -Wall -Wextra -std=c++17

# C project
program_c: main.o student.o
	$(CC) $(CFLAGS) -o program_c main.o student.o

main.o: main.c student.h
	$(CC) $(CFLAGS) -c main.c

student.o: student.c student.h
	$(CC) $(CFLAGS) -c student.c

# C++ project
program_cpp: main.cpp
	$(CXX) $(CXXFLAGS) -o program_cpp main.cpp

# Clean
clean:
	rm -f *.o program_c program_cpp

.PHONY: clean
```

Run make:

```bash
make
make clean

# Or in Vim
<leader>cm
```

### CMake

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project(MyProject)

# C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Executable
add_executable(program main.cpp)

# Library
add_library(mylib STATIC student.cpp)
target_link_libraries(program mylib)

# Include directories
target_include_directories(program PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
```

Build with CMake:

```bash
mkdir build && cd build
cmake ..
make

# Generate compile_commands.json for LSP
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
ln -s build/compile_commands.json ../
```

### compile_commands.json

For clangd LSP support:

```json
[
  {
    "directory": "/path/to/project",
    "command": "g++ -std=c++17 -c main.cpp",
    "file": "main.cpp"
  }
]
```

Generate automatically with CMake or use:

```bash
bear -- make
```

## 🐛 Debugging

### GDB Basics

```bash
# Compile with debug symbols
gcc -g -o program main.c

# Start GDB
gdb program

# Or in Vim
<leader>cd
```

### GDB Commands

| Command                  | Description        |
| ------------------------ | ------------------ |
| `run` or `r`             | Start program      |
| `break main` or `b main` | Set breakpoint     |
| `next` or `n`            | Next line          |
| `step` or `s`            | Step into function |
| `continue` or `c`        | Continue execution |
| `print var` or `p var`   | Print variable     |
| `backtrace` or `bt`      | Show call stack    |
| `quit` or `q`            | Exit GDB           |

### Debugging Example

```c
// buggy.c
#include <stdio.h>

int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

int main() {
    int num = 5;
    int result = factorial(num);
    printf("Factorial of %d is %d\n", num, result);
    return 0;
}
```

Debug session:

```bash
gcc -g -o buggy buggy.c
gdb buggy

(gdb) break main
(gdb) run
(gdb) next
(gdb) print num
(gdb) step  # Step into factorial
(gdb) print n
(gdb) continue
```

### Valgrind (Memory Checker)

```bash
# Check for memory leaks
valgrind --leak-check=full ./program

# Check for memory errors
valgrind --track-origins=yes ./program
```

## 💾 Memory Management

### C Memory Management

```c
#include <stdlib.h>
#include <string.h>

void memory_example() {
    // Allocate memory
    int *arr = (int *)malloc(10 * sizeof(int));
    if (arr == NULL) {
        // Handle error
        return;
    }

    // Use memory
    for (int i = 0; i < 10; i++) {
        arr[i] = i;
    }

    // Reallocate
    arr = (int *)realloc(arr, 20 * sizeof(int));
    if (arr == NULL) {
        // Handle error
        return;
    }

    // Free memory
    free(arr);
    arr = NULL; // Good practice
}

// String allocation
char* create_string(const char *src) {
    char *dest = (char *)malloc(strlen(src) + 1);
    if (dest == NULL) {
        return NULL;
    }
    strcpy(dest, src);
    return dest;
}
```

### C++ Smart Pointers

```cpp
#include <memory>

void smart_pointer_example() {
    // Unique pointer (exclusive ownership)
    std::unique_ptr<int> ptr1 = std::make_unique<int>(42);
    // ptr1 owns the memory

    // Transfer ownership
    std::unique_ptr<int> ptr2 = std::move(ptr1);
    // Now ptr2 owns, ptr1 is nullptr

    // Shared pointer (shared ownership)
    std::shared_ptr<int> ptr3 = std::make_shared<int>(100);
    std::shared_ptr<int> ptr4 = ptr3; // Both own

    // Weak pointer (non-owning reference)
    std::weak_ptr<int> weak = ptr3;

    // Check if still valid
    if (auto locked = weak.lock()) {
        // Use locked
    }

    // Automatic cleanup when scope ends
}
```

### Memory Leaks

```c
// BAD: Memory leak
void memory_leak() {
    int *ptr = (int *)malloc(sizeof(int));
    *ptr = 42;
    // Forgot to free!
}

// GOOD: Proper cleanup
void no_leak() {
    int *ptr = (int *)malloc(sizeof(int));
    if (ptr == NULL) return;

    *ptr = 42;
    // Use ptr

    free(ptr);
    ptr = NULL;
}
```

## 🔄 Common Workflows

### Project Setup

```bash
# Create project structure
mkdir -p myproject/{src,include,build,tests}
cd myproject

# Create files
vim src/main.cpp
vim include/mylib.h
vim CMakeLists.txt

# Initialize git
git init
echo "build/" >> .gitignore
echo "*.o" >> .gitignore
```

### Development Workflow

```bash
# 1. Edit code
vim src/main.cpp

# 2. Format code
<leader>fmt

# 3. Compile
<leader>cpp

# 4. Run
<leader>cpr

# 5. Debug if needed
<leader>cd
```

### Testing Workflow

```cpp
// test.cpp
#include <cassert>
#include "mylib.h"

void test_add() {
    assert(add(2, 3) == 5);
    assert(add(0, 0) == 0);
    assert(add(-1, 1) == 0);
}

int main() {
    test_add();
    std::cout << "All tests passed!\n";
    return 0;
}
```

## 🎯 Best Practices

### Code Organization

```
myproject/
├── src/
│   ├── main.cpp
│   └── mylib.cpp
├── include/
│   └── mylib.h
├── tests/
│   └── test_mylib.cpp
├── build/
├── CMakeLists.txt
└── README.md
```

### Header Guards

```cpp
// mylib.h
#ifndef MYLIB_H
#define MYLIB_H

// Declarations

#endif // MYLIB_H

// Or use #pragma once (modern)
#pragma once

// Declarations
```

### Naming Conventions

```cpp
// Classes: PascalCase
class MyClass {};

// Functions: camelCase or snake_case
void myFunction();
void my_function();

// Constants: UPPER_CASE
const int MAX_SIZE = 100;

// Variables: camelCase or snake_case
int myVariable;
int my_variable;
```

### const Correctness

```cpp
// Use const for read-only parameters
void print(const std::string& str);

// Use const member functions
class MyClass {
    int getValue() const { return value; }
private:
    int value;
};

// Use const pointers
const int* ptr;  // Pointer to const int
int* const ptr;  // Const pointer to int
const int* const ptr;  // Const pointer to const int
```

## 📚 Resources

- C Reference: https://en.cppreference.com/w/c
- C++ Reference: https://en.cppreference.com/w/
- Modern C++: https://isocpp.org/
- GDB Manual: https://sourceware.org/gdb/current/onlinedocs/gdb/
- CMake: https://cmake.org/documentation/

---

[← Back to Languages](../README.md#language-support) | [Go Guide →](go.md)
