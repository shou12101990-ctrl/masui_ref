import json, re
BS = chr(92)          # backslash
ESC_N = BS + "n"      # 2文字の \n (Dartのエスケープ)
d = json.load(open(".claude/book3_research/antiviral_jp.json", encoding="utf-8"))
PUNCT = [("、", ", "), ("。", ". "), ("（", " ("), ("）", ")"), ("：", ": "),
         ("，", ", "), ("．", ". ")]
def nz(s):
    s = s or ""
    for a, b in PUNCT:
        s = s.replace(a, b)
    s = s.replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&")
    s = re.sub(r"[ \t]+", " ", s)
    s = re.sub(r"[ \t]*\n[ \t]*", "\n", s)
    s = re.sub(r"\( +", "(", s)
    s = re.sub(r" +\)", ")", s)
    return s.strip()
def dq(s):
    s = nz(s)
    s = s.replace(BS, BS + BS).replace("'", BS + "'").replace("$", BS + "$")
    s = s.replace("\r\n", "\n").replace("\r", "\n").replace("\n", ESC_N)
    return s
def lit(s, indent=8):
    b = dq(s)
    if len(b) <= 88:
        return "'" + b + "'"
    parts = b.split(ESC_N)
    pad = " " * indent
    out = []
    for i, p in enumerate(parts):
        out.append("'" + p + (ESC_N if i < len(parts) - 1 else "") + "'")
    return ("\n" + pad).join(out)
ORDER = ["ヘルペス属", "インフルエンザ", "RSV", "COVID-19", "肝炎ウイルス", "HIV", "その他"]
d.sort(key=lambda x: (ORDER.index(x["virusGroup"]) if x["virusGroup"] in ORDER else 99,
                      x["generic"]))
rows = []
for x in d:
    note = nz(x.get("periop", ""))
    if x.get("adverse"):
        note = (note + "\n" + nz(x["adverse"])).strip()
    r = ["  AbxMatrixRow("]
    r.append("    group: " + lit(x["virusGroup"]) + ",")
    r.append("    generic: " + lit(x["generic"]) + ",")
    if x.get("brand"):
        r.append("    brand: " + lit(x["brand"]) + ",")
    if x.get("abbr"):
        r.append("    abbr: " + lit(x["abbr"]) + ",")
    if x.get("dose"):
        r.append("    dose: " + lit(x["dose"]) + ",")
    if x.get("indication"):
        r.append("    effect: " + lit(x["indication"][:200]) + ",")
    r.append("    coverage: {'対象ウイルス': " + lit(x["targetVirus"][:70]) + "},")
    if note:
        r.append("    note: " + lit(note[:700]) + ",")
    r.append("  ),")
    rows.append("\n".join(r))
src = open("lib/data/abx_matrix.dart", encoding="utf-8").read()
block = ("/// 抗ウイルス薬の一覧表. 日本で承認・販売されているものを網羅.\n"
         "/// カバー範囲は対象ウイルスで示す. group はウイルス群.\n"
         "const List<AbxMatrixRow> kAntiviralMatrix = [\n" + "\n".join(rows) + "\n];\n")
src = re.sub(r"/// 抗ウイルス薬の一覧表.*?\nconst List<AbxMatrixRow> kAntiviralMatrix = \[.*?\n\];\n",
             lambda _m: block, src, flags=re.S)
open("lib/data/abx_matrix.dart", "w", encoding="utf-8").write(src)
odd = sum(1 for l in src.split("\n") if l.count("'") % 2 == 1)
print("抗ウイルス薬 " + str(len(d)) + "剤 を反映 / クォート奇数の行: " + str(odd))
