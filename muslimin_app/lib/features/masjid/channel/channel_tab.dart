import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/nav.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/refresh.dart';
import '../../../core/widgets/surfaces.dart';
import '../../../data/models/channel.dart';
import '../../../data/models/masjid.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/channel.dart';
import '../../../state/providers.dart';
import 'attachment_view.dart';
import 'channel_invite_card.dart';

String roleName(L10n t, ChannelRole r) => switch (r) {
  ChannelRole.member => t.roleMember,
  ChannelRole.editor => t.roleEditor,
  ChannelRole.admin => t.roleAdmin,
};

/// Asks, then leaves [masjid]'s channel.
Future<void> leaveChannel(
  BuildContext context,
  WidgetRef ref,
  Masjid masjid,
) async {
  final t = L10n.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (d) => AlertDialog(
      content: Text(t.leaveChannelQ, style: AppText.body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(d, false),
          child: Text(t.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(d, true),
          child: Text(t.leave),
        ),
      ],
    ),
  );
  if (ok != true) return;
  try {
    await ref.read(channelActionsProvider).leave(masjid.id);
  } catch (_) {
    if (context.mounted) toast(context, t.somethingWrong);
  }
}

/// Masjid page → Channel. Non-members see the invitation; members read the
/// messages (newest at the bottom); editors and admins also write.
class MasjidChannelTab extends ConsumerWidget {
  const MasjidChannelTab({super.key, required this.masjid});

  final Masjid masjid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(channelRoleProvider(masjid));
    if (role == null) {
      return RefreshList(
        onRefresh: () => refreshAll(ref),
        padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, Gap.xxl),
        children: [ChannelInviteCard(masjid: masjid, onOpen: () {})],
      );
    }
    return Column(
      children: [
        Expanded(
          child: _Messages(masjid: masjid, role: role),
        ),
        if (role.canPost) _Composer(masjid: masjid, role: role),
      ],
    );
  }
}

class _Messages extends ConsumerWidget {
  const _Messages({required this.masjid, required this.role});

