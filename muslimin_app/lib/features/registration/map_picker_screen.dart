import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../services/location_service.dart';
import '../../services/osm_service.dart';
import '../../state/providers.dart';

final osmServiceProvider = Provider((_) => OsmService());

/// OpenStreetMap's tiles washed out – less colour under a white veil – so
/// the map reads light and the pins stand out.
final _lightTiles = ColorFilter.matrix(_wash(saturation: 0.4, veil: 0.25));

/// The app's light OpenStreetMap layer (map picker, directions).
TileLayer lightTileLayer() => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'com.muslimin.muslimin_app',
  maxNativeZoom: 19,
  tileBuilder: (_, tile, _) =>
      ColorFiltered(colorFilter: _lightTiles, child: tile),
);

List<double> _wash({required double saturation, required double veil}) {
  const lum = [0.2126, 0.7152, 0.0722];
  final k = 1 - veil;
  final add = 255 * veil;
  return [
    for (var row = 0; row < 3; row++) ...[
      for (var col = 0; col < 3; col++)
        k * (lum[col] * (1 - saturation) + (row == col ? saturation : 0)),
      0,
      add,
    ],
    0,
    0,
    0,
    1,
    0,
  ];
}

/// Choose a masjid's location on the map: drag the map (or tap a spot) so
/// the pin sits on the masjid, or tap a masjid already on the map. Returns a
/// [UserLocation] with `fromMap: true`, or null if cancelled.
Future<UserLocation?> pickOnMap(
  BuildContext context, {
  UserLocation? initial,
}) => Navigator.of(context).push<UserLocation>(
  MaterialPageRoute(builder: (_) => MapPickerScreen(initial: initial)),
);

class MapPickerScreen extends ConsumerStatefulWidget {
  const MapPickerScreen({super.key, this.initial});

  final UserLocation? initial;

