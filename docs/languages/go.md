# Go Development Guide

Complete guide for Go (Golang) development with modern practices.

## 📚 Table of Contents

- [Setup](#-setup)
- [Go Basics](#-go-basics)
- [Web Development](#-web-development)
- [Testing](#-testing)
- [Concurrency](#-concurrency)
- [Common Workflows](#-common-workflows)
- [Best Practices](#-best-practices)

## 🚀 Setup

### Prerequisites

```bash
# Install Go
# Termux
pkg install golang

# Arch Linux
sudo pacman -S go

# Ubuntu/Debian
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verify installation
go version
```

### Environment Setup

```bash
# Set GOPATH (if not set)
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

# Verify
go env GOPATH
go env GOROOT
```

### Development Tools

```bash
# Install gopls (Language Server)
go install golang.org/x/tools/gopls@latest

# Install goimports
go install golang.org/x/tools/cmd/goimports@latest

# Install golangci-lint
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Install delve (debugger)
go install github.com/go-delve/delve/cmd/dlv@latest
```

### Coc Extension

```vim
:CocInstall coc-go
```

## 📝 Go Basics

### Features

- Auto-completion
- Go to definition
- Find references
- Auto-formatting
- Import management
- Error detection

### Key Mappings

| Shortcut     | Action             |
| ------------ | ------------------ |
| `<leader>gb` | Go build           |
| `<leader>gr` | Go run             |
| `<leader>gt` | Go test            |
| `<leader>gf` | Format with gofmt  |
| `<leader>gi` | Fix imports        |
| `gd`         | Go to definition   |
| `gr`         | Find references    |
| `<leader>rn` | Rename symbol      |
| `K`          | Show documentation |

### Hello World

```go
// main.go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

Run:

```bash
go run main.go

# Or in Vim
<leader>gr
```

### Variables and Types

```go
package main

import "fmt"

func main() {
    // Variable declaration
    var name string = "Alice"
    var age int = 25

    // Short declaration
    city := "New York"

    // Multiple variables
    var (
        firstName string = "John"
        lastName  string = "Doe"
        height    float64 = 1.75
    )

    // Constants
    const PI = 3.14159
    const (
        StatusOK = 200
        StatusNotFound = 404
    )

    // Basic types
    var (
        b bool = true
        i int = 42
        f float64 = 3.14
        s string = "Hello"
        r rune = 'A'  // Unicode code point
        by byte = 255  // alias for uint8
    )

    fmt.Println(name, age, city)
}
```

### Functions

```go
package main

import "fmt"

// Basic function
func add(a, b int) int {
    return a + b
}

// Multiple return values
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, fmt.Errorf("division by zero")
    }
    return a / b, nil
}

// Named return values
func getUserInfo() (name string, age int) {
    name = "Alice"
    age = 25
    return // naked return
}

// Variadic function
func sum(numbers ...int) int {
    total := 0
    for _, num := range numbers {
        total += num
    }
    return total
}

// Function as parameter
func apply(f func(int, int) int, a, b int) int {
    return f(a, b)
}

func main() {
    result := add(10, 20)
    fmt.Println(result)

    quotient, err := divide(10, 2)
    if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Println(quotient)
    }

    name, age := getUserInfo()
    fmt.Println(name, age)

    total := sum(1, 2, 3, 4, 5)
    fmt.Println(total)

    // Anonymous function
    multiply := func(a, b int) int {
        return a * b
    }
    fmt.Println(multiply(5, 6))
}
```

### Structs

```go
package main

import "fmt"

// Define struct
type Person struct {
    Name string
    Age  int
    Email string
}

// Method
func (p Person) Introduce() {
    fmt.Printf("Hi, I'm %s and I'm %d years old\n", p.Name, p.Age)
}

// Pointer receiver (can modify)
func (p *Person) HaveBirthday() {
    p.Age++
}

// Constructor pattern
func NewPerson(name string, age int, email string) *Person {
    return &Person{
        Name:  name,
        Age:   age,
        Email: email,
    }
}

// Embedded struct
type Employee struct {
    Person  // Embedding
    Company string
    Salary  float64
}

func main() {
    // Create struct
    person1 := Person{
        Name:  "Alice",
        Age:   25,
        Email: "alice@example.com",
    }

    // Short form
    person2 := Person{"Bob", 30, "bob@example.com"}

    // Using constructor
    person3 := NewPerson("Charlie", 35, "charlie@example.com")

    // Call methods
    person1.Introduce()
    person1.HaveBirthday()
    fmt.Println("New age:", person1.Age)

    // Embedded struct
    emp := Employee{
        Person:  Person{"David", 28, "david@example.com"},
        Company: "Tech Corp",
        Salary:  75000,
    }
    emp.Introduce() // Can call Person methods
    fmt.Println("Works at:", emp.Company)
}
```

### Interfaces

```go
package main

import (
    "fmt"
    "math"
)

// Define interface
type Shape interface {
    Area() float64
    Perimeter() float64
}

// Rectangle implements Shape
type Rectangle struct {
    Width, Height float64
}

func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

func (r Rectangle) Perimeter() float64 {
    return 2 * (r.Width + r.Height)
}

// Circle implements Shape
type Circle struct {
    Radius float64
}

func (c Circle) Area() float64 {
    return math.Pi * c.Radius * c.Radius
}

func (c Circle) Perimeter() float64 {
    return 2 * math.Pi * c.Radius
}

// Function using interface
func printShapeInfo(s Shape) {
    fmt.Printf("Area: %.2f\n", s.Area())
    fmt.Printf("Perimeter: %.2f\n", s.Perimeter())
}

func main() {
    rect := Rectangle{Width: 10, Height: 5}
    circle := Circle{Radius: 7}

    printShapeInfo(rect)
    printShapeInfo(circle)
}
```

### Arrays and Slices

```go
package main

import "fmt"

func main() {
    // Array (fixed size)
    var arr [5]int
    arr[0] = 1
    arr[1] = 2

    arr2 := [5]int{1, 2, 3, 4, 5}

    // Slice (dynamic size)
    slice1 := []int{1, 2, 3, 4, 5}

    // Make slice
    slice2 := make([]int, 5)     // length 5
    slice3 := make([]int, 5, 10) // length 5, capacity 10

    // Append
    slice1 = append(slice1, 6, 7, 8)

    // Slicing
    sub := slice1[1:4] // Elements 1, 2, 3

    // Copy
    dest := make([]int, len(slice1))
    copy(dest, slice1)

    // Iterate
    for i, v := range slice1 {
        fmt.Printf("Index: %d, Value: %d\n", i, v)
    }

    // Iterate values only
    for _, v := range slice1 {
        fmt.Println(v)
    }
}
```

### Maps

```go
package main

import "fmt"

func main() {
    // Create map
    ages := make(map[string]int)
    ages["Alice"] = 25
    ages["Bob"] = 30

    // Map literal
    scores := map[string]int{
        "Alice":   95,
        "Bob":     87,
        "Charlie": 92,
    }

    // Access
    age := ages["Alice"]
    fmt.Println(age)

    // Check if key exists
    score, exists := scores["David"]
    if exists {
        fmt.Println(score)
    } else {
        fmt.Println("Not found")
    }

    // Delete
    delete(ages, "Bob")

    // Iterate
    for name, score := range scores {
        fmt.Printf("%s: %d\n", name, score)
    }
}
```

## 🌐 Web Development

### HTTP Server

```go
// main.go
package main

import (
    "encoding/json"
    "fmt"
    "log"
    "net/http"
)

type User struct {
    ID    int    `json:"id"`
    Name  string `json:"name"`
    Email string `json:"email"`
}

var users = []User{
    {ID: 1, Name: "Alice", Email: "alice@example.com"},
    {ID: 2, Name: "Bob", Email: "bob@example.com"},
}

func main() {
    http.HandleFunc("/", homeHandler)
    http.HandleFunc("/users", usersHandler)
    http.HandleFunc("/user/", userHandler)

    fmt.Println("Server starting on :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

func homeHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Welcome to Go API")
}

func usersHandler(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")

    switch r.Method {
    case "GET":
        json.NewEncoder(w).Encode(users)
    case "POST":
        var user User
        if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
            http.Error(w, err.Error(), http.StatusBadRequest)
            return
        }
        user.ID = len(users) + 1
        users = append(users, user)
        w.WriteStatus(http.StatusCreated)
        json.NewEncoder(w).Encode(user)
    default:
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
    }
}

func userHandler(w http.ResponseWriter, r *http.Request) {
    // Implementation for specific user
}
```

### Gin Framework

```go
package main

import (
    "net/http"
    "github.com/gin-gonic/gin"
)

type User struct {
    ID    int    `json:"id"`
    Name  string `json:"name"`
    Email string `json:"email"`
}

var users = []User{
    {ID: 1, Name: "Alice", Email: "alice@example.com"},
    {ID: 2, Name: "Bob", Email: "bob@example.com"},
}

func main() {
    router := gin.Default()

    // Routes
    router.GET("/", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "message": "Welcome to Go API",
        })
    })

    router.GET("/users", getUsers)
    router.POST("/users", createUser)
    router.GET("/users/:id", getUser)
    router.PUT("/users/:id", updateUser)
    router.DELETE("/users/:id", deleteUser)

    router.Run(":8080")
}

func getUsers(c *gin.Context) {
    c.JSON(http.StatusOK, users)
}

func createUser(c *gin.Context) {
    var user User
    if err := c.ShouldBindJSON(&user); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    user.ID = len(users) + 1
    users = append(users, user)
    c.JSON(http.StatusCreated, user)
}

func getUser(c *gin.Context) {
    id := c.Param("id")
    // Find user by ID
    c.JSON(http.StatusOK, gin.H{"id": id})
}

func updateUser(c *gin.Context) {
    // Update implementation
}

func deleteUser(c *gin.Context) {
    // Delete implementation
}
```

Install Gin:

```bash
go get -u github.com/gin-gonic/gin
```

## 🧪 Testing

### Basic Tests

```go
// math.go
package math

func Add(a, b int) int {
    return a + b
}

func Multiply(a, b int) int {
    return a * b
}
```

```go
// math_test.go
package math

import "testing"

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    expected := 5

    if result != expected {
        t.Errorf("Add(2, 3) = %d; want %d", result, expected)
    }
}

