local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

local wk = require("which-key")

-- Add group names for your existing keymaps
wk.add({
  -- Groups (no actual command, just the name)
  { "<leader>f", group = "Find/Files", icon = "" },
  { "<leader>g", group = "Git" },
  { "<leader>t", group = "Tabs" },
  { "<leader>s", group = "Split Window" },
  { "<leader>w", group = "Window" },
  -- { "<leader>f", group = "🔍 Find" },
  -- { "<leader>g", group = "🌳 Git" },
  -- { "<leader>e", group = "📁 Explorer" },
  -- { "<leader>t", group = "🖥️ Terminal" },
  -- { "<leader>b", group = "📄 Buffer" },
  -- { "<leader>w", group = "🪟 Window" },
  -- { "<leader>l", group = "💡 LSP" },
  -- { "<leader>c", group = "🤖 Copilot" },
  -- { "<leader>a", group = "✨ AI Actions" },
  -- { "<leader>n", group = "🔔 Notifications" },
  -- { "<leader>u", group = "🎨 UI" },
  -- { "<leader>o", group = "🚀 Open" },
  -- { "<leader>r", group = "▶️ Run" },
  -- { "<leader>x", group = "🐛 Diagnostics" },
  -- { "<leader>s", group = "🔎 Search" },
  -- { "<leader>d", group = "🐞 Debug" },
  -- { "<leader>y", group = "📋 Yank" },
  -- { "<leader>p", group = "📌 Project" },
  -- { "<leader>m", group = "🏷️ Marks" },
  -- { "<leader>q", group = "🚪 Quit" },
  -- { "<leader>v", group = "👁️ View" },
  -- { "<leader>h", group = "❓ Help" },
  -- { "<leader>j", group = "⬇️ Jump" },
  -- { "<leader>k", group = "⬆️ Bookmarks" },
  -- { "<leader>z", group = "🧘 Zen" },
})
