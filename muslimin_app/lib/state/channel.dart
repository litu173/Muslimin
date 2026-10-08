import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;

import '../data/models/channel.dart';
import '../data/models/masjid.dart';
import '../services/notification_service.dart';
import 'providers.dart';

/// My membership of a masjid's channel (null = not joined).
final channelMembershipProvider = StreamProvider.family<ChannelMember?, String>(
  (ref, masjidId) {
    ref.watch(authProvider); // re-check after sign-in / sign-out
    return ref.watch(backendProvider).channelMembership(masjidId);
  },
);

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

final channelMessagesProvider =
    StreamProvider.family<List<ChannelMessage>, String>(
      (ref, masjidId) => ref.watch(backendProvider).channelMessages(masjidId),
    );

final channelMembersProvider =
    StreamProvider.family<List<ChannelMember>, String>(
      (ref, masjidId) => ref.watch(backendProvider).channelMembers(masjidId),
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
