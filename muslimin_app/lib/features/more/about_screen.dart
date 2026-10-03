import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../l10n/app_localizations.dart';
import '../registration/registration_flow.dart' show showTerms;

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
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
                TextButton(
                  onPressed: () => showTerms(context),
                  child: Text(t.termsAndConditions),
                ),
                FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (_, s) => Text(
                    s.hasData
                        ? t.version(
                            f.digits(
                              '${s.data!.version} (${s.data!.buildNumber})',
                            ),
                          )
                        : '',
                    style: AppText.caption.copyWith(color: AppColors.muted),
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
