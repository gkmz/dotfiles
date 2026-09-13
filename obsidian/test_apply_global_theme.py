"""全局主题脚本的回归测试。"""

import importlib.util
import json
from pathlib import Path
import tempfile
import unittest


SCRIPT = Path(__file__).with_name("apply_global_theme.py")
spec = importlib.util.spec_from_file_location("apply_global_theme", SCRIPT)
module = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(module)


class ApplyGlobalThemeTest(unittest.TestCase):
    def test_apply_to_vault_writes_appearance_json_only(self) -> None:
        """主题设置应写入 appearance.json，而不是被 Obsidian 忽略的 app.json。"""
        with tempfile.TemporaryDirectory() as temp_dir:
            tmp_path = Path(temp_dir)
            vault = tmp_path / "vault"
            obsidian = vault / ".obsidian"
            obsidian.mkdir(parents=True)
            app_path = obsidian / "app.json"
            app_path.write_text('{"attachmentFolderPath":"assets"}\n', encoding="utf-8")
            appearance_path = obsidian / "appearance.json"
            appearance_path.write_text(
                json.dumps({"theme": "system", "enabledCssSnippets": ["existing"]}),
                encoding="utf-8",
            )
            snippet = tmp_path / "minimal-ai-global.css"
            snippet.write_text("body { color: red; }\n", encoding="utf-8")

            self.assertTrue(module.apply_to_vault(vault, snippet)[0])

            self.assertEqual(
                json.loads(app_path.read_text(encoding="utf-8")),
                {"attachmentFolderPath": "assets"},
            )
            appearance = json.loads(appearance_path.read_text(encoding="utf-8"))
            self.assertEqual(appearance["cssTheme"], "Minimal")
            self.assertEqual(appearance["baseColorScheme"], "adapt-to-system")
            self.assertEqual(
                appearance["enabledCssSnippets"], ["existing", "minimal-ai-global"]
            )


if __name__ == "__main__":
    unittest.main()
