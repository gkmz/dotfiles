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
