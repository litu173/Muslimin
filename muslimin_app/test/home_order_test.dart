import 'package:flutter_test/flutter_test.dart';
import 'package:muslimin/data/models/app_config.dart';

void main() {
  test('Home order from the admins, unknown and repeated keys dropped', () {
    expect(HomeSection.order(null), HomeSection.all);
    expect(
      HomeSection.order(['verses', 'dua', 'nope', 'verses']),
      ['verses', 'dua', 'masjids', 'womenSpace', 'dailyQuran', 'dailyDhikr'],
    );
    expect(
      AppConfig.fromMap({
        'homeOrder': ['dailyQuran'],
      }).homeOrder.first,
      'dailyQuran',
    );
  });
}
