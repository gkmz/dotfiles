# RTK.md

RTK 是 Codex 的上下文读取规则。目标是：先定位，再读取；先看摘要，再看细节；减少无关输出进入上下文。

## 基本原则

- 默认只读取完成当前任务所需的最小上下文。
- 不一开始全量读取 `backend/`、`frontend/`、`docs/`、`node_modules/`、`dist/`、`build/`、`vendor/`。
- 不主动读取 `.env`、密钥、token、cookie 等敏感内容。
- 修改代码前，必须读取相关真实源码片段，不能只依赖摘要。
- 如果摘要信息不足，继续读取精确行段或运行原生命令。

## 优先使用 rtk 命令

本机安装 `rtk` 时，优先用它压缩高噪声命令输出。

- 看目录：`rtk ls`、`rtk tree`
- 找文件：`rtk find . -name "*.go"`、`rtk find . -name "*.tsx"`
- 搜索代码：`rtk grep "keyword" path`
- 读文件摘要：`rtk read path/to/file`
- 看 Git 状态：`rtk git status`
- 看 Git 改动：`rtk git diff -- path/to/file`
- 看依赖：`rtk deps`
- 看 JSON：`rtk json path/to/file.json`
- 只看错误：`rtk err -- <command>`
- 跑测试摘要：`rtk test -- <command>`

## 精确读取规则

当需要实现、修改或审查代码时：

1. 先用 `rtk grep` 或 `rg` 定位相关文件和行号。
2. 再用 `sed -n 'start,endp' file` 读取精确片段。
3. 大文件不要一次性全文读取。
4. 如果 `rtk read` 过滤掉关键细节，改用精确行段读取。

## Go 项目默认入口

Go 后端任务优先定位这些文件：

- `go.mod`
- `cmd/*/main.go`
- `internal/router*`
- `internal/http*`
- `internal/handler*`
- `internal/service*`
- `internal/repository*`
- `internal/model*`
- `internal/config*`
- `migrations/*`

验证优先使用：

- `rtk go test ./...`
- `rtk err -- go test ./...`
- `rtk golangci-lint run`

## React 项目默认入口

React 前端任务优先定位这些文件：

- `package.json`
- `src/main.*`
- `src/App.*`
- `src/routes*`
- `src/pages/*`
- `src/components/*`
- `src/api/*`
- `src/styles/*`
- `vite.config.*`

验证优先使用：

- `rtk npm run build`
- `rtk pnpm build`
- `rtk tsc`
- `rtk lint`
- `rtk test -- npm test`
- `rtk playwright test`

## Figma 任务

涉及 Figma、设计稿还原或视觉一致性时：

- 先获取 Figma 设计上下文。
- 再读取项目现有组件、样式 token 和页面结构。
- 优先复用现有组件和样式系统。
- 实现后用浏览器或截图验证关键页面。

## Git 与提交前检查

查看改动优先使用：

- `rtk git status`
- `rtk git diff -- path/to/file`
- `rtk git diff --stat`

提交前如果需要精确确认补丁，可以查看相关文件的原始 `git diff`。

## 何时扩大上下文

只有这些情况才扩大读取范围：

- 当前模块依赖不清楚。
- 构建或测试失败需要定位。
- 改动涉及公共 API、数据库模型或跨模块流程。
- 用户要求全面审查。
- Figma 设计与现有实现差异较大。

扩大上下文时，先说明原因。
