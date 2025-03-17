-- local function prefer_bin_from_venv(executable_name)
--   local notifications = require("utils.defaults").notifications.python
--
--   -- global or local .venv
--   if vim.env.VIRTUAL_ENV then
--     local paths = vim.fn.glob(vim.env.VIRTUAL_ENV .. "/**/bin/" .. executable_name, true, true)
--     local venv_path = table.concat(paths, ", ")
--     if venv_path ~= "" and venv_path ~= nil then
--       notifications[executable_name].path = venv_path
--       return venv_path
--     end
--   end

--   -- exec file in mason
--   local mason_registry = require("mason-registry")
--   local mason_path = mason_registry.get_package(executable_name):get_install_path() .. "/venv/bin/" .. executable_name
--   if mason_path then
--     notifications[executable_name].path = mason_path
--     notifications[executable_name].warn = true
--     return mason_path
--   end
--
--   -- global exec file
--   local global_path = vim.fn.exepath(executable_name)
--   if global_path then
--     notifications[executable_name].path = global_path
--     notifications[global_path].warn = true
--     return global_path
--   end
--
--   return nil
-- end

-- local function find_debugpy_python_path()
--   local notifications = require("utils.defaults").notifications.python
--   if vim.env.VIRTUAL_ENV then
--     local paths = vim.fn.glob(vim.env.VIRTUAL_ENV .. "/**/debugpy", true, true)
--     if table.concat(paths, ", ") ~= "" then
--       local venv_path = vim.env.VIRTUAL_ENV .. "/bin/python"
--       notifications.debugpy.path = venv_path
--       return venv_path
--     end
--   end
--
--   local mason_registry = require("mason-registry")
--   local mason_path = mason_registry.get_package("debugpy"):get_install_path() .. "/venv/bin/python"
--   if mason_path then
--     notifications.debugpy.path = mason_path
--     notifications.debugpy.warn = true
--     return mason_path
--   end
--
--   return nil
-- end

local function find_python_executable()
  local notifications = require("utils.defaults").notifications.python
  if vim.fn.filereadable(".venv/bin/python") == 1 then
    local executable_path = vim.fn.expand(".venv/bin/python")
    notifications.python3.path = executable_path
    return executable_path
  elseif vim.env.VIRTUAL_ENV then
    local paths = vim.fn.glob(vim.env.VIRTUAL_ENV .. "/**/bin/python", true, true)
    local executable_path = table.concat(paths, ", ")
    if executable_path ~= "" then
      notifications.python3.path = executable_path
      return executable_path
    end
    return executable_path
  else
    local global_path = vim.fn.exepath("python3")
    if global_path then
      notifications.python3.path = global_path
      notifications.python3.warn = true
      return global_path
    end
  end

  return nil
end

local function notify_tooling(lang)
  local notifications = require("utils.defaults").notifications[lang]
  local infos = ""
  local warnings = ""
  local errors = ""
  for tool, info in pairs(notifications) do
    if type(info) == "table" then
      if info.path ~= nil then
        if info.warn == true then
          warnings = warnings
            .. "Using "
            .. tool
            .. " from Mason ("
            .. info.path
            .. "), consider installing it in your virtual environment.\n"
        else
          infos = infos .. "Using " .. tool .. ": " .. info.path .. "\n"
        end
      else
        errors = errors .. tool .. " not found.\n"
      end
    end
  end

  -- remove newline from end of strings
  infos = string.sub(infos, 1, -2)
  warnings = string.sub(warnings, 1, -2)
  errors = string.sub(errors, 1, -2)

  if infos ~= "" then
    vim.notify_once(infos, vim.log.levels.INFO)
  end
  if warnings ~= "" then
    vim.notify_once(warnings, vim.log.levels.WARN)
  end
  if errors ~= "" then
    vim.notify_once(errors, vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.py" },
  callback = function()
    local notifications = require("utils.defaults").notifications.python

    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.colorcolumn = "100"
    if not vim.g.python3_host_prog then
      notifications.python3.path = find_python_executable()
      vim.g.python3_host_prog = notifications.python3.path
    end

    if not notifications._emitted then
      notify_tooling("python")
      notifications._emitted = true
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    ft = { "python" },
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          {
            "williamboman/mason.nvim",
          },
        },
        opts = function(_, opts)
          -- local ruff_path = prefer_bin_from_venv("ruff")
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "basedpyright", "ruff" })
        end,
      },
    },
    opts = {
      servers = {
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
              },
            },
          },
        },
        basedpyright = {
          -- https://docs.basedpyright.com/#/settings
          settings = {
            basedpyright = {
              disableOrganizeImports = true, -- use ruff lsp for this instead
              analysis = {
                diagnosticMode = "openFilesOnly",
                -- uncomment this to ignore linting. Good for projects where basedpyright lights up as a christmas tree.
                ignore = { "*" },
                inlayHints = {
                  callArgumentNames = true,
                },
              },
            },
          },
        },
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          keys = {
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
          },
          -- https://docs.astral.sh/ruff/editors/
          on_attach = function(client, bufnr)
            if client.name == "ruff" then
              -- set to false to disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = true
            end
          end,
          init_options = {
            settings = {
              logLevel = "error",
              configurationPreference = "filesystemFirst",
              lineLength = 88,
              lint = {
                enabled = true,
              },
            },
          },
        },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    ft = { "python" },
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          args = { "--log-level", "DEBUG", "--color", "yes", "-vv", "-s" },
          dap = { justMyCode = false },
          python = ".venv/bin/python",
          -- Returns if a given file path is a test file.
          -- NB: This function is called a lot so don't perform any heavy tasks within it.
          is_test_file = function(file_path)
            return vim.fs.basename(file_path):match("test_") or vim.fs.basename(file_path):match("_test")
          end,
          -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
          -- instances for files containing a parametrize mark (default: false)
          pytest_discover_instances = false,
        },
      },
    },
  },

  {
    "andythigpen/nvim-coverage",
    ft = { "python" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      auto_reload = true,
      lang = {
        python = {
          coverage_file = vim.fn.getcwd() .. "/coverage.out",
        },
      },
    },
  },

  -- poetry-nvim plugin using when using poetry
  {
    "karloskar/poetry-nvim",
    ft = { "python" },
    config = function()
      require("poetry-nvim").setup()
    end,
  },
}
