import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:muslimin/data/models/prayer.dart';
import 'package:muslimin/services/board_parser.dart';
import 'package:muslimin/services/time_board_reader.dart';

/// Runs the on-device board reader's parser over OCR output saved from
/// photos of time boards: BOARDS_DIR holds `<name>.ocr.json` (lines from
/// Apple Vision) and `truth.json` ({name: {fajr: "5:15", …}}).
void main() {
  test('timesIn fixes 7-segment OCR', () {
    expect(timesIn('O 100 O1:15').map((e) => e.$1), ['01:00', '01:15']);
    expect(timesIn('0 130 0145').map((e) => e.$1), ['01:30', '01:45']);
    expect(timesIn('05:30 05:45').map((e) => e.$1), ['05:30', '05:45']);
    expect(timesIn('FAJR 5.15').map((e) => e.$1), ['5:15']);
    expect(timesIn('০৫:১৫').map((e) => e.$1), ['05:15']);
    expect(timesIn('04: 15').map((e) => e.$1), ['04:15']);
    expect(timesIn('0 130 O :45').map((e) => e.$1), ['01:30']);
    expect(timesIn('05:45012004:5006:5007:000 1:15').map((e) => e.$1), [
      '05:45',
      '01:20',
      '04:50',
      '06:50',
      '07:00',
      '01:15',
    ]);
  });

  test('Gemini rows: labels, azan + jamat, sunrise, Bangla digits', () {
    final got = assignBoard(
      rowsFromGemini({
        'rows': [
          {
            'label': 'ফজর',
            'prayer': 'fajr',
            'times': ['৫:০০', '৫:১৫'],
          },
          {
            'label': 'সূর্যোদয়',
            'prayer': 'other',
            'times': ['6:02'],
          },
          {
            'label': 'যোহর',
            'prayer': 'dhuhr',
            'times': ['12:45', '1:15'],
          },
          {
            'label': 'আসর',
            'prayer': 'asr',
            'times': ['4:30', '4:45'],
          },
          {
            'label': 'মাগরিব',
            'prayer': 'maghrib',
            'times': ['5:50', '5:55'],
          },
          {
            'label': 'এশা',
            'prayer': 'isha',
            'times': ['7:10', '7:30'],
          },
          {
            'label': 'জুমা',
            'prayer': 'jumuah',
            'times': ['1:30'],
          },
        ],
      }),
    );
    expect(got.map((p, v) => MapEntry(p.name, v.toStorage())), {
      'fajr': '05:15',
      'dhuhr': '13:15',
      'asr': '16:45',
      'maghrib': '17:55',
      'isha': '19:30',
      'jumuah': '13:30',
    });
  });

  test('Unlabelled rows go by order', () {
    final got = assignBoard(
      rowsFromGemini({
        'rows': [
          {
            'label': '',
            'prayer': 'other',
            'times': ['5:15'],
          },
          {
            'label': '',
            'prayer': 'other',
            'times': ['1:15'],
          },
        ],
      }),
    );
    // Two unlabelled times are too little to go by order alone.
    expect(got, isEmpty);
    final ordered = assignBoard([
      for (final t in ['5:15', '1:15', '4:45', '5:55', '7:30', '1:30'])
        BoardRow(times: [t]),
    ]);
    expect(ordered.map((p, v) => MapEntry(p.name, v.toStorage())), {
      'fajr': '05:15',
      'dhuhr': '13:15',
      'asr': '16:45',
      'maghrib': '17:55',
      'isha': '19:30',
      'jumuah': '13:30',
    });
  });

  final dir = Platform.environment['BOARDS_DIR'];
  if (dir == null) return;
  final truth = jsonDecode(
    File('$dir/truth.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  var right = 0, total = 0;
  for (final f in Directory(dir).listSync().whereType<File>()) {
    if (!f.path.endsWith('.ocr.json')) continue;
    final name = f.uri.pathSegments.last.replaceAll('.ocr.json', '');
    final want =
        truth[name.replaceAll(RegExp(r'_(flat|photo)$'), '')]
            as Map<String, dynamic>?;
    if (want == null) continue;
    List<OcrLine> load(File f) => [
      for (final m in jsonDecode(f.readAsStringSync()) as List)
        OcrLine.fromMap(m as Map),
    ];
    // Like the app: upright first, upside down if that reads better.
    var got = readOcr(load(f));
    final down = File(f.path.replaceAll('.ocr.json', '.down.json'));
    if (down.existsSync()) {
      final d = readOcr(load(down));
      if (d.length > got.length) got = d;
    }
    final miss = <String>[];
    for (final p in Prayer.values) {
      final w = want[p.name] as String?;
      if (w == null) continue;
      total++;
      final g = got[p];
      final ok =
          g != null && '${g.hour}:${g.minute.toString().padLeft(2, '0')}' == w;
      if (ok) {
        right++;
      } else {
        miss.add('${p.name} want $w got $g');
      }
    }
    // ignore: avoid_print
    print('${miss.isEmpty ? 'OK  ' : 'MISS'} $name ${miss.join('; ')}');
  }
  // ignore: avoid_print
  print('score $right / $total');
}
