-- LSP Performance Optimizations
-- Reduces memory usage and prevents freezing

return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Reduce LSP update frequency to prevent excessive processing
    vim.lsp.set_log_level("WARN") -- Reduce log verbosity
    
    -- Debounce LSP updates to reduce CPU usage
    vim.opt.updatetime = 300 -- Default is 4000ms, 300ms is a good balance
    
    -- Limit the number of items in completion menu
    vim.opt.pumheight = 15 -- Limit popup menu height
    
    -- Configure LSP handlers to be less aggressive
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
      max_width = 80,
      max_height = 20,
    })
    
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
      max_width = 80,
      max_height = 20,
    })
    
    -- Disable semantic tokens for better performance (optional)
    -- Uncomment if you still experience issues
    -- vim.lsp.handlers["textDocument/semanticTokens/full"] = function() end
    
    -- Auto-command to limit LSP diagnostics updates
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        
        -- Disable document formatting for Tailwind (use Prettier instead)
        if client and client.name == "tailwindcss" then
          client.server_capabilities.documentFormattingProvider = false
        end
        
        -- Limit Intelephense indexing for better performance
        if client and client.name == "intelephense" then
          -- Reduce file watching
          client.server_capabilities.workspace = {
            fileOperations = {
              didCreate = false,
              willCreate = false,
              didRename = false,
              willRename = false,
              didDelete = false,
              willDelete = false,
            },
          }
        end
      end,
    })
  end,
}
