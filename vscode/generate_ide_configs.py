#!/usr/bin/env python3
"""
根据通用 VSCode 配置 + 各 IDE 专用配置，生成每个 IDE 的最终 settings/keybindings。

用法示例（在 dotfiles 根目录执行）:

  cd vscode
  python generate_ide_configs.py

目录结构约定：
- 根目录下的 `settings.json` / `keybindings.json` 为“基础通用配置”
- 每个 IDE 一个子目录，例如：
  - vscode/
  - cursor/
  - windsuf/
  - trae/
  - kiro/
  - antigravity/

在每个 IDE 子目录里：
- 你可以放若干个 settings*.json / keybindings*.json 作为该 IDE 的增量配置
- 本脚本会将它们与根目录基础配置合并后，覆盖写入：
  - <ide>/settings.json
  - <ide>/keybindings.json

然后你可以把对应 IDE 的真实配置软链接到这些各自目录中的文件。
"""

import json
import os
from copy import deepcopy

ROOT = os.path.dirname(os.path.abspath(__file__))

IDES = [
    "vscode",      # 原生 VS Code
    "cursor",      # Cursor IDE
    "windsurf",    # Windsurf
    "trae",        # Trae IDE
    "kiro",        # Kiro（当作一个独立 IDE 使用）
    "antigravity", # Antigravity（当作一个独立 IDE 使用）
]


def _strip_json_comments(text: str) -> str:
    """
    非严格的 JSONC -> JSON 转换:
    - 去掉以 // 开头的整行注释
    - 去掉行尾的 // 注释（当 // 不在字符串内部时）
    - 不处理 /* */ 块注释
    """
    result_lines = []
    for raw in text.splitlines():
        stripped = raw.lstrip()
        # 整行注释
        if stripped.startswith("//"):
            continue

        line = []
        in_string = False
        i = 0
        while i < len(raw):
            ch = raw[i]
            # 处理字符串状态（仅考虑双引号）
            if ch == '"' and (i == 0 or raw[i - 1] != "\\"):
                in_string = not in_string
                line.append(ch)
                i += 1
                continue

            # 检测字符串外的 //
            if not in_string and ch == "/" and i + 1 < len(raw) and raw[i + 1] == "/":
                # 截断到此处，后面的视为注释
                break

            line.append(ch)
            i += 1

        result_lines.append("".join(line))

    return "\n".join(result_lines)


def load_jsonc(path: str, default):
    if not os.path.exists(path):
        return deepcopy(default)
    with open(path, "r", encoding="utf-8") as f:
        raw = f.read()
    cleaned = _strip_json_comments(raw)
    if not cleaned.strip():
        return deepcopy(default)
    return json.loads(cleaned)


def deep_merge_dict(base: dict, override: dict) -> dict:
    """
    递归合并两个 dict:
    - override 中的值覆盖 base
    - 如果都是 dict，则递归合并
    """
    result = deepcopy(base)
    for k, v in override.items():
        if k in result and isinstance(result[k], dict) and isinstance(v, dict):
            result[k] = deep_merge_dict(result[k], v)
        else:
            result[k] = deepcopy(v)
    return result


def merge_settings_for_ide(ide: str):
    """
    合并根目录 settings.json 与 <ide>/ 下所有 settings*.json，生成 <ide>/settings.json
    """
    base_path = os.path.join(ROOT, "settings.json")
    ide_dir = os.path.join(ROOT, ide)

    base = load_jsonc(base_path, default={})
    merged = deepcopy(base)

    if os.path.isdir(ide_dir):
        for name in sorted(os.listdir(ide_dir)):
            # 排除生成的最终文件，避免循环合并
            if name in ["settings.json", "keybindings.json"]:
                continue
            if name.startswith("settings") and name.endswith(".json"):
                path = os.path.join(ide_dir, name)
                extra = load_jsonc(path, default={})
                merged = deep_merge_dict(merged, extra)

    os.makedirs(ide_dir, exist_ok=True)
    out_path = os.path.join(ide_dir, "settings.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(merged, f, ensure_ascii=False, indent=2)
        f.write("\n")
    print(f"[settings] generated for {ide}: {out_path}")


def merge_keybindings_for_ide(ide: str):
    """
    合并根目录 keybindings.json 与 <ide>/ 下所有 keybindings*.json，生成 <ide>/keybindings.json
    """
    base_path = os.path.join(ROOT, "keybindings.json")
    ide_dir = os.path.join(ROOT, ide)

    base = load_jsonc(base_path, default=[])
    if not isinstance(base, list):
        raise ValueError("根目录 keybindings.json 必须是数组形式")

    merged = list(base)

    if os.path.isdir(ide_dir):
        for name in sorted(os.listdir(ide_dir)):
            # 排除生成的最终文件，避免循环合并
            if name in ["settings.json", "keybindings.json"]:
                continue
            if name.startswith("keybindings") and name.endswith(".json"):
                path = os.path.join(ide_dir, name)
                extra = load_jsonc(path, default=[])
                if not isinstance(extra, list):
                    raise ValueError(f"{path} 必须是数组形式")
                merged.extend(extra)

    os.makedirs(ide_dir, exist_ok=True)
    out_path = os.path.join(ide_dir, "keybindings.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(merged, f, ensure_ascii=False, indent=2)
        f.write("\n")
    print(f"[keybindings] generated for {ide}: {out_path}")


def main():
    for ide in IDES:
        merge_settings_for_ide(ide)
        merge_keybindings_for_ide(ide)


if __name__ == "__main__":
    main()

