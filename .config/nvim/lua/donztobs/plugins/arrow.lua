return {
  "otavioschwanck/arrow.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  opts = {
    -- Show icons next to tags
    show_icons = true,

    -- Leader key to open arrow menu (single key recommended)
    leader_key = ";", -- Press ; to open arrow menu

    -- Per-buffer bookmarks leader key
    buffer_leader_key = "m", -- Press m to manage buffer-local bookmarks

    -- Separate bookmarks by git branch
    separate_by_branch = false,

    -- Show/hide handbook (shortcuts help)
    hide_handbook = false,

    -- Save location for arrow data
    save_path = function()
      return vim.fn.stdpath("cache") .. "/arrow"
    end,

    -- Mappings inside the arrow menu
    mappings = {
      edit = "e",           -- Edit file path
      delete_mode = "d",    -- Enter delete mode
      clear_all_items = "C", -- Clear all bookmarks
      toggle = "s",         -- Toggle/save bookmark
      open_vertical = "v",  -- Open in vertical split
      open_horizontal = "-", -- Open in horizontal split
      quit = "q",           -- Close menu
      remove = "x",         -- Remove bookmark
      next_item = "]",      -- Next bookmark
      prev_item = "[",      -- Previous bookmark
    },

    -- Window options
    window = {
      width = "auto",
      height = "auto",
      row = "auto",
      col = "auto",
      border = "rounded",
    },

    -- Per-buffer config
    per_buffer_config = {
      lines = 4,              -- Number of lines in preview
      sort_automatically = true, -- Auto-sort buffer marks
      satellite = {           -- Show in scrollbar
        enable = false,
        overlap = true,
        priority = 1000,
      },
    },

    -- Index keys for quick selection (1-9, then letters)
    index_keys = "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP",

    -- Always show full path for these filenames
    full_path_list = { "update_stuff" },
  },
  config = function(_, opts)
    require("arrow").setup(opts)

    -- Helper function to show notifications
    local function notify(msg, level)
      vim.notify(msg, level or vim.log.levels.INFO, { title = "Arrow" })
    end

    -- Add keymaps with visual feedback
    vim.keymap.set("n", "H", function()
      local ok, result = pcall(require("arrow.persist").previous)
      if not ok then
        notify("No previous bookmark", vim.log.levels.WARN)
      end
    end, { desc = "Arrow: Previous bookmark" })

    vim.keymap.set("n", "L", function()
      local ok, result = pcall(require("arrow.persist").next)
      if not ok then
        notify("No next bookmark", vim.log.levels.WARN)
      end
    end, { desc = "Arrow: Next bookmark" })

    -- Quick toggle with visual feedback
    vim.keymap.set("n", "<C-s>", function()
      require("arrow.persist").toggle()
      -- Check if current file is bookmarked
      local statusline = require("arrow.statusline")
      if statusline.is_on_arrow_file() then
        notify("✓ Bookmark added", vim.log.levels.INFO)
      else
        notify("✗ Bookmark removed", vim.log.levels.INFO)
      end
    end, { desc = "Arrow: Toggle bookmark" })
  end,
}
