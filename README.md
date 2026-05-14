# 2026.5.15 Freecc4ccSkillsProjectTemplate

This project repository contains the setup and scripts for running **Claude Code** integrated with **CC Switch** to route API requests to alternative providers like **DeepSeek** via **OpenRouter**, while maintaining a clean, automated project management workflow.

## 📝 Task History Log

Throughout this session, the following tasks were accomplished to set up and configure the environment:

### Setup & Installation
- **Task 1.1**: Installed the **CC Switch** desktop application via Homebrew (`brew install --cask cc-switch`) to manage AI CLI API configurations.
- **Task 2.1**: Developed a comprehensive implementation plan (`deepseek_skills_plan.md`) detailing the architecture for integrating CC Switch, OpenRouter, and Claude Code skills.
- **Task 2.2**: Reviewed reference materials and tutorial notes (`ref1.txt`) concerning DeepSeek V4 and zero-cost API routing strategies.

### OpenSpec Configuration (Archived)
- **Task 3.1 & 3.2**: Installed `@fission-ai/openspec` globally and initialized it for Claude Code. Cloned the `projectPM_initial` template repository and successfully ported the automated workflow scripts:
  - `startup.sh`
  - `ending.sh` (Stripped of ComfyUI-specific logic)
  - `reconstruct_dialog.py` (Updated to target the `huango` user path)
  - `project_initial.md`
- **Task 4.1**: Confirmed the successful generation of `.claude/skills` directory and OpenSpec commands.

### Repository & Workflow Management
- **Task 4.2**: Initialized a local Git repository, linked it to the remote `https://github.com/huanchen1107/2026.5.15-Freecc4ccSkillsProjectTemplate.git`, and pushed the initial setup to the `main` branch.
- **Task 5.1**: Executed `./startup.sh` to trigger the PM workflow. Successfully generated the daily development log (`2026.05.15開發日誌.md`) and the first tutorial file (`Tutorial/Tutorial_1.md`).

### Pivot to Native Claude Code
- **Task 6.1**: Based on user preference, completely removed the OpenSpec framework from the project (deleted `.claude` and `openspec` directories) to rely on the native Claude Code interface. These changes were committed and synced to GitHub. The global OpenSpec package was also subsequently uninstalled.
- **Task 7.1**: Authored a step-by-step guide on configuring the CC Switch desktop app to properly route native Claude Code requests to DeepSeek via OpenRouter.

---

## 🚀 How to Use

1. **Configure CC Switch**: Open the CC Switch app, set OpenRouter as the active provider with the Base URL (`https://openrouter.ai/api/v1`) and your API key. Set the model to `deepseek/deepseek-chat` or `deepseek/deepseek-coder`.
2. **Start Working**: Run `./startup.sh` to read project goals.
3. **Run Claude**: Simply execute `claude` in your terminal. CC Switch will automatically intercept the traffic and route it to DeepSeek.
4. **End Session**: Run `./ending.sh` to update logs, recover dialogs, and push all changes to GitHub.
