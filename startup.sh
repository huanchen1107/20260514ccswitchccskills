#!/bin/bash

# =========================================================
# 0. Environment Check
# =========================================================
echo "================================================="
echo "🔍 環境檢查 (Environment Check)"
echo "================================================="
PASS=true

# --- Dependencies ---
echo ""
echo "📦 依賴工具："

check_cmd() {
    if command -v "$1" &>/dev/null; then
        echo "  ✅ $1 ($(command -v $1))"
    else
        echo "  ❌ $1 — 未安裝！請執行: $2"
        PASS=false
    fi
}

check_cmd "uv"   "brew install uv"
check_cmd "node" "brew install node"
check_cmd "npx"  "brew install node"
check_cmd "curl" "brew install curl"
check_cmd "git"  "brew install git"

# --- Project .env ---
echo ""
echo "🔑 API Keys (.env)："
if [ -f ".env" ]; then
    source .env 2>/dev/null
    if [ -n "$OPENROUTER_API_KEY" ]; then
        echo "  ✅ OPENROUTER_API_KEY 已設定"
    else
        echo "  ❌ OPENROUTER_API_KEY 未設定！請在 .env 中加入"
        PASS=false
    fi
else
    echo "  ❌ .env 檔案不存在！請建立並填入 API Key"
    PASS=false
fi

# --- Proxy directory ---
echo ""
echo "📁 Proxy 目錄："
PROXY_DIR="$HOME/free-claude-code"
if [ -d "$PROXY_DIR" ]; then
    echo "  ✅ $PROXY_DIR 存在"
    if [ -f "$PROXY_DIR/server.py" ]; then
        echo "  ✅ server.py 存在"
    else
        echo "  ❌ server.py 不存在！請重新 clone free-claude-code"
        PASS=false
    fi
else
    echo "  ❌ $PROXY_DIR 不存在！請執行:"
    echo "     git clone https://github.com/turian/free-claude-code.git ~/free-claude-code"
    PASS=false
fi

# --- Port availability ---
echo ""
echo "🔌 Port 狀態："
if lsof -ti :8082 &>/dev/null; then
    echo "  ⚠️  Port 8082 已被佔用 (可能代理已在運行，或有殘留程序)"
    echo "     執行 lsof -ti :8082 | xargs kill -9 可強制清除"
else
    echo "  ✅ Port 8082 可用"
fi

# --- OpenRouter connectivity ---
echo ""
echo "🌐 網路連線："
if curl -s --max-time 5 "https://openrouter.ai/api/v1/models" -H "Authorization: Bearer ${OPENROUTER_API_KEY:-test}" -o /dev/null -w "%{http_code}" | grep -q "^[24]"; then
    echo "  ✅ OpenRouter API 可連線"
else
    echo "  ⚠️  OpenRouter API 連線失敗（請確認網路或 API Key）"
fi

echo ""
echo "================================================="
if [ "$PASS" = true ]; then
    echo "✅ 環境檢查通過！繼續啟動..."
else
    echo "❌ 環境有問題，請修正後再執行 ./startup.sh"
    echo "================================================="
    exit 1
fi
echo "================================================="
echo ""

# =========================================================
# 1. Pull latest from GitHub
# =========================================================
echo "🚀 正在從 GitHub 拉取最新進度 (git pull)..."
git pull origin main || echo "⚠️ 同步失敗，跳過此步驟。"

# =========================================================
# 2. Read latest dev log
# =========================================================
echo ""
echo "================================================="
echo "📖 最新開發日誌內容："
echo "================================================="
LATEST_LOG=$(ls -t *開發日誌*.md 2>/dev/null | head -n 1)
if [ -n "$LATEST_LOG" ]; then
    cat "$LATEST_LOG"
else
    echo "⚠️ 找不到開發日誌檔案！"
fi
echo "================================================="
echo ""
echo "🤖 嗨，AI 助手！請閱讀上方的開發日誌，並總結目前的進度，然後告訴我接下來可以開始哪些任務 (Tasks to start)。"
echo ""

# =========================================================
# 3. Launch Claude Code via cc.sh
# =========================================================
echo "================================================="
echo "🤖 啟動 Claude Code (via cc.sh)..."
echo "================================================="
if [ -f "cc.sh" ]; then
    bash cc.sh
else
    echo "❌ 找不到 cc.sh，請確認檔案是否存在。"
fi
