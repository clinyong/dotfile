# ~/.zprofile
# 登录 shell 加载(交互/非交互登录都读,典型场景: LaunchAgent 的 `zsh -lc`)。
# 放需要在登录态就生效的 PATH 和环境变量。
#   - 交互体验(别名/补全/提示符/eval hook) → .zshrc
#   - 所有 shell 都要的纯 export(密钥/EDITOR)  → .zshenv

# mise: 让非交互登录 shell 也能找到 mise 管理的命令(node/pi 等)
export PATH="$HOME/.local/share/mise/shims:$PATH"
