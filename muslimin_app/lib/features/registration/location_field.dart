import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/backend/backend.dart' show kRequiredAccuracyM;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/form_fields.dart';
import '../../l10n/app_localizations.dart';
import '../../services/location_service.dart';

/// "Masjid location" for registering or editing a masjid. Two ways:
/// * at the masjid – the phone's GPS (stay inside while it loads), or
/// * on the map – point at the masjid or tap one already on the map.
/// Once set, a small map shows the spot with how it was chosen.
class LocationField extends StatelessWidget {
  const LocationField({
    super.key,
    required this.fix,
    required this.loading,
    required this.error,
    required this.onUseGps,
    required this.onPickMap,
  });

  final UserLocation? fix;
  final bool loading;
  final String? error;
  final VoidCallback onUseGps;
  final VoidCallback onPickMap;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(t.masjidLocation),
        if (fix == null) ...[
          Text(
            t.chooseLocationWay,
            style: AppText.caption.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: Gap.s),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _OptionCard(
                    icon: Icons.my_location_rounded,
                    title: t.atTheMasjid,
                    body: t.atTheMasjidBody,
                    loading: loading,
                    onTap: loading ? null : onUseGps,
                  ),
                ),
                const SizedBox(width: Gap.m),
                Expanded(
                  child: _OptionCard(
                    icon: Icons.map_rounded,
                    title: t.onTheMap,
                    body: t.onTheMapBody,
                    onTap: loading ? null : onPickMap,
                  ),
                ),
              ],
            ),
          ),
        ] else
          _Chosen(
            fix: fix!,
            loading: loading,
            onUseGps: onUseGps,
            onPickMap: onPickMap,
          ),
        if (error != null) ...[
          const SizedBox(height: Gap.s),
          Text(
            error!,
            style: AppText.caption.copyWith(color: AppColors.danger),
          ),
        ],
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    this.loading = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.field,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.card),
      side: BorderSide(color: AppColors.gold.withValues(alpha: 0.45)),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(Radii.card),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(Gap.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.14),
              ),
              child: loading
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.gold,
                      ),
                    )
                  : Icon(icon, color: AppColors.gold),
            ),
            const SizedBox(height: Gap.s),
            Text(title, style: AppText.label),
            const SizedBox(height: 2),
            Text(body, style: AppText.micro.copyWith(color: AppColors.muted)),
          ],
        ),
      ),
    ),
  );
}

/// The chosen spot: map preview, how it was chosen, coordinates, and the
/// two ways to change it.
class _Chosen extends StatelessWidget {
  const _Chosen({
    required this.fix,
    required this.loading,
    required this.onUseGps,
    required this.onPickMap,
  });

  final UserLocation fix;
  final bool loading;
  final VoidCallback onUseGps;
  final VoidCallback onPickMap;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final p = LatLng(fix.lat, fix.lng);
    final gpsOk = fix.accuracy <= kRequiredAccuracyM;
    final (chip, chipColor) = fix.fromMap
        ? (t.locFromMap, AppColors.gold)
        : fix.accuracy > 0
        ? (
            '${t.locFromGps} · ${t.accuracy(f.digits(fix.accuracy.round()))}',
            gpsOk ? AppColors.success : AppColors.danger,
          )
        : (t.locSaved, AppColors.muted);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                FlutterMap(
                  key: ValueKey('${fix.lat},${fix.lng}'),
                  options: MapOptions(
                    initialCenter: p,
                    initialZoom: 17,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                    onTap: (_, _) => onPickMap(),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.muslimin.muslimin_app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: p,
                          width: 40,
                          height: 44,
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.location_on_rounded,
                            size: 44,
                            color: AppColors.header,
                            shadows: const [
                              Shadow(color: Colors.black38, blurRadius: 6),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  left: Gap.s,
                  top: Gap.s,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(Radii.pill),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          fix.fromMap
                              ? Icons.map_rounded
                              : Icons.gps_fixed_rounded,
                          size: 14,
                          color: chipColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          chip,
                          style: AppText.micro.copyWith(
                            color: chipColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  right: 4,
                  bottom: 2,
                  child: Text(
                    '© OpenStreetMap',
                    style: TextStyle(fontSize: 9, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.m, Gap.m, Gap.m, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fix.label.isNotEmpty)
                  Text(
                    fix.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label,
                  ),
                Text(
                  '${f.digits(fix.lat.toStringAsFixed(6))}, ${f.digits(fix.lng.toStringAsFixed(6))}',
                  style: AppText.caption.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.xs),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: loading ? null : onUseGps,
                    icon: loading
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location_rounded, size: 18),
                    label: Text(t.useGpsInstead, textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: loading ? null : onPickMap,
                    icon: const Icon(Icons.edit_location_alt_rounded, size: 18),
                    label: Text(t.adjustOnMap, textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
