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


SALT_RE = re.compile(
    r"(?:一|二|三|四|１|２|３|４)?"
    r"(ナトリウム|カリウム|カルシウム|マグネシウム|塩酸塩|臭化水素酸塩|硫酸塩|水和物|"
    r"メシル酸塩|ベシル酸塩|トシル酸塩|メタンスルホン酸塩|メタンスルホン酸|"
    r"リン酸塩|酢酸塩|マレイン酸塩|フマル酸塩|コハク酸塩|酒石酸塩|乳酸塩|"
    r"クエン酸塩|臭化物|塩化物|エシル酸塩|パモ酸塩)$"
)

# 名寄せキーを作るときに, 塩を剥がすと意味が壊れるので保護する語.
# (硫酸マグネシウム・アデノシン三リン酸などは「塩の名前」自体が薬剤名の一部)
PROTECT = (
    "硫酸マグネシウム",
    "炭酸リチウム",
    "アデノシン三リン酸",
    "重炭酸ナトリウム",
    "塩化カリウム",
    "塩化ナトリウム",
    "グルコン酸カルシウム",
)


def key_of(name):
    """塩・水和物・略号・記号を落として名寄せ用のキーにする.

    「パロキセチン塩酸塩水和物」のような多段の塩も, 変化しなくなるまで剥がす.
    薬剤名自体に塩の名前を含むもの (硫酸マグネシウム等) は PROTECT で保護する.
    """
    s = re.sub(r"\s*\(.*?\)", "", str(name)).strip()
    for p in PROTECT:
        if s.startswith(p):
            return re.sub(r"[\s・･/／]+", "", p)
    # 配合剤は「・」で区切られた成分ごとに塩を剥がす
    parts = re.split(r"[・･/／]", s)
    cleaned = []
    for part in parts:
        p = part.strip()
        prev = None
        while prev != p:
            prev = p
            p = SALT_RE.sub("", p).strip()
        if p:
            cleaned.append(p)
    s = "".join(cleaned)
    s = re.sub(r"\s+", "", s)
    return s.strip()


def load_aliases():
    """名寄せ台帳を読む. 出力時は canonical (簡素な名前)を使うための辞書を返す."""
    p = os.path.join(RES, "drug_aliases.json")
    if not os.path.exists(p):
        return {}
    data = json.load(open(p, encoding="utf-8"))
    # 混同禁止に載っている薬剤は簡素化で潰れないよう除外する.
    # 台帳の表記は表示名 (略号つき) なので, 正規化キーでも保護する.
    protected = set()
    for x in data.get("distinct", []):
        for item in x.get("items", []):
            protected.add(item)
            protected.add(key_of(item))
    out = {}
    for g in data.get("same", []):
        can = g.get("canonical", "").strip()
        if not can:
            continue
        for v in g.get("variants", []):
            if v in protected or key_of(v) in protected:
                continue
            # 元の表記でも, 正規化キーでも引けるようにする
            out[v] = can
            out.setdefault(key_of(v), can)
    return out


ALIASES = load_aliases()


def display_name(name, abbr):
    """表示名. 台帳に canonical があれば簡素な名前を使い, 略号は括弧で残す."""
    base = ALIASES.get(name) or ALIASES.get(key_of(name))
    if base:
        # 元の表記から略号を拾う (台帳の canonical には略号が無いため)
        m = re.search(r"\(([A-Za-z0-9\-/]{2,8})\)", name)
        if m:
            return f"{base} ({m.group(1)})"
        return f"{base} ({abbr})" if abbr and abbr not in base else base
    if abbr and abbr not in name:
        return f"{name} ({abbr})"
    return name


def render_drug(d, cat):
    """1剤分の Drug(...) リテラルを生成."""
    L = []
    a = L.append
    a("  Drug(")
    name = d.get("name", "")
    abbr = d.get("abbr", "")
    disp = display_name(name, abbr)
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
    gl_tips = d.get("_tips") or []
    if notes or gl_tips:
        a("    notes: [")
        for n in notes:
            a("      DrugNote(")
            a(f"        {lit(n.get('heading',''), 10)},")
            a(f"        {lit(n.get('body',''), 10)},")
            a("        type: DrugNoteType.packageInsert,")
            a("      ),")
        # 感染症GL・成書から拾った実践的な tips
        for t in gl_tips:
            head = t.get("heading", "").strip() or "ガイドライン"
            src = t.get("source", "").strip()
            body = t.get("body", "")
            if src:
                body = f"{body}\n[出典] {src}"
            a("      DrugNote(")
            a(f"        {lit('GL/成書: ' + head, 10)},")
            a(f"        {lit(body, 10)},")
            a("        type: DrugNoteType.literature,")
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


# 既存マスタに同じ薬剤があるため, Book3 側では収載しないもの.
# (既存の記載のほうが周術期向けに吟味されている / 重複表示を避ける)
SKIP_NAMES = {
    "ランジオロール塩酸塩",  # circulatory_other.dart に既収載
    "ハロペリドール (HPD)",  # psychotropic.dart に既収載 (周術期せん妄の注意つき)
    "ミダゾラム",  # sedative.dart に既収載 (てんかん重積用ミダフレッサは別途収載)
    "ジアゼパム",  # 既存の記載を優先
}


# 末尾から順に剥がす塩・水和物の表記. 「二ナトリウム水和物」のような多段にも対応するため
# 変化しなくなるまで繰り返し適用する.
def load_tips():
    """感染症GL・成書から抽出した薬剤別tipsを読む (無ければ空).

    塩の表記ゆれ (バンコマイシン塩酸塩 vs バンコマイシン) を吸収するため
    名寄せキーでも引けるようにする.
    """
    p = os.path.join(RES, "abx_tips.json")
    if not os.path.exists(p):
        return {}
    data = json.load(open(p, encoding="utf-8"))
    # まず名寄せキーごとに統合する (バンコマイシン と バンコマイシン塩酸塩 を同一視)
    merged = {}
    for d in data:
        t = [x for x in (d.get("tips") or []) if x.get("body")]
        if not t:
            continue
        k = key_of(d["name"]) or d["name"]
        cur = merged.setdefault(k, [])
        seen = {x["body"][:50] for x in cur}
        cur.extend(x for x in t if x["body"][:50] not in seen)
    # 元の表記でも名寄せキーでも引けるようにする
    out = dict(merged)
    for d in data:
        k = key_of(d["name"]) or d["name"]
        if k in merged:
            out[d["name"]] = merged[k]
    return out


def main():
    buckets = {"antiarrhythmic": [], "antimicrobial": [], "psychotropic": []}
    tips = load_tips()
    if tips:
        print(f"  (tips: {len(tips)}剤分を読み込み)")
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
                if not nm or nm in seen or nm in SKIP_NAMES:
                    continue
                seen.add(nm)
                t = tips.get(nm) or tips.get(key_of(nm))
                if t:
                    d = dict(d)
                    d["_tips"] = t
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
