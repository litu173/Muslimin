import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/surfaces.dart';
import '../../l10n/app_localizations.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final items = [
      (t.faqQ1, t.faqA1),
      (t.faqQ2, t.faqA2),
      (t.faqQ3, t.faqA3),
      (t.faqQ4, t.faqA4),
      (t.faqQ5, t.faqA5),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t.faq)),
      body: ListView.separated(
        padding: const EdgeInsets.all(Gap.l),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) => AppCard(
          padding: EdgeInsets.zero,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: AppColors.gold,
              collapsedIconColor: AppColors.ink,
              title: Text(items[i].$1, style: AppText.label),
              childrenPadding: const EdgeInsets.fromLTRB(
                Gap.l,
                0,
                Gap.l,
                Gap.l,
              ),
              children: [Text(items[i].$2, style: AppText.body)],
            ),
          ),
        ),
      ),
    );
  }
}
