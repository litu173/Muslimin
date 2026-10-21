// Bangla name suggestions with Gemini (Firebase AI Logic, free Gemini
// Developer API) – the same service the app uses to read time boards.
// Suggestions are only shown for review; nothing is saved without a click.
import { app, emu } from './fb.js';

let model;
async function getModel() {
  if (model) return model;
  if (emu) throw new Error('Bangla suggestions use Gemini on the live project – they don\'t work in emulator mode.');
  const { getAI, getGenerativeModel, GoogleAIBackend } = await import('https://www.gstatic.com/firebasejs/11.10.0/firebase-ai.js');
  model = getGenerativeModel(getAI(app, { backend: new GoogleAIBackend() }), {
    model: 'gemini-2.5-flash',
    generationConfig: { temperature: 0, responseMimeType: 'application/json' },
  });
  return model;
}

const GUIDE = {
  masjid: `These are names of masjids (mosques), mostly in Bangladesh, written in English letters.
Write each the way Bangladeshi people write it in Bangla script: "Masjid"/"Mosque" -> "মসজিদ", "Jame" -> "জামে",
"Baitul Mukarram" -> "বায়তুল মোকাররম", "Baitul Aman Jame Masjid" -> "বায়তুল আমান জামে মসজিদ". Keep proper names as names
(transliterate them); translate only common words (Masjid, Jame, Central, Road, Bazar, Para, Mia, Bari, Kendrio…).`,
  place: `These are place names (districts, upazilas/thanas, cities, areas, countries), mostly in Bangladesh.
Give the standard Bangla spelling used by the Bangladesh government and newspapers, e.g. "Dhaka" -> "ঢাকা",
"Chattogram" -> "চট্টগ্রাম", "Barisal Sadar (Kotwali)" -> "বরিশাল সদর (কোতোয়ালি)", "Saudi Arabia" -> "সৌদি আরব".`,
};

/**
 * names: English strings. Returns {english: bangla} for the ones it could do.
 * Throws a friendly error when Firebase AI Logic is not set up.
 */
export async function suggestBangla(names, kind = 'masjid') {
  const out = {};
  const m = await getModel();
  for (let i = 0; i < names.length; i += 60) {
    const part = names.slice(i, i + 60);
    const prompt = `${GUIDE[kind]}
Return only a JSON object mapping each English name exactly as given to its Bangla. If unsure of one, leave it out.
Names:
${part.map((n) => `- ${n}`).join('\n')}`;
    let res;
    try {
      res = await m.generateContent(prompt);
    } catch (e) {
      const msg = `${e?.message || e}`;
      if (/genai config not found|not been used|disabled|PERMISSION_DENIED|403|404/i.test(msg)) {
        throw new Error('Gemini is not switched on for this Firebase project yet. Firebase console → AI Logic → Get started → Gemini Developer API (free). Then try again.');
      }
      throw e;
    }
    let obj = {};
    try { obj = JSON.parse(res.response.text()); } catch { /* skip a bad chunk */ }
    for (const n of part) {
      const v = obj[n];
      if (typeof v === 'string' && /[ঀ-৿]/.test(v)) out[n] = v.trim();
    }
  }
  return out;
}
