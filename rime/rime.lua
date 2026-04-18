-- Rime Lua 入口文件（关键）
-- 原因：lua_translator@xxx 在多数 librime-lua 配置中需要在此注册全局函数名。
-- 若缺少该文件，schema 里虽写了 lua_translator@date_time，输入 rq/sj/dt/xq 仍可能无候选。

-- 将 lua/date_time.lua 返回的翻译函数注册为 date_time
date_time = require("date_time")
