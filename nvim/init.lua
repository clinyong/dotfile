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
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 3. 加载插件 (auto-import 整个 lua/plugins/ 目录)
require("lazy").setup("plugins")
