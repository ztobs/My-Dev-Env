return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    -- Custom function to get relative path to git root
    local function get_relative_git_path()
      local filepath = vim.fn.expand("%:p")
      if filepath == "" then
        return ""
      end
      
      -- Get git root directory
      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
      if not git_root or vim.v.shell_error ~= 0 then
        -- Not in a git repository, return relative path from current directory
        return vim.fn.fnamemodify(filepath, ":~:.")
      end
      
      -- Make sure git_root ends with path separator
      git_root = git_root:gsub("/$", "") .. "/"
      
      -- Get relative path from git root
      if filepath:sub(1, #git_root) == git_root then
        local relative_path = filepath:sub(#git_root + 1)
        if relative_path == "" then
          return "[git root]"
        end
        return relative_path
      else
        -- File is not under git root (shouldn't happen), fall back to relative path
        return vim.fn.fnamemodify(filepath, ":~:.")
      end
    end

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = my_lualine_theme,
      },
      sections = {
        lualine_a = {"mode"},
        lualine_b = {"branch", "diff", "diagnostics"},
        lualine_c = {
          {
            get_relative_git_path,
            color = { fg = colors.fg, gui = "bold" },
          }
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat", symbols = { unix = "" } },
          { "filetype" },
        },
        lualine_y = {"progress"},
        lualine_z = {"location"}
      },
    })
  end,
}
