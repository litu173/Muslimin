import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/nav.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/gold_sheet.dart';
import '../../../core/widgets/surfaces.dart';
import '../../../data/models/masjid.dart';
import '../../../data/models/notice.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/providers.dart';
import '../../notices/notice_card.dart';
import '../../notices/notice_form_screen.dart';
import '../masjid_screen.dart';

class MasjidNoticeTab extends ConsumerWidget {
  const MasjidNoticeTab({
    super.key,
    required this.masjid,
    required this.canEdit,
  });

  final Masjid masjid;
  final bool canEdit;

  Future<void> _write(BuildContext context) async {
    final f = Fmt.of(context);
    final cat = await showGoldSheet<NoticeCategory>(
      context,
      icon: Icons.article_outlined,
      title: f.t.selectCategory,
      options: [
        for (final c in const [
          NoticeCategory.janaza,
          NoticeCategory.recruitment,
          NoticeCategory.quran,
          NoticeCategory.mahfil,
          NoticeCategory.talim,
          NoticeCategory.tafsir,
          NoticeCategory.general,
        ])
          GoldSheetOption(c, f.category(c)),
      ],
    );
    if (cat != null && context.mounted) {
      push(context, NoticeFormScreen(masjid: masjid, category: cat));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    ref.listen(masjidEditRequestProvider, (_, next) {
      if (next.$1 == 1 && canEdit) _write(context);
    });
    final notices = ref.watch(noticesProvider(masjid.id));
    final now = ref.watch(minuteProvider);

    return Column(
      children: [
        Expanded(
          child: notices.when(
            loading: () => const Loader(),
            error: (_, _) => EmptyState(message: t.somethingWrong),
            data: (list) {
              if (list.isEmpty) {
                return EmptyState(
                  message: t.noNotices,
                  icon: Icons.campaign_outlined,
                );
              }
              // Group by posting day: "Today", "05/03/2023", …
              final groups = <String, List<Notice>>{};
              for (final n in list) {
                final today = DateUtils.isSameDay(n.createdAt, now);
                groups
                    .putIfAbsent(
                      today ? t.today : f.date(n.createdAt),
                      () => [],
                    )
                    .add(n);
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  Gap.l,
                  Gap.s,
                  Gap.l,
                  Gap.xxl,
                ),
                children: [
                  for (final g in groups.entries) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, Gap.l, 0, Gap.m),
                      child: Text(g.key, style: AppText.body),
                    ),
                    for (final n in g.value) ...[
                      NoticeCard(
                        notice: n,
                        showMasjid: false,
                        onDelete: canEdit
                            ? () => ref.read(backendProvider).deleteNotice(n.id)
                            : null,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              );
            },
          ),
        ),
        if (canEdit)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.s, Gap.xl, Gap.l),
              child: AppButton(
                t.writeNotice,
                expand: true,
                onPressed: () => _write(context),
              ),
            ),
          ),
      ],
    );
  }
}
