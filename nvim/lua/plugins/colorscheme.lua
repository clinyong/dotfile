return {
    "RRethy/base16-nvim",
    priority = 1000,
    lazy = false,
    config = function()
        vim.opt.termguicolors = true

        -- Follow macOS Appearance at startup, matching Ghostty's Gruvbox pair.
        local background = "dark"
        if vim.fn.has("macunix") == 1 then
            local interface_style = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
            background = vim.v.shell_error == 0 and vim.trim(interface_style) == "Dark" and "dark" or "light"
        end

        vim.o.background = background
        vim.cmd.colorscheme(
            background == "light" and "base16-gruvbox-light-hard" or "base16-gruvbox-dark"
        )
    end,
}
