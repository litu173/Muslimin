import 'package:flutter_test/flutter_test.dart';
import 'package:muslimin/services/update_service.dart';

void main() {
  test('versions compare by number, suffixes ignored', () {
    expect(compareVersions('1.23.0', '1.22.0'), 1);
    expect(compareVersions('1.10.0', '1.9.3'), 1);
    expect(compareVersions('1.23.0', '1.23.0'), 0);
    expect(compareVersions('1.22.0-beta', '1.23.0'), -1);
  });
}
