import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';
import '../../services/update_service.dart';
import '../registration/registration_flow.dart' show showTerms;

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.aboutApp)),
      body: ListView(
        children: [
          SizedBox(
            height: 180,
            child: IslamicPattern(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Wordmark(size: 40),
                    if (kBeta) ...[
                      const SizedBox(height: 6),
                      const BetaBadge(),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      t.tagline,
                      style: AppText.body.copyWith(color: AppColors.cream),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Gap.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.aboutBody, style: AppText.body.copyWith(height: 1.6)),
                const SizedBox(height: Gap.xl),
                Text(t.credits, style: AppText.subtitle),
                const SizedBox(height: Gap.s),
                Text(
                  t.fontCredits,
                  style: AppText.caption.copyWith(height: 1.6),
                ),
                const SizedBox(height: Gap.xs),
                Text(
                  t.designInspired,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: Gap.m),
                Wrap(
                  spacing: Gap.s,
                  children: [
                    TextButton(
                      onPressed: () => showTerms(context),
                      child: Text(t.termsAndConditions),
                    ),
                    TextButton(
                      onPressed: () => showLicensePage(
                        context: context,
                        applicationName: kAppName,
                        applicationLegalese: t.fontCredits,
                      ),
                      child: Text(t.openSourceLicenses),
                    ),
                  ],
                ),
                const SizedBox(height: Gap.m),
                const _VersionCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Installed version + "update available" with a direct APK download
/// (Android) or the install guide (iPhone). Data: latest GitHub release.
class _VersionCard extends StatefulWidget {
  const _VersionCard();

  @override
  State<_VersionCard> createState() => _VersionCardState();
}

class _VersionCardState extends State<_VersionCard> {
  late final Future<(PackageInfo, UpdateInfo?)> _data = _load();

  Future<(PackageInfo, UpdateInfo?)> _load() async {
    final info = await PackageInfo.fromPlatform();
    try {
      return (info, await UpdateService().latest());
    } catch (_) {
      return (info, null);
    }
  }

  bool get _android =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  void _open(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    return AppCard(
      child: FutureBuilder(
        future: _data,
        builder: (context, snap) {
          final info = snap.data?.$1;
          final latest = snap.data?.$2;
          final newer =
              info != null &&
              latest != null &&
              latest.isNewerThan(info.version);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.system_update_alt_rounded,
                    color: AppColors.gold,
                  ),
                  const SizedBox(width: Gap.m),
                  Expanded(child: Text(t.appVersion, style: AppText.subtitle)),
                  if (info != null)
                    Text(
                      f.digits('${info.version} (${info.buildNumber})') +
                          (kBeta ? ' · Beta' : ''),
                      style: AppText.label,
                    ),
                ],
              ),
              const SizedBox(height: Gap.m),
              if (snap.connectionState != ConnectionState.done)
                Text(
                  t.checkingUpdates,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                )
              else if (latest == null)
                Text(
                  t.updateCheckFailed,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                )
              else ...[
                Row(
                  children: [
                    Icon(
                      newer
                          ? Icons.new_releases_outlined
                          : Icons.check_circle_outline_rounded,
                      size: 18,
                      color: newer ? AppColors.gold : AppColors.success,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        newer
                            ? t.updateAvailable(f.digits(latest.version))
                            : t.upToDate,
                        style: AppText.label.copyWith(
                          color: newer ? AppColors.gold : AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Gap.m),
                if (_android) ...[
                  AppButton(
                    '${t.downloadLatestApk} (${latest.tag})',
                    icon: Icons.download_rounded,
                    style: newer
                        ? AppButtonStyle.filled
                        : AppButtonStyle.outlined,
                    expand: true,
                    onPressed: () => _open(latest.apkUrl),
                  ),
                  const SizedBox(height: Gap.s),
                  Text(
                    t.updateApkHint,
                    style: AppText.caption.copyWith(color: AppColors.muted),
                  ),
                ] else
                  AppButton(
                    t.updateIosButton,
                    icon: Icons.open_in_new_rounded,
                    style: newer
                        ? AppButtonStyle.filled
                        : AppButtonStyle.outlined,
                    expand: true,
                    onPressed: () => _open(UpdateService.installGuideUrl),
                  ),
                TextButton(
                  onPressed: () => _open(latest.pageUrl),
                  child: Text(t.releaseNotes),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