func TestMultiply(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive", 2, 3, 6},
        {"zero", 0, 5, 0},
        {"negative", -2, 3, -6},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Multiply(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Multiply(%d, %d) = %d; want %d",
                    tt.a, tt.b, result, tt.expected)
            }
        })
    }
}
```

Run tests:

```bash
go test
go test -v
go test -cover

# Or in Vim
<leader>gt
```

### Table-Driven Tests

```go
func TestDivide(t *testing.T) {
    tests := []struct {
        name        string
        a, b        float64
        expected    float64
        expectError bool
    }{
        {"normal", 10, 2, 5, false},
        {"zero divisor", 10, 0, 0, true},
        {"negative", -10, 2, -5, false},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result, err := Divide(tt.a, tt.b)

            if tt.expectError {
                if err == nil {
                    t.Error("Expected error, got nil")
                }
                return
            }

            if err != nil {
                t.Errorf("Unexpected error: %v", err)
            }

            if result != tt.expected {
                t.Errorf("Divide(%v, %v) = %v; want %v",
                    tt.a, tt.b, result, tt.expected)
            }
        })
    }
}
```

## ⚡ Concurrency

### Goroutines

```go
package main

import (
    "fmt"
    "time"
)

func sayHello(name string) {
    for i := 0; i < 5; i++ {
        time.Sleep(100 * time.Millisecond)
        fmt.Printf("Hello %s\n", name)
    }
}

