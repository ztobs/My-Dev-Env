return {
  "lpoto/telescope-docker.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>dc",
      "<cmd>Telescope docker containers<cr>",
      desc = "🐋 Containers",
    },
    {
      "<leader>di",
      "<cmd>Telescope docker images<cr>",
      desc = "🐋 Images",
    },
    {
      "<leader>dv",
      "<cmd>Telescope docker volumes<cr>",
      desc = "🐋 Volumes",
    },
    {
      "<leader>dn",
      "<cmd>Telescope docker networks<cr>",
      desc = "🐋 Networks",
    },
    {
      "<leader>dp",
      "<cmd>Telescope docker compose<cr>",
      desc = "🐋 Compose",
    },
  },
}