vim.cmd("let g:netrw_liststyle = 3")
vim.g.mapleader = " "

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- Per-filetype indentation. Global default is 2 spaces (see above); only
-- languages whose convention differs need to be listed here.
local indent_4 = {
  "python", "php", "java", "c", "cpp", "cs", "rust", "kotlin", "swift",
  "objc", "perl", "sql", "julia", "erlang",
}
local indent_tab = { "go", "gomod", "gosum", "make" }

local four, tabs = {}, {}
for _, ft in ipairs(indent_4) do
  four[ft] = true
end
for _, ft in ipairs(indent_tab) do
  tabs[ft] = true
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Set indentation width per filetype",
  callback = function(ev)
    local buf = ev.buf
    if tabs[vim.bo[buf].filetype] then
      vim.bo[buf].expandtab = false
      vim.bo[buf].tabstop = 4
      vim.bo[buf].shiftwidth = 4
    elseif four[vim.bo[buf].filetype] then
      vim.bo[buf].expandtab = true
      vim.bo[buf].tabstop = 4
      vim.bo[buf].shiftwidth = 4
    else
      vim.bo[buf].expandtab = true
      vim.bo[buf].tabstop = 2
      vim.bo[buf].shiftwidth = 2
    end
  end,
})

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- conceallevel for obsidian.nvim
opt.conceallevel = 1

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Flash yanked text",
  group = vim.api.nvim_create_augroup("FlashYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

-- Auto-reload files changed outside neovim
vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime",
  pattern = "*",
})
