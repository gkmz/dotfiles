# Tokyo Night Knowledge Semantics Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a Tokyo Night-compatible semantic note style that remains readable in Obsidian and preserves meaning-bearing colors in exported PDFs.

**Architecture:** Keep Tokyo Night as the base theme and add one focused CSS snippet for Markdown semantics and print overrides. Update `appearance.json` to enable the new snippet and remove the Minimal-only snippet.

**Tech Stack:** Obsidian CSS snippets, JSON configuration, Python unittest.

## Global Constraints

- Reuse Tokyo Night variables where possible.
- Do not alter Mermaid layout rules.
- Include Chinese comments for key CSS sections.
- Keep PDF output warm-white, high-contrast, and color-preserving.

### Task 1: Add semantic CSS

**Files:**
- Create: `obsidian/snippets/knowledge-semantics.css`

- [ ] Add light/dark semantic color variables, Markdown selectors, and `@media print` rules.
- [ ] Run a CSS structural check for required selectors and print rules.

### Task 2: Update notebook configuration

**Files:**
- Modify: `obsidian/appearance.json`

- [ ] Remove `minimal-ai-global` from `enabledCssSnippets`.
- [ ] Add `knowledge-semantics` to `enabledCssSnippets`.
- [ ] Keep `cssTheme` set to `Tokyo Night`.
- [ ] Validate JSON.

### Task 3: Document and verify

**Files:**
- Modify: `obsidian/README.md`
- Create: `obsidian/test_knowledge_semantics.py`

- [ ] Document the new snippet and PDF behavior.
- [ ] Test required semantic selectors, print media rules, and configuration expectations.
- [ ] Run unittest, JSON parsing, and `git diff --check`.
