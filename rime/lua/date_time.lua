-- 动态日期时间翻译器：在全拼方案里输入指定编码时，由 Lua 生成候选（需鼠须管内置 librime-lua）
-- 文件须位于用户目录 lua/date_time.lua，且 schema 中注册 lua_translator@date_time

local function make_candidate(kind, seg, text, comment)
  local cand = Candidate(kind, seg.start, seg._end, text, comment)
  -- 提高质量，尽量避免被拼音缩写候选淹没
  cand.quality = 10000
  return cand
end

local function is_match(input, a, b)
  return input == a or input == b
end

local function translator(input, seg)
  -- 为避免与拼音缩写冲突，支持三套触发：
  -- 1) 传统：rq/sj(st)/dt/xq
  -- 2) 分号前缀：;rq/;sj/;st/;dt/;xq（在半角标点下最直观）
  -- 3) 纯字母前缀：zrq/zsj/zst/zdt/zxq（不受全角/半角标点影响）

  -- rq：日期
  if is_match(input, "rq", ";rq") or input == "zrq" then
    yield(make_candidate("date", seg, os.date("%Y-%m-%d"), "日期"))
    yield(make_candidate("date", seg, os.date("%Y年%m月%d日"), "日期"))
    return
  end

  -- sj/st：时间（兼容你习惯的 st）
  if is_match(input, "sj", ";sj") or is_match(input, "st", ";st")
    or input == "zsj" or input == "zst" then
    yield(make_candidate("time", seg, os.date("%H:%M"), "时间"))
    yield(make_candidate("time", seg, os.date("%H:%M:%S"), "时间"))
    return
  end

  -- dt：日期时间合一
  if is_match(input, "dt", ";dt") or input == "zdt" then
    yield(make_candidate("datetime", seg, os.date("%Y-%m-%d %H:%M"), "日期时间"))
    yield(make_candidate("datetime", seg, os.date("%Y-%m-%d %H:%M:%S"), "日期时间"))
    return
  end

  -- xq：星期（os.date("%w")：0=周日 … 6=周六）
  if is_match(input, "xq", ";xq") or input == "zxq" then
    local w = tonumber(os.date("%w")) or 0
    local names = { "日", "一", "二", "三", "四", "五", "六" }
    yield(make_candidate("week", seg, "星期" .. names[w + 1], "星期"))
    return
  end
end

return translator
