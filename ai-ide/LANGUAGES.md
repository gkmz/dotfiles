# 支持的编程语言

`geekmo-course` skill 支持所有主流编程语言的教程编写。

## 已测试的语言

### Go
- ✅ 完整支持
- 代码块标记：`go`
- 示例要求：包含 `package main` 和 `main` 函数
- 特色：并发、错误处理、接口

### Rust
- ✅ 完整支持
- 代码块标记：`rust`
- 示例要求：包含 `fn main()` 和必要的 `use` 语句
- 特色：所有权、借用、生命周期、安全性

### Python
- ✅ 完整支持
- 代码块标记：`python`
- 示例要求：包含必要的 `import`，可选 `if __name__ == "__main__":`
- 特色：简洁、动态类型、列表推导式、装饰器

### JavaScript/TypeScript
- ✅ 完整支持
- 代码块标记：`javascript` / `typescript`
- 示例要求：说明运行环境（Node.js/浏览器/Deno）
- 特色：异步编程、原型链、闭包

### Java
- ✅ 完整支持
- 代码块标记：`java`
- 示例要求：包含 `public class` 和 `public static void main`
- 特色：面向对象、泛型、Stream API

### C/C++
- ✅ 完整支持
- 代码块标记：`c` / `cpp`
- 示例要求：包含 `#include` 和 `main` 函数
- 特色：指针、内存管理、模板

## 其他语言

理论上支持所有编程语言，只需：
1. 使用正确的代码块标记
2. 包含该语言运行所需的基本结构
3. 遵循该语言的命名和风格规范

## 使用示例

### Go 教程
```
用 geekmo-course 风格写一篇 Go 切片的教程
```

### Rust 教程
```
用 geekmo-course 风格写一篇 Rust 所有权系统的教程
```

### Python 教程
```
用 geekmo-course 风格写一篇 Python 装饰器的教程
```

### JavaScript 教程
```
用 geekmo-course 风格写一篇 JavaScript Promise 的教程
```

### TypeScript 教程
```
用 geekmo-course 风格写一篇 TypeScript 泛型的教程
```

### Java 教程
```
用 geekmo-course 风格写一篇 Java Stream API 的教程
```

### C++ 教程
```
用 geekmo-course 风格写一篇 C++ 智能指针的教程
```

## 语言特定的注意事项

### Go
- 强调简洁性和实用性
- 对比 Java/C++ 的复杂性
- 突出并发、错误处理等特色

### Rust
- 强调安全性和性能
- 对比 C/C++ 的内存管理
- 突出所有权、借用、生命周期等核心概念

### Python
- 强调简洁和易读性
- 对比 Java/C++ 的冗长
- 突出 Pythonic 的写法

### JavaScript/TypeScript
- 强调灵活性和生态
- 对比传统语言的类型系统
- 突出异步编程、原型链等特色

### Java
- 强调面向对象和企业级特性
- 对比现代语言的简洁性
- 突出泛型、Stream API 等现代特性

### C/C++
- 强调性能和底层控制
- 对比高级语言的内存管理
- 突出指针、模板等核心特性

## 添加新语言支持

如果需要添加新语言的特定支持：

1. 在 `SKILL.md` 的"不同语言的特殊要求"部分添加该语言
2. 添加该语言的代码块标记
3. 说明该语言的示例要求
4. 添加该语言的特色和注意事项
5. 更新本文档

## 反馈

如果你在使用某个语言时遇到问题，或者有改进建议，欢迎提 Issue 或 PR！
