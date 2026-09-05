# Tokyo Night 知识笔记语义样式设计

## 目标

在保留 Tokyo Night 主题整体视觉的前提下，为知识笔记增加稳定的语义层级，并让 Obsidian 导出 PDF 时保留重点、链接、代码和提示内容的颜色。

## 范围

- 停用面向 Minimal 主题的 `minimal-ai-global` snippet。
- 新增独立的 `knowledge-semantics.css` snippet。
- 复用 Tokyo Night 已定义的色彩变量，不重写主题基础背景和界面色板。
- 覆盖阅读视图、实时预览和源码编辑视图中常用 Markdown 元素。
- 增加打印媒体规则，使用暖白纸张背景和深色正文，同时保留语义色。

## 语义映射

- `strong`：暖琥珀色，用于重点结论和关键知识。
- `em`：青绿色，用于补充说明和术语提示。
- 内部链接：蓝紫色；外部链接：青色；悬停状态提高亮度并保留下划线。
- 行内代码：淡紫背景和紫色文字；代码块：低对比深色背景、边框和清晰的代码文字。
- 引用：蓝色边框和轻微背景；`mark`：浅黄色高亮。
- Callout：info 蓝色、success 绿色、warning 橙色、danger 红色。
- 表格：轻量表头和分隔线，避免大面积深色填充。

## PDF 行为

`@media print` 将页面背景设置为暖白，正文设置为深墨色，隐藏交互装饰和阴影；链接、粗体、行内代码、代码块、引用和 Callout 使用可打印的高对比颜色。代码块、表格和 Callout 尽量避免跨页拆分。

## 验收标准

1. `appearance.json` 使用 Tokyo Night，且不再启用 `minimal-ai-global`。
2. `knowledge-semantics` 在当前 Vault 的 CSS Snippet 中启用。
3. 阅读视图和实时预览中的语义元素颜色清晰、互不混淆。
4. 现有 Mermaid 样式和笔记布局不被破坏。
5. CSS 文件通过语法检查，且包含打印媒体规则。
