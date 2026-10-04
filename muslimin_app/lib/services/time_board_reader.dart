import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';

import '../data/models/hm.dart';
import '../data/models/prayer.dart';

/// Reads the jamat times from a photo of a masjid's salat time board
/// (LED / digital boards, printed or hand-written charts).
abstract class TimeBoardReader {
  /// Returns the times it could read; prayers it could not read are absent.
  /// Throws [TimeBoardException] when nothing usable was found.
  Future<Map<Prayer, HM>> read(Uint8List jpeg);
}

class TimeBoardException implements Exception {
  const TimeBoardException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Gemini (via Firebase AI Logic, Gemini Developer API) looks at the photo
/// and returns the times as structured JSON.
class GeminiTimeBoardReader implements TimeBoardReader {
  static const _keys = {
    Prayer.fajr: 'fajr',
    Prayer.dhuhr: 'dhuhr',
    Prayer.asr: 'asr',
    Prayer.maghrib: 'maghrib',
    Prayer.isha: 'isha',
    Prayer.jumuah: 'jumuah',
  };

  static const _prompt = '''
This is a photo of a salat (prayer) time board in a masjid, usually in Bangladesh.
Boards are often red/green 7-segment LED displays, but can also be printed or hand-written.
Labels may be in Bangla (ফজর, যোহর/জোহর, আছর/আসর, মাগরিব, এশা/ইশা, জুম'আ/জুমা),
English or Arabic (الفجر, الظهر, العصر, المغرب, العشاء, الجمعة).

Return the JAMAT (iqamah) time for each prayer:
- If the board shows two times per prayer (start/azan and jamat/iqamah), return the jamat one.
- Ignore the current clock, the date, sunrise, sehri/iftar and other rows.
- Write each time as H:MM with ASCII digits exactly as shown (12-hour, no AM/PM), e.g. "5:15", "1:30".
- Convert Bangla digits (০-৯) to ASCII.
- Use null for a prayer you cannot read or that shows a placeholder such as 8:88 or --:--.
Do not guess.''';

  @override
  Future<Map<Prayer, HM>> read(Uint8List jpeg) async {
    final time = Schema.string(
      nullable: true,
      description: 'Jamat time as H:MM (12-hour, no AM/PM), or null',
    );
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: Schema.object(
          properties: {for (final k in _keys.values) k: time},
        ),
      ),
    );
    final response = await model.generateContent([
      Content.multi([TextPart(_prompt), InlineDataPart('image/jpeg', jpeg)]),
    ]);
    final text = response.text;
    if (text == null || text.trim().isEmpty) {
      throw const TimeBoardException('empty response');
    }
    final json = jsonDecode(text) as Map<String, dynamic>;
    final out = <Prayer, HM>{
      for (final e in _keys.entries)
        e.key: ?normalizeBoardTime(e.key, json[e.value]),
    };
    if (out.isEmpty) throw const TimeBoardException('no times found');
    return out;
  }
}

/// Offline demo: pretends to read a board.
class DemoTimeBoardReader implements TimeBoardReader {
  @override
  Future<Map<Prayer, HM>> read(Uint8List jpeg) async {
    await Future<void>.delayed(const Duration(milliseconds: 2800));
    return const {
      Prayer.fajr: HM(5, 10),
      Prayer.dhuhr: HM(13, 15),
      Prayer.asr: HM(16, 50),
      Prayer.maghrib: HM(18, 2),
      Prayer.isha: HM(19, 40),
      Prayer.jumuah: HM(13, 30),
    };
  }
}

/// Boards show 12-hour times without AM/PM ("1:15"), so the prayer decides
/// the half of the day. Returns null for anything that cannot be a jamat time.
HM? normalizeBoardTime(Prayer p, Object? raw) {
  if (raw is! String) return null;
  final m = RegExp(r'(\d{1,2})\s*[:.]\s*(\d{2})').firstMatch(raw);
  if (m == null) return null;
  var h = int.parse(m.group(1)!);
  final min = int.parse(m.group(2)!);
  if (min > 59 || h > 23) return null;
  switch (p) {
    case Prayer.fajr:
      if (h >= 12) return null; // Fajr is always in the morning
    case Prayer.dhuhr:
    case Prayer.jumuah:
      if (h < 10) h += 12; // 1:15 -> 13:15; 12:30 stays
    case Prayer.asr:
    case Prayer.maghrib:
    case Prayer.isha:
      if (h < 12) h += 12;
  }
  // Rough sanity windows (Bangladesh, all seasons, generous margins).
  final ok = switch (p) {
    Prayer.fajr => h >= 3 && h <= 7,
    Prayer.dhuhr || Prayer.jumuah => h >= 11 && h <= 15,
    Prayer.asr => h >= 14 && h <= 18,
    Prayer.maghrib => h >= 16 && h <= 20,
    Prayer.isha => h >= 18 && h <= 23,
  };
  return ok ? HM(h, min) : null;
}
