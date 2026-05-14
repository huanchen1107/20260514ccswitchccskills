#!/usr/bin/env bash
set -e

# =========================================================
# Free Claude Code Auto Launcher
# Antigravity → Claude Code → Free Claude Code → Gemini/OpenRouter
# =========================================================

FREECC_DIR="$HOME/free-claude-code"
PORT="8082"
AUTH_TOKEN="freecc"
ORIGINAL_DIR="$(pwd)"

echo ""
echo "========================================================="
echo "🤖 Free Claude Code Launcher"
echo "========================================================="
echo ""

# =========================================================
# 提示使用者輸入 API KEY
# =========================================================

echo "請選擇模型來源："
echo ""
echo "1) OpenRouter（推薦，最穩）"
echo "2) Gemini API（需 fork 已支援 Gemini provider）"
echo "3) ChatGPT API (OpenAI)"
echo ""

read -p "請輸入選項 [1-3]: " PROVIDER_CHOICE

if [ "$PROVIDER_CHOICE" = "1" ]; then

    echo ""
    echo "🔑 請輸入 OpenRouter API Key"
    echo "格式通常是： sk-or-xxxxxxxx"
    echo ""

    read -s -p "OPENROUTER_API_KEY: " OPENROUTER_API_KEY
    echo ""

    MODEL_PROVIDER="open_router/google/gemini-2.5-pro"

elif [ "$PROVIDER_CHOICE" = "2" ]; then

    echo ""
    echo "🔑 請輸入 Gemini API Key"
    echo ""

    read -s -p "GEMINI_API_KEY: " GEMINI_API_KEY
    echo ""

    MODEL_PROVIDER="gemini/gemini-2.5-pro"

elif [ "$PROVIDER_CHOICE" = "3" ]; then

    echo ""
    echo "🔑 請輸入 OpenAI API Key"
    echo ""

    read -s -p "OPENAI_API_KEY: " OPENAI_API_KEY
    echo ""

    MODEL_PROVIDER="openai/gpt-4o"

else
    echo "❌ 無效選項"
    exit 1
fi

echo ""
echo "🚀 準備啟動 Free Claude Code..."
echo ""

# =========================================================
# Clone repo
# =========================================================

if [ ! -d "$FREECC_DIR" ]; then
    echo "📦 Clone free-claude-code..."
    git clone https://github.com/huanchen1107/free-claude-code.git "$FREECC_DIR"
fi

cd "$FREECC_DIR"

# =========================================================
# 建立 .env
# =========================================================

if [ ! -f ".env" ]; then
    cp .env.example .env
fi

echo "⚙️ 產生 .env 設定..."

if [ "$PROVIDER_CHOICE" = "1" ]; then

cat > .env <<EOF
ANTHROPIC_AUTH_TOKEN="$AUTH_TOKEN"

OPENROUTER_API_KEY="$OPENROUTER_API_KEY"

MODEL="$MODEL_PROVIDER"

ENABLE_MODEL_THINKING=true

PROVIDER_RATE_LIMIT=1
PROVIDER_RATE_WINDOW=3
PROVIDER_MAX_CONCURRENCY=3

HTTP_READ_TIMEOUT=120
EOF

elif [ "$PROVIDER_CHOICE" = "2" ]; then

cat > .env <<EOF
ANTHROPIC_AUTH_TOKEN="$AUTH_TOKEN"

GEMINI_API_KEY="$GEMINI_API_KEY"

MODEL="$MODEL_PROVIDER"

ENABLE_MODEL_THINKING=true

PROVIDER_RATE_LIMIT=1
PROVIDER_RATE_WINDOW=3
PROVIDER_MAX_CONCURRENCY=3

HTTP_READ_TIMEOUT=120
EOF

else

cat > .env <<EOF
ANTHROPIC_AUTH_TOKEN="$AUTH_TOKEN"

OPENAI_API_KEY="$OPENAI_API_KEY"

MODEL="$MODEL_PROVIDER"

ENABLE_MODEL_THINKING=true

PROVIDER_RATE_LIMIT=1
PROVIDER_RATE_WINDOW=3
PROVIDER_MAX_CONCURRENCY=3

HTTP_READ_TIMEOUT=120
EOF

fi

# =========================================================
# 檢查 uv
# =========================================================

if ! command -v uv >/dev/null 2>&1; then

    echo ""
    echo "📦 未檢測到 uv，開始安裝..."
    echo ""

    curl -LsSf https://astral.sh/uv/install.sh | sh

    export PATH="$HOME/.local/bin:$PATH"
fi

# =========================================================
# 安裝 Python
# =========================================================

echo ""
echo "🐍 安裝 Python 3.12..."
echo ""

uv python install 3.12 || true

# =========================================================
# 啟動 Proxy
# =========================================================

echo ""
echo "🧠 啟動 Free Claude Code Proxy..."
echo ""

pkill -f "uvicorn server:app" || true

nohup uv run uvicorn server:app \
    --host 0.0.0.0 \
    --port "$PORT" \
    > freecc.log 2>&1 &

sleep 4

# =========================================================
# Claude Code 環境變數
# =========================================================

export ANTHROPIC_AUTH_TOKEN="$AUTH_TOKEN"
export ANTHROPIC_BASE_URL="http://localhost:$PORT"
export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1

echo ""
echo "========================================================="
echo "✅ Free Claude Code 已啟動"
echo "========================================================="
echo ""
echo "📡 Proxy:"
echo "http://localhost:$PORT"
echo ""
echo "🧠 Model:"
echo "$MODEL_PROVIDER"
echo ""
echo "🤖 即將啟動 Claude Code..."
echo ""
echo "提示："
echo "進入 Claude Code 後可輸入："
echo ""
echo "/model"
echo ""
echo "查看目前模型"
echo ""
echo "========================================================="
echo ""

# =========================================================
# 啟動 Claude Code
# =========================================================

cd "$ORIGINAL_DIR"
claude