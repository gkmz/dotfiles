local function parse_aihubmix_free_models()
  return {
    "coding-glm-5-turbo-free",
    "coding-glm-5-free",
    "coding-minimax-m2.7-free",
    "minimax-m2.5-free",
    "coding-minimax-m2.5-free",
    "gemini-3.1-flash-image-preview-free",
    "gemini-3-flash-preview-free",
    "gemini-2.0-flash-free",
    "gpt-4.1-free",
    "gpt-4.1-mini-free",
    "gpt-4.1-nano-free",
    "gpt-4o-free",
    "glm-4.7-flash-free",
    "coding-glm-4.7-free",
    "step-3.5-flash-free",
    "coding-minimax-m2.1-free",
    "kimi-for-coding-free",
    "mimo-v2-flash-free",
  }
end

local function pick_default_adapter()
  if vim.env.CODECOMPANION_DEFAULT_ADAPTER and vim.env.CODECOMPANION_DEFAULT_ADAPTER ~= "" then
    return vim.env.CODECOMPANION_DEFAULT_ADAPTER
  end

  -- If Ollama is available locally, prefer local DeepSeek R1 by default.
  if vim.fn.executable("ollama") == 1 then
    return "local_deepseek_r1"
  end

  return "aihubmix"
end

local default_adapter = pick_default_adapter()

local function open_chat_with(adapter, model)
  local cmd = "CodeCompanionChat adapter=" .. adapter
  if model and model ~= "" then
    cmd = cmd .. " model=" .. model
  end
  vim.cmd(cmd)
end

local function open_agent_cli(command)
  Snacks.terminal.open(command, {
    win = {
      position = "float",
      border = "rounded",
      width = 0.86,
      height = 0.86,
    },
    interactive = true,
  })
end

local function get_http_adapters()
  local ok, config = pcall(require, "codecompanion.config")
  if not ok or not config.adapters or not config.adapters.http then
    return {}
  end

  local adapters = {}
  for name, _ in pairs(config.adapters.http) do
    if name ~= "opts" and name ~= "http" and name ~= "acp" then
      table.insert(adapters, name)
    end
  end
  table.sort(adapters)
  return adapters
end

local function get_adapter_models(adapter_name)
  local ok_config, config = pcall(require, "codecompanion.config")
  if not ok_config or not config.adapters or not config.adapters.http then
    return {}, nil
  end

  local adapter_config = config.adapters.http[adapter_name]
  if not adapter_config then
    return {}, nil
  end

  local ok_adapter, adapter = pcall(require("codecompanion.adapters").resolve, adapter_config)
  if not ok_adapter or not adapter or adapter.type ~= "http" then
    return {}, nil
  end

  local model_schema = adapter.schema and adapter.schema.model or {}
  local choices = model_schema.choices
  if type(choices) == "function" then
    local ok_choices, result = pcall(choices, adapter, { async = false })
    choices = ok_choices and result or nil
  end

  local models = {}
  if type(choices) == "table" then
    if vim.islist(choices) then
      models = vim.deepcopy(choices)
    else
      for name, _ in pairs(choices) do
        table.insert(models, name)
      end
    end
  end

  if #models == 0 and type(model_schema.default) == "string" and model_schema.default ~= "" then
    table.insert(models, model_schema.default)
  end

  table.sort(models)
  return models, model_schema.default
end

local function pick_adapter_and_model()
  local adapters = get_http_adapters()
  if #adapters == 0 then
    vim.notify("CodeCompanion: no HTTP adapters available", vim.log.levels.WARN)
    return
  end

  vim.ui.select(adapters, { prompt = "Select provider (adapter)" }, function(adapter)
    if not adapter then
      return
    end

    local models, default_model = get_adapter_models(adapter)
    if #models == 0 then
      open_chat_with(adapter, nil)
      return
    end

    if default_model and default_model ~= "" then
      for i, model in ipairs(models) do
        if model == default_model then
          table.remove(models, i)
          break
        end
      end
      table.insert(models, 1, default_model)
    end

    vim.ui.select(models, { prompt = "Select model (" .. adapter .. ")" }, function(model)
      if not model then
        return
      end
      open_chat_with(adapter, model)
    end)
  end)
end

