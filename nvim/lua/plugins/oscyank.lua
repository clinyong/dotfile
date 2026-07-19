return {
  "ojroques/vim-oscyank",
  lazy = true,
  keys = {
    -- 用 OSC52 复制：motion / visual / 最近 yank 寄存器 / 文件路径
    -- 本地 macOS 由 clipboard=unnamedplus 直接走 pbcopy，以下按键主要给 SSH 远程场景用
    { "<leader>yc",  "<Plug>OSCYankOperator", desc = "OSCYank (motion)" },
    { "<leader>yc",  "<Plug>OSCYankVisual",  desc = "OSCYank (visual)", mode = "x" },
    { "<leader>yy",  function()
        require("lazy").load({ plugins = { "vim-oscyank" } })
        vim.fn.OSCYankRegister('"')
      end, desc = "OSCYank yanked register" },
    { "<leader>ypa", function()
        require("lazy").load({ plugins = { "vim-oscyank" } })
        vim.fn.OSCYank(vim.fn.expand("%:p"))
      end, desc = "Yank path (Absolute)" },
    { "<leader>ypr", function()
        require("lazy").load({ plugins = { "vim-oscyank" } })
        vim.fn.OSCYank(vim.fn.fnamemodify(vim.fn.expand("%:p"), ":."))
      end, desc = "Yank path (Relative)" },
  },
}
