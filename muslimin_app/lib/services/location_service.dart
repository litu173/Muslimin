import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  const UserLocation({
    required this.lat,
    required this.lng,
    required this.label,
    this.accuracy = 0,
    this.fromMap = false,
    this.approximate = false,
  });

  final double lat;
  final double lng;
  final String label;
  final double accuracy;

  /// Chosen on the map (no GPS accuracy) rather than measured on site.
  final bool fromMap;

  /// The phone only gives an approximate position (iOS "Precise Location"
  /// off, or Android "Approximate") – it can be kilometres off.
  final bool approximate;
}

class LocationService {
  final _geocoding = Geocoding();

  Future<bool> serviceEnabled() => Geolocator.isLocationServiceEnabled();

  /// Current position with a human readable label ("Dilu Road, Dhaka").
  ///
  /// A single `getCurrentPosition` can hand back the phone's last cached
  /// fix (often from a cell tower, hundreds of metres off), so this watches
  /// fresh GPS fixes for a few seconds and keeps the best one.
  Future<UserLocation> current({bool precise = false}) async {
    var approximate = await _approximate();
    if (approximate && Platform.isIOS) {
      // Asks once per session: "Allow precise location for…?"
      try {
        approximate =
            await Geolocator.requestTemporaryFullAccuracy(
              purposeKey: 'MasjidDistance',
            ) ==
            LocationAccuracyStatus.reduced;
      } catch (_) {}
    }
    final pos = await _freshFix(
      window: Duration(seconds: precise ? 12 : 6),
      goodEnough: precise ? 10 : 30,
    );
    return UserLocation(
      lat: pos.latitude,
      lng: pos.longitude,
      accuracy: pos.accuracy,
      approximate: approximate,
      label: await labelFor(pos.latitude, pos.longitude),
    );
  }

  Future<bool> _approximate() async {
    try {
      return await Geolocator.getLocationAccuracy() ==
          LocationAccuracyStatus.reduced;
    } catch (_) {
      return false;
    }
  }

  /// The most accurate fix seen within [window], stopping early once one is
  /// within [goodEnough] metres. Fixes older than two minutes are ignored.
  Future<Position> _freshFix({
    required Duration window,
    required double goodEnough,
  }) async {
    Position? best;
    bool fresh(Position p) =>
        DateTime.now().difference(p.timestamp).inSeconds.abs() < 120;
    final stream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    ).timeout(window, onTimeout: (sink) => sink.close());
    try {
      await for (final p in stream) {
        if (!fresh(p)) continue;
        if (best == null || p.accuracy < best.accuracy) best = p;
        if (p.accuracy <= goodEnough) break;
      }
    } catch (_) {}
    return best ??
        await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 20),
          ),
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
        if (DateTime.now().difference(p.timestamp).inSeconds.abs() > 120) {
          continue;
        }
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
