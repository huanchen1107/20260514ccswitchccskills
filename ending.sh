#!/bin/bash
echo "🛑 準備結束目前的工作階段..."
echo ""

# 2. 提醒 AI 更新開發日誌
echo ""
echo "🤖 嗨，AI 助手！請確認你已經將本次對話中「所有有意義的除錯、優化與結論」寫入當日的開發日誌中。"
echo "（如果還沒寫，請立刻更新檔案再繼續）"
echo ""

# 3. 讀取 Log 並更新對話紀錄
echo "🤖 正在讀取系統底層 Log 並更新 user/dialog.md (包含所有歷史對話)..."
python3 reconstruct_dialog.py 2>/dev/null || echo "⚠️ reconstruct_dialog.py 執行失敗"

echo ""
echo "🤖 嗨，AI 助手！請檢查以下事項："
echo "1. 今天的進度是否已寫入開發日誌？"
echo "2. dialog.md 是否已自動更新完畢？"
echo "3. 是否已更新 Tutorials/ 資料夾中的分項任務教學 (tutorial_#.md)？"
echo ""
read -p "請確認以上事項皆已完成？ (按 Enter 繼續推送至 GitHub)"

# 4. Git 備份
echo "📦 正在將所有檔案推送到 GitHub..."
git add .
git commit -m "Auto-commit: 結束工作階段 $(date +%Y-%m-%d)"
git push origin main || echo "⚠️ 推送失敗：可能尚未設定 git remote，請確認。"
echo "✅ 完成備份與同步！"
