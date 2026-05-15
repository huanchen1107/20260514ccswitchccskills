#!/bin/bash
# Native Claude Code Launcher for CC Switch / OpenRouter

# 1. Load local .env keys
if [ -f ".env" ]; then
    # Export variables from .env (ignoring comments)
    export $(grep -v '^#' .env | xargs)
fi

# 2. Configuration
# If you are using a local CC Switch proxy, change this to http://localhost:18080 (or your app's port)
# Defaulting to OpenRouter official gateway for maximum compatibility
export ANTHROPIC_BASE_URL="https://openrouter.ai/api/v1"
export ANTHROPIC_AUTH_TOKEN="freecc"

# 3. Handle default model (OpenRouter requires specific IDs)
ARGS="$@"
if [[ "$*" != *"--model"* ]]; then
    # Defaulting to Sonnet 3.5 which is the best for coding
    ARGS="--model anthropic/claude-3.5-sonnet $ARGS"
fi

# 4. Execution
echo "========================================="
echo "🤖 Native Claude Code Launcher"
echo "========================================="
echo "📍 Gateway: $ANTHROPIC_BASE_URL"
echo "📦 Default Model: anthropic/claude-3.5-sonnet"
echo "-----------------------------------------"

claude $ARGS
