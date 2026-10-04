import 'dart:async';
import 'dart:math' as math;

import '../../core/utils/geo.dart';
import '../models/app_user.dart';
import '../models/hm.dart';
import '../models/masjid.dart';
import '../models/notice.dart';
import '../models/prayer.dart';
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
    ];
    final now = DateTime.now();
    for (var i = 0; i < names.length; i++) {
      final dist = 150.0 + i * 320 + rnd.nextInt(80);
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
        jamat: {
          Prayer.fajr: HM(5, 30 + i * 2),
          Prayer.dhuhr: HM(13, 15 + i * 5),
          Prayer.asr: HM(16, 45 + i * 2),
          Prayer.maghrib: const HM(18, 5),
          Prayer.isha: HM(19, 45 + i * 3),
          Prayer.jumuah: HM(13, 30 + i * 5),
        },
        jamatUpdatedAt: now.subtract(Duration(days: 3 + i * 4)),
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

  @override
  Future<void> updateJamat(String id, Map<Prayer, HM> jamat) async => _patch(
    id,
    (m) => m.copyWith(jamat: jamat, jamatUpdatedAt: DateTime.now()),
  );

  @override
  Future<void> updateMaktab(String id, Maktab maktab) async =>
      _patch(id, (m) => m.copyWith(maktab: maktab));

  @override
  Future<void> updateStaff(
    String id,
    Map<StaffRole, StaffMember> staff,
  ) async => _patch(id, (m) => m.copyWith(staff: staff));

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
}
