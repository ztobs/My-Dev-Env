return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      view = {
        width = 50,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer

    -- Custom file duplication command
    vim.api.nvim_create_user_command("DuplicateFile", function()
      local current_file = vim.fn.expand("%:p")
      local current_dir = vim.fn.expand("%:p:h")
      local current_name = vim.fn.expand("%:t")
      
      if current_file == "" then
        vim.notify("No file to duplicate", vim.log.levels.WARN)
        return
      end

      -- Prompt for new filename
      vim.ui.input({
        prompt = "Duplicate as: ",
        default = current_name,
      }, function(new_name)
        if not new_name or new_name == "" or new_name == current_name then
          return
        end

        local new_file = current_dir .. "/" .. new_name
        
        -- Check if target file already exists
        if vim.fn.filereadable(new_file) == 1 then
          vim.notify("File already exists: " .. new_name, vim.log.levels.ERROR)
          return
        end

        -- Copy the file
        local success = vim.fn.writefile(vim.fn.readfile(current_file), new_file)
        
        if success == 0 then
          vim.notify("File duplicated: " .. new_name, vim.log.levels.INFO)
          -- Open the new file
          vim.cmd("edit " .. vim.fn.fnameescape(new_file))
        else
          vim.notify("Failed to duplicate file", vim.log.levels.ERROR)
        end
      end)
    end, { desc = "Duplicate current file" })

    -- Keymap for file duplication
    keymap.set("n", "<leader>fd", "<cmd>DuplicateFile<CR>", { desc = "Duplicate current file" })
  end,
}
