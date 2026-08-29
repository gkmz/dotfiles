# Neovim 窗口分隔线视觉增强设计

## 目标

在 TokyoNight Storm 透明主题下，提高水平和垂直窗口分隔线的辨识度，让多个 split 窗口能够快速区分，同时避免高亮过强影响代码阅读。

## 方案

- 在 TokyoNight 的 `on_highlights` 回调中覆盖 `WinSeparator`。
- 同步覆盖兼容旧版 Neovim 或插件使用的 `VertSplit` 高亮组。
- 分隔线前景色使用 TokyoNight 调色板中的中等对比蓝灰色 `blue0`。
- 在全局选项中明确设置 split 相关 `fillchars`，水平线使用连续横线，垂直线使用连续竖线，并补齐交叉连接字符。

## 影响范围

- `nvim/lua/plugins/colortheme.lua`：设置主题相关分隔线颜色。
- `nvim/lua/config/options.lua`：设置窗口分隔线字符。

不修改浮窗边框、bufferline、窗口背景和活动窗口状态，不引入窗口切换自动命令。

## 验证

- 使用 headless Neovim 检查配置可正常加载。
- 检查 `WinSeparator` 与 `VertSplit` 的最终前景色一致且不为空。
- 检查水平、垂直及交叉分隔字符均已配置。
- 执行 Lua 语法检查和 `git diff --check`。
