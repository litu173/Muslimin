import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  const UserLocation({
    required this.lat,
    required this.lng,
    required this.label,
    this.accuracy = 0,
    this.fromMap = false,
  });

  final double lat;
  final double lng;
  final String label;
  final double accuracy;

  /// Chosen on the map (no GPS accuracy) rather than measured on site.
  final bool fromMap;
}

class LocationService {
  final _geocoding = Geocoding();

  Future<bool> serviceEnabled() => Geolocator.isLocationServiceEnabled();

  /// Current position with a human readable label ("Dilu Road, Dhaka").
  Future<UserLocation> current({bool precise = false}) async {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: precise
            ? LocationAccuracy.bestForNavigation
            : LocationAccuracy.high,
        timeLimit: Duration(seconds: precise ? 30 : 20),
      ),
    );
    return UserLocation(
      lat: pos.latitude,
      lng: pos.longitude,
      accuracy: pos.accuracy,
      label: await labelFor(pos.latitude, pos.longitude),
    );
  }

  /// Samples GPS for a few seconds and returns the most accurate fix – used
  /// when registering a masjid ("stay inside the masjid during loading").
  Future<UserLocation> preciseFix({
    Duration window = const Duration(seconds: 8),
  }) async {
    Position? best;
    final stream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    ).timeout(window, onTimeout: (sink) => sink.close());
    try {
      await for (final p in stream) {
        if (best == null || p.accuracy < best.accuracy) best = p;
        if (p.accuracy <= 8) break;
      }
    } catch (_) {}
    best ??= await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );
    return UserLocation(
      lat: best.latitude,
      lng: best.longitude,
      accuracy: best.accuracy,
      label: await labelFor(best.latitude, best.longitude),
    );
  }

  Future<String> labelFor(double lat, double lng) async {
    try {
      final marks = await _geocoding.placemarkFromCoordinates(lat, lng);
      if (marks.isEmpty) return _coords(lat, lng);
      final p = marks.first;
      String? first(List<String?> xs) => xs.firstWhere(
        (x) => x != null && x.trim().isNotEmpty,
        orElse: () => null,
      );
      final parts = <String?>[
        first([p.subLocality, p.thoroughfare, p.name]),
        first([p.locality, p.subAdministrativeArea, p.administrativeArea]),
        p.country,
      ].whereType<String>().where((s) => s.trim().isNotEmpty).toSet().toList();
      return parts.isEmpty ? _coords(lat, lng) : parts.join(', ');
    } catch (_) {
      return _coords(lat, lng);
    }
  }

  String _coords(double lat, double lng) =>
      '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
}
