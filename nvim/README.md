# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## AI 补全

Minuet 默认使用 DeepSeek 的 OpenAI 兼容接口。请在 shell 环境中设置：

```sh
export DEEPSEEK_API_KEY="your-deepseek-api-key"
# 可选：代理或自建兼容接口
export DEEPSEEK_BASE_URL="https://api.deepseek.com/v1"
```

在 Neovim 中使用 `:MinuetModel` 或 `<leader>am` 选择 `deepseek-v4-flash`、`deepseek-reasoner` 或自定义模型。也可以直接执行 `:MinuetModel reasoner`。`<leader>ai` 仍用于在 Windsurf、Minuet 和关闭之间切换。

## 开发快捷键参考

本文档记录当前配置中开发过程中最常用的快捷键。除特别说明外，快捷键均在 Normal 模式下使用。

`<leader>` 默认为空格键，例如 `<leader>ff` 实际输入为空格后再按 `ff`。

### 文件与搜索

| 快捷键 | 功能 |
| --- | --- |
| `<leader>e` | 打开/关闭浮动文件浏览器 |
| `<leader>E` | 从项目根目录打开文件浏览器 |
| `<leader>fe` | 在文件浏览器中定位当前文件 |
| `<leader>ff` | 搜索项目文件 |
| `<leader>fg` | 搜索 Git 文件 |
| `<leader>fb` | 搜索已打开的 Buffer |
| `<leader>fr` | 搜索最近打开的文件 |
| `<leader>fc` | 搜索 Neovim 配置文件 |
| `<leader>sg` | 搜索项目内容 |
| `<leader>sw` | 搜索当前单词或选中文本 |
| `<leader>sr` | 搜索并替换 |
| `<leader>ss` | 搜索当前文件的 LSP Symbols |
| `<leader>sS` | 搜索工作区 Symbols |
| `<leader>fn` | 新建文件 |

文件浏览器使用 28 列浮动窗口。打开文件后自动关闭；打开目录时继续展开浏览。

### 编辑与代码导航

| 快捷键 | 功能 |
| --- | --- |
| `<C-s>` | 保存文件 |
| `<leader>cf` | 格式化当前文件或选区 |
| `<leader>ca` | Code Action |
| `<leader>cr` | 重命名符号 |
| `gd` | 跳转到定义 |
| `gr` | 查找引用 |
| `gI` | 跳转到实现 |
| `gy` | 跳转到类型定义 |
| `K` | 查看悬浮文档 |
| `[f` | 上一个函数/方法名称 |
| `]f` | 下一个函数/方法名称 |
| `[d` / `]d` | 上一个/下一个诊断 |
| `[e` / `]e` | 上一个/下一个错误 |
| `[w` / `]w` | 上一个/下一个警告 |
| `<leader>cd` | 显示当前行诊断 |
| `<leader>xx` | 打开所有诊断列表 |
| `<leader>xX` | 打开当前 Buffer 的诊断列表 |
| `gh` / `gl` | 跳到行首/行尾 |
| `gcc` | 注释/取消注释当前行 |
| `gc` | 注释/取消注释选区 |
| `<M-d>` | 复制当前行 |
| `<M-x>` | 删除当前行 |

`[f`/`]f` 已调整为直接落到函数或方法名称位置，便于随后执行 `gr`。

### 窗口、Buffer 与 Tab

| 快捷键 | 功能 |
| --- | --- |
| `<leader><Up/Down/Left/Right>` | 切换到对应方向的窗口 |
| `<leader>-` | 水平切分窗口 |
| `<leader>\|` | 垂直切分窗口 |
| `<leader>wd` | 关闭当前窗口 |
| `<A-0>` | 当前窗口临时全屏/恢复 |
| `<M-Up/Down>` | 调整窗口高度 |
| `<M-Left/Right>` | 调整窗口宽度 |
| `<leader>wm` / `<leader>uZ` | 切换当前窗口放大 |
| `<leader>uz` | 切换 Zen Mode |
| `<leader>bs` | 选择 Buffer |
| `<leader><Tab><Tab>` | 新建 Tab |
| `<leader><Tab>]` / `<leader><Tab>[` | 下一个/上一个 Tab |
| `<leader><Tab>l` / `<leader><Tab>f` | 最后一个/第一个 Tab |
| `<leader><Tab>d` | 关闭当前 Tab |
| `<leader><Tab>o` | 关闭其他 Tab |

### 终端

| 快捷键 | 功能 |
| --- | --- |
| `<C-\`>` / `<A-1>` | 切换底部终端 1 |
| `<A-2>` | 切换底部终端 2 |
| `<leader>Tb1` ~ `<leader>Tb4` | 切换底部终端 1～4 |
| `<A-v>` / `<leader>Tv` | 切换右侧主终端 |
| `<leader>Tr1` ~ `<leader>Tr4` | 切换右侧终端 1～4 |
| `<A-f>` / `<leader>Tf` | 切换浮动终端 |
| `<leader>Th` | 隐藏全部终端但保留进程 |
| `<leader>Tq` | 关闭全部终端 |
| `<Esc>` | 终端模式返回 Terminal-Normal 状态 |
| `<C-h/j/k/l>` | AI 终端中切换 Neovim 窗口 |

`<A-0>` 是 Neovim 当前窗口的临时全屏；WezTerm 自身 pane 的高度放大使用 `Ctrl+Alt+Z`，再次按下恢复。

### 运行、测试与调试

