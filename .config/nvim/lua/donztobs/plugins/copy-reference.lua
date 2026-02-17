-- Using lazy.nvim
return {
  "cajames/copy-reference.nvim",
  opts = {
    register = "+", -- System clipboard
    use_git_root = true, -- Use git root for relative paths in repos
  },
  keys = {
    { "yr", "<cmd>CopyReference file<cr>", mode = { "n", "v" }, desc = "Copy file path" },
    { "yrr", "<cmd>CopyReference line<cr>", mode = { "n", "v" }, desc = "Copy file:line reference" },
  },
}
