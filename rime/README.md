# Rime 配置说明（macOS 鼠须管）

本目录是我的 Rime（Squirrel）配置，目标是：

- 默认简体中文输入（拼音）
- 支持 emoji 候选
- 支持日期/时间快捷输入（如 `zrq`、`zsj`）
- 中英文输入体验接近常用商业输入法，但保持本地化与可控性

---

## 1. 使用前提

- 系统：macOS
- 前端：Squirrel（鼠须管）
- 用户目录：`~/Library/Rime`

---

## 2. 快速开始

在 dotfiles 根目录执行：

```bash
./install.sh rime
```

如需安装扩展资源（emoji / 英文混输）：

```bash
./rime/install-plugins.sh emoji
./rime/install-plugins.sh english
# 或一次安装
./rime/install-plugins.sh all
```

然后在鼠须管菜单点击 **重新部署**。

---

## 3. 目录结构与作用

- `default.custom.yaml`  
  全局行为：默认方案列表、选单热键、候选页大小、开关保存策略。

- `hank_luna_pinyin.schema.yaml`  
  独立增强方案（推荐默认方案）。显式内置：
  - 默认简体（`simplification/reset: 1`）
  - emoji 过滤器
  - `lua_translator@date_time`

- `luna_pinyin.custom.yaml`  
  给原生 `luna_pinyin` 追加增强（保留兼容链路）。

- `luna_pinyin_simp.schema.yaml` / `luna_pinyin_simp.custom.yaml`  
  兼容简体链路（历史调试保留）。

- `squirrel.custom.yaml`  
  Squirrel UI 外观：字体、配色、候选布局。

- `lua/date_time.lua`  
  日期/时间 Lua 翻译器逻辑。

- `rime.lua`  
  Lua 入口注册（把 `date_time` 模块注册给 `lua_translator` 使用）。

- `custom_phrase.txt`  
  固定短语词条。

- `install-plugins.sh`  
  通过 SSH 拉取并安装 `rime-emoji` / `rime-easy-en` 资源。

---

## 4. 当前默认方案

`default.custom.yaml` 中默认优先方案：

1. `hank_luna_pinyin`（朙月拼音·简体增强）
2. `luna_pinyin`
3. `luna_pinyin_simp`

建议日常使用第 1 个。

---

## 5. 常用功能

## 5.1 日期/时间快捷输入

为避免和拼音缩写冲突，推荐用 `z*` 前缀：

- `zrq`：日期
- `zsj` / `zst`：时间
- `zdt`：日期时间
- `zxq`：星期

同时兼容：

- `rq/sj/st/dt/xq`
- `;rq/;sj/;st/;dt/;xq`（在半角标点模式下）

## 5.2 Emoji

- 菜单（`Ctrl + \``）里有 `emoji_suggestion` 开关
- 快捷键：`Ctrl + Shift + E` 切换 emoji 开/关
- 开启后输入中文词（如“笑”）会出现对应 emoji 候选

## 5.3 简体/繁体

- 默认简体（`simplification/reset: 1`）
- 可在方案选单切换到繁体（同一方案内开关）

## 5.4 中英文与标点

- 默认使用系统输入法快捷键切换中英文（不使用 Shift 切换）
- 默认半角字符（避免英文/日期变全角）
- 中文标点由 `ascii_punct` 控制（可在菜单切换）

---

## 6. 故障排查

## 6.1 改了配置没生效

1. 确认软链是否正确：

```bash
ls -l ~/Library/Rime/default.custom.yaml
ls -l ~/Library/Rime/hank_luna_pinyin.schema.yaml
ls -l ~/Library/Rime/lua/date_time.lua
ls -l ~/Library/Rime/rime.lua
```

2. 鼠须管菜单点击 **重新部署**。

## 6.2 `zrq` 等无候选

检查是否编译进最终方案：

```bash
rg -n "hank_luna_pinyin|lua_translator@date_time" ~/Library/Rime/build/*.yaml
```

## 6.3 emoji 不出现

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

---

## 7. 维护建议

- 新增快捷输入优先放在 `lua/date_time.lua`（动态）或 `custom_phrase.txt`（静态）
- 每次改配置后都执行一次「重新部署」
- 若切换机器，优先恢复本目录并执行 `./install.sh rime`

