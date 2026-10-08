import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:muslimin/data/models/prayer.dart';
import 'package:muslimin/services/time_board_reader.dart';

/// Runs the on-device reader (Apple Vision / ML Kit through the app's own
/// channel) on photos of time boards. On the iOS simulator the app can read
/// the Mac's files: BOARDS_DIR is passed with --dart-define.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const dir = String.fromEnvironment('BOARDS_DIR');

  testWidgets('on-device board reader', (tester) async {
    if (dir.isEmpty) return;
    final truth =
        jsonDecode(File('$dir/truth.json').readAsStringSync())
            as Map<String, dynamic>;
    final reader = OnDeviceTimeBoardReader();
    var right = 0, total = 0;
    final files =
        Directory(dir)
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('_photo.jpg'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final f in files) {
      final name = f.uri.pathSegments.last.replaceAll('_photo.jpg', '');
      final want = truth[name] as Map<String, dynamic>;
      Map<Prayer, dynamic> got;
      try {
        got = await reader.read(f.readAsBytesSync());
      } catch (e) {
        got = {};
      }
      final miss = <String>[];
      for (final e in want.entries) {
        total++;
        final g = got[Prayer.values.byName(e.key)];
        final s = g == null
            ? null
            : '${g.hour}:${g.minute.toString().padLeft(2, '0')}';
        if (s == e.value) {
          right++;
        } else {
          miss.add('${e.key} ${e.value}≠$s');
        }
      }
      // ignore: avoid_print
      print('BOARD ${miss.isEmpty ? 'OK  ' : 'MISS'} $name ${miss.join(' ')}');
    }
    // ignore: avoid_print
    print('BOARD score $right / $total');
    expect(right, greaterThan(0));
  });
}
