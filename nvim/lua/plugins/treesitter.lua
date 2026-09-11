return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- 该插件不支持懒加载
    build = ":TSUpdate",
    config = function()
      -- markdown / markdown_inline 是 render-markdown.nvim 的硬依赖
      -- 已装过则是 no-op；插件更新后若 parser 被清掉，这里会自愈
      require("nvim-treesitter").install({ "markdown", "markdown_inline" })
    end,
  },
}
