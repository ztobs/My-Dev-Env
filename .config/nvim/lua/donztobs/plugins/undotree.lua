-- ~/.config/nvim/lua/plugins/undotree.lua
return {
  "mbbill/undotree",
  cmd = "UndotreeToggle", -- Load only when command is used
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
  },
  init = function()
    -- Configuration variables (must be set before loading)
    vim.g.undotree_WindowLayout = 2 -- Layout style (1-4)
    vim.g.undotree_SplitWidth = 40 -- Width of undotree panel
    vim.g.undotree_DiffpanelHeight = 10 -- Height of diff panel
    vim.g.undotree_SetFocusWhenToggle = 1 -- Focus undotree when opened
    vim.g.undotree_TreeNodeShape = "●" -- Node shape
    vim.g.undotree_TreeVertShape = "│" -- Vertical line shape
    vim.g.undotree_TreeSplitShape = "╱" -- Split shape
    vim.g.undotree_TreeReturnShape = "╲" -- Return shape

    -- Optional: Auto-close when selecting undo
    vim.g.undotree_AutoCloseWhenDiff = 0

    -- Optional: Show relative timestamps
    vim.g.undotree_RelativeTimestamp = 1

    -- Optional: Short timestamps
    vim.g.undotree_ShortIndicators = 1
  end,
  config = function()
    -- Optional: Additional setup after load
    -- Keymaps for undotree buffer (only active when undotree is open)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "undotree",
      callback = function()
        local opts = { buffer = true, silent = true }
        vim.keymap.set("n", "q", "<cmd>UndotreeToggle<cr>", opts)
        vim.keymap.set("n", "<esc>", "<cmd>UndotreeToggle<cr>", opts)
      end,
    })
  end,
}
