# 快速开始

## 一键安装

```bash
cd ~/dotfiles/vscode
./install.sh
```

这会自动：
1. 备份你现有的配置
2. 创建软链接到所有 IDE
3. 应用统一配置

Windows:

```powershell
cd $HOME\dotfiles\vscode
pwsh -ExecutionPolicy Bypass -File .\install.ps1
```

## 验证安装

安装后，打开任意一个 IDE（Kiro、Cursor、Trae 等），按 macOS 的 `Cmd + 1` 或 Windows 的 `Ctrl + 1`：
- 第一次按：显示 Explorer 并定位到当前文件
- 再次按：关闭 Explorer

## 修改配置

直接编辑这个目录下的文件：
- `keybindings.json` - 快捷键配置
- `settings.json` - 编辑器设置

保存后，所有 IDE 会自动同步（可能需要重启 IDE）。

## 添加新的快捷键

编辑 `keybindings.json`，添加你的配置：

```json
{
  "key": "cmd+shift+f",
  "command": "你的命令",
  "when": "条件"
}
```

## 卸载

如果需要恢复各 IDE 的独立配置：

```bash
./uninstall.sh
```

## 同步到其他机器

1. 克隆这个仓库
2. 进入 `~/dotfiles/vscode`（Windows 为 `$HOME\dotfiles\vscode`）
3. 运行 `./install.sh` 或 `.\install.ps1`
4. 完成！

## 常见问题

### Q: 修改配置后没有生效？
A: 重启对应的 IDE。

### Q: 某个 IDE 需要特殊配置怎么办？
A: 可以在对应 IDE 的 User 目录下创建额外的配置文件，它会和软链接的配置合并。

### Q: 如何查看软链接是否创建成功？
A: macOS/Linux 运行 `ls -la ~/Library/Application\ Support/Kiro/User/` 查看；Windows 运行 `dir $env:APPDATA\Kiro\User` 查看，软链接会显示目标路径。
