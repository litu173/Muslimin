"""Builds assets/duas/duas.json – the "day with duas" story (Dua tab) – from
Hisn al-Muslim (Fortress of the Muslim) by Sa'id bin Ali bin Wahf
al-Qahtani, as published on the book's official site hisnmuslim.com:

  * Arabic, transliteration, English, repeat count and audio:
    http://www.hisnmuslim.com/api/en/<chapter>.json
  * Bangla meaning and hadith reference: https://hisnmuslim.com/i/bn/<page>

Every dua keeps its Hisn al-Muslim number, so it can be checked against the
book. Run:  python3 tool/build_duas.py
"""
import html
import json
import re
import subprocess
import time

OUT = 'assets/duas/duas.json'

# Scenes of a day, in order. (scene id, [(chapter id, max items or None)])
SCENES = [
    ('wake', [(1, 2)]),
    ('restroom', [(6, 1), (7, 1)]),
    ('wudu', [(8, 1), (9, 1)]),
    ('dress', [(2, 1), (3, 1)]),
    ('athan', [(15, 2)]),
    ('masjid', [(12, 1), (13, 1), (14, 1)]),
    ('after_salah', [(25, 3)]),
    ('morning', [(27, 4)]),
    ('eating', [(69, 1), (70, 1)]),
    ('leave_home', [(10, 1)]),
    ('travel', [(95, 1), (102, 1), (98, 1)]),
    ('meeting', [(108, 1), (77, 1)]),
    ('good_news', [(123, 1), (87, 1)]),
    ('hardship', [(43, 1), (46, 1), (34, 1)]),
    ('patience', [(53, 1)]),
    ('anger', [(82, 1)]),
    ('pain', [(124, 1), (49, 1)]),
    ('rain', [(64, 1)]),
    ('home', [(11, 1)]),
    ('gathering', [(85, 1)]),
    ('forgiveness', [(129, 2)]),
    ('sleep', [(28, 4)]),
    ('night', [(29, 1), (31, 1)]),
]

BN_DIGITS = str.maketrans('০১২৩৪৫৬৭৮৯', '0123456789')

# Hadith collections named in the Bangla footnotes -> English.
COLLECTIONS = [
    ('বুখারী', 'al-Bukhari'), ('মুসলিম', 'Muslim'), ('আবূ দাঊদ', 'Abu Dawud'),
    ('আবু দাউদ', 'Abu Dawud'), ('তিরমিযী', 'at-Tirmidhi'), ('নাসাঈ', "an-Nasa'i"),
    ('ইবন মাজাহ', 'Ibn Majah'), ('ইবনে মাজাহ', 'Ibn Majah'), ('আহমাদ', 'Ahmad'),
    ('আহমদ', 'Ahmad'), ('হাকিম', 'al-Hakim'), ('ইবনুস সুন্নী', 'Ibn as-Sunni'),
    ('ইবনুস সুন্নি', 'Ibn as-Sunni'), ('বাইহাকী', 'al-Bayhaqi'),
    ('তাবারানী', 'at-Tabarani'), ('মালিক', 'Malik'), ('দারেমী', 'ad-Darimi'),
    ('ইবন হিব্বান', 'Ibn Hibban'), ('ইবন খুযাইমা', 'Ibn Khuzaymah'),
    ('সূরা', 'Qur\'an'),
]


def get(url):
    for _ in range(3):
        r = subprocess.run(['curl', '-sL', '-m', '30', url], capture_output=True)
        if r.returncode == 0 and r.stdout:
            return r.stdout.decode('utf-8-sig', errors='ignore')
        time.sleep(2)
    raise RuntimeError(url)


def bn_page(ch):
    # The site swaps the first chapters: page 0 = ch 28, 1 = ch 27, 28 = ch 1.
    page = {28: 0, 27: 1, 1: 28}.get(ch, ch)
    t = get(f'https://hisnmuslim.com/i/bn/{page}')
    out = {}
    for m in re.finditer(r'<div class="thikr">(.*?)<div class="meaning">', t, re.S):
        body = html.unescape(re.sub(r'<[^>]+>', '', m.group(1))).strip()
        num = re.match(r'([০-৯]+)\s*-', body)
        if not num:
            continue
        n = int(num.group(1).translate(BN_DIGITS))
        # Footnote (hadith reference) follows a line of dots or dashes.
        parts = re.split(r'\s*(?:\.{4,}|-{4,})\s*', body, maxsplit=1)
        text = parts[0]
        foot = parts[1] if len(parts) > 1 else ''
        text = re.sub(r'^[০-৯]+\s*-\s*(?:\([০-৯]+\)\s*)?', '', text)
        text = re.sub(r'\([০-৯]+\)', '', text)
        text = re.sub(r'\s+', ' ', text).strip()
        if not foot:
            # A few entries put the reference inline at the end.
            m2 = re.search(
                r'(?<=[।!?])\s*((?:সহীহ\s+)?(?:বুখারী|মুসলিম|আবূ দাঊদ|আবু দাঊদ|'
                r'তিরমিযী|নাসাঈ|ইবন মাজাহ|আহমাদ)[^।]*হাদীস নং.*)$', text)
            if m2:
                foot = m2.group(1)
                text = text[:m2.start()].strip()
        foot = re.sub(r'^\s*\([০-৯]+\)\s*', '', foot)
        foot = re.sub(r'\s+', ' ', foot).strip()
        out[n] = (text, foot)
    return out


def en_ref(foot_bn):
    names = []
    for bn, en in COLLECTIONS:
        if bn in foot_bn and en not in names:
            names.append(en)
    return ' · '.join(names)


def clean(s):
    s = s.strip()
    while s.startswith('(') and s.endswith(')') and s.count('(') == s.count(')'):
        inner = s[1:-1].strip()
        if inner.count('(') != inner.count(')'):
            break
        s = inner
    return re.sub(r'\s+', ' ', s)


def main():
    scenes = []
    for sid, chapters in SCENES:
        duas = []
        for ch, limit in chapters:
            api = json.loads(get(f'http://www.hisnmuslim.com/api/en/{ch}.json'))
            title_en, items = next(iter(api.items()))
            bn = bn_page(ch)
            for it in items[:limit]:
                n = it['ID']
                bn_text, bn_foot = bn.get(n, ('', ''))
                duas.append({
                    'n': n,
                    'chapter': ch,
                    'title_en': title_en.strip(),
                    'ar': clean(it['ARABIC_TEXT']).strip(' .'),
                    'tr': clean(it['LANGUAGE_ARABIC_TRANSLATED_TEXT']),
                    'en': clean(it['TRANSLATED_TEXT']),
                    'bn': bn_text,
                    'ref_bn': bn_foot,
                    'ref_en': en_ref(bn_foot),
                    'repeat': it.get('REPEAT', 1),
                    'audio': it.get('AUDIO', ''),
                })
                print(sid, ch, n, 'bn' if bn_text else 'NO-BN')
            time.sleep(0.4)
        scenes.append({'id': sid, 'duas': duas})
    with open(OUT, 'w', encoding='utf-8') as f:
        json.dump({'source': 'Hisn al-Muslim, hisnmuslim.com', 'scenes': scenes},
                  f, ensure_ascii=False, indent=1)
    print('wrote', OUT, sum(len(s['duas']) for s in scenes), 'duas')


if __name__ == '__main__':
    main()
