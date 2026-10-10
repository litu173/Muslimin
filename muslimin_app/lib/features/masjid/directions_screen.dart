import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/geo.dart';
import '../../core/widgets/buttons.dart';
import '../../data/models/masjid.dart';
import '../../l10n/app_localizations.dart';
import '../../services/location_service.dart';
import '../../services/route_service.dart';
import '../../state/providers.dart';
import '../registration/map_picker_screen.dart' show lightTileLayer;
import 'masjid_screen.dart' show openDirections;

final _routes = RouteService();

/// Directions inside the app: the way from the user to the masjid on a map,
/// walking or driving, with distance, time and the next jamat – and a
/// button to continue in Google Maps / Apple Maps.
class DirectionsScreen extends ConsumerStatefulWidget {
  const DirectionsScreen({super.key, required this.masjid});

  final Masjid masjid;

  @override
  ConsumerState<DirectionsScreen> createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends ConsumerState<DirectionsScreen> {
  final _map = MapController();
  UserLocation? _from;
  TravelRoute? _route;
  bool? _walk;
  bool _loading = true;
  bool _ready = false;

  LatLng get _to => LatLng(widget.masjid.lat, widget.masjid.lng);

  @override
  void initState() {
    super.initState();
    _from = ref.read(locationProvider).value;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    // A fresh fix: the way starts where the user is now.
    try {
      _from = await ref.read(locationServiceProvider).current();
    } catch (_) {}
    final from = _from;
    if (from == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    _walk ??=
        distanceMeters(from.lat, from.lng, _to.latitude, _to.longitude) < 2500;
    final r = await _routes.route(
      LatLng(from.lat, from.lng),
      _to,
      walk: _walk!,
    );
    if (!mounted) return;
    setState(() {
      _route = r;
      _loading = false;
    });
    _fit();
  }

  void _fit() {
    if (!_ready) return;
    final from = _from;
    final pts = [
      _to,
      if (from != null) LatLng(from.lat, from.lng),
      ...?_route?.points,
    ];
    if (pts.length < 2) return;
    _map.fitCamera(
      CameraFit.coordinates(
        coordinates: pts,
        padding: const EdgeInsets.fromLTRB(48, 120, 48, 320),
        maxZoom: 18,
      ),
    );
  }

  String _duration(L10n t, Fmt f, double seconds) {
    final m = (seconds / 60).ceil();
    return m < 60
        ? t.minutesShort(f.digits(m))
        : t.hoursMinutes(f.digits(m ~/ 60), f.digits(m % 60));
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final m = widget.masjid;
    final from = _from;
    final now = ref.watch(minuteProvider);
    final next = m.nextJamat(now);
    final straight = from == null
        ? null
        : distanceMeters(from.lat, from.lng, m.lat, m.lng);
    final meters = _route?.meters ?? straight;
    String km(double v) => v < 1000
        ? '${f.digits(v.round())} m'
        : '${f.digits((v / 1000).toStringAsFixed(1))} km';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: _to,
                initialZoom: 16,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                onMapReady: () {
                  _ready = true;
                  _fit();
                },
              ),
              children: [
                lightTileLayer(),
                if (_route != null)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _route!.points,
                        strokeWidth: 6,
                        color: AppColors.gold,
                        borderStrokeWidth: 2,
                        borderColor: Colors.white,
                        pattern: _walk == true
                            ? StrokePattern.dotted(spacingFactor: 1.6)
                            : const StrokePattern.solid(),
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    if (from != null)
                      Marker(
                        point: LatLng(from.lat, from.lng),
                        width: 26,
                        height: 26,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E88E5),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 6),
                            ],
                          ),
                        ),
                      ),
                    Marker(
                      point: _to,
                      width: 48,
                      height: 52,
                      alignment: Alignment.topCenter,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 52,
                            color: AppColors.header,
                            shadows: const [
                              Shadow(color: Colors.black38, blurRadius: 6),
                            ],
                          ),
                          Positioned(
                            top: 9,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.goldLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.mosque_rounded,
                                size: 14,
                                color: AppColors.inkDeep,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Close, top left.
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Gap.m),
                child: Material(
                  color: AppColors.card,
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: IconButton(
                    tooltip: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                    icon: Icon(Icons.close_rounded, color: AppColors.ink),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            // Masjid, way and actions.
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Radii.sheet),
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 16),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Gap.xl,
                      Gap.l,
                      Gap.xl,
                      Gap.m,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(m.displayName(f.isBn), style: AppText.subtitle),
                        if (m.fullAddress.isNotEmpty)
                          Text(
                            m.fullAddress,
                            style: AppText.caption.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                        if (next != null) ...[
                          const SizedBox(height: Gap.xs),
                          Text(
                            t.jamatLine(
                              f.prayer(next.prayer),
                              f.timeUpper(next.at),
                            ),
                            style: AppText.label.copyWith(
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                        const SizedBox(height: Gap.m),
                        Row(
                          children: [
                            for (final walk in [true, false]) ...[
                              ChoiceChip(
                                avatar: Icon(
                                  walk
                                      ? Icons.directions_walk_rounded
                                      : Icons.directions_car_rounded,
                                  size: 18,
                                ),
                                label: Text(walk ? t.walk : t.drive),
                                selected: _walk == walk,
                                showCheckmark: false,
                                onSelected: _loading
                                    ? null
                                    : (_) {
                                        if (_walk == walk) return;
                                        setState(() {
                                          _walk = walk;
                                          _route = null;
                                        });
                                        _load();
                                      },
                              ),
                              const SizedBox(width: Gap.s),
                            ],
                            const Spacer(),
                            if (_loading)
                              const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: Gap.s),
                        Text(
                          from == null
                              ? t.locating
                              : [
                                  if (meters != null) km(meters),
                                  if (_route != null)
                                    _duration(t, f, _route!.seconds),
                                  if (_route == null && !_loading)
                                    t.routeUnavailable,
                                ].join(' · '),
                          style: AppText.title,
                        ),
                        const SizedBox(height: Gap.l),
                        AppButton(
                          t.openInMapsApp,
                          icon: Icons.navigation_rounded,
                          expand: true,
                          onPressed: () => openDirections(m, from),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
