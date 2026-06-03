# Rime 配置说明（macOS 鼠须管）

本目录是精简版 Rime（Squirrel）配置，目标是：

- 只保留两个输入方案：简体中文、繁體中文
- 默认简体中文输入
- 支持 emoji 候选
- 支持日期/时间快捷输入（如 `zrq`、`zsj`）
- 使用 macOS 输入源切换中英文，不使用 Rime 内部西文模式

## 使用前提

- 系统：macOS
- 前端：Squirrel（鼠须管）
- 用户目录：`~/Library/Rime`

## 快速开始

在 dotfiles 根目录执行：

```bash
./install.sh rime
```

如需安装扩展资源：

```bash
./rime/install-plugins.sh emoji
```

然后在鼠须管菜单点击 **重新部署**。

## 目录结构

- `default.custom.yaml`  
  全局行为：只启用两个方案、设置方案选单热键、候选页大小、开关保存策略。

- `hank_pinyin_simp.schema.yaml`  
  简体中文方案，默认输出简体。

- `hank_pinyin_trad.schema.yaml`  
  繁體中文方案，默认输出繁体。

- `squirrel.custom.yaml`  
  Squirrel UI 外观：字体、配色、候选布局。

- `lua/date_time.lua`  
  日期/时间 Lua 翻译器逻辑。

- `lua/radical_lookup.lua` / `radical_lookup.dict.yaml`  
  偏旁部首输入。

- `rime.lua`  
  Lua 入口注册。

- `custom_phrase.txt`  
  固定短语词条。

## 当前方案

`default.custom.yaml` 只启用：

1. `hank_pinyin_simp`（简体中文）
2. `hank_pinyin_trad`（繁體中文）

方案选单热键为 `F3` 或 `Ctrl+Shift+\``。不再使用 `Ctrl+\``，避免某些应用把“方案选单”文案留在输入框里。

## 中英文切换

建议在 macOS 输入源里保留：

- `ABC`
- `鼠须管`

用系统输入法快捷键在 `ABC / 鼠须管` 之间切换。Rime 配置里已禁用 `Shift` 和 `Caps Lock` 切换内部西文状态，避免切回鼠须管后仍停在英文。

## 常用功能

### 日期/时间快捷输入

- `zrq`：日期
- `zsj` / `zst`：时间
- `zdt`：日期时间
- `zxq`：星期

同时兼容：

- `rq/sj/st/dt/xq`
- `;rq/;sj/;st/;dt/;xq`（在半角标点模式下）

### Emoji

- 快捷键：`Ctrl + Shift + E` 切换 emoji 开关
- 开启后输入中文词（如“笑”）会出现对应 emoji 候选

### 笔画 / 偏旁部首

- `zps` -> `亻`
- `znnn` -> `氵`
- `znns` -> `忄`
- `zhsp` -> `艹`
- `zpzn` -> `辶`
- `zjg` -> 结构符号（`⿰ ⿱ ⿲ ⿳ ...`）

输入规则：`z + 笔顺码`。笔顺码字母为 `h` 横、`s` 竖、`p` 撇、`n` 点、`z` 折。

### 标点

- 默认半角字符
- 中文/英文标点由 `ascii_punct` 控制，可在 `F3` 或 `Ctrl+Shift+\`` 方案选单里切换

## 故障排查

### 改了配置没生效

确认软链是否正确：

```bash
ls -l ~/Library/Rime/default.custom.yaml
ls -l ~/Library/Rime/hank_pinyin_simp.schema.yaml
ls -l ~/Library/Rime/hank_pinyin_trad.schema.yaml
ls -l ~/Library/Rime/lua/date_time.lua
ls -l ~/Library/Rime/rime.lua
```

然后在鼠须管菜单点击 **重新部署**。

### `zrq` 等无候选

检查是否编译进最终方案：

```bash
rg -n "hank_pinyin|lua_translator@date_time" ~/Library/Rime/build/*.yaml
```

### VS Code 中选中简体中文仍输入英文

Squirrel 默认配置会对部分编辑器应用启用 `ascii_mode`。本配置已在 `squirrel.custom.yaml` 里显式关闭 VS Code 的应用级西文模式：

```yaml
app_options/com.microsoft.VSCode/ascii_mode: false
```

改动后需要在鼠须管菜单点击 **重新部署**。部署后可确认：

```bash
rg -n "com.microsoft.VSCode|ascii_mode" ~/Library/Rime/build/squirrel.yaml
```

### emoji 不出现

检查资源文件是否在位：

```bash
ls ~/Library/Rime/emoji_suggestion.yaml
ls ~/Library/Rime/opencc/emoji.json
ls ~/Library/Rime/opencc/emoji_word.txt
```

再确认 build 中包含：

```bash
rg -n "emoji_suggestion|simplifier@emoji_suggestion" ~/Library/Rime/build/*.yaml
```

## 维护建议

- 新增快捷输入优先放在 `lua/date_time.lua`（动态）或 `custom_phrase.txt`（静态）
- 每次改配置后都执行一次「重新部署」
- 若切换机器，优先恢复本目录并执行 `./install.sh rime`
