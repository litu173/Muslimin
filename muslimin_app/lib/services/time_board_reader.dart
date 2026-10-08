import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../data/models/hm.dart';
import '../data/models/prayer.dart';
import 'board_parser.dart';

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

/// Gemini (via Firebase AI Logic, Gemini Developer API) transcribes the
/// board row by row; [assignBoard] then picks each prayer's jamat the same
/// way as for on-device text: by label, else by the board's order.
class GeminiTimeBoardReader implements TimeBoardReader {
  static const _prompt = '''
This is a photo of a salat (prayer) time board in a masjid, usually in Bangladesh.
Boards are often red/green 7-segment LED displays, but can also be printed, painted or hand-written.
Labels may be in Bangla (ফজর, যোহর/জোহর, আসর/আছর, মাগরিব, এশা/ইশা, জুম'আ/জুমা, সূর্যোদয়, সাহরি, ইফতার),
English, or Arabic (الفجر, الظهر, العصر, المغرب, العشاء, الجمعة).
Some boards have two times per prayer: azan/start (আযান) and jamat/iqamah (জামাত).

Transcribe the board's rows from top to bottom. If the prayers stand side by side, list them left to right.
For each row give:
- label: the row's name exactly as written (any script), or "" if none
- prayer: fajr, dhuhr, asr, maghrib, isha or jumuah if the label names one, else "other" (sunrise, sehri, iftar, zawal…)
- times: every time on that row, left to right, as H:MM with ASCII digits (convert Bangla ০-৯ and Arabic ٠-٩ digits), 12- or 24-hour exactly as shown.
For analog clock faces, read the hands to the nearest minute.
Leave out the current clock, the date and the temperature.
Skip a time that is unreadable or a placeholder like 8:88 or --:--. Do not guess.''';

  @override
  Future<Map<Prayer, HM>> read(Uint8List jpeg) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: Schema.object(
          properties: {
            'rows': Schema.array(
              items: Schema.object(
                properties: {
                  'label': Schema.string(),
                  'prayer': Schema.enumString(
                    enumValues: [
                      'fajr',
                      'dhuhr',
                      'asr',
                      'maghrib',
                      'isha',
                      'jumuah',
                      'other',
                    ],
                  ),
                  'times': Schema.array(items: Schema.string()),
                },
              ),
            ),
          },
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
    final out = assignBoard(rowsFromGemini(jsonDecode(text)));
    if (out.isEmpty) throw const TimeBoardException('no times found');
    return out;
  }
}

/// Gemini's JSON rows → board rows.
List<BoardRow> rowsFromGemini(Object? json) {
  final rows = (json is Map ? json['rows'] : null) as List? ?? const [];
  return [
    for (final r in rows.whereType<Map>())
      BoardRow(
        label: switch (r['prayer']) {
          // Unlabelled rows keep their place in the board's order.
          'other' when '${r['label'] ?? ''}'.trim().isEmpty => null,
          'other' => skipRow,
          final String k when Prayer.values.any((p) => p.name == k) =>
            Prayer.values.byName(k),
          _ => labelOf('${r['label'] ?? ''}'),
        },
        times: [
          for (final t in (r['times'] as List? ?? const []))
            ...timesIn('$t').map((e) => e.$1),
        ],
      ),
  ];
}

/// On-device text recognition (Apple Vision / ML Kit): free, offline, and
/// good with printed and LED digits in Latin script. It cannot read Bangla
/// digits or labels – the board's order fills in for the labels.
class OnDeviceTimeBoardReader implements TimeBoardReader {
  static const _channel = MethodChannel('muslimin/board_ocr');

  Future<List<OcrLine>> lines(Uint8List jpeg, {bool down = false}) async {
    final r = await _channel.invokeListMethod<Map<Object?, Object?>>('read', {
      'bytes': jpeg,
      'down': down,
    });
    return [
      for (final m in r ?? const <Map<Object?, Object?>>[]) OcrLine.fromMap(m),
    ];
  }

  @override
  Future<Map<Prayer, HM>> read(Uint8List jpeg) async {
    // Read it both ways round (photos taken with the phone upside down)
    // and keep the reading that makes more sense.
    final up = readOcr(await lines(jpeg));
    final turned = readOcr(await lines(jpeg, down: true));
    final out = turned.length > up.length ? turned : up;
    if (out.isEmpty) throw const TimeBoardException('no times found');
    return out;
  }
}

/// Both readers at once: Gemini's answer where it has one (it also reads
/// Bangla digits), the on-device one for the rest – and on its own when
/// Gemini is unavailable (offline, not set up, quota).
class CombinedTimeBoardReader implements TimeBoardReader {
  CombinedTimeBoardReader(this.ai, this.device);

  final TimeBoardReader ai;
  final TimeBoardReader device;

  @override
  Future<Map<Prayer, HM>> read(Uint8List jpeg) async {
    Future<Map<Prayer, HM>> safe(TimeBoardReader r) =>
        r.read(jpeg).catchError((Object e) {
          debugPrint('time board ($r): $e');
          return <Prayer, HM>{};
        });
    final both = await Future.wait([safe(ai), safe(device)]);
    final out = {...both[1], ...both[0]};
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
