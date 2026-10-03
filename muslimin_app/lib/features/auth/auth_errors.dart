import '../../data/backend/backend.dart';
import '../../l10n/app_localizations.dart';

/// Turns backend error codes into friendly, localised messages.
String authErrorText(L10n t, Object error) {
  if (error is! BackendException) return t.somethingWrong;
  return switch (error.code) {
    'email-already-in-use' => t.errEmailInUse,
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' => t.errInvalidCredential,
    'invalid-email' => t.invalidEmail,
    'weak-password' => t.errWeakPassword,
    'too-many-requests' => t.errTooManyRequests,
    'network-request-failed' || 'unavailable' => t.errNetwork,
    'credential-already-in-use' ||
    'account-exists-with-different-credential' => t.errPhoneInUse,
    'user-disabled' => t.errUserDisabled,
    'invalid-otp' => t.invalidOtp,
    _ => error.message ?? t.somethingWrong,
  };
}

final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$');

String? validateEmail(L10n t, String? v) =>
    _emailRe.hasMatch((v ?? '').trim()) ? null : t.invalidEmail;

String? validatePassword(L10n t, String? v) =>
    (v ?? '').length >= 6 ? null : t.passwordTooShort;