  @override
  ConsumerState<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends ConsumerState<MapPickerScreen> {
  static const _dhaka = LatLng(23.7465, 90.3965);

  final _map = MapController();
  final _search = TextEditingController();

  late LatLng _center = widget.initial != null
      ? LatLng(widget.initial!.lat, widget.initial!.lng)
      : _fromUser() ?? _dhaka;
  bool _moving = false;

  /// Masjid tapped on the map (its name goes with the result).
  MapPlace? _selected;
  List<MapPlace> _masjids = const [];
  LatLng? _loadedAt;
  bool _loadingMasjids = false;

  String _address = '';
  Timer? _addressTimer;
  Timer? _searchTimer;
  List<MapPlace> _results = const [];
  bool _searching = false;

  LatLng? _fromUser() {
    final u = ref.read(locationProvider).value;
    return u == null ? null : LatLng(u.lat, u.lng);
  }

  String get _lang => Localizations.localeOf(context).languageCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMasjids();
      _lookupAddress();
    });
  }

  @override
  void dispose() {
    _addressTimer?.cancel();
    _searchTimer?.cancel();
    _search.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------ map moves
  void _onMoved(MapCamera camera, bool gesture) {
    _center = camera.center;
    if (gesture && _selected != null) _selected = null;
    if (!_moving) setState(() => _moving = true);
  }

  void _onMoveEnd() {
    setState(() => _moving = false);
    _addressTimer?.cancel();
    _addressTimer = Timer(const Duration(milliseconds: 400), _lookupAddress);
    final last = _loadedAt;
    if (last == null ||
        const Distance().as(LengthUnit.Meter, last, _center) > 700) {
      _loadMasjids();
    }
  }

  void _goTo(LatLng p, {double? zoom}) {
    _map.move(p, zoom ?? _map.camera.zoom);
    _center = p;
    _onMoveEnd();
  }

  Future<void> _lookupAddress() async {
    final c = _center;
    final label = await ref
        .read(locationServiceProvider)
        .labelFor(c.latitude, c.longitude);
    if (mounted && c == _center) setState(() => _address = label);
  }

  Future<void> _loadMasjids() async {
    if (_map.camera.zoom < 13.5) return;
    final c = _center;
    setState(() => _loadingMasjids = true);
    final list = await ref
        .read(osmServiceProvider)
        .masjidsAround(c.latitude, c.longitude, lang: _lang);
    if (!mounted) return;
    setState(() {
      _loadingMasjids = false;
      _loadedAt = c;
      // Keep earlier ones too, so markers don't blink while panning.
      final seen = {for (final m in list) '${m.lat},${m.lng}'};
      _masjids = [
        ...list,
        for (final m in _masjids)
          if (!seen.contains('${m.lat},${m.lng}')) m,
      ].take(300).toList();
    });
  }

  Future<void> _myLocation() async {
    try {
      final u = await ref.read(locationServiceProvider).current();
      if (!mounted) return;
      _selected = null;
      _goTo(LatLng(u.lat, u.lng), zoom: 18);
    } catch (_) {
      if (mounted) toast(context, L10n.of(context).somethingWrong);
    }
  }

  /// A tap on the map: the pin goes there, then snaps to the masjid or
  /// named place marked at that spot, if any (its name goes with it).
  Future<void> _tapAt(LatLng p) async {
    setState(() => _selected = null);
    _goTo(p);
    const near = Distance();
    for (final m in _masjids) {
      if (near.as(LengthUnit.Meter, p, LatLng(m.lat, m.lng)) < 30) {
        _pickMasjid(m);
        return;
      }
    }
    final place = await ref
        .read(osmServiceProvider)
        .placeAt(p.latitude, p.longitude, lang: _lang);
    // Ignore it if the user has moved on, or it is not where they tapped.
    if (!mounted ||
        place == null ||
        near.as(LengthUnit.Meter, p, _center) > 1) {
      return;
    }
    if (near.as(LengthUnit.Meter, p, LatLng(place.lat, place.lng)) > 40) {
      return;
    }
    _pickMasjid(place);
  }

  void _pickMasjid(MapPlace m) {
    HapticFeedback.selectionClick();
    setState(() => _selected = m);
    _goTo(LatLng(m.lat, m.lng), zoom: 18);
  }

  // --------------------------------------------------------------- search
  void _onSearch(String q) {
    _searchTimer?.cancel();
    if (q.trim().length < 3) {
      setState(() => _results = const []);
      return;
    }
    _searchTimer = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _searching = true);
      try {
        final r = await ref.read(osmServiceProvider).search(q, lang: _lang);
        if (mounted && q == _search.text) setState(() => _results = r);
      } catch (_) {
      } finally {
        if (mounted) setState(() => _searching = false);
      }
    });
  }

  void _pickResult(MapPlace p) {
    FocusScope.of(context).unfocus();
    _search.clear();
    setState(() {
      _results = const [];
      _selected = p.isMasjid ? p : null;
    });
    _goTo(LatLng(p.lat, p.lng), zoom: 18);
  }

  void _confirm() {
    final c = _center;
    Navigator.pop(
      context,
      UserLocation(
        lat: c.latitude,
        lng: c.longitude,
        label: _selected?.name.isNotEmpty == true ? _selected!.name : _address,
        fromMap: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          PageHeader(
            title: t.pickOnMapTitle,
            back: true,
            bottom: AppSearchField(
              controller: _search,
              hint: t.mapSearchHint,
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _map,
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: 17,
                    minZoom: 5,
                    maxZoom: 19,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                    onPositionChanged: _onMoved,
                    onMapEvent: (e) {
                      if (e is MapEventMoveEnd ||
                          e is MapEventFlingAnimationEnd ||
                          e is MapEventDoubleTapZoomEnd ||
                          e is MapEventScrollWheelZoom) {
                        _onMoveEnd();
                      }
                    },
                    // Tap a spot or a marked place: the pin moves there.
                    onTap: (_, p) => _tapAt(p),
                  ),
                  children: [
                    lightTileLayer(),
                    MarkerLayer(
                      markers: [
                        for (final m in _masjids)
                          Marker(
                            point: LatLng(m.lat, m.lng),
                            width: 40,
                            height: 40,
                            child: _MasjidMarker(
                              selected: identical(m, _selected),
                              onTap: () => _pickMasjid(m),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                // Centre pin – lifts while the map moves.
                IgnorePointer(
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0, -24),
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 160),
                        offset: Offset(0, _moving ? -0.25 : 0),
                        child: const _CenterPin(),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: _moving ? 14 : 8,
                      height: _moving ? 6 : 4,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                // Search results.
                if (_results.isNotEmpty || _searching)
                  Positioned(
                    left: Gap.l,
                    right: Gap.l,
                    top: Gap.s,
                    child: Material(
                      color: AppColors.card,
                      elevation: 6,
                      borderRadius: BorderRadius.circular(Radii.card),
                      clipBehavior: Clip.antiAlias,
                      child: _searching && _results.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(Gap.l),
                              child: Loader(),
                            )
                          : ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 300),
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                children: [
                                  for (final r in _results)
                                    ListTile(
                                      leading: Icon(
                                        Icons.place_outlined,
                                        color: AppColors.gold,
                                      ),
                                      title: Text(r.name, style: AppText.label),
                                      subtitle: r.subtitle.isEmpty
                                          ? null
                                          : Text(
                                              r.subtitle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppText.micro.copyWith(
                                                color: AppColors.muted,
                                              ),
                                            ),
                                      onTap: () => _pickResult(r),
                                    ),
                                ],
                              ),
                            ),
                    ),
                  ),
                // My location + loading indicator.
                Positioned(
                  right: Gap.l,
                  bottom: Gap.l,
                  child: Column(
                    children: [
                      if (_loadingMasjids)
                        Container(
                          margin: const EdgeInsets.only(bottom: Gap.s),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            shape: BoxShape.circle,
                          ),
                          child: const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      FloatingActionButton.small(
                        heroTag: 'myloc',
                        tooltip: t.useMyLocation,
                        backgroundColor: AppColors.card,
                        foregroundColor: AppColors.gold,
                        onPressed: _myLocation,
                        child: const Icon(Icons.my_location_rounded),
                      ),
                    ],
                  ),
                ),
                // OSM attribution (required by its licence).
                Positioned(
                  left: Gap.s,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    color: Colors.white.withValues(alpha: 0.8),
                    child: const Text(
                      '© OpenStreetMap contributors',
                      style: TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _BottomCard(
            center: _center,
            address: _address,
            selected: _selected,
            moving: _moving,
            onConfirm: _confirm,
          ),
        ],
      ),
    );
  }
}

class _CenterPin extends StatelessWidget {
  const _CenterPin();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 48,
    height: 52,
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Icon(
          Icons.location_on_rounded,
          size: 52,
          color: AppColors.header,
          shadows: const [Shadow(color: Colors.black38, blurRadius: 6)],
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
  );
}

class _MasjidMarker extends StatelessWidget {
  const _MasjidMarker({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.all(selected ? 0 : 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.gold : Colors.white,
        border: Border.all(
          color: selected ? Colors.white : const Color(0xFF2E8B57),
          width: 2,
        ),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Icon(
        Icons.mosque_rounded,
        size: selected ? 22 : 16,
        color: selected ? Colors.white : const Color(0xFF2E8B57),
      ),
    ),
  );
}

class _BottomCard extends StatelessWidget {
  const _BottomCard({
    required this.center,
    required this.address,
    required this.selected,
    required this.moving,
    required this.onConfirm,
  });

  final LatLng center;
  final String address;
  final MapPlace? selected;
  final bool moving;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final name = selected?.name ?? '';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16)],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, Gap.m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t.mapPickHint,
                style: AppText.caption.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: Gap.m),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withValues(alpha: 0.12),
                    ),
                    child: Icon(
                      selected?.isMasjid ?? false
                          ? Icons.mosque_rounded
                          : Icons.place_rounded,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(width: Gap.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isNotEmpty
                              ? name
                              : (moving || address.isEmpty)
                              ? t.mapMoving
                              : address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.label,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${f.digits(center.latitude.toStringAsFixed(6))}, ${f.digits(center.longitude.toStringAsFixed(6))}',
                          style: AppText.micro.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Gap.l),
              AppButton(
                t.useThisLocation,
                icon: Icons.check_rounded,
                expand: true,
                onPressed: moving ? null : onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
