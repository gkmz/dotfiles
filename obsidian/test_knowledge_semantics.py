import json
from pathlib import Path
import unittest


ROOT = Path(__file__).parent


class KnowledgeSemanticsTest(unittest.TestCase):
    def test_css_contains_semantic_and_print_rules(self):
        css = (ROOT / "snippets/knowledge-semantics.css").read_text(encoding="utf-8")
        for selector in ("language-text", "cm-lang-text", "@media print"):
            self.assertIn(selector, css)
        for size in ("1.55em", "1.35em", "1.20em", "1.08em", "1em", ".92em"):
            self.assertIn(size, css)
        self.assertIn("font-size: 0.92em", css)
        for color in ("#c13f76", "#f38ba8", "#b52f68"):
            self.assertIn(color, css)
        self.assertNotIn("strong", css)
        self.assertNotIn("internal-link", css)

    def test_notebook_enables_tokyo_night_semantics(self):
        appearance = json.loads((ROOT / "appearance.json").read_text(encoding="utf-8"))
        self.assertEqual(appearance["cssTheme"], "Tokyo Night")
        self.assertIn("knowledge-semantics", appearance["enabledCssSnippets"])
        self.assertNotIn("minimal-ai-global", appearance["enabledCssSnippets"])


if __name__ == "__main__":
    unittest.main()