  final Masjid masjid;
  final ChannelRole role;

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    ChannelMessage m,
  ) async {
    final t = L10n.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        content: Text(t.deleteMessageQ, style: AppText.body),
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
    if (ok != true) return;
    try {
      await ref.read(backendProvider).deleteChannelMessage(masjid.id, m.id);
    } catch (_) {
      if (context.mounted) toast(context, t.somethingWrong);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = L10n.of(context);
    final uid = ref.watch(authProvider).value?.uid;
    return ref
        .watch(channelMessagesProvider(masjid.id))
        .when(
          loading: () => const Loader(),
          error: (e, _) => EmptyState(
            message: isPermissionError(e)
                ? t.channelNotAllowed
                : t.somethingWrong,
            icon: Icons.lock_outline_rounded,
          ),
          data: (list) => list.isEmpty
              ? EmptyState(
                  message: role.canPost ? t.channelEmptyAdmin : t.channelEmpty,
                  icon: Icons.forum_outlined,
                )
              : ListView.separated(
                  // Newest at the bottom, like a chat. Scrolls on its own
                  // (a reversed list can't drive the masjid page's scroll).
                  reverse: true,
                  primary: false,
                  padding: const EdgeInsets.all(Gap.l),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: Gap.m),
                  itemBuilder: (_, i) {
                    final m = list[i];
                    final mine = m.authorUid == uid;
                    return _Bubble(
                      message: m,
                      mine: mine,
                      onDelete: role.canManage || mine
                          ? () => _delete(context, ref, m)
                          : null,
                    );
                  },
                ),
        );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.mine, this.onDelete});

  final ChannelMessage message;
  final bool mine;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final now = DateTime.now();
    final sameDay =
        now.year == message.createdAt.year &&
        now.month == message.createdAt.month &&
        now.day == message.createdAt.day;
    return GestureDetector(
      onLongPress: onDelete == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onDelete!();
            },
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(Gap.l, Gap.m, Gap.l, Gap.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    mine ? t.you : message.authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(color: AppColors.gold),
                  ),
                ),
                const SizedBox(width: Gap.s),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                  child: Text(
                    roleName(t, message.authorRole),
                    style: AppText.micro.copyWith(color: AppColors.gold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Gap.xs),
            if (message.attachment != null) ...[
              const SizedBox(height: Gap.xs),
              AttachmentView(masjidId: message.masjidId, m: message),
            ],
            if (message.text.isNotEmpty) ...[
              const SizedBox(height: Gap.xs),
              SelectableText(message.text, style: AppText.body),
            ],
            const SizedBox(height: Gap.xs),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                sameDay
                    ? f.timePeriod(message.createdAt)
                    : '${f.date(message.createdAt)} · '
                          '${f.timePeriod(message.createdAt)}',
                style: AppText.micro.copyWith(color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends ConsumerStatefulWidget {
  const _Composer({required this.masjid, required this.role});

  final Masjid masjid;
  final ChannelRole role;

  @override
  ConsumerState<_Composer> createState() => _ComposerState();
}

/// WhatsApp-style input: a round text field with attach and camera inside,
/// and one round button – send when there is something to send, otherwise a
/// microphone: hold to talk (your words are written out and sent on
/// release), slide left to cancel.
class _ComposerState extends ConsumerState<_Composer> {
  final _text = TextEditingController();
  bool _sending = false;

  /// Picked attachment: (name, bytes).
  (String, Uint8List)? _file;

  final _stt = SpeechToText();
  bool _listening = false;
  String _heard = '';
  double _dragX = 0;

  static const _cancelDrag = -90.0;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _stt.cancel();
    _text.dispose();
    super.dispose();
  }

  bool get _canSend => _text.text.trim().isNotEmpty || _file != null;

  // ------------------------------------------------------------ attach
  Future<void> _attach() async {
    final t = L10n.of(context);
    final pick = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.card,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (k, icon, label) in [
              ('photo', Icons.image_outlined, t.attachPhoto),
              ('camera', Icons.photo_camera_outlined, t.takePhoto),
              ('file', Icons.attach_file_rounded, t.attachAnyFile),
            ])
              ListTile(
                leading: Icon(icon, color: AppColors.gold),
                title: Text(label),
                onTap: () => Navigator.pop(ctx, k),
              ),
          ],
        ),
      ),
    );
    if (pick == 'file') {
      await _pickFile();
    } else if (pick != null) {
      await _pickPhoto(
        pick == 'camera' ? ImageSource.camera : ImageSource.gallery,
      );
    }
  }

  Future<void> _pickPhoto(ImageSource source) async {
    // Photos are shrunk before sending (small, quick to load).
    final x = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 80,
    );
    if (x == null || !mounted) return;
    final ext = x.name.contains('.') ? x.name.split('.').last : 'jpg';
    _setFile((
      'photo_${DateTime.now().millisecondsSinceEpoch}.$ext',
      await x.readAsBytes(),
    ));
  }

  /// Any file: video, audio, PDF, documents…
  Future<void> _pickFile() async {
    final t = L10n.of(context);
    final f = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'any', uniformTypeIdentifiers: ['public.item']),
      ],
    );
    if (f == null || !mounted) return;
    // Check the size before loading a huge file into memory.
    if (await f.length() > kMaxAttachmentBytes) {
      if (mounted) {
        toast(context, t.fileTooLarge(fileSize(kMaxAttachmentBytes)));
      }
      return;
    }
    _setFile((f.name, await f.readAsBytes()));
  }

  void _setFile((String, Uint8List) picked) {
    if (!mounted) return;
    if (picked.$2.length > kMaxAttachmentBytes) {
      toast(
        context,
        L10n.of(context).fileTooLarge(fileSize(kMaxAttachmentBytes)),
      );
      return;
    }
    setState(() => _file = picked);
  }

  // -------------------------------------------------------------- send
  Future<void> _send() async {
    final text = _text.text.trim();
    if ((text.isEmpty && _file == null) || _sending) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(backendProvider)
          .postChannelMessage(widget.masjid, text, widget.role, file: _file);
      _text.clear();
      setState(() => _file = null);
    } catch (e) {
      if (mounted) {
        toast(
          context,
          isPermissionError(e)
              ? L10n.of(context).channelNotAllowed
              : L10n.of(context).somethingWrong,
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  // ------------------------------------------------------- hold to talk
  /// The recognizer's locale for the app language (bn_BD, ar_SA…), when
  /// the phone has it.
  Future<String?> _locale() async {
    final lang = Localizations.localeOf(context).languageCode;
    final all = await _stt.locales();
    for (final l in all) {
      if (l.localeId.toLowerCase().startsWith(lang)) return l.localeId;
    }
    return null;
  }

  Future<void> _startTalk() async {
    final t = L10n.of(context);
    final ok = await _stt.initialize(
      onError: (_) {
        if (mounted && _listening) setState(() => _listening = false);
      },
    );
    if (!mounted) return;
    if (!ok) {
      toast(context, t.speechUnavailable);
      return;
    }
    final locale = await _locale();
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _listening = true;
      _heard = '';
      _dragX = 0;
    });
    await _stt.listen(
      onResult: (r) {
        if (mounted) setState(() => _heard = r.recognizedWords);
      },
      listenOptions: SpeechListenOptions(
        localeId: locale,
        listenMode: ListenMode.dictation,
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  Future<void> _endTalk() async {
    if (!_listening) return;
    final cancel = _dragX < _cancelDrag;
    if (cancel) {
      await _stt.cancel();
    } else {
      await _stt.stop();
      // The last words arrive just after stopping.
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
    if (!mounted) return;
    final words = _heard.trim();
    setState(() => _listening = false);
    if (cancel) return;
    if (words.isEmpty) {
      toast(context, L10n.of(context).speechNothing);
      return;
    }
    // Like typing it: whatever is already in the box stays in front.
    final typed = _text.text.trim();
    _text.text = typed.isEmpty ? words : '$typed $words';
    await _send();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final fieldColor = AppColors.field;
    return Container(
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(
        Gap.s,
        Gap.s,
        Gap.s,
        Gap.s + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_file != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.s, 0, 0, Gap.s),
              child: Row(
                children: [
                  Icon(Icons.attach_file_rounded, color: AppColors.gold),
                  const SizedBox(width: Gap.s),
                  Expanded(
                    child: Text(
                      '${_file!.$1} · ${fileSize(_file!.$2.length)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption,
                    ),
                  ),
                  if (!_sending)
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: AppColors.muted),
                      onPressed: () => setState(() => _file = null),
                    ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  decoration: BoxDecoration(
                    color: fieldColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: _listening
                      ? _Listening(heard: _heard, dragX: _dragX)
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: Gap.l),
                            Expanded(
                              child: TextField(
                                controller: _text,
                                minLines: 1,
                                maxLines: 5,
                                maxLength: kMaxChannelMessage,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: AppText.body,
                                decoration: InputDecoration(
                                  hintText: t.messageHint,
                                  counterText: '',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: t.attach,
                              onPressed: _sending ? null : _attach,
                              icon: Transform.rotate(
                                angle: -0.6,
                                child: Icon(
                                  Icons.attach_file_rounded,
                                  color: AppColors.muted,
                                ),
                              ),
                            ),
                            if (_text.text.isEmpty)
                              IconButton(
                                tooltip: t.takePhoto,
                                onPressed: _sending
                                    ? null
                                    : () => _pickPhoto(ImageSource.camera),
                                icon: Icon(
                                  Icons.photo_camera_outlined,
                                  color: AppColors.muted,
                                ),
                              ),
                          ],
                        ),
                ),
              ),
              const SizedBox(width: 6),
              _canSend || _sending
                  ? _RoundButton(
                      tooltip: t.send,
                      onTap: _sending ? null : _send,
                      child: _sending
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded, color: Colors.white),
                    )
                  : GestureDetector(
                      onTap: () => toast(context, t.holdToTalk),
                      onLongPressStart: (_) => _startTalk(),
                      onLongPressMoveUpdate: (d) => setState(
                        () => _dragX = d.offsetFromOrigin.dx.clamp(-200, 0),
                      ),
                      onLongPressEnd: (_) => _endTalk(),
                      onLongPressCancel: _endTalk,
                      child: AnimatedScale(
                        scale: _listening ? 1.35 : 1,
                        duration: const Duration(milliseconds: 150),
                        child: _RoundButton(
                          tooltip: t.holdToTalk,
                          color: _listening ? AppColors.danger : null,
                          child: const Icon(
                            Icons.mic_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

/// While holding the mic: what has been heard so far, and how to cancel.
class _Listening extends StatelessWidget {
  const _Listening({required this.heard, required this.dragX});

  final String heard;
  final double dragX;

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final cancelling = dragX < _ComposerState._cancelDrag;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.l, vertical: 12),
      child: Row(
        children: [
          Icon(
            cancelling
                ? Icons.delete_outline_rounded
                : Icons.fiber_manual_record,
            size: 16,
            color: AppColors.danger,
          ),
          const SizedBox(width: Gap.s),
          Expanded(
            child: Text(
              heard.isEmpty ? t.listening : heard,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppText.body.copyWith(
                color: heard.isEmpty ? AppColors.muted : AppColors.ink,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(dragX / 3, 0),
            child: Text(
              '‹ ${t.slideToCancel}',
              style: AppText.caption.copyWith(
                color: cancelling ? AppColors.danger : AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.child,
    required this.tooltip,
    this.onTap,
    this.color,
  });

  final Widget child;
  final String tooltip;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Material(
      color: color ?? AppColors.gold,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(dimension: 48, child: Center(child: child)),
      ),
    ),
  );
}
