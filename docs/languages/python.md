# Python Development Guide

Complete guide for Python development with Django, Flask, and data science tools.

## 📚 Table of Contents

- [Setup](#-setup)
- [Python Basics](#-python-basics)
- [Django Development](#-django-development)
- [Flask Development](#-flask-development)
- [Data Science](#-data-science)
- [Testing](#-testing)
- [Common Workflows](#-common-workflows)
- [Best Practices](#-best-practices)

## 🚀 Setup

### Prerequisites

```bash
# Install Python
pkg install python  # Termux
sudo pacman -S python python-pip  # Arch
sudo apt install python3 python3-pip  # Ubuntu

# Verify installation
python --version
pip --version
```

### Development Tools

```bash
# Formatters and linters
pip install black flake8 autopep8 pylint isort

# Type checking
pip install mypy

# Testing
pip install pytest pytest-cov

# Virtual environment
pip install virtualenv
```

### Coc Extension

```vim
:CocInstall coc-pyright
```

### Virtual Environment Setup

```bash
# Create virtual environment
python -m venv venv

# Activate
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows/Termux

# Install packages
pip install -r requirements.txt

# Deactivate
deactivate
```

## 🐍 Python Basics

### Features

- IntelliSense completion
- Type checking
- Docstring hints
- Import organization
- Refactoring tools

### Key Mappings

| Shortcut     | Action             |
| ------------ | ------------------ |
| `<leader>py` | Run Python script  |
| `<leader>pf` | Format with Black  |
| `<leader>pl` | Lint with flake8   |
| `<leader>pt` | Run pytest         |
| `<leader>pi` | Python REPL        |
| `gd`         | Go to definition   |
| `gr`         | Find references    |
| `<leader>rn` | Rename symbol      |
| `K`          | Show documentation |

### Basic Script Example

```python
# main.py
from typing import List, Optional

def greet(name: str, age: Optional[int] = None) -> str:
    """
    Greet a person by name and optionally show their age.

    Args:
        name: The person's name
        age: The person's age (optional)

    Returns:
        A greeting string
    """
    greeting = f"Hello, {name}!"
    if age is not None:
        greeting += f" You are {age} years old."
    return greeting

def main() -> None:
    """Main entry point."""
    print(greet("Alice", 30))
    print(greet("Bob"))

if __name__ == "__main__":
    main()
```

### Type Hints

```python
from typing import List, Dict, Tuple, Optional, Union

# Basic types
def add(a: int, b: int) -> int:
    return a + b

# Collections
def process_items(items: List[str]) -> Dict[str, int]:
    return {item: len(item) for item in items}

# Optional
def find_user(user_id: int) -> Optional[Dict[str, str]]:
    users = {1: {"name": "Alice"}, 2: {"name": "Bob"}}
    return users.get(user_id)

# Union
def handle_input(value: Union[int, str]) -> str:
    return str(value)

# Tuples
def get_coordinates() -> Tuple[float, float]:
    return (10.5, 20.3)
```

### Classes

```python
from dataclasses import dataclass
from typing import ClassVar

@dataclass
class User:
    """User model with dataclass."""
    id: int
    name: str
    email: str
    is_active: bool = True

    # Class variable
    total_users: ClassVar[int] = 0

    def __post_init__(self):
        User.total_users += 1

    def deactivate(self) -> None:
        """Deactivate the user."""
        self.is_active = False

    @classmethod
    def create(cls, name: str, email: str) -> 'User':
        """Factory method to create user."""
        user_id = cls.total_users + 1
        return cls(id=user_id, name=name, email=email)

# Usage
user = User.create("Alice", "alice@example.com")
print(user.name)  # Auto-completion works
user.deactivate()
```

### Async/Await

```python
import asyncio
from typing import List

async def fetch_data(url: str) -> dict:
    """Simulate fetching data."""
    await asyncio.sleep(1)  # Simulate delay
    return {"url": url, "data": "response"}

async def fetch_all(urls: List[str]) -> List[dict]:
    """Fetch all URLs concurrently."""
    tasks = [fetch_data(url) for url in urls]
    return await asyncio.gather(*tasks)

async def main() -> None:
    urls = ["url1", "url2", "url3"]
    results = await fetch_all(urls)
    for result in results:
        print(result)

if __name__ == "__main__":
    asyncio.run(main())
```

## 🌐 Django Development

### Setup

```bash
# Install Django
pip install django djangorestframework

# Create project
django-admin startproject myproject
cd myproject

# Create app
python manage.py startapp myapp

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Run server
python manage.py runserver
```

### Key Mappings

| Shortcut     | Action                        |
| ------------ | ----------------------------- |
| `<leader>la` | Run Django management command |
| `<leader>ls` | Start Django server           |
| `<leader>lm` | Run migrations                |
| `<leader>lt` | Run tests                     |

### Models

```python
# myapp/models.py
from django.db import models
from django.contrib.auth.models import User

class Category(models.Model):
    """Product category model."""
    name = models.CharField(max_length=100, unique=True)
    slug = models.SlugField(unique=True)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name_plural = "categories"
        ordering = ['name']

    def __str__(self) -> str:
        return self.name

class Product(models.Model):
    """Product model."""
    name = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    category = models.ForeignKey(
        Category,
        on_delete=models.CASCADE,
        related_name='products'
    )
    stock = models.IntegerField(default=0)
    is_available = models.BooleanField(default=True)
    created_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self) -> str:
        return self.name

    @property
    def is_in_stock(self) -> bool:
        return self.stock > 0
```

### Views

```python
# myapp/views.py
from django.shortcuts import render, get_object_or_404
from django.http import JsonResponse
from django.views.generic import ListView, DetailView
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Product, Category
from .serializers import ProductSerializer

class ProductListView(ListView):
    """List all products."""
    model = Product
    template_name = 'products/list.html'
    context_object_name = 'products'
    paginate_by = 20

    def get_queryset(self):
        queryset = super().get_queryset()
        category_slug = self.kwargs.get('category_slug')
        if category_slug:
            queryset = queryset.filter(category__slug=category_slug)
        return queryset.filter(is_available=True)

class ProductDetailView(DetailView):
    """Product detail page."""
    model = Product
    template_name = 'products/detail.html'
    context_object_name = 'product'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['related_products'] = Product.objects.filter(
            category=self.object.category
        ).exclude(id=self.object.id)[:4]
        return context

@api_view(['GET', 'POST'])
def product_api(request):
    """Product API endpoint."""
    if request.method == 'GET':
        products = Product.objects.all()
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = ProductSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)
```

## 🌶️ Flask Development

### Setup

```bash
# Install Flask
pip install flask flask-sqlalchemy flask-migrate

# Create app
mkdir myapp && cd myapp
touch app.py
```

### Basic Flask App

```python
# app.py
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app.db'
db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'created_at': self.created_at.isoformat()
        }

@app.route('/')
def index():
    return jsonify({'message': 'Hello World'})

@app.route('/api/users', methods=['GET', 'POST'])
def users():
    if request.method == 'GET':
        users = User.query.all()
        return jsonify([user.to_dict() for user in users])

    data = request.get_json()
    user = User(username=data['username'], email=data['email'])
    db.session.add(user)
    db.session.commit()
    return jsonify(user.to_dict()), 201

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
```

## 📊 Data Science

### NumPy

```python
import numpy as np

# Create arrays
arr = np.array([1, 2, 3, 4, 5])
matrix = np.array([[1, 2], [3, 4]])

# Operations
mean = np.mean(arr)
std = np.std(arr)

# Matrix operations
transpose = matrix.T
dot_product = np.dot(matrix, matrix.T)
```

### Pandas

```python
import pandas as pd

# Create DataFrame
df = pd.DataFrame({
    'name': ['Alice', 'Bob', 'Charlie'],
    'age': [25, 30, 35],
    'city': ['NY', 'LA', 'SF']
})

# Read CSV
df = pd.read_csv('data.csv')

# Operations
print(df.head())
young_users = df[df['age'] < 30]
grouped = df.groupby('city')['age'].mean()
```

## 🧪 Testing

### Pytest

```python
# test_calculator.py
import pytest

def add(a, b):
    return a + b

def test_add():
    assert add(2, 3) == 5

@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5),
    (0, 0, 0),
    (-1, 1, 0),
])
def test_add_parametrized(a, b, expected):
    assert add(a, b) == expected
```

Run tests:

```bash
pytest
pytest -v
pytest --cov=myapp
```

## 🔄 Common Workflows

### Project Setup

```bash
# Create project
mkdir my-project && cd my-project
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
vim .
```

### Development

```bash
# Open in Vim
vim src/main.py

# Format code
<leader>pf

# Run script
<leader>py

# Run tests
<leader>pt
```

## 🎯 Best Practices

### Code Organization

```
my-project/
├── src/
│   ├── __init__.py
│   ├── main.py
│   └── models/
├── tests/
│   └── test_main.py
├── requirements.txt
└── README.md
```

### Type Hints

```python
def process_data(data: List[str]) -> Dict[str, int]:
    return {item: len(item) for item in data}
```

### Documentation

```python
def function(param: str) -> int:
    """
    Brief description.

    Args:
        param: Description

    Returns:
        Description of return value
    """
    return len(param)
```

## 📚 Resources

- Python: https://docs.python.org/3/
- Django: https://docs.djangoproject.com/
- Flask: https://flask.palletsprojects.com/
- Pytest: https://docs.pytest.org/

---

[← Back to Languages](../README.md#language-support) | [C/C++ Guide →](c-cpp.md)
