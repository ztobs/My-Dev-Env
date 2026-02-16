return {
  "gbprod/yanky.nvim",
  event = "TextYankPost",
  opts = {
    -- Correct highlight configuration
    highlight = {
      on_put = true, -- Flash on paste (p/P)
      on_yank = true, -- Flash on yank (y)
      timer = 300, -- Duration in ms
    },
    -- Optional: ring configuration for history
    ring = {
      history_length = 100,
      storage = "shada", -- or "sqlite" if you have sqlite.lua
      sync_with_numbered_registers = true,
    },
    -- Optional: picker for yank history
    picker = {
      select = {
        action = nil, -- nil to use default put action
      },
    },
  },
  keys = {
    -- Optional: keymaps for yank history
    {
      "<leader>p",
      function()
        require("yanky").cycle(1)
      end,
      desc = "Next yank",
    },
    {
      "<leader>P",
      function()
        require("yanky").cycle(-1)
      end,
      desc = "Previous yank",
    },
    { "<leader>y", "<cmd>Telescope yank_history<cr>", desc = "Yank history" },
  },
}
