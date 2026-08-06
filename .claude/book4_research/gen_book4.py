"""Book4 ワークフローの構造化出力から Dart のマトリクスデータと薬剤マスタを生成する."""
import html
import json
import re
import sys
from pathlib import Path

ROOT = Path('/Users/s/Desktop/AI開発環境/アプリ/麻酔薬リファレンス')
data = json.loads(Path(sys.argv[1]).read_text())
groups = {g['key']: g for g in data['result']['groups']}

# 既存マスタにある一般名 (重複エントリを作らないため)
GENERATED = {'diuretic.dart', 'gastrointestinal.dart'}
existing = set()
for p in (ROOT / 'lib/data/drugs').glob('*.dart'):
    if p.name in GENERATED:  # 自分が前回生成したものは既存扱いしない
        continue
    existing |= set(re.findall(r"name:\s*'((?:[^'\\]|\\.)*)'", p.read_text()))


def clean(s):
    if not s:
        return ''
    # 抽出時に紛れ込んだHTMLエンティティを戻す
    s = html.unescape(s)
    # 表示テキストの記号は半角に統一する
    for a, b in (('、', ', '), ('。', '. '), ('（', ' ('), ('）', ')'), ('：', ': ')):
        s = s.replace(a, b)
    return re.sub(r'[ \t]+', ' ', s).strip()


def q(s):
    s = clean(s).replace('\\', r'\\').replace("'", r"\'").replace('$', r'\$')
    return "'" + s.replace('\n', r'\n') + "'"


def marks_lit(m, cols):
    body = ', '.join(f"{q(c)}: {q(m.get(c, ''))}" for c in cols if m.get(c))
    return '{' + body + '}'


def by_group(items):
    """上位分類が連続するよう初出順で安定ソートする (縦帯を1回で描くため)."""
    order = {}
    for it in items:
        order.setdefault(it['group'], len(order))
    return sorted(items, key=lambda it: order[it['group']])


def matrix_rows(items, cols):
    out = []
    for it in by_group(items):
        if not any(it.get('marks', {}).get(c) for c in cols):
            continue  # マークが1つも無い行は表に出さない (PPI等)
        f = [f"    group: {q(it['group'])},", f"    generic: {q(it['generic'])},"]
        for key in ('brand', 'spec', 'dose', 'doseLimit', 'effect', 'mechanism'):
            if clean(it.get(key, '')):
                f.append(f"    {key}: {q(it[key])},")
        note = '\n'.join(
            f"■{clean(n['heading'])}\n{clean(n['body'])}" for n in it.get('notes', [])
        )
        if note:
            f.append(f"    note: {q(note)},")
        f.append(f"    marks: {marks_lit(it.get('marks', {}), cols)},")
        out.append('  SimpleMatrixRow(\n' + '\n'.join(f) + '\n  ),')
    return out


FORMS = {
    'injection': "DrugFormAvailability(hasInjection: true, hasOral: false, summary: '注射のみ')",
    'oral': "DrugFormAvailability(hasInjection: false, hasOral: true, summary: '内服のみ')",
    'both': "DrugFormAvailability(hasInjection: true, hasOral: true, summary: '注射と内服の両方')",
}


def drug_entries(items, category):
    out, skipped = [], []
    for it in items:
        name = clean(it['generic'])
        if name in existing:
            skipped.append(name)
            continue
        existing.add(name)
        f = [f"    name: {q(name)},", f"    brand: {q(it.get('brand', ''))},",
             f"    category: DrugCategory.{category},"]
        if clean(it.get('spec', '')):
            f.append(f"    spec: {q(it['spec'])},")
        if clean(it.get('dose', '')):
            f.append(f"    dose: {q(it['dose'])},")
        if clean(it.get('doseLimit', '')):
            f.append(f"    doseLimit: {q(it['doseLimit'])},")
        form = FORMS.get(it.get('forms', ''))
        if form:
            f.append(f"    forms: const {form},")
        f.append(f"    mechanism: {q(it.get('mechanism', ''))},")
        notes = it.get('notes', [])
        if notes:
            body = '\n'.join(
                f"      DrugNote({q(n['heading'])}, {q(n['body'])})," for n in notes
            )
            f.append('    notes: [\n' + body + '\n    ],')
        ci = it.get('contraindications', [])
        if ci:
            body = '\n'.join(
                f"      DrugContraindication({q(c['target'])}, {q(c['reason'])}),"
                for c in ci
            )
            f.append('    contraindications: [\n' + body + '\n    ],')
        cu = it.get('cautiousUse', [])
        if cu:
            body = '\n'.join(f"      {q(c)}," for c in cu)
            f.append('    cautiousUse: [\n' + body + '\n    ],')
        out.append('  Drug(\n' + '\n'.join(f) + '\n  ),')
    return out, skipped


