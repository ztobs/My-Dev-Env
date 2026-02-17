-- Using lazy.nvim
return {
  "cajames/copy-reference.nvim",
  lazy = false, -- Load immediately on startup
  priority = 1000, -- Load early
  dependencies = {
    "folke/which-key.nvim",
  },
  config = function()
    require("copy-reference").setup({
      register = "+", -- System clipboard
      use_git_root = true, -- Use git root for relative paths in repos
    })
    
    -- Set up keymaps manually after plugin loads
    vim.keymap.set({ "n", "v" }, "yr", "<cmd>CopyReference file<cr>", { desc = "Copy file path" })
    vim.keymap.set({ "n", "v" }, "yrr", "<cmd>CopyReference line<cr>", { desc = "Copy file:line reference" })
    
    -- Register with which-key
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({
        { "yr", group = "yank reference" },
        { "yr", "<cmd>CopyReference file<cr>", desc = "Copy file path", mode = { "n", "v" } },
        { "yrr", "<cmd>CopyReference line<cr>", desc = "Copy file:line reference", mode = { "n", "v" } },
      })
    end
  end,
}
