return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    keys = {
     { "<leader>b", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
   },
    lazy = false, -- neo-tree will lazily load itself
  }
}