func main() {
    // Start goroutine
    go sayHello("Alice")
    go sayHello("Bob")

    // Wait for goroutines
    time.Sleep(time.Second)
    fmt.Println("Done")
}
```

### Channels

```go
package main

import "fmt"

func sum(numbers []int, c chan int) {
    total := 0
    for _, num := range numbers {
        total += num
    }
    c <- total // Send to channel
}

func main() {
    numbers := []int{1, 2, 3, 4, 5, 6}

    c := make(chan int)

    go sum(numbers[:len(numbers)/2], c)
    go sum(numbers[len(numbers)/2:], c)

    x, y := <-c, <-c // Receive from channel

    fmt.Println("Total:", x+y)
}
```

### Select Statement

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    c1 := make(chan string)
    c2 := make(chan string)

    go func() {
        time.Sleep(1 * time.Second)
        c1 <- "one"
    }()

    go func() {
        time.Sleep(2 * time.Second)
        c2 <- "two"
    }()

    for i := 0; i < 2; i++ {
        select {
        case msg1 := <-c1:
            fmt.Println("Received", msg1)
        case msg2 := <-c2:
            fmt.Println("Received", msg2)
        }
    }
}
```

### WaitGroup

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

func worker(id int, wg *sync.WaitGroup) {
    defer wg.Done()

    fmt.Printf("Worker %d starting\n", id)
    time.Sleep(time.Second)
    fmt.Printf("Worker %d done\n", id)
}

