return {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,
    lazy = false,
    config = function()
        -- 对齐 Ghostty 主题 (theme = kanagawa)。
        -- ghostty 内置的 `kanagawa` 即 Wave 调色板，对应 rebelot/kanagawa.nvim 的 wave 变体。
        -- 想要更暗可换 "dragon" (对齐 ghostty 的 Kanagawa Dragon)，白天可换 "lotus"。
        require("kanagawa").setup({ theme = "wave" })
        vim.cmd.colorscheme("kanagawa-wave")
    end,
}