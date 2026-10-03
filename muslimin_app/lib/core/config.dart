/// Release-stage switches.
///
/// While Muslimin is in public beta:
///  * the app is branded "Muslimin Beta";
///  * masjid authorities can register with any account – the SMS OTP step
///    is skipped (phone auth needs Firebase's Blaze plan). They type their
///    phone number instead and the admin sees it marked "not verified".
/// Flip [kBeta] to false (and enable Phone auth) for the stable release.
const kBeta = true;

const kRequirePhoneOtp = !kBeta;

const kAppName = kBeta ? 'Muslimin Beta' : 'Muslimin';

/// Everyone signs in (email or Google) after onboarding. Set to false to show
/// a "Continue as guest" option on the Welcome screen instead.
const kRequireAccount = true;
