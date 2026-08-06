export const meta = {
  name: 'book4-gi-diuretics',
  description: 'Book4.xlsx から利尿薬・便秘薬・プロバイオティクス・PPIを薬剤マスタ用に構造化する',
  phases: [
    { title: '抽出', detail: '原典セル + コメントから薬剤データを構造化 (sonnet)' },
    { title: '検証', detail: '電子添文と突き合わせて誤りを削除・訂正 (sonnet)' },
  ],
}

const ROOT = '/Users/s/Desktop/AI開発環境/アプリ/麻酔薬リファレンス'
const SRC = '.claude/book4_research/source_raw.txt'

const SCHEMA = {
  type: 'object',
  properties: {
    items: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          generic: { type: 'string', description: '一般名. 薬剤マスタの name にそのまま使う' },
          brand: { type: 'string', description: '商品名. 複数は " / " 区切り. 不明なら空文字' },
          group: { type: 'string', description: '上位分類 (系統). マトリクスの左端の縦帯に使う' },
          spec: { type: 'string', description: '規格. 不明なら空文字' },
          dose: { type: 'string', description: '標準的な用法・用量. 1-2行' },
          doseLimit: { type: 'string', description: '上限量・1日回数上限・投与間隔の規定. 規定が無ければ空文字' },
          mechanism: { type: 'string', description: '作用機序の要約. 1-2文' },
          effect: { type: 'string', description: '位置づけの一言 (マトリクスの行に出す). 30字以内' },
          marks: {
            type: 'object',
            description: 'マトリクスのマーク. キーは指定された列名, 値は "○" (該当) / "△" (限定的・条件付き) / "" (非該当)',
            additionalProperties: { type: 'string' },
          },
          notes: {
            type: 'array',
            description: '詳細画面に出す臨床メモ. 原典コメントの内容を整理して入れる',
            items: {
              type: 'object',
              properties: {
                heading: { type: 'string' },
                body: { type: 'string' },
              },
              required: ['heading', 'body'],
            },
          },
          contraindications: {
            type: 'array',
            description: '電子添文上の禁忌. 理由必須. 確実なものだけ',
            items: {
              type: 'object',
              properties: {
                target: { type: 'string' },
                reason: { type: 'string' },
              },
              required: ['target', 'reason'],
            },
          },
          cautiousUse: {
            type: 'array',
            description: '慎重投与・注意する患者背景',
            items: { type: 'string' },
          },
          forms: { type: 'string', enum: ['injection', 'oral', 'both', 'other'], description: '剤形' },
        },
        required: ['generic', 'brand', 'group', 'dose', 'mechanism', 'effect', 'marks', 'notes'],
      },
    },
  },
  required: ['items'],
}

const RULES = `
## 表記ルール (厳守)
- 表示テキストの記号は半角に統一する. 読点は ", " / 句点は ". " / 括弧は " (" と ")" / コロンは ": ". 中黒 "・" は使ってよい.
- 全角の 、。（）： は絶対に使わない.
- 数値は必ず単位付き.
- 冗長な前置きを書かない. 「〜とされている」ではなく事実を短く.

## 正確性 (最重要)
- 原典 (Book4) は施設のメモであり誤記・空欄・書きかけ (「あ」「●h」など)が混ざっている. そのまま写さない.
- 用量・機序・禁忌は国内の電子添文を基準に確認し, 원典と食い違う場合は電子添文を正とする.
- 確信が持てない数値・禁忌は書かない (空文字 / 空配列にする). 網羅性より正確性を優先する.
- 原典コメントにある臨床的な知見 (使い分け, 副作用, 周術期の注意) は notes に整理して残す. これが本アプリの価値なので削らない.
- 出典が原典コメントのみで電子添文に無い記述は, notes の heading に " (施設メモ)" と付ける.
`

