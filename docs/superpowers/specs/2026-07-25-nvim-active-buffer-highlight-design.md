# Neovim 激活 Buffer 高亮设计

## 目标

让 bufferline 中当前激活的 buffer 能被快速识别，同时保持 TokyoNight Storm 与透明背景的现有视觉风格。

## 方案

- 为激活 buffer 使用 TokyoNight 的 `bg_highlight` 作为背景色。
- 激活 buffer 的标题使用主题亮色前景并加粗。
- 图标、关闭按钮和相邻分隔符沿用相同背景色，保证高亮色块连续。
- 非激活 buffer 的样式保持不变。
- 颜色从当前主题调色板读取，不硬编码具体色值，以兼容主题样式调整。

## 实现边界

新增独立的 bufferline 插件覆盖配置，仅调整 `highlights`，不改变 buffer 排序、关闭、选择、诊断或快捷键行为。

## 验证

- 使用无界面 Neovim 加载配置，确认没有 Lua 或插件配置错误。
- 检查 bufferline 最终配置，确认激活标题、图标、关闭按钮和分隔符使用一致背景色。
- 在实际 Neovim 界面中确认激活 buffer 的背景清晰可辨，且非激活 buffer 未发生视觉回归。
