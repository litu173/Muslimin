/// Set by the super admin in the admin website.
///  * superAdmin / admin – manage everything in the app (and the website)
///  * editor – edits times, maktab, staff and location of any masjid
///  * volunteer – may volunteer for any masjid, near or far
enum UserRole { user, volunteer, editor, admin, superAdmin }

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    this.name = '',
    this.phone = '',
    this.emailVerified = false,
    this.role = UserRole.user,
    this.hasPassword = true,
  });

  final String uid;
  final String email;
  final String name;

  /// Verified phone (E.164). Empty until the user verifies it with an OTP –
  /// required before registering a masjid.
  final String phone;
  final bool emailVerified;
  final UserRole role;

  /// False for accounts that only sign in with Google (no password to change).
  final bool hasPassword;

  bool get isSuperAdmin => role == UserRole.superAdmin;

  /// Admin or super admin: approve masjids, manage any masjid.
  bool get isAdmin => role == UserRole.admin || role == UserRole.superAdmin;

  /// May edit times, maktab, staff and location of any masjid.
  bool get isGlobalEditor => isAdmin || role == UserRole.editor;

  /// May volunteer for a masjid without being near it.
  bool get isTrustedVolunteer => role == UserRole.volunteer;
  bool get hasPhone => phone.isNotEmpty;

  String get displayName =>
      name.trim().isNotEmpty ? name : email.split('@').first;

  AppUser copyWith({String? name, String? phone, bool? emailVerified}) =>
      AppUser(
        uid: uid,
        email: email,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        emailVerified: emailVerified ?? this.emailVerified,
        role: role,
        hasPassword: hasPassword,
      );
}