return {
  -- CodeCompanion with custom keys from env
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} },
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = { adapter = default_adapter },
        inline = { adapter = default_adapter },
      },
      prompt_library = {
        ["Document Code"] = {
          strategy = "chat",
          description = "Generate documentation comments for selected code",
          opts = {
            alias = "doc_comment",
            is_slash_cmd = true,
            auto_submit = true,
            modes = { "v" },
          },
          prompts = {
            {
              role = "user",
              content = [[请为选中的代码生成清晰、简洁、符合当前语言习惯的文档注释。

要求：
- 只输出建议添加或替换的注释和必要的最小代码片段。
- Go 使用 Go doc 风格，公开方法注释以标识符名称开头。
- Python 使用简洁 docstring，说明参数、返回值和异常边界。
- 不要改写业务逻辑。]],
            },
          },
        },
      },
      display = {
        chat = {
          window = {
            layout = "vertical", -- 垂直布局
            position = "right", -- 显示在右侧
          },
        },
      },
      adapters = {
        http = {
          opts = {
            show_presets = true,
            show_model_choices = true,
          },
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = "cmd:echo $OPENAI_API_KEY",
              },
            })
          end,
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = "cmd:echo ${ANTHROPIC_API_KEY:-$CLAUDE_API_KEY}",
              },
            })
          end,
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = "cmd:echo $GEMINI_API_KEY",
              },
            })
          end,
          aihubmix = function()
            local free_models = parse_aihubmix_free_models()
            local active_model = free_models[1]
            local active_index = 1
            for i, model in ipairs(free_models) do
              if model == active_model then
                active_index = i
                break
              end
            end

            local function is_quota_or_rate_error(data)
              if type(data) ~= "table" then
                return false
              end

              if data.status == 429 then
                return true
              end

              local body = type(data.body) == "string" and data.body:lower() or ""
              return body:find("quota", 1, true) ~= nil
                or body:find("insufficient", 1, true) ~= nil
                or body:find("rate limit", 1, true) ~= nil
                or body:find("too many requests", 1, true) ~= nil
            end

            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "aihubmix",
              formatted_name = "AIHubMix",
              env = {
                url = "cmd:echo ${AIHUBMIX_BASE_URL:-https://aihubmix.com/v1}",
                api_key = "cmd:echo ${AIHUBMIX_API_KEY:-$OPENAI_API_KEY}",
                chat_url = "/chat/completions",
                models_endpoint = "/models",
              },
              schema = {
                model = {
                  default = active_model,
                  choices = free_models,
                },
              },
              handlers = {
                setup = function(self)
                  if self.opts and self.opts.stream then
                    self.parameters.stream = true
                    self.parameters.stream_options = { include_usage = true }
                  end
                  self.parameters.model = free_models[active_index]
                  self.schema.model.default = free_models[active_index]
                  return true
                end,
                on_exit = function(self, data)
                  if is_quota_or_rate_error(data) and #free_models > 1 then
                    local previous = free_models[active_index]
                    active_index = (active_index % #free_models) + 1
                    local next_model = free_models[active_index]
                    vim.schedule(function()
                      vim.notify(
                        string.format("AIHubMix免费模型已从 %s 切换到 %s", previous, next_model),
                        vim.log.levels.WARN
                      )
                    end)
                  end
                  return require("codecompanion.adapters.http.openai").handlers.on_exit(self, data)
                end,
              },
            })
          end,
          deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              schema = {
                model = {
                  default = "deepseek-chat",
                  choices = {
                    ["deepseek-chat"] = { opts = { can_use_tools = true } },
                    ["deepseek-reasoner"] = { opts = { can_reason = true, can_use_tools = false } },
                  },
                },
              },
              env = {
                api_key = "cmd:echo $DEEPSEEK_API_KEY",
              },
            })
          end,
          local_deepseek_r1 = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "local_deepseek_r1",
              formatted_name = "Local DeepSeek R1",
              env = {
                url = function()
                  return vim.env.OLLAMA_HOST or "http://127.0.0.1:11434"
                end,
              },
              schema = {
                model = {
                  default = vim.env.LOCAL_DEEPSEEK_R1_MODEL or "deepseek-r1:latest",
                  choices = {
                    ["deepseek-r1:latest"] = { opts = { can_reason = true, can_use_tools = true } },
                    ["deepseek-r1:70b"] = { opts = { can_reason = true, can_use_tools = true } },
                    ["deepseek-r1:32b"] = { opts = { can_reason = true, can_use_tools = true } },
                    ["deepseek-r1:14b"] = { opts = { can_reason = true, can_use_tools = true } },
                    ["deepseek-r1:8b"] = { opts = { can_reason = true, can_use_tools = true } },
                  },
                },
              },
            })
          end,
          doubao = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "doubao",
              formatted_name = "Doubao (ARK)",
              env = {
                url = "cmd:echo ${DOUBAO_BASE_URL:-https://ark.cn-beijing.volces.com/api/v3}",
                api_key = "cmd:echo ${ARK_API_KEY:-$DOUBAO_API_KEY}",
                chat_url = "/chat/completions",
                models_endpoint = "/models",
              },
            })
          end,
          minimax = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "minimax",
              formatted_name = "MiniMax",
              env = {
                -- url = "cmd:echo ${MINIMAX_BASE_URL:-https://api.minimax.io/v1}",
                url = "cmd:echo ${MINIMAX_BASE_URL:-https://api.minimaxi.com/v1}",
                api_key = "cmd:echo $MINIMAX_API_KEY",
                chat_url = "/chat/completions",
                models_endpoint = "/models",
              },
              schema = {
                model = {
                  default = "MiniMax-M2.5",
                  choices = {
                    "MiniMax-M2.5",
                    "MiniMax-M2.5-highspeed",
                    "MiniMax-M2.1",
                    "MiniMax-M2.1-highspeed",
                    "MiniMax-M2",
                  },
                },
              },
            })
          end,
          kimi = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "kimi",
              formatted_name = "Kimi",
              env = {
                url = "https://api.moonshot.cn/v1",
                api_key = "cmd:echo $MOONSHOT_API_KEY",
                chat_url = "/chat/completions",
                models_endpoint = "/models",
              },
              schema = {
                model = {
                  default = "kimi-k2-0905-preview",
                  choices = {
                    "kimi-k2-0905-preview",
                    "kimi-k2-turbo-preview",
                    "kimi-thinking-preview",
                    "kimi-latest",
                  },
                },
              },
            })
          end,
          glm = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "glm",
              formatted_name = "GLM (Zhipu)",
              env = {
                url = "https://open.bigmodel.cn/api/paas/v4",
                api_key = "cmd:echo $ZHIPUAI_API_KEY",
                chat_url = "/chat/completions",
                models_endpoint = "/models",
              },
              schema = {
                model = {
                  default = "glm-4.5",
                  choices = {
                    "glm-4.5",
                    "glm-4.5-air",
                    "glm-4.5-flash",
                    "glm-4.5v",
                  },
                },
              },
            })
          end,
        },
        acp = {
          opts = {
            show_presets = false,
          },
        },
      },
    },
    keys = {
      { "<A-a>", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
      { "<leader>a", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      {
        "<leader>as",
        function()
          pick_adapter_and_model()
        end,
        mode = { "n", "v" },
        desc = "Chat: Select provider/model",
      },
      {
        "<leader>al",
        function()
          open_chat_with("local_deepseek_r1", vim.env.LOCAL_DEEPSEEK_R1_MODEL or "deepseek-r1:latest")
        end,
        mode = { "n", "v" },
        desc = "Chat: Local deepseek-r1",
      },
      { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", mode = "n", desc = "Explain code" },
      { "<leader>ae", ":CodeCompanion /explain<cr>", mode = "v", desc = "Explain selection" },
      { "<leader>ar", "<cmd>CodeCompanion /fix<cr>", mode = "n", desc = "Fix/refactor code" },
      { "<leader>ar", ":CodeCompanion /fix<cr>", mode = "v", desc = "Fix/refactor selection" },
      { "<leader>at", "<cmd>CodeCompanion /tests<cr>", mode = "n", desc = "Generate tests" },
      { "<leader>at", ":CodeCompanion /tests<cr>", mode = "v", desc = "Generate tests for selection" },
      { "<leader>ad", ":CodeCompanion /doc_comment<cr>", mode = "v", desc = "Generate doc comments" },
      { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to AI Chat" },
      {
        "<leader>ac",
        function()
          open_agent_cli("claude")
        end,
        desc = "Open Claude CLI",
      },
      {
        "<leader>ax",
        function()
          open_agent_cli("codex")
        end,
        desc = "Open Codex CLI",
      },
    },
  },
}