| 快捷键 | 功能 |
| --- | --- |
| `<leader>rr` | 运行当前文件 |
| `<leader>rp` | 运行当前项目 |
| `<leader>rq` | 关闭运行窗口 |
| `<leader>tn` | 运行最近测试 |
| `<leader>tf` | 运行当前文件测试 |
| `<leader>ta` | 运行全部测试 |
| `<leader>tl` | 重新运行上次测试 |
| `<leader>td` | 使用调试器运行最近测试 |
| `<leader>to` | 打开测试输出 |
| `<leader>ts` | 打开/关闭测试摘要 |
| `<leader>tr` | Go race test：`go test -race ./...` |
| `<F5>` | 调试继续运行 |
| `<F7>` | Step Into |
| `<F8>` | Step Over |
| `<F9>` | Step Out |
| `<F10>` | 终止调试 |
| `<leader>db` | 设置/取消断点 |
| `<leader>dB` | 条件断点 |
| `<leader>du` | 打开/关闭 DAP UI |

### Go

| 快捷键 | 功能 |
| --- | --- |
| `<leader>lgd` | 调试最近的 Go 测试 |
| `<leader>lgr` | 调试 Go 包并输入参数 |
| `<leader>lgi` | 安装 Go 依赖 |
| `<leader>lgm` | 执行 `go mod tidy` |
| `<leader>lga` | 添加 Go 测试 |
| `<leader>lgA` | 为全部函数添加 Go 测试 |
| `<leader>lge` | 为导出函数添加 Go 测试 |
| `<leader>lgg` | 执行 Go generate |
| `<leader>lgG` | 对当前文件执行 Go generate |
| `<leader>lgc` | 生成 Go 注释 |
| `<leader>lgI` | 实现 Go interface |

### Python

| 快捷键 | 功能 |
| --- | --- |
| `<leader>lpv` | 选择 Python 虚拟环境 |
| `<leader>lpr` | Ruff fix all |
| `<leader>lpf` | Ruff 格式化 |
| `<leader>lpt` | 运行最近的 Python 测试 |
| `<leader>lpd` | 调试最近的 Python 测试 |

Python 格式化流程使用 `ruff_organize_imports`、`ruff_format` 和 `ruff_fix`。

### Git 与 Diffview

| 快捷键 | 功能 |
| --- | --- |
| `<leader>gg` | 打开项目根目录 Lazygit |
| `<leader>gG` | 打开当前目录 Lazygit |
| `<leader>gL` / `<leader>gl` | Git Log / 项目 Git Log |
| `<leader>gb` | 当前行 Git blame |
| `<leader>gf` | 当前文件 Git 历史 |
| `<leader>gB` | 在浏览器打开当前 Git 页面 |
| `<leader>gY` | 复制当前 Git 页面链接 |
| `<leader>gd` | 查看当前 Git hunk |
| `<leader>gdc` | 比较 `origin/main` 与当前分支 |
| `<leader>gdq` | 关闭 Diffview |
| `<leader>gdh` / `<leader>gdH` | 当前文件/仓库历史 |
| `<leader>gdm` | 查看合并冲突 |
| `<leader>gdo` | 与 `main` 分支比较 |
| `<leader>gdp` | 查看当前 PR |
| `<leader>gdP` | 按 commit 查看当前 PR |

### AI 工具与补全

| 快捷键 | 功能 |
| --- | --- |
| `<leader>aa` | 打开/关闭 Agentic |
| `<leader>an` | 新建 Agentic 会话 |
| `<leader>ar` | 恢复 Agentic 会话 |
| `<leader>ad` | 将当前 Buffer 诊断加入 Agentic |
| `ga` | 将当前文件或选区加入 Agentic 上下文 |
| `[u` / `]u` | Agentic 中上一个/下一个用户问题 |
| `<leader>Tc` | 打开 Codex CLI |
| `<leader>Tl` | 打开 Claude CLI |
| `<leader>Tmx` / `<leader>Tma` | 标记当前终端为 Codex/Claude CLI |
| `gC` | 将 Visual 选区发送到 Claude CLI |
| `<leader>ai` | 切换 Windsurf / Minuet / 关闭 |
| `<leader>am` | 选择 Minuet 模型 |
| `<M-[>` / `<M-]>` | 上一个/下一个 AI 补全建议 |
| `<Tab>` | 接受 AI 补全或普通补全候选 |

相关命令：`:AICompletion status` 查看补全 provider，`:MinuetModel` 选择 Minuet 模型。

### HTTP、翻译与 Obsidian

| 快捷键 | 功能 |
| --- | --- |
| `<leader>hr` | 执行 HTTP 请求 |
| `<leader>ht` | 切换请求头/请求体 |
| `<leader>hp` / `<leader>hn` | 上一个/下一个请求 |
| `<leader>he` | 选择 HTTP 环境 |
| `<leader>ute` | 翻译成英文 |
| `<leader>utz` | 翻译成中文 |
| `<leader>utw` | 将当前单词翻译成中文 |
| `<leader>os` | 搜索 Obsidian 笔记内容 |
| `<leader>of` | 搜索 Obsidian 笔记文件名 |
| `<leader>on` | 新建 Obsidian 笔记 |
| `<leader>ol` / `<leader>og` / `<leader>ov` | 打开常用学习笔记 |

### 界面开关

| 快捷键 | 功能 |
| --- | --- |
| `<leader>uf` / `<leader>uF` | 格式化开关/强制格式化开关 |
| `<leader>us` | 拼写检查 |
| `<leader>uw` | 自动换行 |
| `<leader>uL` | 相对行号 |
| `<leader>ud` | 诊断显示 |
| `<leader>ul` | 行号显示 |
| `<leader>uc` | conceallevel |
| `<leader>uT` | Treesitter |
| `<leader>ub` | 深色背景 |
| `<leader>uD` | Dim |
| `<leader>ua` | 动画 |
| `<leader>ug` | 缩进线 |
| `<leader>uS` | 滚动动画 |
| `<leader>uh` | LSP Inlay Hints |
| `<leader>uM` | Agentic Markdown 渲染 |
