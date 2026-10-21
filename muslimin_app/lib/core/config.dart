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

const kAppName = 'Muslimin';

/// The "Beta" badge: on the test builds from GitHub, not on Google Play.
const kShowBeta = kBeta && !kPlayStore;

/// Where users write for help (More → Help & Contact, store listing,
/// privacy policy).
const kSupportEmail = 'muslimin.admin@gmail.com';

/// The Google Play build (`--dart-define=PLAY=true`). Play doesn't allow an
/// app to update itself from elsewhere, so updates open the Play listing
/// instead of downloading the APK from GitHub.
const kPlayStore = bool.fromEnvironment('PLAY');

const kPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=com.muslimin.muslimin';

/// Everyone signs in (email or Google) after onboarding. Set to false to show
/// a "Continue as guest" option on the Welcome screen instead.
const kRequireAccount = true;
