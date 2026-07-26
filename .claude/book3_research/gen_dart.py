#!/usr/bin/env python3
"""Book3 リサーチ結果 (JSON) → Dart 薬剤マスタ生成.

使い方:
    python3 .claude/book3_research/gen_dart.py

入力:
    .claude/book3_research/cached_research.json   (取得済み4群)
    .claude/book3_research/sonnet_research.json   (残り群. あれば)
出力:
    lib/data/drugs/antiarrhythmic.dart
    lib/data/drugs/antimicrobial.dart
    lib/data/drugs/psychotropic_ext.dart
"""
import json
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
RES = os.path.join(ROOT, ".claude", "book3_research")
OUT = os.path.join(ROOT, "lib", "data", "drugs")

# ── CLAUDE.md の表記ルール: 全角句読点を半角に ──────────────────────
PUNCT = [
    ("、", ", "),
    ("。", ". "),
    ("（", " ("),
    ("）", ")"),
    ("：", ": "),
    ("，", ", "),
    ("．", ". "),
    ("；", "; "),
]


def norm(s):
    """全角句読点を半角化し, 余分な空白をたたむ."""
    if not s:
        return ""
    s = str(s)
    for a, b in PUNCT:
        s = s.replace(a, b)
    # 行頭のスペース, 連続スペース, 行末スペースを整理
    s = re.sub(r"[ \t]+", " ", s)
    s = re.sub(r" *\n *", "\n", s)
    s = re.sub(r"\( +", "(", s)
    s = re.sub(r" +\)", ")", s)
    return s.strip()


def dq(s):
    """Dart のシングルクォート文字列リテラルに埋め込む形へエスケープ."""
    s = norm(s)
    s = s.replace("\\", "\\\\").replace("'", "\\'").replace("$", "\\$")
    s = s.replace("\n", "\\n")
    return s


def lit(s, indent=8):
    """長い文字列を Dart の隣接文字列連結で複数行に分割する."""
    body = dq(s)
    if len(body) <= 90:
        return "'" + body + "'"
    # \n 区切りで折る (\n は残す)
    parts = body.split("\\n")
    pad = " " * indent
    out = []
    for i, p in enumerate(parts):
        tail = "\\n" if i < len(parts) - 1 else ""
        out.append("'" + p + tail + "'")
    return ("\n" + pad).join(out)


# ── カテゴリ判定 ─────────────────────────────────────────────
def category_of(group_key, drug):
    k = (group_key or "").lower()
    g = (drug.get("group") or "") + " " + (drug.get("name") or "")
    if k.startswith("aa-") or "抗不整脈" in g or "Vaughan" in g:
        return "antiarrhythmic"
    if k in (
        "cephalosporin",
        "penicillin-carbapenem",
        "anti-mrsa-aminoglycoside",
        "macrolide-quinolone-others",
        "antifungal-antiviral",
    ):
        return "antimicrobial"
    return "psychotropic"


CAT_ENUM = {
    "antiarrhythmic": "DrugCategory.antiarrhythmic",
    "antimicrobial": "DrugCategory.antimicrobial",
    "psychotropic": "DrugCategory.psychotropic",
}


