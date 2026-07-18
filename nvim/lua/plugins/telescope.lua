return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Find commands" },
  },
}
