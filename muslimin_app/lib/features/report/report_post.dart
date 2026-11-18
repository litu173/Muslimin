import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

/// People whose channel messages I chose to hide (kept on the phone).
final hiddenAuthorsProvider = NotifierProvider<HiddenAuthors, Set<String>>(
  HiddenAuthors.new,
);

class HiddenAuthors extends Notifier<Set<String>> {
  @override
  Set<String> build() => ref.watch(prefsProvider).hiddenAuthors.toSet();

  void hide(String uid) {
    state = {...state, uid};
    ref.read(prefsProvider).hiddenAuthors = state.toList();
  }

  void clear() {
    state = {};
    ref.read(prefsProvider).hiddenAuthors = const [];
  }
}

/// A post anyone can report (channel message or notice).
class ReportablePost {
  const ReportablePost({
    required this.kind,
    required this.masjidId,
    required this.masjidName,
    required this.itemId,
    required this.text,
    this.authorUid = '',
    this.authorName = '',
  });

  /// 'message' | 'notice'.
  final String kind;
  final String masjidId;
  final String masjidName;
  final String itemId;
  final String text;
  final String authorUid;
  final String authorName;
}

/// Actions on a channel message: delete (when allowed), report, and hide
/// the sender's messages. Google Play requires a way to report posts and
/// users wherever people can post.
Future<void> showPostActions(
  BuildContext context,
  WidgetRef ref,
  ReportablePost post, {
  VoidCallback? onDelete,
}) {
  final t = L10n.of(context);
  final me = ref.read(authProvider).value?.uid;
  final mine = post.authorUid.isNotEmpty && post.authorUid == me;
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onDelete != null)
            ListTile(
              leading: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.danger,
              ),
              title: Text(t.delete),
              onTap: () {
                Navigator.pop(ctx);
                onDelete();
              },
            ),
          if (!mine)
            ListTile(
              leading: Icon(Icons.flag_outlined, color: AppColors.ink),
              title: Text(t.reportPostTitle),
              onTap: () {
                Navigator.pop(ctx);
                reportPost(context, ref, post);
              },
            ),
          if (!mine && post.authorUid.isNotEmpty)
            ListTile(
              leading: Icon(
                Icons.visibility_off_outlined,
                color: AppColors.ink,
              ),
              title: Text(t.hideAuthor(post.authorName)),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(hiddenAuthorsProvider.notifier).hide(post.authorUid);
                toast(context, t.authorHidden);
              },
            ),
        ],
      ),
    ),
  );
}

/// Asks why, then sends the report to the Muslimin team.
Future<void> reportPost(
  BuildContext context,
  WidgetRef ref,
  ReportablePost post,
) async {
  final t = L10n.of(context);
  final reasons = [
    ('offensive', t.reasonOffensive),
    ('spam', t.reasonSpam),
    ('false', t.reasonFalse),
    ('other', t.reportOther),
  ];
  var reason = reasons.first.$1;
  final note = TextEditingController();
  final send = await showDialog<bool>(
    context: context,
    builder: (d) => StatefulBuilder(
      builder: (d, set) => AlertDialog(
        title: Text(t.reportPostTitle, style: AppText.subtitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioGroup<String>(
                groupValue: reason,
                onChanged: (v) => set(() => reason = v ?? reason),
                child: Column(
                  children: [
                    for (final (id, label) in reasons)
                      RadioListTile<String>(
                        value: id,
                        title: Text(label, style: AppText.body),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: Gap.s),
              TextField(
                controller: note,
                maxLength: 300,
                maxLines: 2,
                decoration: InputDecoration(labelText: t.reportPostNote),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(t.reportSend),
          ),
        ],
      ),
    ),
  );
  final text = note.text.trim();
  // The dialog's text field is still on screen while it animates away.
  Future<void>.delayed(const Duration(seconds: 1), note.dispose);
  if (send != true) return;
  try {
    await ref
        .read(backendProvider)
        .reportContent(
          kind: post.kind,
          masjidId: post.masjidId,
          masjidName: post.masjidName,
          itemId: post.itemId,
          text: post.text,
          authorUid: post.authorUid,
          authorName: post.authorName,
          reason: reason,
          note: text,
        );
    if (context.mounted) toast(context, t.reportPostThanks);
  } catch (_) {
    if (context.mounted) toast(context, t.somethingWrong);
  }
}
