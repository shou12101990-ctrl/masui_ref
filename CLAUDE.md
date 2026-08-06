# やさしい麻酔科ローテ β — プロジェクトルール

麻酔科ローテ研修医向け Flutter web アプリ（薬剤リファレンス＋計算機＋解説＋緊急対応）。
GitHub Pages 公開: https://shou12101990-ctrl.github.io/masui_ref/

> 途中の作業・未回答の保留事項・マシン間の引き継ぎは `HANDOFF.md` を参照。

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

- `deploy.yml` は `workflow_dispatch` のみ＝**自動デプロイ OFF**。push してもデプロイは走らない。
- ユーザーが「デプロイ」「dep」「cctd」と言うまでデプロイしない。
- 手動デプロイ手順（`gh auth` 済み前提）:

  ```
  gh workflow run deploy.yml
  gh run list --workflow=deploy.yml --limit 1 --json databaseId,status,headSha
  gh run watch <id> --exit-status
  ```

- **push / deploy の前に必ず `git fetch` して `origin/main` との差分を確認する**（別セッション・codex が同じリポジトリを編集していることがある）。必要なら `git pull --rebase`。
- `cctd` = codex レビュー → `NO_FIX_NEEDED` ならデプロイ、というユーザー定義のショートカット。
- コミット／push は各バッチで可。
- コミットメッセージ末尾に必ず: `Co-Authored-By: Claude <使用モデル名> <noreply@anthropic.com>`（例: `Claude Opus 5`）

## 主要ファイル

- `lib/models/drug.dart` — `Drug` / `DrugNote` / `DrugContraindication` / カテゴリ enum
- `lib/data/drugs/` — 薬剤マスタ。カテゴリ別に 18 ファイルへ分割済み（計 248 剤）。
  `analgesic` `sedative` `antiarrhythmic` `antimicrobial`(53) `psychotropic_ext`(94) `vasopressor` `vasodilator`
  `circulatory_other` `local_anesthetic` `anticoagulant` `muscle_relaxant` `inhalational` `steroid` `antiemetic`
  `antihistamine` `transfusion` `other` `psychotropic`
- `lib/data/columns.dart` — 解説ノート（カテゴリ色 + ColumnArticle）
- `lib/screens/` — 各画面（機能ハブ calculator_hub、緊急対応 emergency、γ計算・iv PCA・点滴メトロノーム・局麻極量・DLT・酸素較差・許容出血量・メイロンBE補正・オピオイド換算 など）
  - `pre_entry_screen.dart` — 入室前準備チェックリスト（共通 16 項目 + 個別事例 9 群）
  - `abx_matrix_screen.dart` / `psy_matrix_screen.dart` — 抗微生物薬・向精神薬の一覧表（左端に上位分類の縦帯、自動縮小あり）
  - `drug_detail_screen.dart` — 薬剤詳細。カード順は 用法・用量 → 上限量・投与間隔 → 緊急時 → スペクトラム → 腎調節 → 機序
- `lib/main.dart` — タブ（機能／薬剤／解説／緊急対応）。下部ナビは自作（`_BottomNav`）で緊急対応のみ赤・太字。起動時は「機能」タブ。