def render_drug(d, cat):
    """1剤分の Drug(...) リテラルを生成."""
    L = []
    a = L.append
    a("  Drug(")
    name = d.get("name", "")
    abbr = d.get("abbr", "")
    disp = f"{name} ({abbr})" if abbr and abbr not in name else name
    a(f"    name: {lit(disp)},")
    a(f"    brand: {lit(d.get('brand',''))},")
    a(f"    category: {CAT_ENUM[cat]},")
    if d.get("spec"):
        a(f"    spec: {lit(d['spec'])},")
    if d.get("dilution"):
        a(f"    dilution: {lit(d['dilution'])},")
    if d.get("concentration"):
        a(f"    concentration: {lit(d['concentration'])},")
    if d.get("dose"):
        a(f"    dose: {lit(d['dose'])},")
    # 剤形
    f = d.get("forms") or {}
    if f:
        a("    forms: DrugFormAvailability(")
        a(f"      hasInjection: {str(bool(f.get('hasInjection'))).lower()},")
        a(f"      hasOral: {str(bool(f.get('hasOral', True))).lower()},")
        a(f"      summary: {lit(f.get('summary',''), 10)},")
        a("    ),")
    if d.get("emergencyDose"):
        a(f"    emergencyDose: {lit(d['emergencyDose'])},")
    if d.get("spectrum"):
        a(f"    spectrum: {lit(d['spectrum'])},")
    if d.get("renalAdjust"):
        a(f"    renalAdjust: {lit(d['renalAdjust'])},")
    if d.get("periop"):
        a(f"    periop: {lit(d['periop'])},")
    a(f"    mechanism: {lit(d.get('mechanism',''))},")
    if d.get("packageInsertRevision") or d.get("packageInsertUrl"):
        a("    packageInsertReviewed: true,")
        if d.get("packageInsertRevision"):
            a(f"    packageInsertRevision: {lit(d['packageInsertRevision'])},")
        if d.get("packageInsertUrl"):
            a(f"    packageInsertUrl: {lit(d['packageInsertUrl'])},")
    notes = d.get("notes") or []
    if notes:
        a("    notes: [")
        for n in notes:
            a("      DrugNote(")
            a(f"        {lit(n.get('heading',''), 10)},")
            a(f"        {lit(n.get('body',''), 10)},")
            a("        type: DrugNoteType.packageInsert,")
            a("      ),")
        a("    ],")
    cis = d.get("contraindications") or []
    if cis:
        a("    contraindications: [")
        for c in cis:
            a("      DrugContraindication(")
            a(f"        {lit(c.get('target',''), 10)},")
            a(f"        {lit(c.get('reason',''), 10)},")
            a("      ),")
        a("    ],")
    cau = d.get("cautiousUse") or []
    if cau:
        a("    cautiousUse: [")
        for c in cau:
            a(f"      {lit(c, 8)},")
        a("    ],")
    a("  ),")
    return "\n".join(L)


FILES = {
    "antiarrhythmic": (
        "antiarrhythmic.dart",
        "kAntiarrhythmicDrugs",
        "抗不整脈薬. 周術期の頻脈性/徐脈性不整脈で静注する機会がある.",
    ),
    "antimicrobial": (
        "antimicrobial.dart",
        "kAntimicrobialDrugs",
        "抗菌薬・抗真菌薬・抗ウイルス薬. 周術期予防投与と重症感染で用いる.",
    ),
    "psychotropic": (
        "psychotropic_ext.dart",
        "kPsychotropicExtDrugs",
        "向精神薬 (抗精神病薬/抗てんかん薬/抗うつ薬/抗不安薬・睡眠薬/抗パーキンソン薬).",
    ),
}


def main():
    buckets = {"antiarrhythmic": [], "antimicrobial": [], "psychotropic": []}
    seen = set()
    for fn in ("cached_research.json", "sonnet_research.json"):
        p = os.path.join(RES, fn)
        if not os.path.exists(p):
            print(f"  (skip {fn}: not found)")
            continue
        data = json.load(open(p, encoding="utf-8"))
        for block in data:
            key = block.get("key") or block.get("run") or ""
            for d in block.get("drugs", []):
                nm = d.get("name", "")
                if not nm or nm in seen:
                    continue
                seen.add(nm)
                buckets[category_of(key, d)].append(d)

    total = 0
    for cat, drugs in buckets.items():
        if not drugs:
            continue
        fname, varname, desc = FILES[cat]
        body = "\n".join(render_drug(d, cat) for d in drugs)
        src = (
            "import '../../models/drug.dart';\n\n"
            f"/// {desc}\n"
            f"/// Book3.xlsx のセルコメントを起点に, 各電子添文で裏取りして作成.\n"
            f"const List<Drug> {varname} = [\n{body}\n];\n"
        )
        with open(os.path.join(OUT, fname), "w", encoding="utf-8") as fh:
            fh.write(src)
        print(f"  {fname}: {len(drugs)}剤")
        total += len(drugs)
    print(f"TOTAL {total}剤")


if __name__ == "__main__":
    main()
