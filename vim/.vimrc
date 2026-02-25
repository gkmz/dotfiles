"=============================================================================
" Vim 快捷键配置文件
" 从 Neovim 配置转换而来
"=============================================================================

" 设置 leader 键为空格 (默认)
let mapleader = " "

"=============================================================================
" DAP 调试快捷键 (需要安装 nvim-dap 插件)
"=============================================================================
" 注意: 以下快捷键需要安装对应的调试插件才能使用
" nnoremap <F7> :call dap#step_into()<CR>
" nnoremap <F8> :call dap#step_over()<CR>
" nnoremap <F9> :call dap#step_out()<CR>
" nnoremap <F10> :call dap#continue()<CR>

"=============================================================================
" 通用快捷键
"=============================================================================

" 快速退出
nnoremap <leader>qc :q<CR>

" 行首/行尾快速跳转
nnoremap gh ^
vnoremap gh ^
nnoremap gl $
vnoremap gl $

" 快速注释 (需要安装 vim-commentary 插件)
" nnoremap <M-/> :Commentary<CR>
" vnoremap <M-/> :Commentary<CR>

" NeoTree 相关 (需要安装 neo-tree 插件)
" nnoremap <leader>Nn :Neotree reveal<CR>:set relativenumber<CR>
" nnoremap <leader>Nc :Neotree reveal<CR>:set relativenumber 0<CR>

" IDEA 风格的快捷键
" 复制当前行
nnoremap <M-d> yyP
" 删除当前行
nnoremap <M-x> dd

"=============================================================================
" Dashboard 快捷键 (需要安装 dashboard-nvim 插件)
"=============================================================================
" nnoremap <leader>; :Dashboard<CR>

"=============================================================================
" Zen Mode (需要安装 zen-mode 插件)
"=============================================================================
" nnoremap <C-z> :ZenMode<CR>

"=============================================================================
" REST HTTP 快捷键 (需要安装 rest-nvim 插件)
"=============================================================================
" nnoremap <leader>he :lua require('telescope').extensions.rest.select_env()<CR>
" nnoremap <leader>hr :Rest run<CR>
" nnoremap <leader>hl :Rest run last<CR>

"=============================================================================
" Go 语言快捷键 (需要安装 vim-go 或 go.nvim 插件)
"=============================================================================
" nnoremap <leader>Gd :GoDebugTest<CR>
" nnoremap <leader>Gi :GoInstallDeps<CR>
" nnoremap <leader>Gt :GoMod tidy<CR>
" nnoremap <leader>Ga :GoTestAdd<CR>
" nnoremap <leader>GA :GoTestsAll<CR>
" nnoremap <leader>Ge :GoTestsExp<CR>
" nnoremap <leader>Gg :GoGenerate<CR>
" nnoremap <leader>GG :GoGenerate %<CR>
" nnoremap <leader>Gc :GoCmt<CR>
" nnoremap <leader>GI :GoImpl<CR>

"=============================================================================
" 窗口管理快捷键
"=============================================================================

" 调整窗口大小
nnoremap <M-Up> :resize -5<CR>
nnoremap <M-Down> :resize +5<CR>
nnoremap <M-Left> :vertical resize +10<CR>
nnoremap <M-Right> :vertical resize -10<CR>

" 使用 Alt+JKHL 调整窗口大小
nnoremap <M-J> :resize -5<CR>
nnoremap <M-K> :resize +5<CR>
nnoremap <M-H> :vertical resize +10<CR>
nnoremap <M-L> :vertical resize -10<CR>

" 使用 leader + 方向键快速切换窗口
nnoremap <leader><Up> <C-w>k
nnoremap <leader><Down> <C-w>j
nnoremap <leader><Left> <C-w>h
nnoremap <leader><Right> <C-w>l

"=============================================================================
" Buffer 管理快捷键 (需要安装 bufferline 插件)
"=============================================================================
" nnoremap <leader>bs :BufferLinePick<CR>

"=============================================================================
" 代码片段快捷键 (需要安装 scissor 或类似插件)
"=============================================================================
" nnoremap <leader>pa :ScissorsAddNewSnippet<CR>
" nnoremap <leader>pe :ScissorsEditSnippet<CR>
" vnoremap <leader>pA :'<,'>ScissorsAddNewSnippet<CR>

"=============================================================================
" 翻译快捷键 (需要安装 translate.nvim 插件)
"=============================================================================
" nnoremap te :Translate EN<CR>
" nnoremap tz :Translate ZH<CR>
" nnoremap tw viw:Translate ZH<CR>

"=============================================================================
" Markdown 快捷键 (需要安装 render-markdown 插件)
"=============================================================================
" nnoremap <Leader>uM :call ToggleMarkdownRender()<CR>

"=============================================================================
" TypeScript LSP 快捷键 (需要安装 vtsls 或 coc-tsserver)
"=============================================================================
" nnoremap gD :VtsExecuteCommand goto_source_definition<CR>
" nnoremap gR :VtsExecuteCommand file_references<CR>
" nnoremap <leader>co :VtsExecuteCommand organize_imports<CR>
" nnoremap <leader>cM :VtsExecuteCommand add_missing_imports<CR>
" nnoremap <leader>cu :VtsExecuteCommand remove_unused_imports<CR>
" nnoremap <leader>cD :VtsExecuteCommand fix_all<CR>
" nnoremap <leader>cV :VtsExecuteCommand select_ts_version<CR>

