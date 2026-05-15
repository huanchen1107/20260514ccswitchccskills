#!/bin/bash
echo "🛑 準備結束目前的工作階段..."
echo ""

# 1. Remind AI to update dev log and README
echo "🤖 嗨，AI 助手！請確認以下文件已更新："
echo "   ✅ 開發日誌 (2026.XX.XX開發日誌.md) — 加入今日所有有意義的除錯、優化與結論"
echo "   ✅ README.md — 確保反映最新的工作流與使用說明"
echo "   ✅ Tutorials/ 資料夾中的分項任務教學 (若有新任務)"
echo ""
echo "（如果還沒更新，請立刻更新檔案再繼續）"
echo ""

# 2. Reconstruct dialog log
echo "🤖 正在讀取系統底層 Log 並更新 user/dialog.md..."
python3 reconstruct_dialog.py 2>/dev/null || echo "⚠️ reconstruct_dialog.py 執行失敗"

# 3. Confirm docs are ready
echo ""
echo "📋 文件更新確認清單："
echo "   1. 今天的進度是否已寫入開發日誌？"
echo "   2. README.md 是否已更新？"
echo "   3. dialog.md 是否已自動更新完畢？"
echo ""
read -r -p "按 Enter 繼續推送至 GitHub..."

# 4. Git backup
echo ""
echo "📦 正在將所有檔案推送到 GitHub..."
git add .
git commit -m "Auto-commit: 結束工作階段 $(date +%Y-%m-%d)"
git push origin main || echo "⚠️ 推送失敗：請確認 git remote 設定。"
echo "✅ 完成備份與同步！"
