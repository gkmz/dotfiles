# 加载按命令前缀检索历史的 ZLE 控件。
autoload -Uz history-beginning-search-backward history-beginning-search-forward
zle -N history-beginning-search-backward
zle -N history-beginning-search-forward

# 同时覆盖当前默认模式和 Vi 插入模式，切换输入模式后仍保持一致操作。
for keymap in emacs viins; do
  # Ctrl-f 直接接受整条灰色建议；Alt-f 只接受到下一个单词边界。
  bindkey -M "$keymap" '^F' autosuggest-accept
  bindkey -M "$keymap" '^[f' forward-word

  # Ctrl-p/Ctrl-n 只浏览与当前已输入前缀匹配的历史命令。
  bindkey -M "$keymap" '^P' history-beginning-search-backward
  bindkey -M "$keymap" '^N' history-beginning-search-forward
done

unset keymap
