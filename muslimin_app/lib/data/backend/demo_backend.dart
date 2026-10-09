import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;

import '../../core/utils/geo.dart';
import '../models/app_user.dart';
import '../models/channel.dart';
import '../models/hm.dart';
import '../models/masjid.dart';
import '../models/notice.dart';
import '../models/prayer.dart';
import '../models/volunteer.dart';
import 'backend.dart';

/// In-memory backend with realistic seed data. Used automatically when
/// Firebase is not configured, so the whole app (including registration and
/// the admin panel) can be tried on a device right away.
///
/// * Accounts: `demo@muslimin.app` / `demo1234` (owns a masjid) and
///   `admin@muslimin.app` / `admin1234` (super admin). Sign-up works too.
/// * OTP code is always `123456`.
class DemoBackend implements Backend {
  DemoBackend() {
    _seedAround(
      23.7465,
      90.4072,
    ); // Dilu Road, Dhaka – matches the Figma content.
  }

  static const demoOtp = '123456';

  final _masjids = <String, Masjid>{};
  final _notices = <String, Notice>{};

  /// masjidId → uid → member, and masjidId → messages (oldest first).
  final _members = <String, Map<String, ChannelMember>>{};
  final _messages = <String, List<ChannelMessage>>{};

  /// masjidId → uid → editor; reports by id; edits (newest first).
  final _editors = <String, Map<String, MasjidEditor>>{};
  final _reports = <String, MasjidReport>{};
  final _edits = <MasjidEdit>[];
  final _editBlocked = <String>{};
  final _changes = StreamController<void>.broadcast();
  final _auth = StreamController<AppUser?>.broadcast();
  AppUser? _user;
  int _seq = 0;
  final _seededCenters = <(double, double)>[];

  @override
  bool get isDemo => true;

  String _id() => 'demo_${_seq++}';

  void _emit() => _changes.add(null);

  Stream<T> _watch<T>(T Function() compute) async* {
    yield compute();
    await for (final _ in _changes.stream) {
      yield compute();
    }
  }

