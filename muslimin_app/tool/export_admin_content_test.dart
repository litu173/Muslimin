// Copies the built-in content to the admin website (docs/admin/data/content),
// which shows it until the admins save their own. Run after changing the
// built-in duas, refresh ayat or dhikr:
//   flutter test tool/export_admin_content_test.dart
// (Home verses come from the .arb files – see verse_carousel.dart.)
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:muslimin/data/dhikr/dhikrs.dart';

void main() {
  test('export admin content', () {
    const out = '../docs/admin/data/content';
    File('assets/duas/duas.json').copySync('$out/duas.json');
    File('assets/quran/refresh_ayat.json').copySync('$out/refreshAyat.json');
    File('$out/dhikr.json').writeAsStringSync(
      const JsonEncoder.withIndent(' ').convert({
        'items': [
          for (final d in kDefaultDhikrs)
            {...d.toJson(), 'afterSalah': d.afterSalah},
        ],
      }),
    );
  });
}
