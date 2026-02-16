-- ~/.config/nvim/lua/plugins/which-key.lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- Load after startup for faster init
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300 -- Time to wait for mapped sequence (ms)
  end,
  opts = {
    -- Your configuration options here
    preset = "modern", -- or "classic", "helix"
    delay = 200, -- Delay before showing popup

    -- Optional: filter out irrelevant mappings
    filter = function(mapping)
      return mapping.desc and mapping.desc ~= ""
    end,
  },
  keys = {
    -- Optional: manual trigger if you want
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
