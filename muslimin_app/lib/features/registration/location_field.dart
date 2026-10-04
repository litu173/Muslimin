import 'package:flutter/material.dart';

import '../../data/backend/backend.dart' show kRequiredAccuracyM;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/form_fields.dart';
import '../../l10n/app_localizations.dart';
import '../../services/location_service.dart';

/// "Latitude & Longitude" field with a Load / Reload button and the GPS
/// accuracy, used when registering a masjid and when editing its info.
class LocationField extends StatelessWidget {
  const LocationField({
    super.key,
    required this.fix,
    required this.loading,
    required this.error,
    required this.onLoad,
  });

  final UserLocation? fix;
  final bool loading;
  final String? error;
  final VoidCallback onLoad;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(t.latLng),
        if (fix != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: Gap.s),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(Radii.field),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${f.digits(fix!.lat.toStringAsFixed(6))}, ${f.digits(fix!.lng.toStringAsFixed(6))}',
                    style: AppText.label,
                  ),
                ),
                // 0 = unknown (older profiles) – no accuracy to show.
                if (fix!.accuracy > 0)
                  Text(
                    t.accuracy(f.digits(fix!.accuracy.round())),
                    style: AppText.caption.copyWith(
                      color: fix!.accuracy <= kRequiredAccuracyM
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                  ),
              ],
            ),
          ),
        AppButton(
          fix == null ? t.load : t.reload,
          style: AppButtonStyle.outlined,
          expand: true,
          loading: loading,
          icon: Icons.my_location_rounded,
          onPressed: onLoad,
        ),
        const SizedBox(height: Gap.s),
        Text(
          error ?? t.stayInsideLoading,
          style: AppText.caption.copyWith(
            color: error == null ? AppColors.ink : AppColors.danger,
          ),
        ),
      ],
    );
  }
}
