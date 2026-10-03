import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/nav.dart';
import '../../../core/utils/live_link.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/surfaces.dart';
import '../../../data/models/masjid.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/providers.dart';

/// Live khutbah / bayan link. Users see a "Live now" card; the masjid
/// authority pastes a YouTube/Facebook link and flips the switch.
class MasjidLiveTab extends ConsumerStatefulWidget {
  const MasjidLiveTab({super.key, required this.masjid, required this.canEdit});

  final Masjid masjid;
  final bool canEdit;

  @override
  ConsumerState<MasjidLiveTab> createState() => _MasjidLiveTabState();
}

class _MasjidLiveTabState extends ConsumerState<MasjidLiveTab> {
  late final _url = TextEditingController(text: widget.masjid.liveUrl ?? '');
  late bool _live = widget.masjid.isLive;
  bool _saving = false;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final url = _url.text.trim();
      await ref
          .read(backendProvider)
          .updateLive(
            widget.masjid.id,
            url: url.isEmpty ? null : url,
            isLive: _live && url.isNotEmpty,
          );
      if (mounted) toast(context, L10n.of(context).updated);
    } catch (_) {
      if (mounted) toast(context, L10n.of(context).somethingWrong);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final m = widget.masjid;
    return ListView(
      padding: const EdgeInsets.all(Gap.l),
      children: [
        if (m.isLive && (m.liveUrl?.isNotEmpty ?? false))
          AppCard(
            color: AppColors.ink,
            padding: const EdgeInsets.all(Gap.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: Gap.s),
                    Text(
                      t.liveNow,
                      style: AppText.subtitle.copyWith(
                        color: AppColors.goldLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Gap.s),
                Text(
                  m.name,
                  style: AppText.body.copyWith(color: AppColors.cream),
                ),
                const SizedBox(height: Gap.l),
                AppButton(
                  t.watchLive,
                  icon: Icons.play_arrow_rounded,
                  onPressed: () => openLiveStream(m.liveUrl!),
                ),
              ],
            ),
          )
        else
          EmptyState(
            message: t.noLive,
            hint: t.noLiveHint,
            icon: Icons.live_tv_outlined,
          ),
        if (widget.canEdit) ...[
          const SizedBox(height: Gap.l),
          AppCard(
            padding: const EdgeInsets.fromLTRB(Gap.l, 0, Gap.l, Gap.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: t.liveLink,
                  controller: _url,
                  keyboardType: TextInputType.url,
                  hint: 'https://',
                ),
                const SizedBox(height: Gap.s),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _live,
                  activeThumbColor: AppColors.gold,
                  title: Text(t.liveToggle, style: AppText.label),
                  onChanged: (v) => setState(() => _live = v),
                ),
                AppButton(
                  t.update,
                  expand: true,
                  loading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
