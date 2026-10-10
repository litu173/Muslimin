import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;

import '../data/models/channel.dart';
import '../data/models/masjid.dart';
import '../data/models/notice.dart';
import 'follows.dart';
import '../services/notification_service.dart';
import 'providers.dart';

/// My membership of a masjid's channel (null = not joined).
final channelMembershipProvider = StreamProvider.family<ChannelMember?, String>(
  (ref, masjidId) {
    ref.watch(authProvider); // re-check after sign-in / sign-out
    return ref.watch(backendProvider).channelMembership(masjidId);
  },
  retry: _noRetry,
);

/// Channel reads fail for good on a permission error; Riverpod's automatic
/// retry would keep the screen on its loading spinner forever.
Duration? _noRetry(int count, Object error) => null;

/// True when Firestore refused the read/write (rules).
bool isPermissionError(Object? e) => '$e'.contains('permission-denied');

/// My role in [masjid]'s channel: the owner and super admins are always
/// admins; otherwise the membership's role; null when not joined.
ProviderListenable<ChannelRole?> channelRoleProvider(Masjid masjid) =>
    _channelRole((masjid.id, masjid.ownerUid));

/// Keyed by (masjid id, owner uid) – records compare by value, so masjid
/// updates reuse the same entry.
final _channelRole = Provider.family<ChannelRole?, (String, String)>((
  ref,
  key,
) {
  final (masjidId, ownerUid) = key;
  final user = ref.watch(authProvider).value;
  if (user == null) return null;
  if (user.uid == ownerUid || user.isSuperAdmin) return ChannelRole.admin;
  return ref.watch(channelMembershipProvider(masjidId)).value?.role;
});

/// Re-opened whenever my membership changes (joined, left, new role), so a
/// refused read from before joining doesn't stick.
final channelMessagesProvider =
    StreamProvider.family<List<ChannelMessage>, String>((ref, masjidId) {
      ref.watch(
        channelMembershipProvider(masjidId)
            .select((m) => m.value?.role.name ?? (m.isLoading ? '…' : '')),
      );
      return ref.watch(backendProvider).channelMessages(masjidId);
    }, retry: _retryRefused);

/// A read refused right after joining (the server not caught up yet): try
/// again a few times; other errors fail straight away.
Duration? _retryRefused(int count, Object error) =>
    isPermissionError(error) && count < 3
    ? Duration(seconds: 1 + count * 2)
    : null;

final channelMembersProvider =
    StreamProvider.family<List<ChannelMember>, String>(
      (ref, masjidId) => ref.watch(backendProvider).channelMembers(masjidId),
      retry: _noRetry,
    );

/// Channels I joined.
final myChannelsProvider = StreamProvider<List<ChannelMember>>((ref) {
  ref.watch(authProvider);
  return ref.watch(backendProvider).myChannels();
});

/// Messages from every channel I joined, newest first (notifications inbox).
final channelInboxProvider = Provider<List<ChannelMessage>>((ref) {
  final channels = ref.watch(myChannelsProvider).value ?? const [];
  final uid = ref.watch(authProvider).value?.uid;
  return [
      for (final c in channels)
        ...?ref.watch(channelMessagesProvider(c.masjidId)).value,
    ].where((m) => m.authorUid != uid).toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

/// Joins / leaves a channel, keeping the push topic in step.
class ChannelActions {
  ChannelActions(this.ref);
  final Ref ref;

  Future<void> join(Masjid m) async {
    await ref.read(backendProvider).joinChannel(m);
    await ref.read(pushProvider).joinChannel(m.id);
  }

  Future<void> leave(String masjidId) async {
    await ref.read(backendProvider).leaveChannel(masjidId);
    await ref.read(pushProvider).leaveChannel(masjidId);
  }
}

final channelActionsProvider = Provider(ChannelActions.new);

/// While the app is open (or recently in the background), shows a phone
/// notification for each new channel message. Push for a closed app comes
/// from the `onChannelMessage` Cloud Function once it is deployed.
final channelNotifierProvider = Provider<void>((ref) {
  final prefs = ref.read(prefsProvider);
  ref.listen(channelInboxProvider, (prev, next) {
    if (next.isEmpty) return;
    final seen = prefs.channelSeenAt;
    // First load after install: don't flood with old messages.
    if (seen == 0) {
      prefs.channelSeenAt = next.first.createdAt.millisecondsSinceEpoch;
      return;
    }
    final fresh = next
        .where((m) => m.createdAt.millisecondsSinceEpoch > seen)
        .toList();
    if (fresh.isEmpty) return;
    prefs.channelSeenAt = fresh.first.createdAt.millisecondsSinceEpoch;
    for (final m in fresh.reversed.take(3)) {
      NotificationService.instance.show(
        m.id.hashCode,
        '${m.masjidName} · ${m.authorName}',
        m.text,
        payload: 'masjid:${m.masjidId}',
      );
    }
  }, fireImmediately: true);
});

// ------------------------------------------------------------------- inbox
/// Notices from the masjids I follow, newest first.
final followedNoticesProvider = Provider<List<Notice>>((ref) {
  final ids = ref.watch(followsProvider).keys;
  if (ids.isEmpty) return const [];
  return ref.watch(noticesProvider(noticeKey(ids))).value ?? const [];
});

/// When the notifications page was last opened.
final inboxOpenedProvider = NotifierProvider<InboxOpened, int>(InboxOpened.new);

class InboxOpened extends Notifier<int> {
  @override
  int build() {
    final p = ref.read(prefsProvider);
    // First run: older items are not "new".
    if (p.inboxOpenedAt == 0) {
      p.inboxOpenedAt = DateTime.now().millisecondsSinceEpoch;
    }
    return p.inboxOpenedAt;
  }

  void markRead() {
    final now = DateTime.now().millisecondsSinceEpoch;
    ref.read(prefsProvider).inboxOpenedAt = now;
    state = now;
  }
}

/// The number on the bell: notices and channel messages since the
/// notifications page was last opened.
final unreadCountProvider = Provider<int>((ref) {
  final since = ref.watch(inboxOpenedProvider);
  bool fresh(DateTime d) => d.millisecondsSinceEpoch > since;
  return ref
          .watch(followedNoticesProvider)
          .where((n) => fresh(n.createdAt))
          .length +
      ref.watch(channelInboxProvider).where((m) => fresh(m.createdAt)).length;
});

/// While the app is open (or kept alive in the background): a phone
/// notification for each new notice from a followed masjid – and the
/// channel topics re-subscribed (new phone, reinstall).
final noticeNotifierProvider = Provider<void>((ref) {
  final prefs = ref.read(prefsProvider);
  ref.listen(followedNoticesProvider, (prev, next) {
    if (next.isEmpty) return;
    final seen = prefs.noticeSeenAt;
    if (seen == 0) {
      prefs.noticeSeenAt = next.first.createdAt.millisecondsSinceEpoch;
      return;
    }
    final fresh = next
        .where((n) => n.createdAt.millisecondsSinceEpoch > seen)
        .toList();
    if (fresh.isEmpty) return;
    prefs.noticeSeenAt = fresh.first.createdAt.millisecondsSinceEpoch;
    for (final n in fresh.reversed.take(3)) {
      NotificationService.instance.show(
        n.id.hashCode,
        n.masjidName,
        n.title,
        payload: 'masjid:${n.masjidId}',
      );
    }
  }, fireImmediately: true);
  ref.listen(myChannelsProvider, (prev, next) {
    for (final c in next.value ?? const <ChannelMember>[]) {
      ref.read(pushProvider).joinChannel(c.masjidId);
    }
  }, fireImmediately: true);
});
