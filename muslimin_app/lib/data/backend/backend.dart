import '../models/app_user.dart';
import '../models/channel.dart';
import '../models/hm.dart';
import '../models/masjid.dart';
import '../models/notice.dart';
import '../models/prayer.dart';

class BackendException implements Exception {
  BackendException(this.code, [this.message]);

  /// Machine readable: `invalid-otp`, `duplicate`, `limit`, `network`, …
  final String code;
  final String? message;

  @override
  String toString() => 'BackendException($code, $message)';
}

/// Everything the UI needs from the server. Two implementations exist:
/// [FirebaseBackend] for production and [DemoBackend] (in-memory, seeded)
/// so the app runs before Firebase has been configured.
abstract class Backend {
  bool get isDemo;

  // ---- Accounts (email + password) ----
  Stream<AppUser?> authState();
  AppUser? get currentUser;

  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<AppUser> signIn({required String email, required String password});

  /// Google sign-in. Returns null when the user closes the Google sheet.
  Future<AppUser?> signInWithGoogle();
  Future<void> sendPasswordReset(String email);
  Future<void> sendEmailVerification();

  /// Re-reads the account (e.g. after the user clicked the verification link).
  Future<AppUser?> reloadUser();
  Future<void> updateName(String name);
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Permanently deletes the account and its profile document (required by
  /// App Store & Play policies).
  /// [password] is null for Google-only accounts (they re-confirm with Google).
  Future<void> deleteAccount({String? password});
  Future<void> signOut();

  // ---- Phone verification (masjid authorities) ----
  /// Sends an OTP to [phoneE164] (e.g. +8801XXXXXXXXX). Returns a verification id,
  /// or `auto` when Android verified the SMS by itself.
  Future<String> sendOtp(String phoneE164);

  /// Verifies the OTP and links the phone number to the signed-in account.
  Future<AppUser> verifyOtp(String verificationId, String code);

  // ---- Per-user data synced to the database ----
  Future<void> saveFcmToken(String token);

  /// Followed masjids: id -> {name, reminder}.
  Future<Map<String, Map<String, dynamic>>> loadFollows();
  Future<void> saveFollows(Map<String, Map<String, dynamic>> follows);

  // ---- Masjids ----
  /// Approved masjids within [radiusKm] of the point.
  Stream<List<Masjid>> nearbyMasjids(double lat, double lng, double radiusKm);

  /// Every approved masjid, nearest to the point first ("View All").
  Stream<List<Masjid>> allMasjids(double lat, double lng);
  Stream<Masjid?> watchMasjid(String id);
  Stream<List<Masjid>> myMasjids(String uid);

  /// Masjids already registered within [meters] of the point (any status).
  Future<List<Masjid>> masjidsNear(double lat, double lng, double meters);

  /// Creates a masjid profile in `pending` state and returns its id.
  Future<String> createMasjid(Masjid draft);

  /// Name, Bangla name and address details given at registration.
  Future<void> updateInfo(
    String id, {
    required String name,
    required String nameBn,
    required String district,
    required String thana,
    required String address,

    /// New GPS fix (lat, lng, accuracy in m); null keeps the location.
    (double, double, double)? location,
    String? locationSource,
  });
  Future<void> updateJamat(String id, Map<Prayer, HM> jamat);
  Future<void> updateMaktab(String id, Maktab maktab);
  Future<void> updateStaff(String id, Map<StaffRole, StaffMember> staff);
  Future<void> updateLive(String id, {String? url, required bool isLive});

  // ---- Admin ----
  Stream<List<Masjid>> masjidsByStatus(MasjidStatus status);
  Future<void> setStatus(String id, MasjidStatus status, {String? reason});

  // ---- Notices ----
  Stream<List<Notice>> noticesFor(List<String> masjidIds, {int limit = 30});
  Future<void> postNotice(Notice notice);
  Future<void> deleteNotice(String id);

  // ---- Masjid channel ----
  /// My membership of a masjid's channel; null when not joined.
  Stream<ChannelMember?> channelMembership(String masjidId);

  /// Every channel I joined (for the notifications inbox).
  Stream<List<ChannelMember>> myChannels();
  Future<void> joinChannel(Masjid masjid);
  Future<void> leaveChannel(String masjidId);

  /// All members – channel admins only.
  Stream<List<ChannelMember>> channelMembers(String masjidId);
  Future<void> setChannelRole(String masjidId, String uid, ChannelRole role);
  Future<void> removeChannelMember(String masjidId, String uid);

  /// Newest first.
  Stream<List<ChannelMessage>> channelMessages(
    String masjidId, {
    int limit = 100,
  });
  Future<void> postChannelMessage(Masjid masjid, String text, ChannelRole as);
  Future<void> deleteChannelMessage(String masjidId, String id);
}

/// Max masjid profiles a single phone number may own.
const kMaxMasjidsPerUser = 3;

/// Required GPS accuracy (metres) while registering a masjid.
const kRequiredAccuracyM = 50.0;

/// Any existing masjid closer than this is treated as a potential duplicate.
const kDuplicateRadiusM = 40.0;
