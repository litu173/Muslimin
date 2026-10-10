import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// A route between two points: its line, length and travel time.
class TravelRoute {
  const TravelRoute(this.points, this.meters, this.seconds);

  final List<LatLng> points;
  final double meters;
  final double seconds;
}

/// Walking and driving routes from the OpenStreetMap routing service run by
/// FOSSGIS (routing.openstreetmap.de – the one openstreetmap.org uses; free,
/// no key, fair use). Returns null when there is no route or no connection.
class RouteService {
  static const _ua = {
    'User-Agent': 'Muslimin/1.14 (https://github.com/litu173/Muslimin)',
  };

  Future<TravelRoute?> route(
    LatLng from,
    LatLng to, {
    required bool walk,
  }) async {
    final profile = walk
        ? 'routed-foot/route/v1/foot'
        : 'routed-car/route/v1/driving';
    final uri = Uri.parse(
      'https://routing.openstreetmap.de/$profile/'
      '${from.longitude},${from.latitude};${to.longitude},${to.latitude}'
      '?overview=full&geometries=geojson',
    );
    try {
      final res = await http
          .get(uri, headers: _ua)
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) return null;
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      final routes = j['routes'] as List?;
      if (j['code'] != 'Ok' || routes == null || routes.isEmpty) return null;
      final r = routes.first as Map<String, dynamic>;
      final coords = (r['geometry'] as Map)['coordinates'] as List;
      return TravelRoute(
        [
          for (final c in coords.cast<List>())
            LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
        ],
        (r['distance'] as num).toDouble(),
        (r['duration'] as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}
