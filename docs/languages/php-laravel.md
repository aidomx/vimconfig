# PHP/Laravel Development Guide

Quick guide for PHP and Laravel development.

## 🚀 Setup

### Prerequisites

```bash
# Termux
pkg install php composer

# Arch Linux
sudo pacman -S php composer

# Ubuntu/Debian
sudo apt install php php-cli php-mbstring php-xml composer
```

### Tools

```bash
# Install PHP tools
composer global require phpactor/phpactor
composer global require friendsofphp/php-cs-fixer

# Add to PATH
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Coc Extension

```vim
:CocInstall coc-phpls
```

## 📝 PHP Basics

### Key Mappings

| Shortcut      | Action                  |
| ------------- | ----------------------- |
| `<leader>la`  | Laravel Artisan command |
| `<leader>ls`  | Laravel serve           |
| `<leader>lm`  | Run migrations          |
| `<leader>lt`  | Run tests               |
| `gd`          | Go to definition        |
| `<leader>fmt` | Format code             |

### Basic PHP

```php
<?php
// variables.php

// Variables
$name = "Alice";
$age = 25;
$isActive = true;

// Arrays
$numbers = [1, 2, 3, 4, 5];
$user = [
    'name' => 'Bob',
    'email' => 'bob@example.com'
];

// Functions
function greet($name) {
    return "Hello, $name!";
}

// Classes
class User {
    private $name;
    private $email;

    public function __construct($name, $email) {
        $this->name = $name;
        $this->email = $email;
    }

    public function getName() {
        return $this->name;
    }
}

$user = new User("Alice", "alice@example.com");
echo $user->getName();
```

## 🎨 Laravel Development

### Create Project

```bash
# Install Laravel
composer create-project laravel/laravel myapp
cd myapp

# Run server
php artisan serve

# Or in Vim
<leader>ls
```

### Routes

```php
// routes/web.php
use App\Http\Controllers\UserController;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/users', [UserController::class, 'index']);
Route::post('/users', [UserController::class, 'store']);
Route::get('/users/{id}', [UserController::class, 'show']);
```

### Controllers

```php
// app/Http/Controllers/UserController.php
namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function index()
    {
        $users = User::all();
        return response()->json($users);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|max:255',
            'email' => 'required|email|unique:users',
        ]);

        $user = User::create($validated);
        return response()->json($user, 201);
    }

    public function show($id)
    {
        $user = User::findOrFail($id);
        return response()->json($user);
    }
}
```

### Models

```php
// app/Models/User.php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    protected $fillable = ['name', 'email', 'password'];
    protected $hidden = ['password'];

    // Relationships
    public function posts()
    {
        return $this->hasMany(Post::class);
    }
}
```

### Migrations

```php
// database/migrations/2024_create_posts_table.php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained();
            $table->string('title');
            $table->text('content');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('posts');
    }
};
```

Run migrations:

```bash
php artisan migrate
# Or: <leader>lm
```

### Blade Templates

```blade
{{-- resources/views/users/index.blade.php --}}
@extends('layouts.app')

@section('content')
<div class="container">
    <h1>Users</h1>

    @foreach($users as $user)
        <div class="card">
            <h3>{{ $user->name }}</h3>
            <p>{{ $user->email }}</p>
        </div>
    @endforeach
</div>
@endsection
```

## 🔄 Common Workflows

### Artisan Commands

```bash
# Create controller
php artisan make:controller UserController

# Create model with migration
php artisan make:model Post -m

# Create migration
php artisan make:migration create_posts_table

# Run migrations
php artisan migrate

# Rollback
php artisan migrate:rollback

# Clear cache
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

In Vim, use `<leader>la` to run Artisan commands interactively.

## 📚 Resources

- PHP: [PHP docs](https://www.php.net/docs.php)
- Laravel: [Laravel docs](https://laravel.com/docs)
- Composer: [Composer](https://getcomposer.org/doc/)

---

[← Back to Languages](../README.md#language-support) | [Bash Guide →](bash.md)
