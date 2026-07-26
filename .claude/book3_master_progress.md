# Book3.xlsx 薬剤マスタ化 作業状態 (中断・再開用)

このファイルは 5時間の利用上限などで中断したとき, 別セッションからでも作業を再開するための
自己完結した作業指示書. 完了したら各チェックを `[x]` に更新すること.

## ゴール

`/Users/s/Desktop/Book3.xlsx` に入っている薬剤を, 既存の麻酔薬マスタと同じ水準で
添付文書ベースの薬剤マスタにして, アプリに実装しデプロイする.

ユーザーからの明示要件:

1. **剤形をマスタに織り込む**: 「静注製剤があるのか, 内服しか無いのか」を必ず持たせる.
2. **抗菌薬・抗精神病薬・抗不整脈薬** を対象とする. 特に **抗精神病薬と抗不整脈薬は
   緊急対応で投与が必要になる**ため, 緊急時の投与法の情報が要る.
3. 基本は **添付文書 (電子添文) の記載事項** を集める. その他の公式情報も集める.
4. リサーチは **opus で並列処理** する (Workflow ツールを使う).

## 元データ (抽出済み)

Book3.xlsx は 3シート. 抽出済み Markdown はセッションのスクラッチパッドにあるが,
消えていたら下記コマンドで再生成する (ふりがな rPh を除外するのが要点):

```bash
cp "/Users/s/Desktop/Book3.xlsx" /tmp/book3.xlsx
# 抽出スクリプトは本ファイル末尾「付録: 抽出スクリプト」を参照
```

| シート | 内容 | 概数 |
|---|---|---|
| sheet1 | 向精神薬 (抗精神病薬/抗不安薬/抗うつ薬/睡眠薬/抗てんかん薬/気分安定薬/抗パーキンソン薬/その他/違法薬物) | 約120剤 |
| sheet2 | 抗菌薬・抗真菌薬・抗ウイルス薬 | 約85剤 |
| sheet3 | 抗不整脈薬 (Vaughan-Williams分類) + 頻脈/徐脈アルゴリズム | 約22剤 |

Excel のセルコメントに臨床メモが入っている (sheet1:29, sheet2:132, sheet3:36 個).
これをベースにしつつ添付文書で裏取りして記載する.

## 実装方針 (決定済み)

- 既存 `lib/models/drug.dart` の `Drug` を使う. 以下を追加する:
  - `DrugForm form` 相当の情報 (静注可否 + 剤形サマリ). 新フィールド追加が必要.
  - `DrugCategory` に `antiarrhythmic('抗不整脈薬')`, `antimicrobial('抗菌薬')` を追加.
    (`psychotropic('向精神薬')` は既存. 現在ハロペリドール1剤のみなので拡充する)
- データは `lib/data/drugs/` 配下にカテゴリ別ファイルで追加し, `lib/data/drugs.dart` の
  `kDrugs` に spread する (既存パターンを踏襲).
- 色は `lib/widgets/drug_visuals.dart` の `DrugCategoryVisual.color` に case を追加
  (switch が網羅的なので enum 追加時は必須).
- 表記ルール: CLAUDE.md の通り全角句読点を半角に (、→", " 。→". " （→" (" ）→")" ：→": ").

## 進捗チェックリスト

- [x] Book3.xlsx の全シート・全コメント抽出 (ふりがな除外)
- [x] 既存アプリ構造の確認 (Drug モデル, drugs/ 分割, drug_visuals)
- [ ] **W1**: 抗不整脈薬(I群/III群/II・IV群) + 抗精神病薬(非定型/定型) リサーチ
      run: `wf_b57e51e0-d86` / task `w4bm0khut`
- [ ] **W2**: 抗てんかん薬(注射/内服)・抗うつ薬・抗不安薬/睡眠薬・抗パーキンソン薬 リサーチ
      run: `wf_d9fa57f2-0b3` / task `wf0nwbbb3`
- [ ] **W3**: 抗菌薬(セフェム/ペニシリン・カルバペネム/抗MRSA・AG/マクロライド・キノロン)・抗真菌/抗ウイルス リサーチ
      run: `wf_9376b7d3-28f` / task `wls3sxwuw`

Workflow の結果は `~/.claude/projects/-Users-s-Desktop-AI------------------/dc122f7e-da10-4533-8b7e-f891f847e2dd/subagents/workflows/<run>/journal.jsonl`
に残る. 再開時はまずここを見て, 完了済みのリサーチを再実行しないこと.
- [ ] モデル変更 (剤形フィールド + カテゴリ2種追加 + 色)
- [ ] データファイル生成 (antiarrhythmic.dart / antimicrobial.dart / psychotropic.dart 拡充)
- [ ] `flutter build web --no-tree-shake-icons --base-href /masui_ref/` が通る
- [ ] コミット
- [ ] デプロイ (下記手順)

## 中断からの再開手順

1. このファイルの進捗チェックを見て, 次の未完了項目から再開する.
2. 走らせていた Workflow の結果は `/workflows` または
   `~/.claude/projects/.../subagents/workflows/<run>/journal.jsonl` で確認できる.
   結果が残っていればリサーチをやり直さない.
3. Workflow が失われていたら, 未完了の群だけ再度 Workflow で回す.
   スクリプトは `~/.claude/projects/.../workflows/scripts/book3-*.js` に保存されている.

## ビルド・デプロイ手順 (このリポジトリ固有)

```bash
cd "/Users/s/Desktop/AI開発環境/アプリ/麻酔薬リファレンス"
flutter build web --no-tree-shake-icons --base-href /masui_ref/
```

デプロイは **自動デプロイが無効化されている** ため手動ディスパッチ:

```bash
git push origin main
gh workflow run "Deploy to GitHub Pages" --ref main
# 完了確認
gh run list --workflow=deploy.yml --limit 1
```

コミットメッセージ末尾には必ず:
`Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`

## 付録: 抽出スクリプト (ふりがな rPh を除外する版)

```python
import zipfile, re
import xml.etree.ElementTree as ET
from collections import defaultdict
NS='{http://schemas.openxmlformats.org/spreadsheetml/2006/main}'
def si_text(si):
    parts=[]
    for child in si:
        tag=child.tag.replace(NS,'')
        if tag=='t': parts.append(child.text or '')
        elif tag=='r':
            for sub in child:
                if sub.tag.replace(NS,'')=='t': parts.append(sub.text or '')
        # rPh (ふりがな) は無視する ← これをやらないと薬剤名が壊れる
    return ''.join(parts)
z=zipfile.ZipFile("/tmp/book3.xlsx")
sst=[si_text(si) for si in ET.fromstring(z.read("xl/sharedStrings.xml")).findall(NS+'si')]
# 以降 sheetN.xml の c/v を sst で解決し, commentsN.xml を ref で突き合わせる
```
