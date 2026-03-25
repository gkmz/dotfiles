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
        chat = { adapter = "aihubmix" },
        inline = { adapter = "aihubmix" },
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
      { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to AI Chat" },
      {
        "<leader>ac",
        function()
          Snacks.terminal.open("claude", {
            win = {
              position = "float",
              border = "rounded",
              width = 0.8,
              height = 0.8,
            },
            interactive = true,
          })
        end,
        desc = "Open ClaudeCode",
      },
    },
  },
}
