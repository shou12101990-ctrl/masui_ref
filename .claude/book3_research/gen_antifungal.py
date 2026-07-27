import json, re
BS = chr(92)
ESC_N = BS + "n"
d = json.load(open(".claude/book3_research/antifungal_jp.json", encoding="utf-8"))
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
    out = [("'" + p + (ESC_N if i < len(parts) - 1 else "") + "'")
           for i, p in enumerate(parts)]
    return ("\n" + pad).join(out)
ORDER = ["ポリエン系", "キャンディン系", "トリアゾール系", "イミダゾール系",
         "フルオロピリミジン系", "PCP治療薬", "アリルアミン系 (経口・外用)",
         "外用抗真菌薬"]
d.sort(key=lambda x: (ORDER.index(x["fungusGroup"]) if x["fungusGroup"] in ORDER else 99,
                      x["generic"]))
COV = ["カンジダ", "クリプトコックス", "接合菌", "アスペルギルス",
       "フサリウム/スケドスポリウム", "PCP", "地域流行真菌"]
ORG = ["眼球", "CNS", "骨", "前立腺", "尿", "唾液"]
rows = []
for x in d:
    cov = x.get("coverage") or {}
    org = x.get("organ") or {}
    covs = ", ".join(lit(k) + ": " + lit(nz(cov[k])[:24]) for k in COV if cov.get(k))
    orgs = ", ".join(lit(k) + ": " + lit(nz(org[k])[:24]) for k in ORG if org.get(k))
    note = nz(x.get("periop", ""))
    for key in ("tdm", "interaction", "adverse"):
        if x.get(key):
            note = (note + "\n" + nz(x[key])).strip()
    r = ["  AbxMatrixRow("]
    r.append("    group: " + lit(x["fungusGroup"]) + ",")
    r.append("    generic: " + lit(x["generic"]) + ",")
    if x.get("brand"):
        r.append("    brand: " + lit(x["brand"]) + ",")
    if x.get("abbr"):
        r.append("    abbr: " + lit(x["abbr"]) + ",")
    if x.get("dose"):
        r.append("    dose: " + lit(x["dose"]) + ",")
    if x.get("indication"):
        r.append("    effect: " + lit(x["indication"][:200]) + ",")
    if covs:
        r.append("    coverage: {" + covs + "},")
    if orgs:
        r.append("    organ: {" + orgs + "},")
    if x.get("renalAdjust"):
        note = (nz(x["renalAdjust"]) + "\n" + note).strip()
    if note:
        r.append("    note: " + lit(note[:800]) + ",")
    r.append("  ),")
    rows.append("\n".join(r))
src = open("lib/data/abx_matrix.dart", encoding="utf-8").read()
block = ("/// 抗真菌薬の一覧表. 日本で承認・販売されているものを網羅 (国内未承認は明記).\n"
         "/// 列は真菌の種類で, 細菌用の列とは意味が異なる.\n"
         "const List<AbxMatrixRow> kAntifungalMatrix = [\n" + "\n".join(rows) + "\n];\n")
src = re.sub(r"/// 抗真菌薬の一覧表.*?\nconst List<AbxMatrixRow> kAntifungalMatrix = \[.*?\n\];\n",
             lambda _m: block, src, flags=re.S)
open("lib/data/abx_matrix.dart", "w", encoding="utf-8").write(src)
odd = sum(1 for l in src.split("\n") if l.count("'") % 2 == 1)
print("抗真菌薬 " + str(len(d)) + "剤 を反映 / クォート奇数の行: " + str(odd))
