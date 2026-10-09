import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/masjid.dart';
import '../data/models/volunteer.dart';
import 'providers.dart';

/// Reads the rules refuse fail for good – no endless retry spinner.
Duration? _noRetry(int count, Object error) => null;

/// Whether I volunteer as an editor of the masjid.
final isEditorProvider = StreamProvider.family<bool, String>((ref, masjidId) {
  ref.watch(authProvider); // re-check after sign-in / sign-out
  return ref.watch(backendProvider).isMasjidEditor(masjidId);
}, retry: _noRetry);

/// Who may change [masjid]'s jamat times, maktab and staff: its owner, the
/// super admin, and its volunteer editors.
final canEditTimesProvider = Provider.family<bool, Masjid>((ref, masjid) {
  final user = ref.watch(authProvider).value;
  if (user == null) return false;
  if (user.uid == masjid.ownerUid || user.isSuperAdmin) return true;
  return masjid.status == MasjidStatus.approved &&
      (ref.watch(isEditorProvider(masjid.id)).value ?? false);
});

final masjidEditorsProvider = StreamProvider.family<List<MasjidEditor>, String>(
  (ref, masjidId) => ref.watch(backendProvider).masjidEditors(masjidId),
  retry: _noRetry,
);

final openReportsProvider = StreamProvider<List<MasjidReport>>(
  (ref) => ref.watch(backendProvider).openReports(),
  retry: _noRetry,
);

final recentEditsProvider = StreamProvider<List<MasjidEdit>>(
  (ref) => ref.watch(backendProvider).recentEdits(),
  retry: _noRetry,
);

final adminStatsProvider = FutureProvider<AdminStats>(
  (ref) => ref.watch(backendProvider).adminStats(),
  retry: _noRetry,
);
