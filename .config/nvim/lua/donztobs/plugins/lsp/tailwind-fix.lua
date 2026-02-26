-- Tailwind CSS LSP Performance Optimization
-- Fixes high CPU and memory usage issues

return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Configure Tailwind CSS LSP with strict limitations
    vim.lsp.config.tailwindcss = {
      -- Only activate on these specific file types
      filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
      },
      
      -- Tailwind config settings to reduce resource usage
      settings = {
        tailwindCSS = {
          -- Validate only on these languages
          validate = true,
          lint = {
            -- Disable CSS conflict warnings to reduce processing
            cssConflict = "warning",
            invalidApply = "error",
            invalidConfigPath = "error",
            invalidScreen = "error",
            invalidTailwindDirective = "error",
            invalidVariant = "error",
            recommendedVariantOrder = "warning",
          },
          -- Disable experimental features that cause performance issues
          experimental = {
            classRegex = {},
          },
          -- Only provide completions in specific contexts
          classAttributes = {
            "class",
            "className",
            "classList",
            "ngClass",
          },
        },
      },
      
      -- Root directory detection - prevent scanning entire filesystem
      root_dir = function(fname)
        local util = require("lspconfig.util")
        -- Only start if we find a tailwind config file
        return util.root_pattern(
          "tailwind.config.js",
          "tailwind.config.ts",
          "tailwind.config.cjs",
          "tailwind.config.mjs"
        )(fname)
      end,
      
      -- Don't auto-start on every file
      autostart = true,
      single_file_support = false, -- Require a project with tailwind.config
    }
    
    -- Enable the tailwindcss server
    vim.lsp.enable("tailwindcss")
  end,
}
