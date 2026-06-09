# やさしい麻酔科ローテ β — プロジェクトルール

麻酔科ローテ研修医向け Flutter web アプリ（薬剤リファレンス＋計算機＋解説＋緊急対応）。
GitHub Pages 公開: https://shou12101990-ctrl.github.io/masui_ref/

## テキスト記載の固定ルール（最重要・薬剤マスタ／解説ノート共通）

ノート・薬剤マスタへ記載・転記する文章は、**全角句読点を必ず半角に統一**する。
新規に書く文章も必ず従うこと。

| 全角 | → 半角 |
|---|---|
| 、 | `, ` |
| 。 | `. ` |
| （ | ` (` |
| ） | `)` |
| ： | `: ` |

（`（`→` (` は前に半角スペースを入れる。`，` `．` も同様に `, ` `. ` へ）

## リライト方針（薬剤マスタ・ノートのリサーチ＆リライト）

- 用量・機序・数値は web（各薬剤の添付文書 / MHAUS / 各種ガイドライン / 成書）で裏取りし、誤り・古い記載は修正する。
- 既に正しい数値は極力そのまま残す（むやみに変えない）。
- 重要な不足（適応・禁忌・副作用・注意点）は簡潔に追記してよい。
- 1 バッチ 3 剤ずつ。各バッチで「リサーチで確認した事実＋リライト案」を提示 → ユーザー確認 → 反映。Sources（参照 URL）を併記する。

## ビルド

```
flutter build web --no-tree-shake-icons --base-href /masui_ref/
```
（Bash のカレントが別フォルダ＝栄養計算機 になることがあるので、必ずこのリポジトリ内＝絶対パスで実行）

## デプロイ（重要）

- GitHub Actions の `Deploy to GitHub Pages` ワークフローは**無効化済み（自動デプロイ OFF）**。
- ユーザーが「デプロイ」と言うまでデプロイしない。再開は `gh workflow enable "Deploy to GitHub Pages"`。
- コミット／push は各バッチで可（push してもデプロイは走らない）。
- コミットメッセージ末尾に必ず: `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`

## 主要ファイル

- `lib/data/drugs.dart` — 薬剤マスタ（Drug + DrugNote、カテゴリ enum は `lib/models/drug.dart`）
- `lib/data/columns.dart` — 解説ノート（カテゴリ色 + ColumnArticle）
- `lib/screens/` — 各画面（機能ハブ calculator_hub、緊急対応 emergency、γ計算・iv PCA・点滴メトロノーム・局麻極量・DLT・酸素較差・許容出血量・メイロンBE補正・オピオイド換算 など）
- `lib/main.dart` — タブ（薬剤／機能／解説／緊急対応）。下部ナビは自作（`_BottomNav`）で緊急対応のみ赤・太字。
