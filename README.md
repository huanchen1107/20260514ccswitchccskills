# 2026.5.15 Freecc4ccSkillsProjectTemplate

> **⚠️ MEMO (2026-05-15)**: CC Switch is currently **not working**. Do not use it.
> This project runs exclusively via the **`free-claude-code` local proxy** with API keys configured in `.env`.
> Simply run `./cc.sh` to start.

A **unified Claude Code launcher** that routes AI requests through the `free-claude-code` local proxy to OpenRouter free-tier models — enabling zero-cost agentic AI coding with a one-command startup.

## 🚀 Quick Start

```bash
./startup.sh   # Initialize project + launch Claude Code
./ending.sh    # Commit, push, and finalize session
```

## 🤖 How it Works

`startup.sh` → reads `project_initial.md` → launches `cc.sh` → interactive menu:

```
1) Start Local Proxy & Claude (8082) [Default]   ← starts free-claude-code proxy
2) Connect to existing Proxy (8082)
3) Connect to CC Switch (18080)
4) Exit

Model options:
1) DeepSeek Chat (Not free)
2) DeepSeek V4 Flash (Free) [Default]
3) Llama 3.3 70B (Free)
4) Qwen3 Coder (Free)
5) Trinity Large Thinking (Free + 🧠 Thinking)
```

## 🔑 Key Design Decisions

| Problem | Solution |
|---------|----------|
| Claude Code browser login loop | `--bare` mode + `CLAUDE_CODE_SKIP_LOGIN=1` + 95-char dummy API key |
| `^M` terminal artifact on Enter | `stty icrnl` at script start |
| OpenRouter rejects request fields | Proxy strips `cache_control`, `context_management`, `mcp_servers`, `$schema`, `additionalProperties` |
| `reasoning` injected for all models | `ENABLE_MODEL_THINKING=false` in proxy `.env`; toggled per-session |
| Old Gemini free model removed | Updated to current free model IDs from OpenRouter |

## 📁 Project Structure

```
.
├── cc.sh              # Unified launcher (proxy + model selection)
├── startup.sh         # Session start: reads project goals + launches cc.sh
├── ending.sh          # Session end: update logs + commit + push
├── .env               # API keys (gitignored)
├── 2026.05.15開發日誌.md  # Daily dev log
└── user/dialog.md     # Auto-reconstructed conversation history
```

## 🆓 Free Models Available (via OpenRouter)

| Model | ID | Notes |
|-------|----|-------|
| DeepSeek V4 Flash | `deepseek/deepseek-v4-flash:free` | Default |
| Llama 3.3 70B | `meta-llama/llama-3.3-70b-instruct:free` | General purpose |
| Qwen3 Coder | `qwen/qwen3-coder:free` | Code-focused |
| Trinity Large Thinking | `arcee-ai/trinity-large-thinking:free` | Reasoning/thinking |

## 🛠 Proxy Modifications (`~/free-claude-code`)

The following files were patched to fix OpenRouter compatibility:

- `core/anthropic/native_messages_request.py` — strips unsupported fields, sanitizes tool schemas
- `providers/base.py` — `enable_thinking: bool = False` (default off)
- `config/settings.py` — reads `ENABLE_MODEL_THINKING` from `.env`

## 📋 Prerequisites

- `uv` — Python package manager (`brew install uv`)
- `npx` / Node.js — for Claude Code CLI
- `free-claude-code` proxy at `~/free-claude-code/`
- OpenRouter API key in `.env`
