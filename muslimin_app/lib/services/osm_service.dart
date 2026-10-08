import 'dart:convert';

import 'package:http/http.dart' as http;

/// A masjid or a search result on the map.
class MapPlace {
  const MapPlace({
    required this.lat,
    required this.lng,
    required this.name,
    this.subtitle = '',
    this.isMasjid = true,
  });

  final double lat;
  final double lng;
  final String name;
  final String subtitle;

  /// False for search results that are areas, roads etc.
  final bool isMasjid;
}

/// OpenStreetMap data used by the map picker – free, no API key:
/// * masjids already on the map (Overpass API),
/// * place / masjid search (Nominatim).
/// Both ask apps to identify themselves with a User-Agent.
class OsmService {
  static const _ua = {
    'User-Agent': 'Muslimin/1.9 (https://github.com/litu173/Muslimin)',
  };
  static const _overpass = [
    'https://overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
  ];

  /// Masjids mapped on OpenStreetMap within [radiusM] of a point.
  Future<List<MapPlace>> masjidsAround(
    double lat,
    double lng, {
    int radiusM = 1500,
    String lang = 'en',
  }) async {
    final query =
        '[out:json][timeout:15];'
        'nwr["amenity"="place_of_worship"]["religion"="muslim"]'
        '(around:$radiusM,$lat,$lng);out center 80;';
    for (final url in _overpass) {
      try {
        final res = await http
            .post(Uri.parse(url), headers: _ua, body: {'data': query})
            .timeout(const Duration(seconds: 20));
        if (res.statusCode != 200) continue;
        final els = (jsonDecode(res.body) as Map)['elements'] as List;
        return [
          for (final e in els.cast<Map<String, dynamic>>())
            if ((e['lat'] ?? (e['center'] as Map?)?['lat']) != null)
              MapPlace(
                lat: ((e['lat'] ?? e['center']['lat']) as num).toDouble(),
                lng: ((e['lon'] ?? e['center']['lon']) as num).toDouble(),
                name: _name(e['tags'] as Map?, lang),
              ),
        ];
      } catch (_) {
        // Try the next mirror.
      }
    }
    return const [];
  }

  /// The masjid's name in [lang] if mapped, else English, else local.
  static String _name(Map? tags, String lang) {
    final t = tags ?? const {};
    return (t['name:$lang'] ?? t['name:en'] ?? t['name'] ?? '') as String;
  }

  /// Places matching [q] in Bangladesh (masjids, areas, roads…).
  Future<List<MapPlace>> search(String q, {String lang = 'en'}) async {
    if (q.trim().length < 3) return const [];
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': q,
      'format': 'jsonv2',
      'limit': '8',
      'countrycodes': 'bd',
      'accept-language': '$lang,en,bn',
    });
    final res = await http
        .get(uri, headers: _ua)
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) return const [];
    return [
      for (final r
          in (jsonDecode(res.body) as List).cast<Map<String, dynamic>>())
        MapPlace(
          lat: double.parse(r['lat'] as String),
          lng: double.parse(r['lon'] as String),
          name: ((r['name'] as String?)?.isNotEmpty ?? false)
              ? r['name'] as String
              : (r['display_name'] as String).split(',').first,
          subtitle: (r['display_name'] as String)
              .split(',')
              .skip(1)
              .take(3)
              .join(',')
              .trim(),
          isMasjid: r['type'] == 'place_of_worship',
        ),
    ];
  }
}
