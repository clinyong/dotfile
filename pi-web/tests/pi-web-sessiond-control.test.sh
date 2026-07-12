#!/usr/bin/env bash
# Verifies the local pi-web wrapper manages web and sessiond together.
set -euo pipefail

ROOT=$(mktemp -d)
PI_WEB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trap 'pkill -f "$ROOT/fake-bin/pi-web" 2>/dev/null || true; rm -rf "$ROOT"' EXIT
mkdir -p "$ROOT/bin" "$ROOT/pi-web" "$ROOT/fake-bin" "$ROOT/.pi-web/logs"
cp "$PI_WEB_DIR/pi-web" "$PI_WEB_DIR/pi-web-up" "$PI_WEB_DIR/pi-web-down" "$ROOT/pi-web/"
ln -s "$ROOT/pi-web/pi-web" "$ROOT/bin/pi-web"

cat >"$ROOT/fake-bin/pi-web-server" <<'EOF'
#!/usr/bin/env bash
echo web >>"$HOME/starts"
exec -a "$0" sleep 60
EOF
cat >"$ROOT/fake-bin/pi-web-sessiond" <<'EOF'
#!/usr/bin/env bash
echo sessiond >>"$HOME/starts"
exec -a "$0" sleep 60
EOF
cat >"$ROOT/fake-bin/launchctl" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
cat >"$ROOT/fake-bin/lsof" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
cat >"$ROOT/fake-bin/ipconfig" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
cat >"$ROOT/fake-bin/pkill" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
cat >"$ROOT/fake-bin/pgrep" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
chmod +x "$ROOT/fake-bin/"*

HOME="$ROOT" PATH="$ROOT/fake-bin:/usr/bin:/bin" "$ROOT/bin/pi-web" start >/dev/null

test -s "$ROOT/.pi-web/daemon.pid"
test -s "$ROOT/.pi-web/sessiond.pid"
test "$(tr '\n' ' ' <"$ROOT/starts")" = 'sessiond web '

HOME="$ROOT" PATH="$ROOT/fake-bin:/usr/bin:/bin" "$ROOT/bin/pi-web" restart >/dev/null
test -s "$ROOT/.pi-web/daemon.pid"
test -s "$ROOT/.pi-web/sessiond.pid"
test "$(tr '\n' ' ' <"$ROOT/starts")" = 'sessiond web sessiond web '

HOME="$ROOT" PATH="$ROOT/fake-bin:/usr/bin:/bin" "$ROOT/bin/pi-web" stop >/dev/null
web_pid=$(cat "$ROOT/.pi-web/daemon.pid" 2>/dev/null || true)
sessiond_pid=$(cat "$ROOT/.pi-web/sessiond.pid" 2>/dev/null || true)
test -z "$web_pid"
test -z "$sessiond_pid"

echo 'PASS: pi-web start/stop manages web and sessiond'
