import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A thana / upazila and its district – the same names the masjid profiles
/// use (`district`, `thana`).
@immutable
class Thana {
  const Thana(this.district, this.name);

  final String district;
  final String name;

  String get label => '$name, $district';

  @override
  bool operator ==(Object other) =>
      other is Thana && other.district == district && other.name == name;

  @override
  int get hashCode => Object.hash(district, name);
}

class _Area {
  _Area(this.thana, this.box, this.rings);
  final Thana thana;
  final List<double> box; // minLng, minLat, maxLng, maxLat
  final List<List<double>> rings; // lng, lat, lng, lat…
}

/// All 544 upazilas and city thanas of Bangladesh with their outlines
/// (`assets/geo/upazilas.json`, built by firebase/tools/build_upazilas.py
/// from geoBoundaries – BBS / OCHA, CC BY 3.0 IGO). Finds a GPS point's thana
/// on the phone, without any server.
class ThanaService {
  ThanaService._(this._areas);

  final List<_Area> _areas;

  static Future<ThanaService>? _loading;

  static Future<ThanaService> load() => _loading ??= () async {
    final raw = await rootBundle.loadString('assets/geo/upazilas.json');
    final areas = await compute(_parse, raw);
    return ThanaService._(areas);
  }();

  static List<_Area> _parse(String raw) => [
    for (final a in (jsonDecode(raw) as List).cast<Map<String, dynamic>>())
      _Area(
        Thana(a['d'] as String, a['t'] as String),
        [for (final v in a['b'] as List) (v as num).toDouble()],
        [
          for (final r in a['p'] as List)
            [for (final v in r as List) (v as num).toDouble()],
        ],
      ),
  ];

  /// Every thana, by name.
  late final List<Thana> all = [for (final a in _areas) a.thana]
    ..sort((a, b) => a.name.compareTo(b.name));

  /// The thana containing the point, or null (outside Bangladesh).
  Thana? at(double lat, double lng) {
    for (final a in _areas) {
      final b = a.box;
      if (lng < b[0] || lng > b[2] || lat < b[1] || lat > b[3]) continue;
      for (final r in a.rings) {
        if (_inside(lng, lat, r)) return a.thana;
      }
    }
    return null;
  }

  static bool _inside(double x, double y, List<double> r) {
    var c = false;
    final n = r.length ~/ 2;
    for (var i = 0, j = n - 1; i < n; j = i++) {
      final xi = r[2 * i], yi = r[2 * i + 1];
      final xj = r[2 * j], yj = r[2 * j + 1];
      if ((yi > y) != (yj > y) && x < (xj - xi) * (y - yi) / (yj - yi) + xi) {
        c = !c;
      }
    }
    return c;
  }
}
