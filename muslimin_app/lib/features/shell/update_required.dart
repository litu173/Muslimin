import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../l10n/app_localizations.dart';
import '../../services/update_service.dart';

/// Shown instead of the app when the admin set a minimum version newer than
/// this install (admin website → App settings).
class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  String get _url => kPlayStore
      ? kPlayStoreUrl
      : !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? UpdateService.latestApkUrl
      : UpdateService.installGuideUrl;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: IslamicPattern(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Gap.xl),
              child: Column(
                children: [
                  const Spacer(),
                  Icon(
                    Icons.system_update_rounded,
                    size: 72,
                    color: AppColors.goldLight,
                  ),
                  const SizedBox(height: Gap.xl),
                  Text(
                    t.updateRequiredTitle,
                    textAlign: TextAlign.center,
                    style: AppText.headline.copyWith(color: AppColors.onHeader),
                  ),
                  const SizedBox(height: Gap.m),
                  Text(
                    t.updateRequiredBody,
                    textAlign: TextAlign.center,
                    style: AppText.body.copyWith(color: AppColors.onHeader),
                  ),
                  const Spacer(),
                  AppButton(
                    t.updateNow,
                    icon: Icons.download_rounded,
                    expand: true,
                    onPressed: () => launchUrl(
                      Uri.parse(_url),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
