import 'package:flutter/material.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/surfaces.dart';
import '../../data/models/hm.dart';
import '../../data/models/notice.dart';
import '../../l10n/app_localizations.dart';
import '../masjid/follow_badge.dart';
import '../masjid/masjid_screen.dart';

class NoticeIcon extends StatelessWidget {
  const NoticeIcon({super.key});

  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/images/notice_mosque.png', width: 40, height: 40);
}

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.notice,
    this.showMasjid = true,
    this.onDelete,
  });

  final Notice notice;
  final bool showMasjid;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final f = Fmt.of(context);
    final t = L10n.of(context);
    final title =
        notice.category == NoticeCategory.janaza &&
            (notice.personName?.isNotEmpty ?? false)
        ? t.janazaOf(notice.personName!)
        : notice.title;
    return InfoTile(
      leading: const NoticeIcon(),
      title: title,
      line: showMasjid ? notice.masjidName : null,
      meta: f.noticeMeta(notice),
      onTap: () => showNoticeDetails(context, notice, onDelete: onDelete),
    );
  }
}

Future<void> showNoticeDetails(
  BuildContext context,
  Notice n, {
  VoidCallback? onDelete,
}) {
  final t = L10n.of(context);
  final f = Fmt.of(context);
  final time = HM.tryParse(n.time);

  Widget row(String label, String? value) => value == null || value.isEmpty
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: Gap.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: AppText.caption.copyWith(color: AppColors.muted),
                ),
              ),
              Expanded(child: Text(value, style: AppText.label)),
            ],
          ),
        );

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
      ),
      padding: EdgeInsets.fromLTRB(
        Gap.xl,
        Gap.m,
        Gap.xl,
        Gap.xl + MediaQuery.of(ctx).padding.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: Gap.l),
            Row(
              children: [
                const NoticeIcon(),
                const SizedBox(width: Gap.m),
                Expanded(
                  child: StatusPill(
                    label: f.category(n.category),
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Gap.m),
            Text(
              n.category == NoticeCategory.janaza &&
                      (n.personName?.isNotEmpty ?? false)
                  ? t.janazaOf(n.personName!)
                  : n.title,
              style: AppText.headline,
            ),
            if (n.details.isNotEmpty) ...[
              const SizedBox(height: Gap.s),
              Text(n.details, style: AppText.body),
            ],
            row(t.personName, n.personName),
            row(t.fathersName, n.fatherName),
            row(t.diedOn, n.diedOn == null ? null : f.date(n.diedOn!)),
            row(t.address, n.address),
            row(
              n.category == NoticeCategory.janaza ? t.janazaTime : t.time,
              time == null ? null : f.hmPeriod(time),
            ),
            row(
              n.category == NoticeCategory.janaza ? t.janazaDate : t.date,
              n.date == null ? null : f.longDate(n.date!),
            ),
            const SizedBox(height: Gap.xl),
            AppCard(
              color: AppColors.cream,
              onTap: () {
                Navigator.pop(ctx);
                push(context, MasjidScreen(masjidId: n.masjidId));
              },
              child: Row(
                children: [
                  FollowBadge(masjidId: n.masjidId, size: 32),
                  const SizedBox(width: Gap.m),
                  Expanded(child: Text(n.masjidName, style: AppText.label)),
                  Icon(Icons.chevron_right_rounded, color: AppColors.ink),
                ],
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(height: Gap.m),
              AppButton(
                t.delete,
                style: AppButtonStyle.outlined,
                icon: Icons.delete_outline_rounded,
                expand: true,
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: ctx,
                    builder: (d) => AlertDialog(
                      title: Text(t.deleteNoticeQ, style: AppText.subtitle),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(d, false),
                          child: Text(t.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(d, true),
                          child: Text(t.delete),
                        ),
                      ],
                    ),
                  );
                  if (ok == true && ctx.mounted) {
                    Navigator.pop(ctx);
                    onDelete();
                  }
                },
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// Horizontal category filter used on Home ("All · Talim · Quran · …").
class NoticeFilterBar extends StatefulWidget {
  const NoticeFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final NoticeCategory? selected;
  final ValueChanged<NoticeCategory?> onChanged;

  static const order = [
    NoticeCategory.talim,
    NoticeCategory.quran,
    NoticeCategory.recruitment,
    NoticeCategory.mahfil,
    NoticeCategory.janaza,
    NoticeCategory.tafsir,
    NoticeCategory.general,
  ];

  @override
  State<NoticeFilterBar> createState() => _NoticeFilterBarState();
}

class _NoticeFilterBarState extends State<NoticeFilterBar> {
  final _keys = {
    for (final c in <NoticeCategory?>[null, ...NoticeFilterBar.order])
      c: GlobalKey(),
  };

  @override
  void didUpdateWidget(NoticeFilterBar old) {
    super.didUpdateWidget(old);
    // Keep the selected chip in view when the category changes by swiping.
    if (old.selected != widget.selected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _keys[widget.selected]?.currentContext;
        if (ctx != null && ctx.mounted) {
          Scrollable.ensureVisible(
            ctx,
            alignment: 0.5,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = Fmt.of(context);
    final t = L10n.of(context);
    return SizedBox(
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Gap.l),
        children: [
          AppChip(
            key: _keys[null],
            label: t.all,
            selected: widget.selected == null,
            onTap: () => widget.onChanged(null),
          ),
          for (final c in NoticeFilterBar.order) ...[
            const SizedBox(width: Gap.m),
            AppChip(
              key: _keys[c],
              label: f.category(c, short: true),
              selected: widget.selected == c,
              onTap: () => widget.onChanged(c),
            ),
          ],
        ],
      ),
    );
  }
}
