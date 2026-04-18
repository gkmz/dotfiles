-- 偏旁/部首词库动态翻译器（词库驱动，不硬编码）
-- 数据源：~/Library/Rime/radical_lookup.dict.yaml
-- 触发：z 开头，例如 zps -> 亻

local cache = nil

local function get_rime_dir()
  return os.getenv("HOME") .. "/Library/Rime"
end

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function load_dict()
  if cache ~= nil then
    return cache
  end

  local map = {}
  local path = get_rime_dir() .. "/radical_lookup.dict.yaml"
  local f = io.open(path, "r")
  if not f then
    cache = map
    return cache
  end

  local in_body = false
  for line in f:lines() do
    if line == "..." then
      in_body = true
    elseif in_body then
      local raw = trim(line)
      if raw ~= "" and raw:sub(1, 1) ~= "#" then
        local text, code = raw:match("^([^\t]+)\t([^\t]+)")
        if text and code then
          if not map[code] then
            map[code] = {}
          end
          table.insert(map[code], text)
        end
      end
    end
  end
  f:close()

  cache = map
  return cache
end

local function make_candidate(seg, text, comment)
  local cand = Candidate("radical_lookup", seg.start, seg._end, text, comment)
  cand.quality = 12000
  return cand
end

local function translator(input, seg)
  if input:sub(1, 1) ~= "z" then
    return
  end

  local dict = load_dict()
  local exact = dict[input]
  if exact then
    for i, text in ipairs(exact) do
      yield(make_candidate(seg, text, "部首 " .. input .. " #" .. i))
    end
    return
  end

  -- 前缀联想：打到一半也给候选
  for code, items in pairs(dict) do
    if code:sub(1, #input) == input then
      for _, text in ipairs(items) do
        yield(make_candidate(seg, text, "部首 " .. code))
      end
    end
  end
end

return translator
