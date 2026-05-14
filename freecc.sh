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

# =========================================================
# 檢查基礎依賴 (Node.js)
# =========================================================

if ! command -v node >/dev/null 2>&1; then
    echo "❌ 錯誤：未檢測到 Node.js，這是執行 Claude Code 所必需的。"
    echo "💡 建議：前往 https://nodejs.org/ 安裝，或使用 'brew install node' (macOS)。"
    exit 1
fi

# =========================================================
# 檢查 Claude Code CLI
# =========================================================

if ! command -v claude >/dev/null 2>&1; then
    echo "⚠️ 警告：未檢測到 'claude' 指令（Claude Code CLI 未安裝）。"
    echo "💡 建議執行以下指令進行安裝："
    echo "   npm install -g @anthropic-ai/claude-code"
    echo ""
    read -p "是否現在嘗試安裝？ (y/n): " INSTALL_CLAUDE
    if [ "$INSTALL_CLAUDE" = "y" ]; then
        npm install -g @anthropic-ai/claude-code
    else
        echo "❌ 請手動安裝 Claude Code 後再執行此腳本。"
        exit 1
    fi
fi

# =========================================================
# 載入本地 .env 設定 (如果存在)
# =========================================================
if [ -f "$ORIGINAL_DIR/.env" ]; then
    echo "⚙️ 載入本地 .env 設定..."
    source "$ORIGINAL_DIR/.env"
fi

# =========================================================
# 硬編碼 API Keys (如果您不想使用 .env，可以在此填寫)
# =========================================================
OPENROUTER_API_KEY="${OPENROUTER_API_KEY:-}"
GEMINI_API_KEY="${GEMINI_API_KEY:-}"
OPENAI_API_KEY="${OPENAI_API_KEY:-}"
DEEPSEEK_API_KEY="${DEEPSEEK_API_KEY:-}"

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
echo "4) DeepSeek API"
echo ""

read -p "請輸入選項 [1-4]: " PROVIDER_CHOICE

if [ "$PROVIDER_CHOICE" = "1" ]; then

    echo ""
    echo "🔑 使用 OpenRouter API Key..."
    if [ -z "$OPENROUTER_API_KEY" ]; then
        echo "格式通常是： sk-or-xxxxxxxx"
        echo ""
        read -s -p "OPENROUTER_API_KEY: " OPENROUTER_API_KEY
        echo ""
    fi

    MODEL_PROVIDER="open_router/google/gemini-2.5-pro"

elif [ "$PROVIDER_CHOICE" = "2" ]; then

    echo ""
    echo "🔑 使用 Gemini API Key..."
    if [ -z "$GEMINI_API_KEY" ]; then
        echo ""
        read -s -p "GEMINI_API_KEY: " GEMINI_API_KEY
        echo ""
    fi

    MODEL_PROVIDER="gemini/models/gemini-2.0-flash"

elif [ "$PROVIDER_CHOICE" = "3" ]; then

    echo ""
    echo "🔑 使用 OpenAI API Key..."
    if [ -z "$OPENAI_API_KEY" ]; then
        echo ""
        read -s -p "OPENAI_API_KEY: " OPENAI_API_KEY
        echo ""
    fi

    MODEL_PROVIDER="openai/gpt-4o"

elif [ "$PROVIDER_CHOICE" = "4" ]; then

    echo ""
    echo "🔑 使用 DeepSeek API Key..."
    if [ -z "$DEEPSEEK_API_KEY" ]; then
        echo ""
        read -s -p "DEEPSEEK_API_KEY: " DEEPSEEK_API_KEY
        echo ""
    fi

    MODEL_PROVIDER="deepseek/deepseek-chat"

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

PROVIDER_RATE_LIMIT=20
PROVIDER_RATE_WINDOW=60
PROVIDER_MAX_CONCURRENCY=10

HTTP_READ_TIMEOUT=120
EOF

elif [ "$PROVIDER_CHOICE" = "2" ]; then

# NOTE: Gemini Free Tier (Google AI Studio) has a strict limit of 15 RPM (Requests Per Minute).
# If you hit this often, consider upgrading to a Paid Tier (Tier 1+) for 2,000 RPM.
# Setting this to 15 is the "Safe Max" for Free Tier.
cat > .env <<EOF
ANTHROPIC_AUTH_TOKEN="$AUTH_TOKEN"

GEMINI_API_KEY="$GEMINI_API_KEY"

MODEL="$MODEL_PROVIDER"

ENABLE_MODEL_THINKING=true

PROVIDER_RATE_LIMIT=15
PROVIDER_RATE_WINDOW=60
PROVIDER_MAX_CONCURRENCY=2

HTTP_READ_TIMEOUT=120
EOF

elif [ "$PROVIDER_CHOICE" = "3" ]; then

cat > .env <<EOF
ANTHROPIC_AUTH_TOKEN="$AUTH_TOKEN"

OPENAI_API_KEY="$OPENAI_API_KEY"

MODEL="$MODEL_PROVIDER"

ENABLE_MODEL_THINKING=true

PROVIDER_RATE_LIMIT=20
PROVIDER_RATE_WINDOW=60
PROVIDER_MAX_CONCURRENCY=10

HTTP_READ_TIMEOUT=120
EOF

else

cat > .env <<EOF
ANTHROPIC_AUTH_TOKEN="$AUTH_TOKEN"

DEEPSEEK_API_KEY="$DEEPSEEK_API_KEY"

MODEL="$MODEL_PROVIDER"

ENABLE_MODEL_THINKING=true

PROVIDER_RATE_LIMIT=20
PROVIDER_RATE_WINDOW=60
PROVIDER_MAX_CONCURRENCY=10

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

# 確保連接埠 8082 是乾淨的
echo "🧹 清理連接埠 $PORT..."
lsof -ti :"$PORT" | xargs kill -9 >/dev/null 2>&1 || true
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
echo "💡 建議事項："
echo "1. 如果模型回應緩慢，可以嘗試切換不同的 Provider。"
echo "2. 如果遇到 401 錯誤，請檢查您的 .env 或 API Key 是否正確。"
echo "3. 您可以使用 /compact 來壓縮對話歷史，節省 Token。"
echo ""
echo "========================================================="
echo ""

# =========================================================
# 啟動 Claude Code
# =========================================================

cd "$ORIGINAL_DIR"

if command -v claude >/dev/null 2>&1; then
    claude
else
    echo "❌ 啟動失敗：找不到 'claude' 指令。"
    echo "💡 請確保已執行 'npm install -g @anthropic-ai/claude-code'。"
fi