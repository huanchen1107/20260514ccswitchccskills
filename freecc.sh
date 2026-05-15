#!/bin/bash

# Free Claude Code (freecc) Launcher - Optimized Version
# Author: Antigravity

# Path to the proxy server
PROXY_DIR="$HOME/free-claude-code"
PROJECT_DIR=$(pwd)
AUTH_TOKEN="freecc" # Default internal token
PORT=8082

# 1. Start the Proxy Server
echo "🧠 啟動 Free Claude Code Proxy..."

if [ ! -d "$PROXY_DIR" ]; then
    echo "❌ 找不到代理伺服器目錄: $PROXY_DIR"
    exit 1
fi

# Ensure .env exists in proxy dir (populated from project .env)
if [ -f "$PROJECT_DIR/.env" ]; then
    cp "$PROJECT_DIR/.env" "$PROXY_DIR/.env"
fi

# Kill any existing process on the port
lsof -ti :$PORT | xargs kill -9 2>/dev/null

# Start proxy in background using uv
(cd "$PROXY_DIR" && uv run python server.py --port $PORT > /tmp/freecc_proxy.log 2>&1) &
PROXY_PID=$!

# Wait for proxy to be ready
echo "⏳ 等待代理伺服器就緒..."
max_retries=10
count=0
while ! curl -s "http://localhost:$PORT/health" > /dev/null; do
    sleep 1
    count=$((count + 1))
    if [ $count -ge $max_retries ]; then
        echo "❌ 代理伺服器啟動失敗，請檢查 /tmp/freecc_proxy.log"
        kill $PROXY_PID 2>/dev/null
        exit 1
    fi
done
echo "✅ 代理伺服器已就緒 (Port $PORT)"

# 2. Run Claude Code
echo "🚀 啟動 Claude Code (已導向代理伺服器)..."

# Set environment variables for the current session
export ANTHROPIC_BASE_URL="http://localhost:$PORT"
export ANTHROPIC_AUTH_TOKEN="$AUTH_TOKEN"

# Execute claude and pass all arguments
claude "$@"

# 3. Cleanup on exit
echo "🛑 關閉代理伺服器..."
kill $PROXY_PID 2>/dev/null
