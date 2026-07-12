# Snacks Explorer 手动定位设计

## 目标

关闭 Snacks Explorer 对当前 buffer 的自动跟随，避免关闭文件或切换 buffer 时，文件树自动跳转到其他目录。

## 交互设计

- `<leader>e` 保持 LazyVim 现有行为，仅负责打开或关闭 Explorer。
- `<leader>fe` 手动定位当前 buffer 对应的文件。
- Explorer 已打开时，手动定位会展开文件所在目录并选中该文件。
- Explorer 未打开时，手动定位会打开 Explorer，然后选中当前文件。
- 当前 buffer 没有对应磁盘文件时，沿用 Snacks Explorer 的默认处理，不增加额外状态或提示。

## 实现范围

在 `nvim/lua/plugins/snack.lua` 的 Explorer picker 配置中关闭 `follow_file`，并在插件快捷键配置中调用官方 `Snacks.explorer.reveal()` API。除这两个配置点外，不修改 Explorer 的打开、关闭、目录展开和文件打开行为。

## 验证

1. 检查 Neovim 配置可正常加载。
2. 打开 Explorer 后切换不同目录中的 buffer，确认文件树不自动跳转。
3. 按 `<leader>fe`，确认 Explorer 定位当前文件。
4. 关闭 Explorer 后按 `<leader>fe`，确认 Explorer 打开并定位当前文件。
5. 按 `<leader>e`，确认仍然只切换 Explorer 的显示状态。