  // ------------------------------------------------------------------ seed
  void _seedAround(double lat, double lng) {
    if (_seededCenters.any(
      (c) => distanceMeters(c.$1, c.$2, lat, lng) < 5000,
    )) {
      return;
    }
    _seededCenters.add((lat, lng));

    final rnd = math.Random(lat.hashCode ^ lng.hashCode);
    const names = [
      (
        'Diluroad Chhata Masjid',
        '1/A, Dilu Road, New Iskaton',
        'দিলুরোড ছাতা মসজিদ',
      ),
      ('Moghbazar Jame Masjid', 'Moghbazar Main Road', 'মগবাজার জামে মসজিদ'),
      ('Baitul Aman Jame Masjid', 'Road 4, Block C', 'বায়তুল আমান জামে মসজিদ'),
      ('Masjid-e-Noor', 'College Gate', 'মসজিদে নূর'),
      ('Taqwa Masjid', 'Lake Road', 'তাকওয়া মসজিদ'),
      // Beyond the 5 km "nearby" radius – only in View All.
      ('Baitul Falah Masjid', 'Mirpur Road', 'বায়তুল ফালাহ মসজিদ'),
      ('Uttara Central Masjid', 'Sector 7, Uttara', 'উত্তরা কেন্দ্রীয় মসজিদ'),
    ];
    final now = DateTime.now();
    for (var i = 0; i < names.length; i++) {
      final dist = switch (i) {
        5 => 6500.0,
        6 => 12000.0,
        _ => 150.0 + i * 320 + rnd.nextInt(80),
      };
      final bearing = rnd.nextDouble() * 2 * math.pi;
      final dLat = dist * math.cos(bearing) / 111320;
      final dLng =
          dist * math.sin(bearing) / (111320 * math.cos(lat * math.pi / 180));
      final id = _id();
      _masjids[id] = Masjid(
        id: id,
        name: names[i].$1,
        nameBn: names[i].$3,
        address: names[i].$2,
        district: 'Dhaka',
        thana: 'Ramna',
        lat: lat + dLat,
        lng: lng + dLng,
        status: MasjidStatus.approved,
        ownerUid: i == 0 ? 'demo_owner' : 'someone_$i',
        ownerPhone: '+8801730273573',
        nid: '1234567890',
        // Taqwa Masjid: added from the map, no times yet – volunteers fill
        // them in.
        imported: i == 4,
        jamat: i == 4
            ? const {}
            : {
                Prayer.fajr: HM(5, 30 + i * 2),
                Prayer.dhuhr: HM(13, 15 + i * 5),
                Prayer.asr: HM(16, 45 + i * 2),
                Prayer.maghrib: const HM(18, 5),
                Prayer.isha: HM(19, 45 + i * 3),
                Prayer.jumuah: HM(13, 30 + i * 5),
              },
        jamatUpdatedAt: i == 4 ? null : now.subtract(Duration(days: 3 + i * 4)),
        maktab: i.isEven
            ? Maktab(
                days: const [6, 7, 1, 2, 3, 4],
                morning: HMRange(const HM(6, 20), const HM(7, 20)),
                evening: HMRange(const HM(17, 0), const HM(18, 0)),
              )
            : const Maktab(),
        staff: const {
          StaffRole.khatib: StaffMember(
            name: 'Mawlana Sheikh Saiful Islam',
            phone: '+8801730273573',
          ),
          StaffRole.imam: StaffMember(
            name: 'Mawlana Tariqul Islam',
            phone: '+8801730273573',
          ),
          StaffRole.muazzin: StaffMember(
            name: 'Hafez Khalilur Rahman',
            phone: '+8801730273573',
          ),
        },
        isLive: i == 1,
        liveUrl: i == 1 ? 'https://www.youtube.com/' : null,
        createdAt: now.subtract(const Duration(days: 60)),
      );

      if (i == 0) {
        // A channel with its Imam as admin and a few messages.
        final m = _masjids[id]!;
        _members[id] = {
          'demo_imam': ChannelMember(
            uid: 'demo_imam',
            masjidId: id,
            masjidName: m.name,
            name: 'Mawlana Tariqul Islam',
            role: ChannelRole.admin,
            joinedAt: now.subtract(const Duration(days: 30)),
          ),
        };
        _messages[id] = [
          for (final (k, text) in const [
            'Assalamu alaikum. From this Friday, a short talk on the Fard '
                "'Ayn of wudu and salah after Asr, in shaa Allah.",
            "Remember to send salawat on the Prophet ﷺ abundantly on Friday.",
            'Questions about your salah? Find me after Isha, every day.',
          ].indexed)
            ChannelMessage(
              id: _id(),
              masjidId: id,
              masjidName: m.name,
              text: text,
              authorUid: 'demo_imam',
              authorName: 'Mawlana Tariqul Islam',
              authorRole: ChannelRole.admin,
              createdAt: now.subtract(Duration(days: 3 - k, hours: 2)),
            ),
        ];
      }

      if (i == 1) {
        // The demo Google user administers this one, to try roles.
        final m = _masjids[id]!;
        ChannelMember member(String uid, String name, ChannelRole r, int d) =>
            ChannelMember(
              uid: uid,
              masjidId: id,
              masjidName: m.name,
              name: name,
              role: r,
              joinedAt: now.subtract(Duration(days: d)),
            );
        _members[id] = {
          'demo_google': member(
            'demo_google',
            'Google User',
            ChannelRole.admin,
            20,
          ),
          'demo_m1': member('demo_m1', 'Abdul Karim', ChannelRole.editor, 12),
          'demo_m2': member('demo_m2', 'Rafiq Hasan', ChannelRole.member, 5),
        };
      }

      if (i < 3) {
        final m = _masjids[id]!;
        final samples = [
          (NoticeCategory.recruitment, 'Recruitment for Imam Position', 20),
          (NoticeCategory.quran, 'Quran Shikkha (Aged)', 12),
          (NoticeCategory.talim, 'Female Talim', 8),
          (NoticeCategory.mahfil, 'Annual Waz Mahfil', 15),
          (NoticeCategory.general, 'Masjid Cleaning', 2),
        ];
        for (var k = 0; k < 2; k++) {
          final s = samples[(i * 2 + k) % samples.length];
          final nid = _id();
          _notices[nid] = Notice(
            id: nid,
            masjidId: id,
            masjidName: m.name,
            category: s.$1,
            title: s.$2,
            details: '',
            date: now.add(Duration(days: s.$3)),
            time:
                s.$1 == NoticeCategory.mahfil || s.$1 == NoticeCategory.general
                ? '20:00'
                : null,
            createdAt: now.subtract(Duration(days: i * 3 + k)),
          );
        }
      }
    }

    // One pending submission so the admin panel has something to review.
    final pid = _id();
    _masjids[pid] = Masjid(
      id: pid,
      name: 'Shantibagh Jame Masjid',
      address: 'Shantibagh Lane 3',
      district: 'Dhaka',
      thana: 'Paltan',
      lat: lat + 0.004,
      lng: lng - 0.003,
      status: MasjidStatus.pending,
      ownerUid: 'someone_pending',
      ownerPhone: '+8801812345678',
      nid: '19901234567890123',
      submitterRole: SubmitterRole.muazzin,
      locationAccuracyM: 12,
      createdAt: now.subtract(const Duration(hours: 5)),
    );
  }

