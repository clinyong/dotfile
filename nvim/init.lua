-- 1. Bootstrap lazy.nvim (首次启动自动 clone,后续启动跳过)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. 基础设置
-- 全局快捷键前缀
vim.g.mapleader = " "
-- 局部快捷键前缀：供特定插件或文件类型使用，避免占用全局快捷键
vim.g.maplocalleader = ","

-- 默认使用 4 个空格缩进
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- 外部修改文件后，在重新聚焦、进入缓冲区或空闲时自动重新读取
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "checktime",
})

-- 3. 加载插件 (auto-import 整个 lua/plugins/ 目录)
require("lazy").setup("plugins")

-- 4. 剪贴板：本地走 pbcopy，SSH 下走 OSC52
require("config.clipboard").setup()