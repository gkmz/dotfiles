# Agentic.nvim 集成设计

## 目标

使用 `agentic.nvim` 作为 Neovim 的主要 AI Agent 界面，通过已安装的 `codex-acp` 提供带文件路径、选区行号和诊断信息的结构化 Codex 上下文。保留现有 Codex 与 Claude Code CLI 浮动终端，作为原生 CLI 兜底。

## 范围

- 删除未实际使用的 CodeCompanion 插件配置、快捷键、终端回退逻辑和锁文件条目。
- 新增独立的 `agentic.nvim` Lazy 插件配置，默认 provider 使用 `codex-acp`。
- 提供聊天开关、添加当前文件或选区、添加诊断、新建与恢复会话等核心快捷键。
- 将可视模式 `ga` 改为向 Agentic 添加结构化选区上下文。
- 保留 `<leader>Tc`、`<leader>Tl` 和其他现有 CLI 终端功能。

## 结构

`nvim/lua/plugins/agentic.lua` 负责插件声明、provider 和 Agentic 专属快捷键。通用终端能力继续留在 `nvim/lua/utils/terminal.lua`，但删除 CodeCompanion 检测及回退分支。全局快捷键说明继续由 `nvim/lua/config/keymaps.lua` 维护。

## 交互

- `<leader>aa`：打开或切换 Agentic 聊天窗口，并自动附加当前文件。
- `ga`：普通模式附加当前文件，可视模式附加带起止行号的选区。
- `<leader>ad`：添加当前 buffer 的诊断信息。
- `<leader>an`：创建新 Agentic 会话。
- `<leader>ar`：恢复 Agentic 会话。
- `<leader>Tc`、`<leader>Tl`：继续打开原生 Codex/Claude Code CLI。

快捷键使用 `<leader>a` 命名空间，避免和终端命名空间 `<leader>T` 混合。插件不可用或 `codex-acp` 缺失时，由 Agentic 的健康检查和通知暴露错误，不静默退回纯文本终端发送。

## 验证

- 检查 Lua 文件语法和无头 Neovim 启动。
- 运行 Lazy 同步，确认 `agentic.nvim` 被安装且 CodeCompanion 被移除。
- 检查 `codex-acp` 可执行文件和 Agentic health 输出。
- 检查关键映射，确认 `ga` 不再调用纯文本终端发送。
- 启动 Agentic 聊天，验证 Codex provider 能建立 ACP 会话；如果认证需要交互，明确记录剩余步骤。

## 非目标

- 不删除或重构现有 Codex/Claude Code 终端管理能力。
- 不同时配置 Claude ACP provider；本次以 Codex 为默认 Agent。
- 不迁移 CodeCompanion 的 HTTP provider、prompt library 或 inline edit 功能。
- 不尝试复刻 OpenAI 官方 VS Code 扩展的全部界面。
