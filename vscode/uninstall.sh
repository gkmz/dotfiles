#!/bin/bash

# VSCode 系列 IDE 统一配置卸载脚本
# 用途：删除软链接，恢复各 IDE 的独立配置

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# IDE 配置目录列表
declare -a IDE_DIRS=(
  "$HOME/Library/Application Support/Kiro/User"
  "$HOME/Library/Application Support/Cursor/User"
  "$HOME/Library/Application Support/Trae/User"
  "$HOME/Library/Application Support/Antigravity/User"
  "$HOME/Library/Application Support/Code/User"
)

echo -e "${GREEN}=== VSCode 系列 IDE 统一配置卸载 ===${NC}\n"

# 函数：删除软链接
remove_symlink() {
  local target=$1
  local ide_name=$2
  
  if [ -L "$target" ]; then
    rm "$target"
    echo -e "${GREEN}  ✓ 删除软链接成功${NC}"
    
    # 查找最新的备份文件
    backup_dir=$(dirname "$target")
    backup_file=$(ls -t "$backup_dir"/$(basename "$target").backup.* 2>/dev/null | head -1)
    
    if [ -n "$backup_file" ]; then
      echo -e "${YELLOW}  提示: 发现备份文件 $(basename "$backup_file")${NC}"
      echo -e "${YELLOW}  如需恢复，运行: cp \"$backup_file\" \"$target\"${NC}"
    fi
  elif [ -f "$target" ]; then
    echo -e "${YELLOW}  跳过: 不是软链接（可能是独立配置）${NC}"
  else
    echo -e "${YELLOW}  跳过: 文件不存在${NC}"
  fi
}

# 遍历所有 IDE 目录
for ide_dir in "${IDE_DIRS[@]}"; do
  ide_name=$(basename "$(dirname "$ide_dir")")
  
  echo -e "${YELLOW}处理 $ide_name...${NC}"
  
  # 检查目录是否存在
  if [ ! -d "$ide_dir" ]; then
    echo -e "${YELLOW}  跳过: 目录不存在${NC}\n"
    continue
  fi
  
  # 删除 keybindings.json 软链接
  echo "  删除快捷键配置..."
  remove_symlink "$ide_dir/keybindings.json" "$ide_name"
  
  # 删除 settings.json 软链接
  echo "  删除设置配置..."
  remove_symlink "$ide_dir/settings.json" "$ide_name"
  
  echo ""
done

echo -e "${GREEN}=== 卸载完成 ===${NC}"
echo -e "\n提示："
echo -e "  1. 所有软链接已删除"
echo -e "  2. 各 IDE 现在使用独立配置"
echo -e "  3. 如需恢复原配置，请从备份文件复制\n"