d = groups['diuretic']
lax = groups['laxative-a']['items'] + groups['laxative-b']['items']
pp = groups['probiotic-ppi']
probio = [i for i in pp['items'] if i['group'] == 'プロバイオティクス']
ppi = [i for i in pp['items'] if i['group'] != 'プロバイオティクス']

(ROOT / 'lib/data/diuretic_matrix.dart').write_text(
    "import '../models/simple_matrix.dart';\n\n"
    "/// 利尿薬の一覧表. 原典は Book4.xlsx「その他」シートの利尿薬ブロック.\n"
    "/// 列は kDiureticCols (作用部位5列 + 利尿の型2列).\n"
    "const List<SimpleMatrixRow> kDiureticMatrix = [\n"
    + '\n'.join(matrix_rows(d['items'], d['cols'])) + '\n];\n'
)

(ROOT / 'lib/data/gi_matrix.dart').write_text(
    "import '../models/simple_matrix.dart';\n\n"
    "/// 便秘薬・消化管運動改善薬の一覧表.\n"
    "/// 原典 Book4.xlsx の「上 / 下 / 軟便化 / 蠕動改善」の4列に対応する.\n"
    "const List<SimpleMatrixRow> kLaxativeMatrix = [\n"
    + '\n'.join(matrix_rows(lax, groups['laxative-a']['cols'])) + '\n];\n\n'
    "/// 整腸剤 (プロバイオティクス)の一覧表. 列は製剤に含まれる菌種.\n"
    "const List<SimpleMatrixRow> kProbioticMatrix = [\n"
    + '\n'.join(matrix_rows(probio, pp['cols'])) + '\n];\n'
)

di, di_skip = drug_entries(d['items'], 'diuretic')
gi, gi_skip = drug_entries(lax + probio + ppi, 'gastrointestinal')

(ROOT / 'lib/data/drugs/diuretic.dart').write_text(
    "import '../../models/drug.dart';\n\n"
    "/// 利尿薬. 原典は Book4.xlsx「その他」シートの利尿薬ブロック.\n"
    "const List<Drug> kDiureticDrugs = [\n" + '\n'.join(di) + '\n];\n'
)
(ROOT / 'lib/data/drugs/gastrointestinal.dart').write_text(
    "import '../../models/drug.dart';\n\n"
    "/// 消化管薬 (便秘薬・消化管運動改善薬・整腸剤・PPI).\n"
    "/// 原典は Book4.xlsx「その他」シートの便秘薬・プロバイオティクス・PPIブロック.\n"
    "const List<Drug> kGastrointestinalDrugs = [\n" + '\n'.join(gi) + '\n];\n'
)

print(f'利尿薬マトリクス {len(matrix_rows(d["items"], d["cols"]))} 行')
print(f'便秘薬マトリクス {len(matrix_rows(lax, groups["laxative-a"]["cols"]))} 行')
print(f'整腸剤マトリクス {len(matrix_rows(probio, pp["cols"]))} 行')
print(f'薬剤マスタ 利尿薬 {len(di)} 剤 (既存のため除外: {di_skip})')
print(f'薬剤マスタ 消化管薬 {len(gi)} 剤 (既存のため除外: {gi_skip})')
