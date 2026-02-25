#!/bin/bash

# 导出 VSCode 系列 IDE 已安装的插件列表

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="exported-extensions"

echo -e "${GREEN}=== 导出插件列表 ===${NC}\n"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 函数：导出单个 IDE 的插件列表
export_extensions() {
  local ide_name=$1
  local command=$2
  local output_file="$OUTPUT_DIR/${ide_name}-extensions-${TIMESTAMP}.txt"
  
  echo -e "${YELLOW}导出 $ide_name 插件列表...${NC}"
  
  # 检查命令是否存在
  if ! command -v "$command" &> /dev/null; then
    echo -e "${YELLOW}  跳过: $command 命令不存在${NC}\n"
    return
  fi
  
  # 导出插件列表
  echo "# $ide_name 插件列表" > "$output_file"
  echo "# 导出时间: $(date)" >> "$output_file"
  echo "" >> "$output_file"
  
  $command --list-extensions >> "$output_file" 2>/dev/null || {
    echo -e "${YELLOW}  警告: 导出失败${NC}\n"
    return
  }
  
  local count=$(grep -v "^#" "$output_file" | grep -v "^$" | wc -l | tr -d ' ')
  echo -e "${GREEN}  ✓ 导出成功: $count 个插件${NC}"
  echo -e "  文件: $output_file\n"
}

# 导出各个 IDE 的插件
export_extensions "Kiro" "kiro"
export_extensions "Cursor" "cursor"
export_extensions "VSCode" "code"

# 注意：Trae 和 Antigravity 可能没有命令行工具，需要手动导出

echo -e "${GREEN}=== 导出完成 ===${NC}"
echo -e "\n提示："
echo -e "  1. 导出的文件位于 $OUTPUT_DIR 目录"
echo -e "  2. 可以对比这些文件，整理到 my-extensions.md"
echo -e "  3. Trae 和 Antigravity 可能需要手动导出\n"
