-- 让 y/p 与系统剪贴板打通：本地走 pbcopy，SSH 下走 OSC52
local M = {}

-- OSC52 copy: 接收行的列表 (nvim clipboard provider 约定)，用 \n 拼成字符串后
-- base64 编码，再通过 OSC52 转义写到 stderr。
-- 终端 (Ghostty/iTerm/tmux 等) 收到后会把它写入本地系统剪贴板。
local function osc52_copy(lines)
  local text = table.concat(lines, "\n")
  if #lines > 1 then text = text .. "\n" end -- 末行换行保留
  local b64 = vim.base64.encode(text)
  local osc = string.format("\27]52;c;%s\7", b64)
  io.stderr:write(osc)
  io.stderr:flush()
  return text
end

-- 缓存最近一次 copy 的内容，供 paste 回读
-- (OSC52 paste 需要终端异步回传，同步 paste 做不到，故用缓存兜底)
local last_copied = ""

function M.setup()
  -- 先开启 unnamedplus：让 y/p 操作直接作用于系统剪存器 `+`
  vim.opt.clipboard = "unnamedplus"

  if vim.env.SSH_CONNECTION == nil and vim.env.SSH_TTY == nil then
    -- 本地：用 neovim 默认 provider (macOS 走 pbcopy)
    return
  end

  vim.g.clipboard = {
    name = "osc52",
    copy = {
      ["+"] = function(lines)
        last_copied = osc52_copy(lines)
      end,
      ["*"] = function(lines)
        last_copied = osc52_copy(lines)
      end,
    },
    paste = {
      ["+"] = function()
        return { last_copied }
      end,
      ["*"] = function()
        return { last_copied }
      end,
    },
  }
end

return M
