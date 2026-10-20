"""Builds assets/dhikr/*.m4a – each dhikr's own words, cut from Hisn
al-Muslim's recitations (hisnmuslim.com/audio/ar/<n>.mp3), without the
narrator's notes ("one hundred times", "after every salah").

Cut points were found with local speech recognition (faster-whisper word
timings) and checked on the waveform; each clip was re-transcribed to
confirm it holds only its dhikr. Uses macOS afconvert. Run:
  mkdir -p /tmp/hisn && for n in 59 66 67 68 69 70 71 91 93 96; do
    curl -so /tmp/hisn/$n.mp3 http://www.hisnmuslim.com/audio/ar/$n.mp3; done
  python3 tool/build_dhikr_audio.py /tmp/hisn assets/dhikr
"""
import array, subprocess, sys, wave

src, out = sys.argv[1], sys.argv[2]
RATE = 44100

# (clip, [(recording, start s, end s), ...]) – pieces are joined in order.
BASMALA = ('70', 0.10, 5.55)
CLIPS = {
    'salah_istighfar': [('66', 8.70, 10.12)],
    'salah_antas_salam': [('66', 13.05, 20.35)],
    'salah_la_mania': [('67', 1.05, 22.35)],
    'salah_la_hawla': [('68', 1.00, 34.95)],
    'salah_subhanallah': [('69', 0.30, 1.65)],
    # "wal-hamdu lillah" / "wallahu akbar" from where the "a" of "al" starts, so
    # the "wa" is gone: "al-hamdu lillah", "Allahu akbar".
    'salah_alhamdulillah': [('69', 2.82, 4.12)],
    'salah_allahu_akbar': [('69', 5.03, 6.15)],
    'salah_tahlil': [('69', 13.40, 23.15)],
    'salah_quls': [('70', 0.10, 87.95)],
    'salah_ayatul_kursi': [BASMALA, ('71', 0.05, 56.70)],
    'salah_ainni': [('59', 1.10, 5.65)],
    'subhanallahi_wa_bihamdihi': [('91', 0.05, 2.70)],
    'tahlil_100': [('93', 0.40, 10.10)],
    'istighfar_100': [('96', 0.60, 3.85)],
}

cache = {}


def samples(rec):
    if rec not in cache:
        wav = f'/tmp/_{rec}.wav'
        subprocess.run(['afconvert', '-f', 'WAVE', '-d', f'LEI16@{RATE}', '-c', '1',
                        f'{src}/{rec}.mp3', wav], check=True)
        w = wave.open(wav)
        cache[rec] = array.array('h', w.readframes(w.getnframes()))
    return cache[rec]


def piece(rec, a, b, fade=0.012):
    d = samples(rec)[int(a * RATE):int(b * RATE)]
    f = int(fade * RATE)
    for i in range(min(f, len(d))):
        g = i / f
        d[i] = int(d[i] * g)
        d[-1 - i] = int(d[-1 - i] * g)
    return d


gap = array.array('h', [0] * int(0.35 * RATE))
for name, parts in CLIPS.items():
    data = array.array('h')
    for k, p in enumerate(parts):
        if k:
            data += gap
        data += piece(*p)
    wav = f'/tmp/{name}.wav'
    w = wave.open(wav, 'wb')
    w.setnchannels(1)
    w.setsampwidth(2)
    w.setframerate(RATE)
    w.writeframes(data.tobytes())
    w.close()
    subprocess.run(['afconvert', '-f', 'm4af', '-d', 'aac', '-b', '48000',
                    wav, f'{out}/{name}.m4a'], check=True)
    print(f'{name}: {len(data) / RATE:.2f}s')
