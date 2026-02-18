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
      desc = "[D]ocker [C]ontainers",
    },
    {
      "<leader>di",
      "<cmd>Telescope docker images<cr>",
      desc = "[D]ocker [I]mages",
    },
    {
      "<leader>dv",
      "<cmd>Telescope docker volumes<cr>",
      desc = "[D]ocker [V]olumes",
    },
    {
      "<leader>dn",
      "<cmd>Telescope docker networks<cr>",
      desc = "[D]ocker [N]etworks",
    },
    {
      "<leader>dp",
      "<cmd>Telescope docker compose<cr>",
      desc = "[D]ocker [C]ompose",
    },
  },
}