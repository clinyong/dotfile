return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format()
            end,
            desc = "Format file",
        },
    },
    config = function()
        local format_on_save_filetypes = {
            lua = true,
            javascript = true,
            javascriptreact = true,
            typescript = true,
            typescriptreact = true,
            python = true,
            go = true,
            rust = true,
        }

        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "oxfmt" },
                javascriptreact = { "oxfmt" },
                typescript = { "oxfmt" },
                typescriptreact = { "oxfmt" },
                python = { "black" },
                go = { "gofmt" },
                rust = { "rustfmt" },
            },
            -- Automatically format supported filetypes before saving.
            format_on_save = function(bufnr)
                if format_on_save_filetypes[vim.bo[bufnr].filetype] then
                    return {
                        timeout_ms = 1000,
                        lsp_format = "never",
                    }
                end
            end,
        })
    end,
}
