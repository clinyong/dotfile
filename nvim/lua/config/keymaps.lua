local function oscyank_path(path)
  require("lazy").load({ plugins = { "vim-oscyank" } })
  vim.fn.OSCYank(path)
end

vim.keymap.set("n", "<leader>ypa", function()
  oscyank_path(vim.fn.expand("%:p"))
end, { desc = "Yank path (Absolute)" })

vim.keymap.set("n", "<leader>ypr", function()
  oscyank_path(vim.fn.fnamemodify(vim.fn.expand("%:p"), ":."))
end, { desc = "Yank path (Relative)" })
