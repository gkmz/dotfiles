# Changelog

## 2025-02-28

### 重命名 Skills - 更清晰的命名

- 将 `geekmo` 重命名为 `geekmo-practice`（实战文章）
- 保持 `geekmo-course`（教程文章）
- 命名更清晰：practice（实践）vs course（课程）

### 更新 geekmo-course Skill - 支持多语言

- 将 `geekmo-course` skill 从 Go 专用扩展为支持所有编程语言
- 支持的语言：Go、Rust、Python、JavaScript/TypeScript、Java、C/C++ 等
- 添加了不同语言的代码规范和示例要求
- 更新了所有相关文档

### 新增 geekmo-course Skill

- 创建了 `geekmo-course` skill，专门用于编写编程语言教程系列文章
- 与 `geekmo-practice` 的区别：
  - `geekmo-practice`: 实战文章风格（问题解决、经验分享）
  - `geekmo-course`: 教程文章风格（系统化知识讲解）

### 文件结构

```
ai-ide/
├── skills/
│   ├── geekmo-practice/     # 实战文章风格（重命名）
│   │   ├── README.md
│   │   └── SKILL.md
│   ├── geekmo-course/       # 教程文章风格
│   │   ├── README.md
│   │   └── SKILL.md
│   └── README.md            # Skills 对比说明
├── steering/
│   └── git-commit-chinese.md
├── install-ai-ide.sh        # 安装脚本（已更新）
├── verify-install.sh        # 验证脚本（已更新）
├── README.md                # 主文档（已更新）
├── QUICK_START.md           # 快速参考（已更新）
├── LANGUAGES.md             # 语言支持说明
└── CHANGELOG.md             # 本文件（已更新）
```

### 安装脚本改进

- 更新了安装脚本的提示信息，说明两个 skills 的区别
- 添加了使用方法示例

### 新增工具

- `verify-install.sh`: 验证安装是否正确的脚本
- `QUICK_START.md`: 快速参考卡片
- `skills/README.md`: 详细的 skills 对比说明

### 使用方法

**安装**：
```bash
./install-ai-ide.sh ~/workspace/myproject
```

**验证**：
```bash
./verify-install.sh ~/workspace/myproject
```

**使用**：
- 实战文章：`用 geekmo-practice 风格写一篇...`
- 教程文章（Go）：`用 geekmo-course 风格写一篇 Go 函数教程`
- 教程文章（Rust）：`用 geekmo-course 风格写一篇 Rust 所有权教程`
- 教程文章（Python）：`用 geekmo-course 风格写一篇 Python 装饰器教程`

### 测试

- ✅ 在 hankmo.com 项目中测试安装成功
- ✅ 验证脚本运行正常
- ✅ 软链接创建正确
- ✅ 支持 kiro 和 trae 两个 IDE

### 文档

- ✅ README.md: 主文档，包含完整说明
- ✅ QUICK_START.md: 快速参考卡片
- ✅ skills/README.md: Skills 详细对比
- ✅ 各 skill 的 README.md: 单独说明

### 下一步

- [ ] 在实际使用中测试两个 skills 的效果
- [ ] 根据反馈优化 SKILL.md 的内容
- [ ] 考虑添加更多 skills（如技术选型、架构设计等）
