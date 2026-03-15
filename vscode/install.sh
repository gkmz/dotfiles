#!/bin/bash

# VSCode 系列 IDE 统一配置安装脚本
# 用途：创建软链接，将统一配置应用到所有 IDE

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 基础配置文件（所有 IDE 共用）
KEYBINDINGS_BASE="$SCRIPT_DIR/keybindings.json"
SETTINGS_BASE="$SCRIPT_DIR/settings.json"

# IDE 名称与目标配置目录（键：本仓库中的子目录名，值：IDE 的配置目录）
declare -A IDE_MAP=(
  ["kiro"]="$HOME/Library/Application Support/Kiro/User"
  ["cursor"]="$HOME/Library/Application Support/Cursor/User"
  ["trae"]="$HOME/Library/Application Support/Trae/User"
  ["antigravity"]="$HOME/Library/Application Support/Antigravity/User"
  ["vscode"]="$HOME/Library/Application Support/Code/User"
  ["windsurf"]="$HOME/Library/Application Support/Windsurf/User"
)

echo -e "${GREEN}=== VSCode 系列 IDE 统一配置安装 ===${NC}\n"

# 检查基础源文件是否存在
if [ ! -f "$KEYBINDINGS_BASE" ]; then
  echo -e "${RED}错误: keybindings.json 不存在${NC}"
  exit 1
fi

if [ ! -f "$SETTINGS_BASE" ]; then
  echo -e "${RED}错误: settings.json 不存在${NC}"
  exit 1
fi

# 函数：创建软链接
create_symlink() {
  local source=$1
  local target=$2
  local ide_name=$3
  
  # 如果目标文件存在且不是软链接，先备份
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    backup_file="${target}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}  备份原文件: $backup_file${NC}"
    cp "$target" "$backup_file"
  fi
  
  # 删除现有文件或软链接
  if [ -e "$target" ] || [ -L "$target" ]; then
    rm "$target"
  fi
  
  # 创建软链接
  ln -s "$source" "$target"
  echo -e "${GREEN}  ✓ 创建软链接成功${NC}"
}

# 遍历所有 IDE
for ide in "${!IDE_MAP[@]}"; do
  ide_dir_on_disk="${IDE_MAP[$ide]}"
  ide_src_dir="$SCRIPT_DIR/$ide"

  echo -e "${YELLOW}处理 $ide...${NC}"

  # 检查目标 IDE 配置目录是否存在
  if [ ! -d "$ide_dir_on_disk" ]; then
    echo -e "${YELLOW}  跳过: 目标目录不存在 -> $ide_dir_on_disk${NC}\n"
    continue
  fi

  # 提示如果 IDE 子目录还没有生成配置
  if [ ! -f "$ide_src_dir/settings.json" ] || [ ! -f "$ide_src_dir/keybindings.json" ]; then
    echo -e "${YELLOW}  警告: 未找到 $ide_src_dir 下的 settings.json 或 keybindings.json，"
    echo -e "        请先运行: python generate_ide_configs.py${NC}\n"
    continue
  fi

  # 创建 keybindings.json 软链接
  echo "  配置快捷键..."
  create_symlink "$ide_src_dir/keybindings.json" "$ide_dir_on_disk/keybindings.json" "$ide"

  # 创建 settings.json 软链接
  echo "  配置设置..."
  create_symlink "$ide_src_dir/settings.json" "$ide_dir_on_disk/settings.json" "$ide"

  echo ""
done

echo -e "${GREEN}=== 安装完成 ===${NC}"
echo -e "\n提示："
echo -e "  1. 所有 IDE 已链接到各自子目录下生成的 settings.json / keybindings.json"
echo -e "  2. 修改根目录下的基础配置或某个 IDE 子目录中的增量配置后，需重新运行:"
echo -e "       python generate_ide_configs.py && ./install.sh"
echo -e "  3. 原有配置已备份，文件名带 .backup 后缀"
echo -e "  4. 如需恢复，运行: ./uninstall.sh\n"