const GROUPS = [
  {
    key: 'diuretic',
    title: '利尿薬',
    rows: '原典の 99〜117 行目 (カルペリチド 〜 メキシレチン)',
    comments: 'セルコメント F99, G99, F100, G100, G101, G102, G103, G105, G108, G114, F116, G116, G117',
    cols: ['近位', 'Henle', '遠位', '集合管', '血管', 'Na利尿', '水利尿'],
    colHelp:
      '「近位/Henle/遠位/集合管」はネフロンのどの部位に作用するか. 「血管」は血管拡張作用を持つか. ' +
      '「Na利尿」はNaと水をともに排泄するか, 「水利尿」は自由水のみを排泄するか. ' +
      '作用機序から確実に言えるものだけ "○", 副次的・限定的なものは "△", 該当しなければ "".',
    hint:
      '原典 117 行目の「メキシレチン」は明らかな誤記で, 内容 (125ml/5ml, 0.8-1.2ml/h, 記載された機序) は ' +
      'カルペリチドの行のコピーになっている. メキシレチンは抗不整脈薬であり利尿薬ではないので items から除外すること. ' +
      'また 104 行目のテルミサルタンは ARB であり厳密には利尿薬ではないが, 原典が利尿薬の並びに入れているので ' +
      'group を "ARB (参考)" として残してよい. ヒドロクロロチアジドの合剤 (110-113行) は本体1剤にまとめる.',
  },
  {
    key: 'laxative-a',
    title: '便秘薬・消化管運動改善薬 (前半)',
    rows: '原典の 73〜85 行目 (エリスロマイシン 〜 リナクロチド)',
    comments: 'セルコメント F73, G73, G74, G75, G76, G78, G79, F80, G80, G81, F82, G82, G83, G84, G85',
    cols: ['上部消化管', '下部消化管', '軟便化', '蠕動改善'],
    colHelp:
      '原典の「上 / 下 / 軟便化 / 蠕動改善」の4列に対応する. 上=上部消化管 (胃・十二指腸)に効く, ' +
      '下=下部消化管 (大腸)に効く, 軟便化=便の水分を増やす, 蠕動改善=腸管運動を促進する. ' +
      '原典の ● が付いている列は "○" にする. 原典に無くても機序から明らかなものは "○" を足してよい.',
    hint:
      'エリスロマイシンとメトクロプラミドは便秘薬ではなく消化管運動改善薬として原典に載っている. group を分けて残す. ' +
      'メトクロプラミドは既に薬剤マスタ (antiemetic.dart) にあるので, マトリクス行としてだけ扱い, ' +
      'notes は原典コメント由来の消化管運動に関する部分に絞る.',
  },
  {
    key: 'laxative-b',
    title: '便秘薬・消化管運動改善薬 (後半)',
    rows: '原典の 86〜96 行目 (エロビキシバット 〜 Zn)',
    comments: 'セルコメント F86, G86, G87, G88, G90, F91, G91, G92, G93, G94, F95, G95, G96',
    cols: ['上部消化管', '下部消化管', '軟便化', '蠕動改善'],
    colHelp:
      '原典の「上 / 下 / 軟便化 / 蠕動改善」の4列に対応する. 上=上部消化管 (胃・十二指腸)に効く, ' +
      '下=下部消化管 (大腸)に効く, 軟便化=便の水分を増やす, 蠕動改善=腸管運動を促進する. ' +
      '原典の ● が付いている列は "○" にする. 原典に無くても機序から明らかなものは "○" を足してよい.',
    hint:
      '漢方 (大建中湯, 麻子仁丸, 六君子湯, 大黄甘草湯)も1剤として扱う. 甘草含有製剤の偽性アルドステロン症は ' +
      '周術期に重要なので notes に残す. 93 行目「浣腸製剤」はグリセリン浣腸・レシカルボン坐剤・テレミンソフト坐剤を ' +
      '含む総称なので, generic を "浣腸・坐剤 (グリセリン / 炭酸水素Na / ビサコジル)" のように整理する. ' +
      '94 行目「ナルメデジン」は正しくは "ナルデメジン" (スインプロイク)なので訂正する. ' +
      '95 行目のビタミンB5 (パンテノール), 96 行目の Zn も原典どおり残す.',
  },
  {
    key: 'probiotic-ppi',
    title: 'プロバイオティクス + PPI',
    rows: '原典の 59〜60 行目 (PPI) と 63〜70 行目 (プロバイオティクス)',
    comments: 'セルコメント C63, H63, I63, J63, L63, M63, G64, G66, G69',
    cols: ['酪酸菌', '乳酸菌', '耐性乳酸菌', '糖化菌', '酵母菌', 'ビフィズス菌'],
    colHelp:
      '原典 63 行目のヘッダ「酪酸菌 / 乳酸菌 / R乳酸菌 / 糖化菌 / 酵母菌 / ビフィズス菌」に対応する. ' +
      'R乳酸菌 = 耐性乳酸菌. その製剤に含まれる菌種の列を "○" にする. ' +
      'PPI の2剤は菌種の列がすべて "" でよい (マトリクスには出さず薬剤マスタにのみ入れる).',
    hint:
      '原典の ● の位置 (64-70行) をそのまま菌種の対応として読む. ' +
      '製剤名は商品名なので generic には成分 (酪酸菌製剤, ビフィズス菌製剤 など)を, brand に製品名を入れる. ' +
      'ラックビーR と ラックビー は別製剤 (耐性乳酸菌 vs ビフィズス菌)なので分けて扱う. ' +
      'PPI (オメプラゾール, ランソプラゾール)は原典の情報が薄いので, 電子添文ベースで最低限の dose と mechanism を書く. ' +
      '牛乳アレルギー禁忌 (ラックビーR)など原典コメントの禁忌は拾う.',
  },
]

