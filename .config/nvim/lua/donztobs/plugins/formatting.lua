return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- Default: OFF
    vim.g.disable_autoformat = true

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier_css" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        php = { "phpcbf" },
        vue = { "prettier" },
      },
      formatters = {
        prettier = {
          prepend_args = { "--tab-width", "4" },
        },
        -- Custom prettier for CSS with 2-space indentation
        prettier_css = {
          inherit = true,
          prepend_args = { "--tab-width", "2" },
        },
        phpcbf = {
          prepend_args = { "--standard=PSR12" },
        },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return {
          timeout_ms = 3000,
          lsp_format = "fallback",
          callback = function(err, ctx)
            if not err then
              vim.notify("Formatted on save", vim.log.levels.INFO, { title = "Conform" })
            end
          end,
        }
      end,
    })

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      }, function(err)
        if not err then
          vim.notify("Formatted", vim.log.levels.INFO, { title = "Conform" })
        end
      end)
    end, { desc = "Format file or range (in visual mode)" })

    vim.keymap.set("n", "<leader>mt", function()
      if vim.g.disable_autoformat or vim.b.disable_autoformat then
        vim.cmd("FormatEnable")
        vim.notify("Format on save: ON", vim.log.levels.INFO, { title = "Conform" })
      else
        vim.cmd("FormatDisable")
        vim.notify("Format on save: OFF", vim.log.levels.INFO, { title = "Conform" })
      end
    end, { desc = "Toggle format on save" })
  end,
}