func main() {
    var wg sync.WaitGroup

    for i := 1; i <= 5; i++ {
        wg.Add(1)
        go worker(i, &wg)
    }

    wg.Wait()
    fmt.Println("All workers done")
}
```

## 🔄 Common Workflows

### Project Setup

```bash
# Create module
mkdir myproject && cd myproject
go mod init github.com/username/myproject

# Create main file
vim main.go

# Initialize git
git init
echo "# My Project" > README.md
```

### Development Workflow

```bash
# 1. Edit code
vim main.go

# 2. Format code (automatic on save)
<leader>gf

# 3. Fix imports
<leader>gi

# 4. Build
<leader>gb

# 5. Run
<leader>gr

# 6. Test
<leader>gt
```

### Dependency Management

```bash
# Add dependency
go get github.com/gin-gonic/gin

# Update dependencies
go get -u ./...

# Tidy dependencies
go mod tidy

# Vendor dependencies
go mod vendor
```

## 🎯 Best Practices

### Project Structure

```
myproject/
├── cmd/
│   └── myapp/
│       └── main.go
├── internal/
│   ├── handlers/
│   └── models/
├── pkg/
│   └── utils/
├── go.mod
├── go.sum
└── README.md
```

### Error Handling

```go
// Always check errors
file, err := os.Open("file.txt")
if err != nil {
    return fmt.Errorf("failed to open file: %w", err)
}
defer file.Close()

// Custom errors
type MyError struct {
    Code    int
    Message string
}

func (e *MyError) Error() string {
    return fmt.Sprintf("Code %d: %s", e.Code, e.Message)
}
```

### Naming Conventions

```go
// Exported (public): Start with uppercase
func PublicFunction() {}
type PublicStruct struct{}

// Unexported (private): Start with lowercase
func privateFunction() {}
type privateStruct struct{}

// Constants: CamelCase or UPPER_CASE
const MaxConnections = 100

// Interfaces: -er suffix
type Reader interface {}
type Writer interface {}
```

## 📚 Resources

- Go Documentation: [doc](https://go.dev/doc/)
- Go by Example: [example](https://gobyexample.com/)
- Effective Go: [effective](https://go.dev/doc/effective_go)
- Go Tour: [touring](https://go.dev/tour/)

---

[← Back to Languages](../README.md#language-support) | [PHP/Laravel Guide →](php-laravel.md)
