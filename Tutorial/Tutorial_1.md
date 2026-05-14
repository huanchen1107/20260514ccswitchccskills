# Tutorial 1: 初始化 CC Switch 與 OpenSpec 工作流

本教學記錄了如何在本專案中設定 AI 開發環境，讓你能夠使用低成本的 DeepSeek 模型來驅動 Claude Code。

## 1. 概念理解
傳統上我們依賴寫得很長的 Prompt 來指揮 AI。但現在，我們將轉向「Skill Engineering」（技能工程），透過 **OpenSpec** 框架建立標準化流程（SOP），讓 AI 像一個「虛擬團隊」般運作。

## 2. CC Switch 設定
**CC Switch** 是一個桌面版管理工具，用來切換 AI CLI 工具（如 Claude Code）背後的 API 供應商。
1. 在 CC Switch 中新增 `OpenRouter` 作為提供者。
2. 將 Base URL 設為 `https://openrouter.ai/api/v1`。
3. 填寫你的 OpenRouter API 金鑰。
4. 選擇模型：`deepseek/deepseek-chat` 或 `deepseek/deepseek-coder`。

## 3. OpenSpec 初始化
1. 使用 npm 安裝：`npm install -g @fission-ai/openspec@latest`
2. 進入專案目錄，執行 `openspec init`。
3. 選擇 `Claude Code`，這會在專案底下產生 `.claude/skills` 與 `.claude/commands`。

## 4. 執行與管理
- **啟動專案**：每次進入專案，可以執行 `./startup.sh` 來檢視最新的開發日誌與專案目標。
- **下指令**：在終端機中執行 `claude`，然後輸入 `/opsx:propose "你的需求"` 來啟動自動化需求分析與規劃。
- **結束工作**：收工時執行 `./ending.sh`，系統會自動備份完整對話歷史、提醒更新日誌，並推送到 GitHub。
