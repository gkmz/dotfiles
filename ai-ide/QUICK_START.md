# AI IDE Skills 快速参考

## 一键安装

```bash
cd ~/workspace/mine/dotfiles
./ai-ide/install-ai-ide.sh ~/workspace/myproject
```

## 两个 Skills 的区别

### 🔧 geekmo-practice - 实战文章

**什么时候用**：
- 我遇到了一个问题，想分享解决方案
- 我想写工具使用经验
- 我想记录踩坑过程

**提示词**：
```
用 geekmo-practice 风格写一篇关于 Docker 部署的文章
```

**文章特点**：
- 开头讲问题/场景（可以较长）
- 中间讲解决过程
- 给出完整代码
- 结尾总结经验和踩坑点

---

### 📚 geekmo-course - 教程文章

**什么时候用**：
- 我想系统讲解某个语言的特性
- 我想写知识点教程
- 我需要配练习题
- 适用于 Go、Rust、Python、JavaScript 等所有编程语言

**提示词**：
```
用 geekmo-course 风格写一篇 Go 函数的教程
用 geekmo-course 风格写一篇 Rust 所有权的教程
用 geekmo-course 风格写一篇 Python 装饰器的教程
```

**文章特点**：
- 开头简短引入（2-3 段）
- 逐个讲解知识点 + 代码片段
- 最后给出完整示例
- 结尾有总结、建议和练习题

---

## 快速对比

| 特征 | geekmo-practice | geekmo-course |
|------|----------------|---------------|
| 开头 | 长故事 | 短引入 |
| 代码 | 完整代码 | 小片段 |
| 口语化 | 更多 | 适度 |
| 练习题 | 无 | 有 |

## 验证安装

```bash
./ai-ide/verify-install.sh ~/workspace/myproject
```

## 常见问题

**Q: 如何选择用哪个 skill？**
- 解决问题 → geekmo-practice
- 讲知识点 → geekmo-course

**Q: 可以混用吗？**
- 不建议。每篇文章选一个风格，保持一致性。

**Q: 如何更新 skill？**
- 编辑 `dotfiles/ai-ide/skills/*/SKILL.md`
- 重启 IDE 即可（软链接自动生效）

**Q: 安装到多个项目？**
```bash
./ai-ide/install-ai-ide.sh ~/project1
./ai-ide/install-ai-ide.sh ~/project2
```

## 示例提示词

### 实战文章示例

```
用 geekmo-practice 风格写一篇文章：
我在 Mac 上部署 Ollama 遇到的问题和解决方案
```

### 教程文章示例

```
用 geekmo-course 风格写一篇教程：
Go 语言的切片（Slice）详解

用 geekmo-course 风格写一篇教程：
Rust 的所有权系统入门

用 geekmo-course 风格写一篇教程：
Python 装饰器从入门到精通
```

## 更多帮助

- 详细说明：[README.md](README.md)
- Skills 对比：[skills/README.md](skills/README.md)
- 安装脚本：`./install-ai-ide.sh --help`
