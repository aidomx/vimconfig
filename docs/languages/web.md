# Web Development Guide

Complete guide for JavaScript, TypeScript, HTML, CSS, React, Vue, and Next.js development.

## 📚 Table of Contents

- [Setup](#-setup)
- [JavaScript/TypeScript](#-javascripttypescript)
- [HTML & CSS](#-html--css)
- [React Development](#-react-development)
- [Next.js Development](#-nextjs-development)
- [Vue.js Development](#-vuejs-development)
- [Node.js Backend](#-nodejs-backend)
- [Common Workflows](#-common-workflows)

## 🚀 Setup

### Prerequisites

```bash
# Install Node.js and npm
pkg install nodejs  # Termux
sudo pacman -S nodejs npm  # Arch
sudo apt install nodejs npm  # Ubuntu

# Verify installation
node --version
npm --version
```

### Global Packages

```bash
# Essential tools
npm install -g typescript prettier eslint

# Framework CLIs
npm install -g create-react-app @vue/cli

# Development servers
npm install -g serve http-server
```

### Coc Extensions

```vim
:CocInstall coc-tsserver coc-json coc-html coc-css coc-prettier
:CocInstall coc-eslint coc-stylelintplus
```

### Project Initialization

```bash
# TypeScript project
npm init -y
npm install --save-dev typescript @types/node
npx tsc --init

# React project
npx create-react-app my-app
cd my-app

# Next.js project
npx create-next-app my-next-app
cd my-next-app

# Vue project
npm create vue@latest my-vue-app
cd my-vue-app
```

## 📝 JavaScript/TypeScript

### Features

- IntelliSense completion
- Auto-imports
- Type checking (TypeScript)
- Refactoring
- Go to definition
- Find references

### Key Mappings

| Shortcut      | Action                |
| ------------- | --------------------- |
| `gd`          | Go to definition      |
| `gy`          | Go to type definition |
| `gi`          | Go to implementation  |
| `gr`          | Find references       |
| `<leader>rn`  | Rename symbol         |
| `<leader>fmt` | Format with Prettier  |
| `<leader>es`  | ESLint fix            |
| `K`           | Show documentation    |

### JavaScript Example

```javascript
// main.js
const greeting = (name) => {
  return `Hello, ${name}!`
}

// Auto-completion works
console.log(greeting('World'))

// Press gd on 'greeting' to jump to definition
// Press K on 'console.log' to see documentation
```

### TypeScript Example

```typescript
// main.ts
interface User {
  name: string
  age: number
}

function greetUser(user: User): string {
  return `Hello, ${user.name}! You are ${user.age} years old.`
}

const user: User = {
  name: 'John',
  age: 30,
}

// Full type checking and completion
console.log(greetUser(user))
```

### Configuration

**tsconfig.json:**

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

**.prettierrc:**

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80
}
```

**.eslintrc.json:**

```json
{
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "extends": ["eslint:recommended", "plugin:@typescript-eslint/recommended"],
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "rules": {
    "semi": ["error", "always"],
    "quotes": ["error", "single"]
  }
}
```

### Workflow

```bash
# 1. Create TypeScript file
vim src/index.ts

# 2. Write code with auto-completion
# Press <Tab> for suggestions

# 3. Format code
# Press <leader>fmt

# 4. Fix linting errors
# Press <leader>es

# 5. Compile TypeScript
tsc

# 6. Run JavaScript
node dist/index.js
```

## 🎨 HTML & CSS

### Features

- Tag completion
- Emmet abbreviations
- CSS property completion
- Color preview
- Selector completion

### Key Mappings

| Shortcut      | Action                     |
| ------------- | -------------------------- |
| `<C-y>,`      | Expand Emmet abbreviation  |
| `<leader>fmt` | Format HTML/CSS            |
| `gd`          | Go to CSS class definition |

### HTML Example

```html
<!-- index.html -->
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Page</title>
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body>
    <div class="container">
      <h1>Hello World</h1>
      <p class="description">Welcome to my website</p>
    </div>
    <script src="script.js"></script>
  </body>
</html>
```

### CSS Example

```css
/* styles.css */
:root {
  --primary-color: #3498db;
  --secondary-color: #2ecc71;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.description {
  color: var(--primary-color);
  font-size: 16px;
  line-height: 1.5;
}

/* Auto-completion for properties */
.button {
  background-color: var(--primary-color);
  padding: 10px 20px;
  border-radius: 5px;
  transition: all 0.3s ease;
}

.button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}
```

### Emmet Usage

Type abbreviation and press `<C-y>,`:

```
div.container>h1{Hello}+p.description{Welcome}

Expands to:
<div class="container">
    <h1>Hello</h1>
    <p class="description">Welcome</p>
</div>
```

More examples:

```
ul>li*3>a                    → Creates ul with 3 li elements with a tags
header+main+footer           → Creates header, main, footer
.container>.row>.col*3       → Creates nested divs with classes
```

## ⚛️ React Development

### Features

- JSX/TSX syntax highlighting
- Component completion
- Props intellisense
- Import auto-completion
- Hooks support

### Key Mappings

| Shortcut      | Action                     |
| ------------- | -------------------------- |
| `<leader>nr`  | Start React dev server     |
| `<leader>fmt` | Format with Prettier       |
| `gd`          | Go to component definition |

### React Component Example

```typescript
// App.tsx
import React, { useState, useEffect } from 'react';
import './App.css';

interface Props {
    title: string;
    initialCount?: number;
}

const Counter: React.FC<Props> = ({ title, initialCount = 0 }) => {
    const [count, setCount] = useState(initialCount);

    useEffect(() => {
        document.title = `Count: ${count}`;
    }, [count]);

    const increment = () => setCount(count + 1);
    const decrement = () => setCount(count - 1);

    return (
        <div className="counter">
            <h1>{title}</h1>
            <p>Count: {count}</p>
            <button onClick={increment}>+</button>
            <button onClick={decrement}>-</button>
        </div>
    );
};

export default Counter;
```

### Custom Hooks

```typescript
// useLocalStorage.ts
import { useState, useEffect } from 'react'

function useLocalStorage<T>(key: string, initialValue: T) {
  const [value, setValue] = useState<T>(() => {
    const item = window.localStorage.getItem(key)
    return item ? JSON.parse(item) : initialValue
  })

  useEffect(() => {
    window.localStorage.setItem(key, JSON.stringify(value))
  }, [key, value])

  return [value, setValue] as const
}

export default useLocalStorage
```

### Workflow

```bash
# 1. Create component file
vim src/components/Counter.tsx

# 2. Type 'rfc' and use snippet (if configured)
# Or write component manually

# 3. Auto-import components
# Start typing component name, select from suggestions

# 4. Format on save
# Already configured

# 5. Start dev server
# Press <leader>nr
# Or: npm start
```

## 🚀 Next.js Development

### Features

- App Router support
- Server/Client component detection
- API route completion
- Dynamic route support

### Key Mappings

| Shortcut     | Action                   |
| ------------ | ------------------------ |
| `<leader>nd` | Start Next.js dev server |
| `<leader>nb` | Build Next.js project    |
| `<leader>ns` | Start production server  |

### Page Component

```typescript
// app/page.tsx
import { Metadata } from 'next';

export const metadata: Metadata = {
    title: 'Home Page',
    description: 'Welcome to my Next.js app',
};

export default function HomePage() {
    return (
        <main className="container">
            <h1>Welcome to Next.js</h1>
            <p>This is a server component by default</p>
        </main>
    );
}
```

### Client Component

```typescript
// app/components/Counter.tsx
'use client';

import { useState } from 'react';

export default function Counter() {
    const [count, setCount] = useState(0);

    return (
        <div>
            <p>Count: {count}</p>
            <button onClick={() => setCount(count + 1)}>
                Increment
            </button>
        </div>
    );
}
```

### API Route

```typescript
// app/api/users/route.ts
import { NextResponse } from 'next/server'

export async function GET() {
  const users = [
    { id: 1, name: 'John' },
    { id: 2, name: 'Jane' },
  ]

  return NextResponse.json(users)
}

export async function POST(request: Request) {
  const body = await request.json()
  // Process data
  return NextResponse.json({ success: true, data: body })
}
```

### Dynamic Route

```typescript
// app/posts/[id]/page.tsx
interface Props {
    params: {
        id: string;
    };
}

export default function PostPage({ params }: Props) {
    return (
        <div>
            <h1>Post ID: {params.id}</h1>
        </div>
    );
}
```

## 🟢 Vue.js Development

### Features

- Vue 3 Composition API support
- Single File Component (SFC) syntax
- Template completion
- Script setup support

### Vue Component Example

```vue
<!-- Counter.vue -->
<template>
  <div class="counter">
    <h1>{{ title }}</h1>
    <p>Count: {{ count }}</p>
    <button @click="increment">+</button>
    <button @click="decrement">-</button>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

interface Props {
  title: string
  initialCount?: number
}

const props = withDefaults(defineProps<Props>(), {
  initialCount: 0,
})

const count = ref(props.initialCount)

const increment = () => {
  count.value++
}

const decrement = () => {
  count.value--
}

const doubleCount = computed(() => count.value * 2)
</script>

<style scoped>
.counter {
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 8px;
}

button {
  margin: 0 5px;
  padding: 5px 15px;
}
</style>
```

## 🔧 Node.js Backend

### Express Server

```typescript
// server.ts
import express, { Request, Response } from 'express'
import cors from 'cors'

const app = express()
const PORT = process.env.PORT || 3000

// Middleware
app.use(cors())
app.use(express.json())

// Routes
app.get('/', (req: Request, res: Response) => {
  res.json({ message: 'Hello World' })
})

app.get('/api/users', (req: Request, res: Response) => {
  const users = [
    { id: 1, name: 'John' },
    { id: 2, name: 'Jane' },
  ]
  res.json(users)
})

app.post('/api/users', (req: Request, res: Response) => {
  const { name } = req.body
  const newUser = { id: Date.now(), name }
  res.status(201).json(newUser)
})

// Error handling
app.use((err: Error, req: Request, res: Response, next: Function) => {
  console.error(err.stack)
  res.status(500).json({ error: 'Something went wrong!' })
})

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})
```

### API with Database (Prisma)

```typescript
// prisma/schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String?
  posts     Post[]
  createdAt DateTime @default(now())
}

model Post {
  id        Int      @id @default(autoincrement())
  title     String
  content   String?
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id])
  authorId  Int
  createdAt DateTime @default(now())
}
```

```typescript
// routes/users.ts
import { PrismaClient } from '@prisma/client'
import { Router } from 'express'

const router = Router()
const prisma = new PrismaClient()

// Get all users
router.get('/', async (req, res) => {
  const users = await prisma.user.findMany({
    include: { posts: true },
  })
  res.json(users)
})

// Create user
router.post('/', async (req, res) => {
  const { email, name } = req.body
  const user = await prisma.user.create({
    data: { email, name },
  })
  res.status(201).json(user)
})

export default router
```

## 🔄 Common Workflows

### Project Setup Workflow

```bash
# 1. Create project
mkdir my-project && cd my-project
npm init -y

# 2. Install dependencies
npm install express
npm install --save-dev typescript @types/node @types/express

# 3. Initialize TypeScript
npx tsc --init

# 4. Open in Vim
vim src/index.ts

# 5. Start development
npm run dev
```

### Development Workflow

```bash
# 1. Open project
cd my-project
vim .

# 2. Use file explorer
tt  # Toggle NERDTree

# 3. Find files quickly
pp  # Fuzzy file finder

# 4. Search in files
gg  # Live grep

# 5. Navigate code
gd  # Go to definition
gr  # Find references

# 6. Format and save
<leader>fmt
<leader>w
```

### Testing Workflow

```typescript
// sum.test.ts
import { describe, it, expect } from 'vitest'
import { sum } from './sum'

describe('sum', () => {
  it('should add two numbers', () => {
    expect(sum(1, 2)).toBe(3)
  })

  it('should handle negative numbers', () => {
    expect(sum(-1, -2)).toBe(-3)
  })
})
```

Run tests:

```bash
npm test
# Or in Vim
:!npm test
```

### Git Workflow

```bash
# Check status
<leader>gs

# Stage changes
# In fugitive: press 's' on file

# Commit
<leader>gc

# Push
<leader>gp

# View diff
<leader>gd
```

### Build and Deploy

```bash
# Build for production
<leader>nb  # Next.js
# Or: npm run build

# Test production build
npm start

# Deploy (example with Vercel)
npx vercel --prod
```

## 🎨 Snippets

### Common JavaScript Snippets

Configure in `~/.config/coc/ultisnips/javascript.snippets`:

```snippets
snippet imp "Import statement"
import ${1:module} from '${2:package}';
endsnippet

snippet impd "Import destructured"
import { ${1:module} } from '${2:package}';
endsnippet

snippet func "Function"
function ${1:name}(${2:params}) {
    ${3:// body}
}
endsnippet

snippet afunc "Arrow function"
const ${1:name} = (${2:params}) => {
    ${3:// body}
};
endsnippet

snippet cl "Console.log"
console.log(${1:variable});
endsnippet

snippet try "Try-catch"
try {
    ${1:// code}
} catch (error) {
    console.error(error);
}
endsnippet
```

### React Snippets

```snippets
snippet rfc "React Functional Component"
import React from 'react';

interface ${1:ComponentName}Props {
    ${2:prop}: ${3:string};
}

const ${1:ComponentName}: React.FC<${1:ComponentName}Props> = ({ ${2:prop} }) => {
    return (
        <div>
            ${4:// component body}
        </div>
    );
};

export default ${1:ComponentName};
endsnippet

snippet useState "useState hook"
const [${1:state}, set${1/(.*)/${1:/capitalize}/}] = useState(${2:initialValue});
endsnippet

snippet useEffect "useEffect hook"
useEffect(() => {
    ${1:// effect}

    return () => {
        ${2:// cleanup}
    };
}, [${3:dependencies}]);
endsnippet
```

## 🔧 Configuration Tips

### Package.json Scripts

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "test": "vitest",
    "lint": "eslint . --ext .ts,.tsx",
    "format": "prettier --write \"src/**/*.{ts,tsx}\""
  }
}
```

### VS Code Settings (for reference)

If you need to share settings with VS Code users:

```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.preferences.importModuleSpecifier": "relative"
}
```

### Coc Settings for Web Dev

```json
{
  "typescript.preferences.importModuleSpecifier": "relative",
  "typescript.suggest.autoImports": true,
  "typescript.updateImportsOnFileMove.enabled": "always",

  "prettier.requireConfig": true,
  "prettier.onlyUseLocalVersion": true,

  "eslint.autoFixOnSave": true,
  "eslint.filetypes": [
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact"
  ],

  "coc.preferences.formatOnSaveFiletypes": [
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "json",
    "html",
    "css",
    "scss"
  ]
}
```

## 🐛 Debugging

### Node.js Debugging

```javascript
// Add debugger statement
function calculateTotal(items) {
  debugger // Execution will pause here
  return items.reduce((sum, item) => sum + item.price, 0)
}
```

Run with debugger:

```bash
node --inspect-brk src/index.js
```

### Browser Console

```javascript
// Development logging
if (process.env.NODE_ENV === 'development') {
  console.log('Debug info:', data)
}

// Better error logging
try {
  // code
} catch (error) {
  console.error('Error:', error.message)
  console.trace() // Print stack trace
}
```

### React DevTools

```bash
# Install React DevTools (browser extension)
# Available for Chrome, Firefox, Edge
```

## 🎯 Best Practices

### File Organization

```
src/
├── components/
│   ├── common/
│   │   ├── Button.tsx
│   │   └── Input.tsx
│   └── features/
│       └── UserProfile.tsx
├── hooks/
│   └── useAuth.ts
├── utils/
│   └── helpers.ts
├── types/
│   └── index.ts
├── services/
│   └── api.ts
└── App.tsx
```

### Code Style

```typescript
// Use meaningful names
const getUserById = (id: number) => {
  /* ... */
}

// Use TypeScript types
interface User {
  id: number
  name: string
  email: string
}

// Use async/await
const fetchUsers = async (): Promise<User[]> => {
  const response = await fetch('/api/users')
  return response.json()
}

// Handle errors properly
const safeExecute = async (fn: Function) => {
  try {
    await fn()
  } catch (error) {
    console.error('Error:', error)
    throw error
  }
}
```

### Performance

```typescript
// Use React.memo for expensive components
const ExpensiveComponent = React.memo(({ data }) => {
    return <div>{/* render */}</div>;
});

// Use useMemo for expensive calculations
const memoizedValue = useMemo(() => {
    return expensiveCalculation(data);
}, [data]);

// Use useCallback for functions
const handleClick = useCallback(() => {
    doSomething(id);
}, [id]);
```

## 📚 Resources

### Documentation

- JavaScript: https://developer.mozilla.org/en-US/docs/Web/JavaScript
- TypeScript: https://www.typescriptlang.org/docs/
- React: https://react.dev/
- Next.js: https://nextjs.org/docs
- Vue: https://vuejs.org/guide/
- Node.js: https://nodejs.org/docs/

### Tools

- npm: https://www.npmjs.com/
- Prettier: https://prettier.io/
- ESLint: https://eslint.org/
- Vite: https://vitejs.dev/
- Vitest: https://vitest.dev/

### Learning

- JavaScript.info: https://javascript.info/
- TypeScript Deep Dive: https://basarat.gitbook.io/typescript/
- React Tutorial: https://react.dev/learn
- Full Stack Open: https://fullstackopen.com/

---

[← Back to Languages](../README.md#language-support) | [Python Guide →](python.md)
