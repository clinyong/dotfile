return {
    "kepano/flexoki-neovim",
    name = "flexoki",
    priority = 1000,
    lazy = false,
    config = function()
        -- "flexoki-dark"   -> force dark
        -- "flexoki-light"  -> force light
        -- "flexoki"        -> follow 'background' option (auto dark/light)
        vim.cmd.colorscheme("flexoki-dark")
    end,
}