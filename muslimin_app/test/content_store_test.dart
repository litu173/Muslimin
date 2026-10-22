import 'package:flutter_test/flutter_test.dart';
import 'package:muslimin/core/widgets/refresh.dart';
import 'package:muslimin/data/dhikr/dhikrs.dart';
import 'package:muslimin/features/dua/dua_data.dart';
import 'package:muslimin/services/content_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('built-in content until the admins change it', () async {
    expect(kDhikrs.length, kDefaultDhikrs.length);
    expect((await RefreshAyah.load()).length, greaterThan(10));
    expect((await loadDuaScenes()).length, greaterThan(10));
  });

  test('admin changes are applied, and only when the version is newer', () async {
    var reads = 0;
    Future<Object?> fetch(String set) async {
      reads++;
      return switch (set) {
        'dhikr' => {
          'items': [
            {'id': kDefaultDhikrs.first.id, 'bn': 'সংশোধিত অর্থ', 'perSalah': 7},
          ],
        },
        'refreshAyat' => [
          {
            'ref': '3:139',
            'ar': 'وَلَا تَهِنُوا',
            'tr': {'en': 'So do not weaken'},
          },
        ],
        _ => null,
      };
    }

    await ContentStore.sync({'dhikr': 5, 'refreshAyat': 5}, fetch);
    expect(reads, 2);
    expect(kDhikrs.first.bn, 'সংশোধিত অর্থ');
    expect(kDhikrs.first.perSalah, 7);
    expect(kDhikrs.first.ar, kDefaultDhikrs.first.ar); // untouched field kept
    expect(kDhikrs.length, kDefaultDhikrs.length);
    final ayat = await RefreshAyah.load();
    expect(ayat.single.ref, '3:139');

    // Same version again: no download.
    await ContentStore.sync({'dhikr': 5, 'refreshAyat': 5}, fetch);
    expect(reads, 2);

    // Back to built-in.
    await ContentStore.sync({'dhikr': 6, 'refreshAyat': 6}, (_) async => null);
    expect(kDhikrs.first.bn, kDefaultDhikrs.first.bn);
    expect((await RefreshAyah.load()).length, greaterThan(10));
  });
}
