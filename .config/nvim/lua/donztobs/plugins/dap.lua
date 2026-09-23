return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")

      local function get_php_adapter_path()
        local base_path = vim.fn.stdpath("data") .. "/mason/packages/"
        local possible_paths = {
          base_path .. "php-debug-adapter/extension/out/phpDebug.js",
          base_path .. "php-debug-adapter/out/phpDebug.js",
        }
        for _, path in ipairs(possible_paths) do
          if vim.fn.filereadable(path) == 1 then
            return path
          end
        end
        return possible_paths[1]
      end

      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { get_php_adapter_path() },
      }

      -- Helper function to get the correct local path mapping
      local function get_local_path()
        local cwd = vim.fn.getcwd()
        -- Check if we're in the main project directory
        if cwd:match("/Projects/main$") then
          -- If in root, map to impulse by default
          return "/home/lukan.oluwatobi/Projects/main/www/impulse"
        elseif cwd:match("/www/impulse") then
          return cwd
        elseif cwd:match("/www/meine") then
          return "/home/lukan.oluwatobi/Projects/main/www/meine"
        elseif cwd:match("/www/shop") then
          return "/home/lukan.oluwatobi/Projects/main/www/shop"
        else
          -- Fallback to current working directory
          return cwd
        end
      end

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "🔴 Listen for Xdebug (Local)",
          port = 9003,
        },
        {
          type = "php",
          request = "launch",
          name = "🐋 Docker: Impulse",
          port = 9003,
          pathMappings = {
            ["/var/www/html"] = "/home/lukan.oluwatobi/Projects/main/www/impulse",
          },
        },
        {
          type = "php",
          request = "launch",
          name = "🐋 Docker: Meine",
          port = 9003,
          pathMappings = {
            ["/var/www/html"] = "/home/lukan.oluwatobi/Projects/main/www/meine",
          },
        },
        {
          type = "php",
          request = "launch",
          name = "🐋 Docker: Shop",
          port = 9003,
          pathMappings = {
            ["/var/www/html"] = "/home/lukan.oluwatobi/Projects/main/www/shop",
          },
        },
        {
          type = "php",
          request = "launch",
          name = "🐋 Docker: Auto-detect",
          port = 9003,
          pathMappings = function()
            return {
              ["/var/www/html"] = get_local_path(),
            }
          end,
        },
      }

      vim.keymap.set("n", "<leader>dr", function() require("dap").continue() end, { desc = "▶️ Run/Continue (Start Listening)" })
      vim.keymap.set("n", "<leader>ds", function() require("dap").step_over() end, { desc = "⏭️ Step Over" })
      vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "⬇️ Step Into" })
      vim.keymap.set("n", "<leader>do", function() require("dap").step_out() end, { desc = "⬆️ Step Out" })
      vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "🔴 Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function() 
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "🔴 Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dk", function() require("dap.ui.widgets").hover() end, { desc = "💬 Hover" })
      vim.keymap.set("n", "<leader>dl", function() require("dap").run_last() end, { desc = "🔁 Run Last" })
      vim.keymap.set("n", "<leader>de", function() require("dapui").eval() end, { desc = "📝 Eval" })
      vim.keymap.set("n", "<leader>dt", function() require("dap").terminate() end, { desc = "⏹️ Terminate" })
      vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "🔄 Toggle UI" })

      -- TypeScript / JavaScript (via js-debug-adapter)
      local js_debug_path = vim.fn.stdpath("data")
        .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path, "${port}" },
        },
      }

      local js_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
      for _, language in ipairs(js_languages) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "🚀 Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "🔗 Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- TypeScript: run `tsc --build` before launching (VS Code preLaunchTask equivalent)
      local function build_ts()
        local local_tsc = vim.fn.getcwd() .. "/node_modules/.bin/tsc"
        local cmd
        if vim.fn.executable(local_tsc) == 1 then
          -- prefer the project's own TypeScript version
          cmd = { local_tsc, "--build", "tsconfig.json" }
        elseif vim.fn.executable("tsc") == 1 then
          -- globally installed TypeScript
          cmd = { "tsc", "--build", "tsconfig.json" }
        else
          -- avoid npm's decoy `tsc` package
          cmd = { "npx", "--yes", "--package", "typescript", "tsc", "--build", "tsconfig.json" }
        end
        local out = vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 then
          vim.notify("tsc build failed:\n" .. out, vim.log.levels.ERROR)
          return dap.ABORT
        end
        vim.notify("tsc build succeeded", vim.log.levels.INFO)
        return "tsc: build - tsconfig.json"
      end

      for _, language in ipairs({ "typescript", "typescriptreact" }) do
        table.insert(dap.configurations[language], {
          type = "pwa-node",
          request = "launch",
          name = "🚀 Launch TS (tsc build first)",
          program = function()
            local rel = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
            local dist = rel:gsub("^src/", "dist/"):gsub("%.tsx?$", ".js")
            return vim.fn.getcwd() .. "/" .. dist
          end,
          outFiles = { "${workspaceFolder}/dist/**/*.js" },
          sourceMaps = true,
          cwd = "${workspaceFolder}",
          preLaunchTask = build_ts,
        })
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "php-debug-adapter",
        "js-debug-adapter",
      },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = "mfussenegger/nvim-dap",
    opts = {},
  },
}