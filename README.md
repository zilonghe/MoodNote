# 心记（MoodNote）— SwiftUI 骨架

抗抑郁向工具 App 第一版界面骨架：三 Tab（今日打卡 / 日记 / 我的），本地 JSON 存储，柔和蓝绿配色。

## 在 Xcode 里怎么用

1. 打开 Xcode → File → New → Project → **App**（iOS）
2. Product Name 填 `MoodNote`，Interface 选 **SwiftUI**，Language **Swift**，最低系统建议 **iOS 17**
3. 删掉自动生成的 `ContentView.swift`（如果有）
4. 把本目录下 `MoodNote/` 文件夹里的全部 `.swift` 拖进工程（勾选 Copy items if needed，Target 勾选 MoodNote）
5. 确认 `@main` 只有 `MoodNoteApp.swift` 一处
6. 选模拟器运行

## 目录

```
MoodNote/
  MoodNoteApp.swift
  Models/MoodModels.swift
  Store/MoodStore.swift
  Components/MoodTheme.swift
  Views/RootTabView.swift
  Views/Today/TodayView.swift
  Views/Journal/JournalListView.swift
  Views/Journal/JournalEditorView.swift
  Views/Profile/ProfileView.swift
```

## 已实现

- 今日：1–5 情绪 + 可选备注，当天可更新
- 日记：列表、按心情筛选、新建/编辑/删除
- 我的：连续打卡天数、近 7 日平均情绪、隐私说明
- 首次空数据时写入示例数据，方便预览

## 说明

本骨架不能替代心理咨询或危机干预。严重困扰时请联系可信赖的人和专业资源。

## GitHub Actions CI

仓库根目录已有 `.github/workflows/ios.yml`：在 `macos-15` 上对 **iOS Simulator** 执行 `xcodebuild`（`CODE_SIGNING_ALLOWED=NO`，无需开发者证书）。

推送到 `main` / 开 PR / 手动 Run workflow 都会触发。在 GitHub → Actions 看绿/红即可。
