import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../core/utils/geo.dart';
import '../../firebase_options.dart';
import '../models/app_user.dart';
import '../models/channel.dart';
import '../models/hm.dart';
import '../models/masjid.dart';
import '../models/notice.dart';
import '../models/prayer.dart';
import 'backend.dart';

/// Production backend: Firebase Auth (email/password + phone OTP) + Cloud Firestore.
/// Security is enforced server-side by `firebase/firestore.rules`.
class FirebaseBackend implements Backend {
  FirebaseBackend() {
    _authSub = _auth.authStateChanges().listen(_onAuth);
  }

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _users = StreamController<AppUser?>.broadcast();
  late final StreamSubscription<User?> _authSub;
  AppUser? _current;

  CollectionReference<Map<String, dynamic>> get _masjids =>
      _db.collection('masjids');
  CollectionReference<Map<String, dynamic>> get _notices =>
      _db.collection('notices');

  @override
  bool get isDemo => false;

  // ------------------------------------------------------------------ auth
  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  Future<void> _onAuth(User? u) async {
    if (u == null) {
      _current = null;
      _users.add(null);
      return;
    }
    try {
      final ref = _userDoc(u.uid);
      var snap = await ref.get();
      if (!snap.exists) {
        await ref.set({
          'name': u.displayName ?? '',
          'email': u.email,
          'phone': u.phoneNumber ?? '',
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
        snap = await ref.get();
      }
      _current = _map(u, snap.data());
    } catch (_) {
      _current = _map(u, null);
    }
    _users.add(_current);
  }

  AppUser _map(User u, Map<String, dynamic>? doc) => AppUser(
    uid: u.uid,
    email: u.email ?? '',
    name: (doc?['name'] as String?)?.isNotEmpty == true
        ? doc!['name'] as String
        : (u.displayName ?? ''),
    phone: u.phoneNumber ?? '',
    emailVerified: u.emailVerified,
    role: doc?['role'] == 'superAdmin' ? UserRole.superAdmin : UserRole.user,
    hasPassword: u.providerData.any((p) => p.providerId == 'password'),
  );

  /// Firebase error code -> our code (the UI localises these).
  Future<T> _guard<T>(Future<T> Function() f) async {
    try {
      return await f();
    } on FirebaseAuthException catch (e) {
      final code = switch (e.code) {
        'wrong-password' ||
        'user-not-found' ||
        'invalid-login-credentials' => 'invalid-credential',
        'invalid-verification-code' => 'invalid-otp',
        _ => e.code,
      };
      throw BackendException(code, e.message);
    } on FirebaseException catch (e) {
      throw BackendException(e.code, e.message);
    }
  }

  Future<AppUser> _waitForUser() async {
    final user =
        _current ??
        await _users.stream
            .firstWhere((u) => u != null)
            .timeout(const Duration(seconds: 15), onTimeout: () => _current);
    if (user == null) throw BackendException('auth-failed');
    return user;
  }

  @override
  AppUser? get currentUser => _current;

  @override
  Stream<AppUser?> authState() async* {
    // A stored session is still being restored: wait for it instead of
    // briefly reporting "signed out".
    if (!(_auth.currentUser != null && _current == null)) yield _current;
    yield* _users.stream;
  }

  @override
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) => _guard(() async {
    _current = null;
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user!.updateDisplayName(name.trim());
    await _onAuth(
      _auth.currentUser,
    ); // creates users/{uid} if it doesn't exist yet
    await _userDoc(cred.user!.uid)
        .set({'name': name.trim()}, SetOptions(merge: true));
    await cred.user!.sendEmailVerification();
    await _onAuth(_auth.currentUser);
    return _current!;
  });

  @override
  Future<AppUser> signIn({required String email, required String password}) =>
      _guard(() async {
        _current = null;
        await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        return _waitForUser();
      });

  /// OAuth "Web client" from google-services.json – Google must issue the
  /// ID token for this audience so Firebase accepts it.
  static const _googleServerClientId =
      '171155844004-vtfmadmt5ugcg5cpun4dtu5nlubp3ics.apps.googleusercontent.com';
  bool _googleReady = false;

  Future<OAuthCredential?> _googleCredential() async {
    final gs = GoogleSignIn.instance;
    if (!_googleReady) {
      await gs.initialize(
        clientId: defaultTargetPlatform == TargetPlatform.iOS
            ? DefaultFirebaseOptions.ios.iosClientId
            : null,
        serverClientId: _googleServerClientId,
      );
      _googleReady = true;
    }
    try {
      final account = await gs.authenticate();
      return GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      throw BackendException('google-failed', e.description);
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() => _guard(() async {
    _current = null;
    if (kIsWeb) {
      await _auth.signInWithPopup(GoogleAuthProvider());
      return _waitForUser();
    }
    final cred = await _googleCredential();
    if (cred == null) return null;
    await _auth.signInWithCredential(cred);
    return _waitForUser();
  });

  @override
  Future<void> sendPasswordReset(String email) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));

  @override
  Future<void> sendEmailVerification() =>
      _guard(() async => _auth.currentUser?.sendEmailVerification());

  @override
  Future<AppUser?> reloadUser() => _guard(() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    await u.reload();
    await _onAuth(_auth.currentUser);
    return _current;
  });