"=============================================================================
" Diffview 快捷键 (需要安装 diffview.nvim 插件)
"=============================================================================
" nnoremap <leader>gdc :DiffviewOpen origin/main...HEAD<CR>
" nnoremap <leader>gdq :DiffviewClose<CR>
" nnoremap <leader>gdh :DiffviewFileHistory %<CR>
" nnoremap <leader>gdH :DiffviewFileHistory<CR>
" nnoremap <leader>gdm :DiffviewOpen<CR>
" nnoremap <leader>gdo :DiffviewOpen main<CR>
" nnoremap <leader>gdt :DiffviewOpen<CR>
" nnoremap <leader>gdp :DiffviewOpen origin/main...HEAD --imply-local<CR>
" nnoremap <leader>gdP :DiffviewFileHistory --range=origin/main...HEAD --right-only --no-merges --reverse<CR>

"=============================================================================
" 终端快捷键
"=============================================================================

" 切换终端 (需要安装 toggleterm 或类似插件)
" nnoremap <C-/> :ToggleTerm<CR>
" nnoremap <A-_> :ToggleTerm<CR>
" nnoremap <C-A-/> :ToggleTerm direction=horizontal<CR>
" nnoremap <C-A-_> :ToggleTerm direction=horizontal<CR>

" 终端模式下退出
" tnoremap <Esc><Esc> <C-\><C-n>

"=============================================================================
" Minimap 快捷键 (需要安装 neominimap 插件)
"=============================================================================
" nnoremap <Leader>umt :Neominimap toggle<CR>
" nnoremap <leader>umf :Neominimap toggleFocus<CR>
" nnoremap <leader>umw :Neominimap winToggle<CR>
" nnoremap <leader>umr :Neominimap winRefresh<CR>
" nnoremap <leader>umb :Neominimap bufToggle<CR>
" nnoremap <leader>uma :Neominimap bufRefresh<CR>

"=============================================================================
" Obsidian 快捷键 (需要安装 obsidian.nvim 插件)
"=============================================================================
" nnoremap <leader>os :ObsidianSearch<CR>
" nnoremap <leader>of :ObsidianQuickSwitch<CR>
" nnoremap <leader>on :ObsidianNew<CR>
" nnoremap <leader>ol :ObsidianQuickSwitch Learning.md<CR><CR>
" nnoremap <leader>og :ObsidianQuickSwitch Go.md<CR><CR>
" nnoremap <leader>ov :ObsidianQuickSwitch Neovim config.md<CR><CR>
" nnoremap <leader>oS :ObsidianOpen scratchpad<CR>
" nnoremap <leader>om :ObsidianNewMeeting<CR>

"=============================================================================
" 代码运行快捷键 (需要安装 code_runner 插件)
"=============================================================================
" nnoremap <leader>Rc :RunCode<CR>
" nnoremap <leader>RC :RunCode tab<CR>
" nnoremap <leader>Rf :RunFile<CR>
" nnoremap <leader>RF :RunFile tab<CR>
" nnoremap <leader>Rp :RunProject<CR>
" nnoremap <leader>Rx :RunClose<CR>
" nnoremap <leader>Rt :CRFiletype<CR>
" nnoremap <leader>Rs :CRProjects<CR>

"=============================================================================
" LSP 快捷键 (需要安装 coc.nvim 或 vim-lsp 插件)
"=============================================================================
" 代码操作
" nnoremap gra :call CocAction('codeAction')<CR>
" vnoremap gra :call CocAction('codeAction', 'selected')<CR>
" nnoremap grn :call CocAction('rename')<CR>
" nnoremap grr :call CocAction('references')<CR>

" 跳转
" nnoremap gd :call CocAction('jumpDefinition')<CR>
" nnoremap gI :call CocAction('jumpImplementation')<CR>
" nnoremap gy :call CocAction('jumpTypeDefinition')<CR>
" nnoremap <Leader>lG :call CocAction('workspaceSymbols')<CR>
" nnoremap <Leader>lR :call CocAction('references')<CR>
" nnoremap gr :call CocAction('references')<CR>

"=============================================================================
" 终端窗口导航 (终端模式下)
"=============================================================================
" tnoremap <C-H> <C-\><C-n><C-w>h
" tnoremap <C-J> <C-\><C-n><C-w>j
" tnoremap <C-K> <C-\><C-n><C-w>k
" tnoremap <C-L> <C-\><C-n><C-w>l
" tnoremap <Esc> <C-\><C-n>

"=============================================================================
" 注释说明
"=============================================================================
" 1. 所有注释掉的快捷键都是依赖于特定 Neovim 插件的
" 2. 如果你在 Vim 中安装了相应的替代插件，可以取消注释并调整命令
" 3. 基本快捷键（如窗口管理、行首行尾跳转等）已经启用
" 4. 建议使用 Vim 插件管理器（如 vim-plug, Pathogen, Vundle）来管理插件
"
" 推荐插件:
" - vim-commentary (注释)
" - vim-go (Go 语言支持)
" - coc.nvim (LSP 支持)
" - fzf.vim (模糊查找)
" - vim-fugitive (Git 集成)
"=============================================================================