phase('抽出')

const results = await pipeline(
  GROUPS,
  (g) =>
    agent(
      `あなたは日本の麻酔科・集中治療で使う薬剤マスタを整備している. リポジトリは ${ROOT} (Flutter/Dart).

## 原典
${ROOT}/${SRC} を Read すること. これは施設の Excel メモ (Book4.xlsx)をテキスト化したもので,
前半が「行番号 | セル値をパイプ区切りにしたもの」, 後半 (「########## COMMENTS ##########」以降)が
各セルに付いていた長文コメントである.

## 担当範囲
${g.title}
- 行: ${g.rows}
- ${g.comments}

補足: ${g.hint}

## 既存マスタとの重複確認
${ROOT}/lib/data/drugs/ に既存の薬剤マスタがある. Grep で担当薬剤の一般名を検索し,
既に存在する薬は items の generic を既存の name と完全一致させること (重複エントリを作らない).

## マトリクスの列
この群のマトリクス列は次のとおり: ${JSON.stringify(g.cols)}
${g.colHelp}
marks のキーは必ずこの列名と完全一致させ, 全列分のキーを含めること.

${RULES}

## タスク
担当範囲の各薬剤について, スキーマどおりの構造化データを作る.
notes は原典コメントの臨床的知見を整理して 1〜4 セクションにまとめる (heading は "■" を付けない短い見出し).
ファイルは編集しないこと. 構造化出力で返すだけでよい.`,
      { label: `抽出:${g.key}`, phase: '抽出', model: 'sonnet', schema: SCHEMA },
    ),
  (res, g) => {
    if (!res || !res.items || res.items.length === 0) return { key: g.key, cols: g.cols, items: [] }
    return agent(
      `あなたは薬剤情報の校閲者. 別の担当者が作った薬剤データを敵対的に検証する.

原典は ${ROOT}/${SRC} の ${g.rows} と ${g.comments}. 必要なら Read して突き合わせること.
マトリクス列は ${JSON.stringify(g.cols)}.

## 検証対象
${JSON.stringify(res.items, null, 2)}

## 検証すること
1. 用量・上限・投与間隔が国内の電子添文と合っているか. 少しでも怪しい数値はその項目を空文字にする (誤りは臨床上危険).
2. 禁忌が実在するか. もっともらしいだけの捏造を消す. 理由が書けないものは消す.
3. 作用機序が正しいか. 原典のコピペミス (別の薬の機序が入っている等)を見逃していないか.
4. marks が機序と整合するか. 根拠の無い "○" は "" に落とす. 全列分のキーが揃っているか.
5. 一般名の表記が正しいか (誤記・旧名). ${ROOT}/lib/data/drugs/ に同じ薬が既にあれば name を完全一致させる.
6. 表記ルール (半角記号)に従っているか. 従っていなければ直す.
7. notes に原典の臨床知見が十分残っているか. 削られすぎていれば原典から補う.

${RULES}

## 出力
検証・修正後の最終リストを返す. 疑わしい数値は消すが, 薬剤そのものは残す.
ファイルは編集しないこと.`,
      { label: `検証:${g.key}`, phase: '検証', model: 'sonnet', schema: SCHEMA },
    ).then((v) => ({ key: g.key, cols: g.cols, items: v && v.items ? v.items : [] }))
  },
)

const ok = results.filter(Boolean)
const total = ok.reduce((s, r) => s + r.items.length, 0)
log(`検証後 ${total} 剤を構造化`)

return { groups: ok, total }
