"""Builds assets/quran/refresh_ayat.json – the short ayat shown one at a
time when a page is pulled down to refresh: reward and warning, mercy and
punishment, and how to live. Arabic (Uthmani) and every app language's
translation come from quran.com, the same translations the Quran tab uses.
Run:  python3 tool/build_refresh_ayat.py
"""
import json
import re
import subprocess

OUT = 'assets/quran/refresh_ayat.json'

# (first verse, last verse) – whole ayat only.
AYAT = [
    ('94:5', '94:6'),    # with hardship comes ease
    ('2:152', '2:152'),  # remember Me, I will remember you
    ('13:28', '13:28'),  # hearts find rest in remembrance
    ('29:57', '29:57'),  # every soul will taste death
    ('99:7', '99:8'),    # an atom's weight of good / evil
    ('15:49', '15:50'),  # forgiving, merciful – and the painful punishment
    ('51:56', '51:56'),  # created only to worship
    ('103:1', '103:3'),  # al-'Asr
    ('4:28', '4:28'),    # Allah wants to lighten your burden
    ('55:13', '55:13'),  # which favours will you deny
    ('102:1', '102:2'),  # rivalry in increase distracts you
    ('82:6', '82:6'),    # what has deceived you about your Lord
    ('14:7', '14:7'),    # gratitude increases, ingratitude punished
    ('47:7', '47:7'),    # support Allah, He supports you
    ('3:31', '3:31'),    # follow the Prophet, Allah will love you
    ('74:38', '74:38'),  # every soul held by what it earned
    ('89:27', '89:28'),  # O reassured soul, return to your Lord
    ('9:51', '9:51'),    # nothing befalls us but what Allah decreed
    ('93:5', '93:5'),    # your Lord will give you and you will be pleased
    ('50:18', '50:18'),  # every word is recorded
]

# Same translation per language as lib/data/quran/quran_repository.dart.
TRANSLATIONS = {'en': 20, 'bn': 213, 'hi': 122, 'ur': 234, 'id': 33,
                'ms': 39, 'tr': 77, 'es': 83}

API = 'https://api.quran.com/api/v4'


def get(url):
    return json.loads(subprocess.check_output(['curl', '-s', url]))


def clean(t):
    t = re.sub(r'<sup[^>]*>.*?</sup>', '', t)
    t = re.sub(r'<[^>]+>', '', t)
    return re.sub(r'\s+', ' ', t).strip()


def keys(a, b):
    s, x = a.split(':')
    y = b.split(':')[1]
    return [f'{s}:{n}' for n in range(int(x), int(y) + 1)]


out = []
for a, b in AYAT:
    ks = keys(a, b)
    item = {'ref': a if a == b else f'{a}-{b.split(":")[1]}', 'ar': '', 'tr': {}}
    arabic = []
    for k in ks:
        arabic.append(get(f'{API}/quran/verses/uthmani?verse_key={k}')['verses'][0]['text_uthmani'])
    item['ar'] = ' ۝ '.join(arabic)
    for lang, tid in TRANSLATIONS.items():
        parts = []
        for k in ks:
            v = get(f'{API}/quran/translations/{tid}?verse_key={k}')['translations'][0]['text']
            parts.append(clean(v))
        item['tr'][lang] = ' '.join(parts)
    out.append(item)
    print(item['ref'], item['tr']['en'][:70])

with open(OUT, 'w', encoding='utf-8') as f:
    json.dump(out, f, ensure_ascii=False, indent=1)
    f.write('\n')
