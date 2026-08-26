-- LSP: 跳转定义 / 引用 / 悬浮文档 / 重命名等
-- Swift 走 Xcode 自带的 sourcekit-lsp (/usr/bin/sourcekit-lsp)，无需额外安装
-- 新 API (nvim 0.11+)：vim.lsp.config / vim.lsp.enable，不再用 require('lspconfig')
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    -- 配置只负责启用 LSP；可执行文件由 setup.sh/Homebrew 安装。
    -- 缺少依赖时给出一次提示，避免 Neovim 反复尝试启动不存在的进程。
    local function enable_if_installed(server, executable, install_hint)
      if vim.fn.executable(executable) == 1 then
        vim.lsp.enable(server)
      else
        vim.notify_once(
          string.format("LSP %s 未安装，请执行：%s", server, install_hint),
          vim.log.levels.WARN
        )
      end
    end

    -- 使用 Neovim 0.12 内置的 LSP completion，不额外依赖 nvim-cmp。
    -- 预选第一项但不直接插入，按 Tab 即可接受当前补全。
    vim.opt.completeopt = { "menu", "menuone", "noinsert", "popup" }

    -- 诊断样式：行内虚拟文本 + 左侧 sign
    vim.diagnostic.config({
      -- 隐藏所有 LSP 的行内诊断提示（不只 TypeScript）
      virtual_text = false,
      -- 不在 sign column 显示 E/W 等诊断标记，但保留下划线提示。
      signs = false,
      underline = true,
      update_in_insert = false,
    })

    -- 快捷键只在 LSP 附着的 buffer 里绑定，避免污染无 LSP 的 buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/completion") then
          -- ts_ls 默认只在 '.', '/', '@' 等字符后触发请求；VS Code
          -- 还会在对象换行、空格和输入 key 时请求，因此补充常见字符。
          local provider = client.server_capabilities.completionProvider
          local triggers = provider.triggerCharacters or {}
          for byte = 32, 126 do
            local char = string.char(byte)
            if not vim.tbl_contains(triggers, char) then
              table.insert(triggers, char)
            end
          end
          for _, char in ipairs({ "\n", "\r", "\t" }) do
            if not vim.tbl_contains(triggers, char) then
              table.insert(triggers, char)
            end
          end
          provider.triggerCharacters = triggers
          vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
        end

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "LSP: " .. desc })
        end
        -- 用 Telescope 展示多个定义；选择后 picker 会自动关闭
        map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "go to implementation")
        map("n", "gr", "<cmd>Telescope lsp_references<cr>", "references")
        map("n", "K", vim.lsp.buf.hover, "hover doc")
        map("n", "<leader>rn", vim.lsp.buf.rename, "rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "code action")
        map("n", "<leader>e", function()
          vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
        end, "show diagnostics")
        map("n", "[d", vim.diagnostic.goto_prev, "previous diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "next diagnostic")
        -- 留出 Ctrl-Space 给 macOS 输入法；手动补全使用标准 Ctrl-X Ctrl-O。
        vim.keymap.set("i", "<Tab>", function()
          return vim.fn.pumvisible() == 1 and "<C-y>" or "<Tab>"
        end, { buffer = buf, expr = true, desc = "accept completion" })
        vim.keymap.set("i", "<S-Tab>", function()
          return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
        end, { buffer = buf, expr = true, desc = "previous completion" })
      end,
    })

    -- Swift: sourcekit-lsp (Xcode 工具链自带)
    enable_if_installed("sourcekit", "sourcekit-lsp", "安装 Xcode Command Line Tools")

    -- TypeScript: typescript-language-server 需要 JS 版 tsserver。
    -- Homebrew 当前的 TypeScript 7 不再提供 tsserver，使用 data 目录下的兼容版本。
    local tsserver_path = vim.fs.joinpath(
      vim.fn.stdpath("data"),
      "typescript/node_modules/typescript/lib/tsserver.js"
    )
    local ts_init_options = { hostInfo = "neovim" }
    if vim.fn.filereadable(tsserver_path) == 1 then
      ts_init_options.tsserver = { path = tsserver_path }
    end
    vim.lsp.config("ts_ls", { init_options = ts_init_options })
    enable_if_installed("ts_ls", "typescript-language-server", "brew install typescript-language-server")

    -- Rust: rust-analyzer (需先安装: rustup component add rust-analyzer)
    enable_if_installed("rust_analyzer", "rust-analyzer", "brew install rust-analyzer")
  end,
}
