#!/usr/bin/env zsh

set -euo pipefail

repo_root="${0:A:h:h:h}"

# 提供自动建议控件桩，只验证配置是否绑定到正确的真实控件名称。
function test_autosuggest_accept() {}
zle -N autosuggest-accept test_autosuggest_accept

bindkey -e
for keymap in emacs viins; do
  bindkey -M "$keymap" '^R' fzf-history-widget
done
source "$repo_root/terminal/zsh/history-keybindings.zsh"

# 同时检查默认 Emacs 输入模式和可选的 Vi 插入模式，避免以后切换模式丢失快捷键。
for keymap in emacs viins; do
  [[ "$(bindkey -M "$keymap" '^F')" == '"^F" autosuggest-accept' ]]
  [[ "$(bindkey -M "$keymap" '^[f')" == '"^[f" forward-word' ]]
  [[ "$(bindkey -M "$keymap" '^P')" == '"^P" history-beginning-search-backward' ]]
  [[ "$(bindkey -M "$keymap" '^N')" == '"^N" history-beginning-search-forward' ]]
  [[ "$(bindkey -M "$keymap" '^R')" == '"^R" fzf-history-widget' ]]
done

print "OK: Zsh history suggestion keybindings are valid"