  // ------------------------------------------------------------------ auth
  /// email -> (password, user). Two accounts are pre-seeded.
  final _accounts = <String, (String, AppUser)>{
    'demo@muslimin.app': (
      'demo1234',
      const AppUser(
        uid: 'demo_owner',
        email: 'demo@muslimin.app',
        name: 'Demo Authority',
        phone: '+8801730273573',
        emailVerified: true,
      ),
    ),
    'admin@muslimin.app': (
      'admin1234',
      const AppUser(
        uid: 'demo_admin',
        email: 'admin@muslimin.app',
        name: 'Muslimin Admin',
        emailVerified: true,
        role: UserRole.superAdmin,
      ),
    ),
  };
  final _follows = <String, Map<String, Map<String, dynamic>>>{};

  void _setUser(AppUser? u) {
    _user = u;
    if (u != null) _accounts[u.email] = (_accounts[u.email]!.$1, u);
    _auth.add(u);
    _emit();
  }

  AppUser _requireUser() => _user ?? (throw BackendException('not-signed-in'));

  @override
  AppUser? get currentUser => _user;

  @override
  Stream<AppUser?> authState() async* {
    yield _user;
    yield* _auth.stream;
  }

  @override
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) {
      throw BackendException('email-already-in-use');
    }
    if (password.length < 6) throw BackendException('weak-password');
    final u = AppUser(uid: _id(), email: key, name: name.trim());
    _accounts[key] = (password, u);
    _setUser(u);
    return u;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final acc = _accounts[email.trim().toLowerCase()];
    if (acc == null || acc.$1 != password) {
      throw BackendException('invalid-credential');
    }
    _setUser(acc.$2);
    return acc.$2;
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    const email = 'google.user@gmail.com';
    _accounts.putIfAbsent(
      email,
      () => (
        '',
        const AppUser(
          uid: 'demo_google',
          email: email,
          name: 'Google User',
          emailVerified: true,
          hasPassword: false,
        ),
      ),
    );
    _setUser(_accounts[email]!.$2);
    return _user;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> sendEmailVerification() async {
    // Demo: verification is instant.
    _setUser(_requireUser().copyWith(emailVerified: true));
  }

  @override
  Future<AppUser?> reloadUser() async => _user;

  @override
  Future<void> updateName(String name) async =>
      _setUser(_requireUser().copyWith(name: name.trim()));

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final u = _requireUser();
    if (_accounts[u.email]!.$1 != currentPassword) {
      throw BackendException('invalid-credential');
    }
    if (newPassword.length < 6) throw BackendException('weak-password');
    _accounts[u.email] = (newPassword, u);
  }

  @override
  Future<void> deleteAccount({String? password}) async {
    final u = _requireUser();
    if (u.hasPassword && _accounts[u.email]!.$1 != password) {
      throw BackendException('invalid-credential');
    }
    _accounts.remove(u.email);
    _follows.remove(u.uid);
    _setUserNull();
  }

  void _setUserNull() {
    _user = null;
    _auth.add(null);
    _emit();
  }

  @override
  Future<void> signOut() async => _setUserNull();

  @override
  Future<String> sendOtp(String phoneE164) async {
    _requireUser();
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return 'demo:$phoneE164';
  }

  @override
  Future<AppUser> verifyOtp(String verificationId, String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (code != demoOtp) throw BackendException('invalid-otp');
    final u = _requireUser().copyWith(phone: verificationId.substring(5));
    _setUser(u);
    return u;
  }

  @override
  Future<void> saveFcmToken(String token) async {}

  @override
  Future<Map<String, Map<String, dynamic>>> loadFollows() async => {
    ...?_follows[_user?.uid],
  };

  @override
  Future<void> saveFollows(Map<String, Map<String, dynamic>> follows) async {
    if (_user != null) _follows[_user!.uid] = {...follows};
  }

  // --------------------------------------------------------------- masjids
  @override
  Stream<List<Masjid>> nearbyMasjids(double lat, double lng, double radiusKm) {
    _seedAround(lat, lng);
    return _watch(() {
      final list =
          _masjids.values
              .where((m) => m.status == MasjidStatus.approved)
              .where(
                (m) =>
                    distanceMeters(lat, lng, m.lat, m.lng) <= radiusKm * 1000,
              )
              .toList()
            ..sort(
              (a, b) => distanceMeters(
                lat,
                lng,
                a.lat,
                a.lng,
              ).compareTo(distanceMeters(lat, lng, b.lat, b.lng)),
            );
      return list;
    });
  }

  @override
  Stream<List<Masjid>> allMasjids(double lat, double lng) => _watch(
    () =>
        _masjids.values.where((m) => m.status == MasjidStatus.approved).toList()
          ..sort(
            (a, b) => distanceMeters(
              lat,
              lng,
              a.lat,
              a.lng,
            ).compareTo(distanceMeters(lat, lng, b.lat, b.lng)),
          ),
  );

  @override
  Future<List<Masjid>> searchMasjids(String prefix, {int limit = 30}) async {
    final q = prefix.trim().toLowerCase();
    return _masjids.values
        .where(
          (m) =>
              m.status == MasjidStatus.approved &&
              m.name.toLowerCase().startsWith(q),
        )
        .take(limit)
        .toList();
  }

  @override
  Stream<Masjid?> watchMasjid(String id) => _watch(() => _masjids[id]);

  @override
  Stream<List<Masjid>> myMasjids(String uid) =>
      _watch(() => _masjids.values.where((m) => m.ownerUid == uid).toList());

  @override
  Future<List<Masjid>> masjidsNear(
    double lat,
    double lng,
    double meters,
  ) async => _masjids.values
      .where((m) => m.status != MasjidStatus.rejected)
      .where((m) => distanceMeters(lat, lng, m.lat, m.lng) <= meters)
      .toList();

  @override
  Future<String> createMasjid(Masjid draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final id = _id();
    _masjids[id] = Masjid.fromMap(
      id,
      draft.toMap(),
      lat: draft.lat,
      lng: draft.lng,
      createdAt: DateTime.now(),
    );
    _emit();
    return id;
  }

  void _patch(String id, Masjid Function(Masjid) f) {
    final m = _masjids[id];
    if (m == null) throw BackendException('not-found');
    _masjids[id] = f(m);
    _emit();
  }

  @override
  Future<void> updateInfo(
    String id, {
    required String name,
    required String nameBn,
    required String district,
    required String thana,
    required String address,
    (double, double, double)? location,
    String? locationSource,
  }) async => _patch(
    id,
    (m) => m.copyWith(
      location: location,
      locationSource: locationSource,
      name: name,
      nameBn: nameBn,
      district: district,
      thana: thana,
      address: address,
    ),
  );

  void _log(
    Masjid m,
    String field,
    Map<String, dynamic> before,
    Map<String, dynamic> after,
  ) {
    final u = _user;
    _edits.insert(
      0,
      MasjidEdit(
        id: _id(),
        masjidId: m.id,
        masjidName: m.name,
        uid: u?.uid ?? '',
        name: u?.displayName ?? '',
        field: field,
        before: before,
        after: after,
        at: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> updateJamat(Masjid m, Map<Prayer, HM> jamat) async {
    _log(m, 'jamat', Masjid.jamatToMap(m.jamat), Masjid.jamatToMap(jamat));
    _patch(
      m.id,
      (x) => Masjid.fromMap(
        x.id,
        {
          ...x.toMap(),
          'jamat': Masjid.jamatToMap(jamat),
          'updatedByName': _user?.displayName ?? '',
          'source': x.imported ? 'osm' : null,
        },
        lat: x.lat,
        lng: x.lng,
        createdAt: x.createdAt,
        jamatUpdatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> updateMaktab(Masjid m, Maktab maktab) async {
    _log(m, 'maktab', m.maktab.toMap(), maktab.toMap());
    _patch(m.id, (x) => x.copyWith(maktab: maktab));
  }

  @override
  Future<void> updateStaff(Masjid m, Map<StaffRole, StaffMember> staff) async {
    _log(m, 'staff', Masjid.staffToMap(m.staff), Masjid.staffToMap(staff));
    _patch(m.id, (x) => x.copyWith(staff: staff));
  }

  @override
  Future<void> updateLive(
    String id, {
    String? url,
    required bool isLive,
  }) async => _patch(id, (m) => m.copyWith(liveUrl: url, isLive: isLive));

  // ----------------------------------------------------------------- admin
  @override
  Stream<List<Masjid>> masjidsByStatus(MasjidStatus status) => _watch(
    () => _masjids.values.where((m) => m.status == status).toList()
      ..sort(
        (a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
      ),
  );

  @override
  Future<void> setStatus(
    String id,
    MasjidStatus status, {
    String? reason,
  }) async => _patch(
    id,
    (m) => m.copyWith(
      status: status,
      rejectionReason: reason,
      reviewedAt: DateTime.now(),
    ),
  );

  // --------------------------------------------------------------- notices
  // ------------------------------------------------------------- channel
  @override
  Stream<ChannelMember?> channelMembership(String masjidId) =>
      _watch(() => _user == null ? null : _members[masjidId]?[_user!.uid]);

  @override
  Stream<List<ChannelMember>> myChannels() => _watch(
    () => [
      if (_user != null)
        for (final m in _members.values) ?m[_user!.uid],
    ],
  );

  @override
  Future<void> joinChannel(Masjid masjid) async {
    final u = _requireUser();
    (_members[masjid.id] ??= {})[u.uid] = ChannelMember(
      uid: u.uid,
      masjidId: masjid.id,
      masjidName: masjid.name,
      name: u.displayName,
      role: ChannelRole.member,
      joinedAt: DateTime.now(),
    );
    _emit();
  }

  @override
  Future<void> leaveChannel(String masjidId) async {
    _members[masjidId]?.remove(_user?.uid);
    _emit();
  }

  @override
  Stream<List<ChannelMember>> channelMembers(String masjidId) => _watch(
    () =>
        (_members[masjidId]?.values.toList() ?? [])
          ..sort((a, b) => a.joinedAt.compareTo(b.joinedAt)),
  );

  @override
  Future<void> setChannelRole(
    String masjidId,
    String uid,
    ChannelRole role,
  ) async {
    final m = _members[masjidId]?[uid];
    if (m != null) _members[masjidId]![uid] = m.copyWith(role: role);
    _emit();
  }

  @override
  Future<void> removeChannelMember(String masjidId, String uid) async {
    _members[masjidId]?.remove(uid);
    _emit();
  }

  @override
  Stream<List<ChannelMessage>> channelMessages(
    String masjidId, {
    int limit = 100,
  }) => _watch(
    () => (_messages[masjidId] ?? const []).reversed.take(limit).toList(),
  );

  /// Attachment bytes by message id.
  final _files = <String, Uint8List>{};

  @override
  Future<void> postChannelMessage(
    Masjid masjid,
    String text,
    ChannelRole as, {
    (String, Uint8List)? file,
  }) async {
    final u = _requireUser();
    final id = _id();
    ChannelAttachment? att;
    if (file != null) {
      _files[id] = file.$2;
      att = ChannelAttachment(
        kind: ChannelAttachment.kindOf(file.$1),
        name: file.$1,
        size: file.$2.length,
        chunks: (file.$2.length / kChunkBytes).ceil(),
      );
    }
    (_messages[masjid.id] ??= []).add(
      ChannelMessage(
        id: id,
        masjidId: masjid.id,
        masjidName: masjid.name,
        text: text,
        authorUid: u.uid,
        authorName: u.displayName,
        authorRole: as,
        createdAt: DateTime.now(),
        attachment: att,
      ),
    );
    _emit();
  }

  @override
  Future<Uint8List> channelAttachment(
    String masjidId,
    String messageId,
    int chunks,
  ) async => _files[messageId] ?? Uint8List(0);

  @override
  Future<void> deleteChannelMessage(String masjidId, String id) async {
    _messages[masjidId]?.removeWhere((m) => m.id == id);
    _emit();
  }

  @override
  Stream<List<Notice>> noticesFor(List<String> masjidIds, {int limit = 30}) =>
      _watch(() {
        final ids = masjidIds.toSet();
        final list =
            _notices.values.where((n) => ids.contains(n.masjidId)).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list.take(limit).toList();
      });

  @override
  Future<void> postNotice(Notice notice) async {
    final id = _id();
    _notices[id] = Notice(
      id: id,
      masjidId: notice.masjidId,
      masjidName: notice.masjidName,
      category: notice.category,
      title: notice.title,
      details: notice.details,
      date: notice.date,
      time: notice.time,
      personName: notice.personName,
      fatherName: notice.fatherName,
      diedOn: notice.diedOn,
      address: notice.address,
      createdAt: DateTime.now(),
    );
    _emit();
  }

  @override
  Future<void> deleteNotice(String id) async {
    _notices.remove(id);
    _emit();
  }

  // ------------------------------------------------------------ volunteers
  @override
  Stream<bool> isMasjidEditor(String masjidId) => _watch(
    () =>
        _user != null && (_editors[masjidId]?.containsKey(_user!.uid) ?? false),
  );

  @override
  Future<void> becomeEditor(Masjid m, double lat, double lng) async {
    final u = _user ?? (throw BackendException('not-signed-in'));
    if (_editBlocked.contains(u.uid)) {
      throw BackendException('permission-denied');
    }
    final d = distanceMeters(lat, lng, m.lat, m.lng);
    if (d > kEditorRadiusM) throw BackendException('too-far');
    await Future<void>.delayed(const Duration(milliseconds: 400));
    (_editors[m.id] ??= {})[u.uid] = MasjidEditor(
      uid: u.uid,
      name: u.displayName,
      masjidId: m.id,
      masjidName: m.name,
      distanceM: d.roundToDouble(),
      createdAt: DateTime.now(),
    );
    _emit();
  }

  @override
  Future<void> leaveEditor(String masjidId) async {
    _editors[masjidId]?.remove(_user?.uid);
    _emit();
  }

  @override
  Stream<List<MasjidEditor>> masjidEditors(String masjidId) =>
      _watch(() => [...?_editors[masjidId]?.values]);

  @override
  Future<void> removeEditor(
    String masjidId,
    String uid, {
    bool block = false,
  }) async {
    _editors[masjidId]?.remove(uid);
    if (block) _editBlocked.add(uid);
    _emit();
  }

  // --------------------------------------------------------------- reports
  @override
  Future<void> reportMasjid(Masjid m, ReportReason reason, String note) async {
    final u = _user ?? (throw BackendException('not-signed-in'));
    final id = MasjidReport.idFor(m.id, u.uid);
    _reports[id] = MasjidReport(
      id: id,
      masjidId: m.id,
      masjidName: m.name,
      district: m.district,
      uid: u.uid,
      userName: u.displayName,
      reason: reason,
      note: note.trim(),
      open: true,
      createdAt: DateTime.now(),
    );
    _emit();
  }

  @override
  Stream<List<MasjidReport>> openReports({int limit = 100}) => _watch(
    () =>
        _reports.values.where((r) => r.open).toList()
          ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!)),
  );

  @override
  Future<void> resolveReport(String id) async {
    final r = _reports[id];
    if (r == null) return;
    _reports[id] = MasjidReport(
      id: r.id,
      masjidId: r.masjidId,
      masjidName: r.masjidName,
      district: r.district,
      uid: r.uid,
      userName: r.userName,
      reason: r.reason,
      note: r.note,
      open: false,
      createdAt: r.createdAt,
    );
    _emit();
  }

  // ----------------------------------------------------------- admin report
  @override
  Stream<List<MasjidEdit>> recentEdits({int limit = 50}) =>
      _watch(() => _edits.take(limit).toList());

  @override
  Future<void> revertEdit(MasjidEdit e) async {
    final m = _masjids[e.masjidId];
    if (m == null) return;
    switch (e.field) {
      case 'jamat':
        await updateJamat(m, Masjid.jamatFromMap(e.before));
      case 'staff':
        await updateStaff(m, Masjid.staffFromMap(e.before));
      case 'maktab':
        await updateMaktab(m, Maktab.fromMap(e.before));
    }
  }

  @override
  Future<AdminStats> adminStats() async {
    final approved = _masjids.values.where(
      (m) => m.status == MasjidStatus.approved,
    );
    return AdminStats(
      masjids: approved.length,
      withTimes: approved.where((m) => m.jamat.isNotEmpty).length,
      editors: _editors.values.fold(0, (a, e) => a + e.length),
      openReports: _reports.values.where((r) => r.open).length,
      pending: _masjids.values
          .where((m) => m.status == MasjidStatus.pending)
          .length,
    );
  }

  @override
  Future<List<DistrictCoverage>> districtCoverage(
    List<String> districts,
  ) async => [
    for (final d in districts)
      (
        district: d,
        masjids: _masjids.values
            .where((m) => m.status == MasjidStatus.approved && m.district == d)
            .length,
        withTimes: _masjids.values
            .where(
              (m) =>
                  m.status == MasjidStatus.approved &&
                  m.district == d &&
                  m.jamat.isNotEmpty,
            )
            .length,
      ),
  ];
}
