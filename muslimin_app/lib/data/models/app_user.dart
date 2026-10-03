enum UserRole { user, superAdmin }

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    this.name = '',
    this.phone = '',
    this.emailVerified = false,
    this.role = UserRole.user,
  });

  final String uid;
  final String email;
  final String name;

  /// Verified phone (E.164). Empty until the user verifies it with an OTP –
  /// required before registering a masjid.
  final String phone;
  final bool emailVerified;
  final UserRole role;

  bool get isSuperAdmin => role == UserRole.superAdmin;
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
      );
}
