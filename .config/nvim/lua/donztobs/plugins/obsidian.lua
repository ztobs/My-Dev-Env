return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true, -- Lazy load for better performance
  ft = "markdown", -- Only load when opening markdown files
  keys = {
    { "<leader>Nn", desc = "New Obsidian note" },
    { "<leader>Ns", desc = "Search Obsidian notes" },
    { "<leader>Nq", desc = "Quick switch Obsidian notes" },
    { "<leader>No", desc = "Open notes directory" },
    { "<leader>Nt", desc = "Open today's note" },
    { "<leader>Ny", desc = "Open yesterday's note" },
    { "<leader>Nb", desc = "Show backlinks" },
    { "<leader>Nl", desc = "Show links" },
    { "<leader>Nf", desc = "Follow link" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    -- Create notes directory if it doesn't exist
    local notes_path = vim.fn.expand("~/.obsidian/neovim")
    vim.fn.mkdir(notes_path, "p")
    
    -- Create templates directory
    local templates_path = notes_path .. "/templates"
    vim.fn.mkdir(templates_path, "p")

    require("obsidian").setup({
      workspaces = {
        {
          name = "notes",
          path = notes_path,
        },
      },

      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      -- Optional, customize how note file names are generated given the ID, target directory, and `title`.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,

      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      -- Optional, configure key mappings. These are the defaults. Set to `false` to disable.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      -- Where to put new notes. Valid options are
      --  * "current_dir" - put new notes in same directory as the current buffer.
      --  * "notes_subdir" - put new notes in the default notes subdirectory.
      new_notes_location = "notes_subdir",

      -- Optional, customize how wiki links are formatted. You can set this to one of:
      --  * "use_alias_only", e.g. '[[Foo Bar]]'
      --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
      --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
      --  * "use_path_only", e.g. '[[foo-bar.md]]'
      -- Or you can set it to a function that takes a table of options and returns a string, like this:
      wiki_link_func = "use_alias_only",

      -- Optional, customize how markdown links are formatted.
      markdown_link_func = function(opts)
        return require("obsidian").util.markdown_link(opts)
      end,

      -- Either 'wiki' or 'markdown'.
      preferred_link_style = "wiki",

      -- Optional, boolean or a function that takes a filename and returns a boolean.
      disable_frontmatter = false,

      -- Optional, for templates (see below).
      templates = {
        folder = templates_path,
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "xdg-open", url }) -- linux
      end,

      -- Optional, set to true if you use the Obsidian Advanced URI plugin.
      use_advanced_uri = false,

      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = false,

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "telescope.nvim",
        -- Optional, configure key mappings for the picker. These are the defaults.
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },

      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      sort_by = "modified",
      sort_reversed = true,

      -- Optional, determines how certain commands open notes. The valid options are:
      -- 1. "current" (the default) - to always open in the current window
      -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
      -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
      open_notes_in = "current",

      -- Optional, configure additional syntax highlighting / extmarks.
      ui = {
        enable = true, -- set to false to disable all additional syntax features
        -- Set conceallevel for markdown files
        conceallevel = 1,
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        max_file_length = 5000, -- disable UI features for files with more than this many lines
        -- Define how various check-boxes are displayed
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          ["!"] = { char = "", hl_group = "ObsidianImportant" },
        },
        -- Use bullet marks for non-checkbox lists.
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },
        hl_groups = {
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianImportant = { bold = true, fg = "#d73128" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianBlockID = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },

      -- Optional, set the YAML parser to use. The valid options are:
      --  * "native" - uses a pure Lua parser that's fast but potentially misses some edge cases.
      --  * "yq" - uses the command-line tool yq (https://github.com/mikefarah/yq), which is more robust
      --    but much slower and needs to be installed separately.
      yaml_parser = "native",
    })

    -- Set conceallevel for markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt_local.conceallevel = 1
      end,
    })

    -- Keymaps
    local keymap = vim.keymap

    keymap.set("n", "<leader>Nn", function()
      local title = vim.fn.input("Note title (can include path like folder/note): ")
      if title == "" then
        return
      end
      
      -- Check if title includes a path
      local dir = notes_path
      local note_title = title
      if title:match("/") then
        local parts = vim.split(title, "/")
        note_title = parts[#parts] -- last part is the title
        -- Join all parts except last as subdirectory
        local subdir = table.concat(vim.list_slice(parts, 1, #parts - 1), "/")
        dir = notes_path .. "/" .. subdir
        -- Create subdirectory if it doesn't exist
        vim.fn.mkdir(dir, "p")
      end
      
      local client = require("obsidian").get_client()
      local note = client:create_note({ title = note_title, dir = dir })
      vim.cmd("edit " .. tostring(note.path))
    end, { desc = "New Obsidian note" })
    keymap.set("n", "<leader>Ns", function()
      local path = vim.fn.expand("~/.obsidian/neovim")
      require("telescope.builtin").live_grep({
        prompt_title = "Search in: " .. path,
        cwd = path,
        file_ignore_patterns = {},
        additional_args = function()
          return { "--hidden", "--no-ignore" }
        end,
      })
    end, { desc = "Search Obsidian notes" })
    keymap.set("n", "<leader>Nq", function()
      local path = vim.fn.expand("~/.obsidian/neovim")
      require("telescope.builtin").find_files({
        prompt_title = "Notes in: " .. path,
        cwd = path,
        hidden = true,
        no_ignore = true,
        file_ignore_patterns = {},
      })
    end, { desc = "Quick switch Obsidian notes" })
    keymap.set("n", "<leader>Nb", function()
      -- Open a note first if not already in one, then show backlinks
      local client = require("obsidian").get_client()
      client:switch_workspace("notes")
      vim.cmd("ObsidianBacklinks")
    end, { desc = "Show Obsidian backlinks" })
    keymap.set("n", "<leader>Nt", function()
      local client = require("obsidian").get_client()
      client:switch_workspace("notes")
      vim.cmd("ObsidianToday")
    end, { desc = "Open today's Obsidian note" })
    keymap.set("n", "<leader>Ny", function()
      local client = require("obsidian").get_client()
      client:switch_workspace("notes")
      vim.cmd("ObsidianYesterday")
    end, { desc = "Open yesterday's Obsidian note" })
    keymap.set("n", "<leader>Nl", function()
      local client = require("obsidian").get_client()
      client:switch_workspace("notes")
      vim.cmd("ObsidianLinks")
    end, { desc = "Show Obsidian links" })
    keymap.set("n", "<leader>Nf", function()
      local client = require("obsidian").get_client()
      client:switch_workspace("notes")
      vim.cmd("ObsidianFollowLink")
    end, { desc = "Follow Obsidian link" })
    keymap.set("n", "<leader>No", function()
      local path = vim.fn.expand("~/.obsidian/neovim")
      require("telescope.builtin").find_files({
        cwd = path,
        hidden = true,
        no_ignore = true,
        file_ignore_patterns = {},
      })
    end, { desc = "Open notes directory" })
    
    -- Debug command to check path
    vim.api.nvim_create_user_command("ObsidianDebug", function()
      print("Notes path: " .. notes_path)
      print("Files found: " .. vim.fn.system("ls -la " .. notes_path .. "/*.md | wc -l"))
    end, {})
  end,
}