  @override
  Future<void> updateName(String name) => _guard(() async {
    final u = _auth.currentUser!;
    await u.updateDisplayName(name.trim());
    await _userDoc(u.uid).update({'name': name.trim()});
    await _onAuth(u);
  });

  Future<void> _reauth(String password) async {
    final u = _auth.currentUser!;
    await u.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: u.email!, password: password),
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => _guard(() async {
    await _reauth(currentPassword);
    await _auth.currentUser!.updatePassword(newPassword);
  });

  @override
  Future<void> deleteAccount({String? password}) => _guard(() async {
    if (password != null) {
      await _reauth(password);
    } else {
      final cred = await _googleCredential();
      if (cred == null) throw BackendException('cancelled');
      await _auth.currentUser!.reauthenticateWithCredential(cred);
    }
    final u = _auth.currentUser!;
    await _userDoc(u.uid).delete();
    await u.delete();
  });

  @override
  Future<void> signOut() async {
    if (_googleReady) await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  @override
  Future<String> sendOtp(String phoneE164) {
    final c = Completer<String>();
    _auth.verifyPhoneNumber(
      phoneNumber: phoneE164,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (cred) async {
        // Android instant verification / auto-retrieval.
        try {
          await _linkPhone(cred);
          if (!c.isCompleted) c.complete('auto');
        } catch (e) {
          if (!c.isCompleted) c.completeError(e);
        }
      },
      verificationFailed: (e) {
        if (!c.isCompleted) {
          c.completeError(BackendException(e.code, e.message));
        }
      },
      codeSent: (id, _) {
        if (!c.isCompleted) c.complete(id);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
    return c.future;
  }

  Future<void> _linkPhone(PhoneAuthCredential cred) => _guard(() async {
    final u = _auth.currentUser;
    if (u == null) throw BackendException('not-signed-in');
    if (u.phoneNumber == null || u.phoneNumber!.isEmpty) {
      await u.linkWithCredential(cred);
    } else {
      await u.updatePhoneNumber(cred);
    }
    // Refresh the ID token so security rules see `phone_number`.
    await _auth.currentUser!.getIdToken(true);
    await _userDoc(u.uid).update({'phone': _auth.currentUser!.phoneNumber});
    await _onAuth(_auth.currentUser);
  });

  @override
  Future<AppUser> verifyOtp(String verificationId, String code) async {
    if (verificationId != 'auto') {
      await _linkPhone(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: code,
        ),
      );
    }
    return _waitForUser();
  }

  @override
  Future<void> saveFcmToken(String token) async {
    final u = _auth.currentUser;
    if (u == null) return;
    await _userDoc(u.uid).set({
      'fcmTokens': FieldValue.arrayUnion([token]),
    }, SetOptions(merge: true));
  }

  @override
  Future<Map<String, Map<String, dynamic>>> loadFollows() async {
    final u = _auth.currentUser;
    if (u == null) return {};
    final raw = (await _userDoc(u.uid).get()).data()?['follows'];
    if (raw is! Map) return {};
    return raw.map(
      (k, v) => MapEntry(k as String, Map<String, dynamic>.from(v as Map)),
    );
  }

  @override
  Future<void> saveFollows(Map<String, Map<String, dynamic>> follows) async {
    final u = _auth.currentUser;
    if (u == null) return;
    await _userDoc(u.uid).set({'follows': follows}, SetOptions(merge: true));
  }

  // --------------------------------------------------------------- masjids
  static DateTime? _ts(Object? v) => v is Timestamp ? v.toDate() : null;

  static Masjid _masjid(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const <String, dynamic>{};
    final gp = (m['geo'] as Map?)?['geopoint'] as GeoPoint?;
    return Masjid.fromMap(
      d.id,
      m,
      lat: gp?.latitude ?? 0,
      lng: gp?.longitude ?? 0,
      createdAt: _ts(m['createdAt']),
      jamatUpdatedAt: _ts(m['jamatUpdatedAt']),
      reviewedAt: _ts(m['reviewedAt']),
    );
  }

  static GeoPoint _geopointFrom(Map<String, dynamic> data) =>
      (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

  @override
  Stream<List<Masjid>> allMasjids(double lat, double lng) => _masjids
      .where('status', isEqualTo: MasjidStatus.approved.name)
      .limit(1000)
      .snapshots()
      .map(
        (s) => s.docs.map(_masjid).toList()
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
  Stream<List<Masjid>> nearbyMasjids(double lat, double lng, double radiusKm) {
    return GeoCollectionReference<Map<String, dynamic>>(_masjids)
        .subscribeWithin(
          center: GeoFirePoint(GeoPoint(lat, lng)),
          radiusInKm: radiusKm,
          field: 'geo',
          geopointFrom: _geopointFrom,
          queryBuilder: (q) =>
              q.where('status', isEqualTo: MasjidStatus.approved.name),
          strictMode: true,
        )
        .map((docs) {
          final list = docs.map(_masjid).toList()
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
  Stream<Masjid?> watchMasjid(String id) =>
      _masjids.doc(id).snapshots().map((d) => d.exists ? _masjid(d) : null);

  @override
  Stream<List<Masjid>> myMasjids(String uid) => _masjids
      .where('ownerUid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(_masjid).toList());

  @override
  Future<List<Masjid>> masjidsNear(
    double lat,
    double lng,
    double meters,
  ) async {
    // Only approved masjids are readable by non-admins; that is what matters
    // for duplicate detection. The admin double-checks pending ones.
    final docs = await GeoCollectionReference<Map<String, dynamic>>(_masjids)
        .fetchWithin(
          center: GeoFirePoint(GeoPoint(lat, lng)),
          radiusInKm: meters / 1000,
          field: 'geo',
          geopointFrom: _geopointFrom,
          queryBuilder: (q) =>
              q.where('status', isEqualTo: MasjidStatus.approved.name),
          strictMode: true,
        );
    return docs.map(_masjid).toList();
  }

  @override
  Future<String> createMasjid(Masjid draft) async {
    final mine = await _masjids
        .where('ownerUid', isEqualTo: draft.ownerUid)
        .get();
    if (mine.size >= kMaxMasjidsPerUser) throw BackendException('limit');
    final ref = _masjids.doc();
    await ref.set({
      ...draft.toMap(),
      'geo': GeoFirePoint(GeoPoint(draft.lat, draft.lng)).data,
      'createdAt': FieldValue.serverTimestamp(),
      'jamatUpdatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
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
  }) => _masjids.doc(id).update({
    if (location != null) ...{
      'geo': GeoFirePoint(GeoPoint(location.$1, location.$2)).data,
      'locationAccuracyM': location.$3,
      'locationSource': locationSource ?? 'gps',
    },
    'name': name,
    'nameLower': name.toLowerCase(),
    'nameBn': nameBn,
    'district': district,
    'thana': thana,
    'address': address,
  });

  @override
  Future<void> updateJamat(String id, Map<Prayer, HM> jamat) =>
      _masjids.doc(id).update({
        'jamat': Masjid.jamatToMap(jamat),
        'jamatUpdatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> updateMaktab(String id, Maktab maktab) =>
      _masjids.doc(id).update({'maktab': maktab.toMap()});

  @override
  Future<void> updateStaff(String id, Map<StaffRole, StaffMember> staff) =>
      _masjids.doc(id).update({'staff': Masjid.staffToMap(staff)});

  @override
  Future<void> updateLive(String id, {String? url, required bool isLive}) =>
      _masjids.doc(id).update({'liveUrl': url, 'isLive': isLive});

  // ----------------------------------------------------------------- admin
  @override
  Stream<List<Masjid>> masjidsByStatus(MasjidStatus status) => _masjids
      .where('status', isEqualTo: status.name)
      .orderBy('createdAt', descending: true)
      .limit(200)
      .snapshots()
      .map((s) => s.docs.map(_masjid).toList());

  @override
  Future<void> setStatus(String id, MasjidStatus status, {String? reason}) =>
      _masjids.doc(id).update({
        'status': status.name,
        'rejectionReason': reason,
        'reviewedBy': _auth.currentUser?.uid,
        'reviewedAt': FieldValue.serverTimestamp(),
      });

  // --------------------------------------------------------------- notices
  static Notice _notice(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const <String, dynamic>{};
    return Notice.fromMap(
      d.id,
      m,
      createdAt: _ts(m['createdAt']) ?? DateTime.now(),
      date: _ts(m['date']),
      diedOn: _ts(m['diedOn']),
    );
  }

  @override
  Stream<List<Notice>> noticesFor(List<String> masjidIds, {int limit = 30}) {
    if (masjidIds.isEmpty) return Stream.value(const []);
    // Firestore `whereIn` accepts at most 30 values.
    final ids = masjidIds.take(30).toList();
    return _notices
        .where('masjidId', whereIn: ids)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map(_notice).toList());
  }

  @override
  Future<void> postNotice(Notice notice) => _notices.add({
    ...notice.toMap(),
    'date': notice.date == null ? null : Timestamp.fromDate(notice.date!),
    'diedOn': notice.diedOn == null ? null : Timestamp.fromDate(notice.diedOn!),
    'createdAt': FieldValue.serverTimestamp(),
    'authorUid': _auth.currentUser?.uid,
  });

  @override
  Future<void> deleteNotice(String id) => _notices.doc(id).delete();

  // ------------------------------------------------------------- channel
  AppUser _requireUser() =>
      _current ?? (throw BackendException('not-signed-in'));

  CollectionReference<Map<String, dynamic>> _members(String masjidId) =>
      _masjids.doc(masjidId).collection('members');
  CollectionReference<Map<String, dynamic>> _messages(String masjidId) =>
      _masjids.doc(masjidId).collection('messages');

  /// Server time, or now while the write is still pending.
  static DateTime _tsNow(Object? v) => _ts(v) ?? DateTime.now();

  static ChannelMember _member(DocumentSnapshot<Map<String, dynamic>> d) =>
      ChannelMember.fromMap(d.data()!, _tsNow(d.data()!['joinedAt']));

  @override
  Stream<ChannelMember?> channelMembership(String masjidId) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);
    return _members(masjidId)
        .doc(uid)
        .snapshots()
        .map((d) => d.exists ? _member(d) : null);
  }

  @override
  Stream<List<ChannelMember>> myChannels() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const []);
    return _db
        .collectionGroup('members')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((s) => s.docs.map(_member).toList());
  }

  @override
  Future<void> joinChannel(Masjid masjid) async {
    final u = _requireUser();
    await _members(masjid.id).doc(u.uid).set({
      ...ChannelMember(
        uid: u.uid,
        masjidId: masjid.id,
        masjidName: masjid.name,
        name: u.displayName,
        role: ChannelRole.member,
        joinedAt: DateTime.now(),
      ).toMap(),
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> leaveChannel(String masjidId) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) await _members(masjidId).doc(uid).delete();
  }

  @override
  Stream<List<ChannelMember>> channelMembers(String masjidId) =>
      _members(masjidId)
          .orderBy('joinedAt')
          .snapshots()
          .map((s) => s.docs.map(_member).toList());

  @override
  Future<void> setChannelRole(String masjidId, String uid, ChannelRole role) =>
      _members(masjidId).doc(uid).update({'role': role.name});

  @override
  Future<void> removeChannelMember(String masjidId, String uid) =>
      _members(masjidId).doc(uid).delete();

  @override
  Stream<List<ChannelMessage>> channelMessages(
    String masjidId, {
    int limit = 100,
  }) => _messages(masjidId)
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .snapshots()
      .map(
        (s) => [
          for (final d in s.docs)
            ChannelMessage.fromMap(
              d.id,
              d.data(),
              _tsNow(d.data()['createdAt']),
            ),
        ],
      );

  @override
  Future<void> postChannelMessage(
    Masjid masjid,
    String text,
    ChannelRole as,
  ) async {
    final u = _requireUser();
    await _messages(masjid.id).add({
      ...ChannelMessage(
        id: '',
        masjidId: masjid.id,
        masjidName: masjid.name,
        text: text,
        authorUid: u.uid,
        authorName: u.displayName,
        authorRole: as,
        createdAt: DateTime.now(),
      ).toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteChannelMessage(String masjidId, String id) =>
      _messages(masjidId).doc(id).delete();

  void dispose() => _authSub.cancel();
}
