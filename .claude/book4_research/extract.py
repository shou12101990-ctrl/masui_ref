import zipfile, re, sys
from xml.etree import ElementTree as ET
NS='{http://schemas.openxmlformats.org/spreadsheetml/2006/main}'
z=zipfile.ZipFile('/Users/s/Downloads/Book4.xlsx')
def txt(el):
    # skip furigana (rPh) runs
    out=[]
    for child in el:
        tag=child.tag
        if tag==NS+'t': out.append(child.text or '')
        elif tag==NS+'r':
            for t in child.findall(NS+'t'): out.append(t.text or '')
    return ''.join(out)
shared=[]
r=ET.fromstring(z.read('xl/sharedStrings.xml'))
for si in r.findall(NS+'si'): shared.append(txt(si))
def col(ref):
    m=re.match(r'([A-Z]+)(\d+)',ref); c=0
    for ch in m.group(1): c=c*26+ord(ch)-64
    return c-1,int(m.group(2))
def cname(i):
    s=''; i+=1
    while i: i,r=divmod(i-1,26); s=chr(65+r)+s
    return s
root=ET.fromstring(z.read('xl/worksheets/sheet1.xml'))
rows={}
for c in root.iter(NS+'c'):
    ref=c.get('r')
    if not ref: continue
    ci,ri=col(ref)
    t=c.get('t'); v=c.find(NS+'v'); isel=c.find(NS+'is')
    if t=='s' and v is not None: val=shared[int(v.text)]
    elif isel is not None: val=txt(isel)
    elif v is not None: val=v.text
    else: val=''
    if val: rows.setdefault(ri,{})[ci]=val
for ri in sorted(rows):
    mx=max(rows[ri])
    print(ri,'|','|'.join((rows[ri].get(k) or '')[:90] for k in range(mx+1)))
print('\n\n########## COMMENTS ##########')
cr=ET.fromstring(z.read('xl/comments1.xml'))
for cm in cr.iter(NS+'comment'):
    print('--- CELL',cm.get('ref'),'---')
    print(txt(cm.find(NS+'text')))
