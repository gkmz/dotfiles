#!/usr/bin/env python3
"""
Obsidian 全局主题应用脚本（面向多 vault）。

关键流程：
1) 读取 Obsidian 全局 vault 列表（obsidian.json）
2) 将统一 CSS snippet 同步到每个 vault 的 .obsidian/snippets
3) 更新每个 vault 的 app.json：
   - 启用统一 snippet
   - 设置跟随系统色彩模式（自动切换）
   - 设置 Minimal 主题（若本地存在）
4) 对每个 vault 的 app.json 先做备份，确保可回滚
"""

from __future__ import annotations

import json
from datetime import datetime
from pathlib import Path
import shutil


SNIPPET_NAME = "minimal-ai-global"


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def backup_file(path: Path) -> None:
    if not path.exists():
        return
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup = path.with_name(f"{path.name}.backup.{ts}")
    shutil.copy2(path, backup)


def apply_to_vault(vault_path: Path, snippet_source: Path) -> tuple[bool, str]:
    if not vault_path.exists():
        return False, f"跳过：vault 不存在 -> {vault_path}"

    obsidian_dir = vault_path / ".obsidian"
    snippets_dir = obsidian_dir / "snippets"
    app_json_path = obsidian_dir / "app.json"
    snippet_target = snippets_dir / f"{SNIPPET_NAME}.css"

    # 1) 同步 snippet 到目标 vault
    snippets_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(snippet_source, snippet_target)

    # 2) 读取并备份 app.json
    app_data = read_json(app_json_path)
    backup_file(app_json_path)

    # 3) 启用 snippet（避免重复）
    enabled = app_data.get("enabledCssSnippets", [])
    if not isinstance(enabled, list):
        enabled = []
    if SNIPPET_NAME not in enabled:
        enabled.append(SNIPPET_NAME)
    app_data["enabledCssSnippets"] = enabled

    # 4) 设置自动切换：跟随系统浅/深色
    app_data["baseColorScheme"] = "adapt-to-system"

    # 5) 设置 Minimal 主题（你当前偏好）
    app_data["cssTheme"] = "Minimal"

    write_json(app_json_path, app_data)
    return True, f"已应用 -> {vault_path}"


def main() -> int:
    repo_root = Path(__file__).resolve().parent
    snippet_source = repo_root / "snippets" / f"{SNIPPET_NAME}.css"
    obsidian_global = Path.home() / "Library/Application Support/obsidian/obsidian.json"

    if not snippet_source.exists():
        print(f"错误：找不到 snippet 文件 -> {snippet_source}")
        return 2

    if not obsidian_global.exists():
        print(f"错误：找不到 Obsidian 全局配置 -> {obsidian_global}")
        return 2

    global_data = read_json(obsidian_global)
    vaults = global_data.get("vaults", {})
    if not isinstance(vaults, dict) or not vaults:
        print("未找到 vault 列表，未执行任何修改。")
        return 1

    success = 0
    for _, meta in vaults.items():
        path_text = meta.get("path") if isinstance(meta, dict) else None
        if not path_text:
            continue
        ok, msg = apply_to_vault(Path(path_text).expanduser(), snippet_source)
        print(msg)
        if ok:
            success += 1

    print(f"\n完成：{success} 个 vault 已应用全局主题。")
    print("请重启 Obsidian 或执行 Reload app without saving。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
