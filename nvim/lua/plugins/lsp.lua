-- LSP: 跳转定义 / 引用 / 悬浮文档 / 重命名等
-- Swift 走 Xcode 自带的 sourcekit-lsp (/usr/bin/sourcekit-lsp)，无需额外安装
-- 新 API (nvim 0.11+)：vim.lsp.config / vim.lsp.enable，不再用 require('lspconfig')
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    -- 诊断样式：行内虚拟文本 + 左侧 sign
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
    })

    -- 快捷键只在 LSP 附着的 buffer 里绑定，避免污染无 LSP 的 buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local buf = args.buf
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "LSP: " .. desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "go to implementation")
        map("n", "gr", "<cmd>Telescope lsp_references<cr>", "references")
        map("n", "K", vim.lsp.buf.hover, "hover doc")
        map("n", "<leader>rn", vim.lsp.buf.rename, "rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "code action")
      end,
    })

    -- Swift: sourcekit-lsp (Xcode 工具链自带)
    vim.lsp.enable("sourcekit")

    -- TypeScript: typescript-language-server (已通过 brew 安装)
    vim.lsp.enable("ts_ls")

    -- Rust: rust-analyzer (需先安装: rustup component add rust-analyzer)
    vim.lsp.enable("rust_analyzer")
  end,
}
