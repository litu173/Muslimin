// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Muslimin';

  @override
  String get tagline => 'A day of a Muslim ummah';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get cancel => 'Cancel';

  @override
  String get getStarted => 'Get Started';

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get edit => 'Edit';

  @override
  String get post => 'Post';

  @override
  String get save => 'Save';

  @override
  String get select => 'Select';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get delete => 'Delete';

  @override
  String get done => 'Done';

  @override
  String get viewAll => 'View All';

  @override
  String get viewDetails => 'View Details';

  @override
  String get dontShowAgain => 'Don\'t Show Again';

  @override
  String get share => 'Share';

  @override
  String get addNew => 'Add New';

  @override
  String get now => 'Now';

  @override
  String get selected => 'Selected';

  @override
  String get home => 'Home';

  @override
  String get more => 'More';

  @override
  String get loading => 'Loading…';

  @override
  String get somethingWrong => 'Something went wrong. Please try again.';

  @override
  String get onb1Title => 'Share Jamat Time';

  @override
  String get onb1Body =>
      'People nearby will be able to view masjid jamat time in this app.';

  @override
  String get onb2Title => 'Post Masjid Notice';

  @override
  String get onb2Body =>
      'People can find masjid notice in this app which will help them to get involve in different occasion.';

  @override
  String get permTitle => 'Allow access to continue';

  @override
  String get permBody =>
      'Muslimin needs your location to find the masjids around you, and notifications to remind you before jamat.';

  @override
  String get permLocation => 'Location';

  @override
  String get permLocationBody =>
      'Find the nearest masjids and calculate accurate prayer times.';

  @override
  String get permNotification => 'Notifications';

  @override
  String get permNotificationBody =>
      'Jamat reminders and notices from masjids you follow.';

  @override
  String get permAllow => 'Allow';

  @override
  String get permGranted => 'Allowed';

  @override
  String get permOpenSettings => 'Open Settings';

  @override
  String get permLocationServiceOff =>
      'Please turn on location (GPS) on your phone.';

  @override
  String get permDeniedForever =>
      'Permission was denied. Please enable it from Settings.';

  @override
  String get permContinue => 'Continue';

  @override
  String get timeLeft => 'Time left';

  @override
  String get startsIn => 'Starts in';

  @override
  String get allPrayers => 'All Prayers';

  @override
  String get nearestMasjid => 'Nearest Masjid';

  @override
  String get noMasjidNearby => 'No verified masjid found near you yet.';

  @override
  String get noMasjidNearbyHint =>
      'Know a masjid authority? Ask them to register the masjid in Muslimin.';

  @override
  String minWalk(String minutes) {
    return '$minutes min walk';
  }

  @override
  String kmAway(String km) {
    return '$km km away';
  }

  @override
  String get jamatNotSet => 'Jamat time not set';

  @override
  String get nextJamat => 'Next jamat';

  @override
  String get notice => 'Notice';

  @override
  String get notices => 'Notices';

  @override
  String get noNotices => 'No notices yet.';

  @override
  String get all => 'All';

  @override
  String get authorityTitle => 'Masjid Authorities';

  @override
  String get authorityBody =>
      'Register your masjid & let Muslims nearby discover in this app.';

  @override
  String get yourLocation => 'Your Location';

  @override
  String get locating => 'Locating…';

  @override
  String get useCurrentLocation => 'Use current location';

  @override
  String get searchMasjid => 'Search masjid';

  @override
  String get nearbyMasjids => 'Nearby Masjids';

  @override
  String get fajr => 'Fajr';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get dhuhr => 'Duhr';

  @override
  String get asr => 'Asr';

  @override
  String get maghrib => 'Maghrib';

  @override
  String get isha => 'Isha';

  @override
  String get jumuah => 'Jum\'ah';

  @override
  String get forbiddenTime => 'Forbidden Time';

  @override
  String get forbiddenInfo =>
      'Salah is not offered during these times: while the sun is rising, at its zenith and while it is setting.';

  @override
  String get morning => 'Morning';

  @override
  String get noon => 'Noon';

  @override
  String get evening => 'Evening';

  @override
  String get naflPrayers => 'Nafl Prayers';

  @override
  String get tahajjud => 'Tahajjud';

  @override
  String get duha => 'Salatul Duha';

  @override
  String get tahajjudHadith =>
      'Allah\'s Messenger (ﷺ) said, \"Our Lord, the Blessed, the Superior, comes every night down on the nearest Heaven to us when the last third of the night remains, saying: \'Is there anyone to invoke Me, so that I may respond to invocation? Is there anyone to ask Me, so that I may grant him his request? Is there anyone seeking My forgiveness, so that I may forgive him?\'\"';

  @override
  String get tahajjudSource => 'Sahih al-Bukhari 1145';

  @override
  String get duhaHadith1 =>
      'Abu Hurairah said: \"My friend, the Messenger of Allah (ﷺ) advised me to do three things: fasting three days of every month, praying the duha prayer, and praying the witr prayer before I sleep.\"';

  @override
  String get duhaSource1 => 'Sahih al-Bukhari & Muslim';

  @override
  String get duhaHadith2 =>
      'Nu\'aym ibn Hammar reported: The Messenger of Allah (ﷺ) said, \"Allah Almighty says: O son of Adam, do not be frustrated to perform four cycles of prayer for me at the beginning of your day. I will suffice you for the rest of it.\"';

  @override
  String get duhaSource2 => 'Sunan Abi Dawud 1289';

  @override
  String get calcMethodNote =>
      'Times are calculated for your location. Jamat times are set by each masjid.';

  @override
  String get following => 'Following';

  @override
  String get follow => 'Follow';

  @override
  String get tabHome => 'Home';

  @override
  String get tabNotice => 'Notice';

  @override
  String get tabLive => 'Live';

  @override
  String get tabAbout => 'About';

  @override
  String get jamatTime => 'Jamat Time';

  @override
  String get maktabTime => 'Maktab Time';

  @override
  String lastUpdated(String when) {
    return 'Last updated $when';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(String count) {
    return '$count days ago';
  }

  @override
  String get khatib => 'Khatib';

  @override
  String get imam => 'Imam';

  @override
  String get muazzin => 'Moazzin';

  @override
  String contact(String phone) {
    return 'Contact: $phone';
  }

  @override
  String get notAdded => 'Not added yet';

  @override
  String get jamatReminder => 'Jamat Reminder';

  @override
  String get notifyBefore => 'Notify before';

  @override
  String minsBefore(String minutes) {
    return '$minutes mins';
  }

  @override
  String get reminderOff => 'Turn off reminder';

  @override
  String reminderSet(String minutes) {
    return 'You will be reminded $minutes minutes before each jamat.';
  }

  @override
  String followedToast(String name) {
    return 'You are now following $name.';
  }

  @override
  String get directions => 'Directions';

  @override
  String get liveNow => 'Live now';

  @override
  String get noLive => 'No live session right now';

  @override
  String get noLiveHint =>
      'When the masjid streams a khutbah or bayan, it will appear here.';

  @override
  String get watchLive => 'Watch live';

  @override
  String get liveLink => 'Live stream link (YouTube / Facebook)';

  @override
  String get liveToggle => 'We are live now';

  @override
  String get maktabDays => 'Maktab days';

  @override
  String get weekdaysShort => 'Sat,Sun,Mon,Tue,Wed,Thu,Fri';

  @override
  String get weekdaysLong =>
      'Saturday,Sunday,Monday,Tuesday,Wednesday,Thursday,Friday';

  @override
  String dayRange(String from, String to) {
    return '$from ~ $to';
  }

  @override
  String get tapToSet => 'Set';

  @override
  String get khatibName => 'Khatib Name';

  @override
  String get imamName => 'Imam Name';

  @override
  String get muazzinName => 'Moazzin Name';

  @override
  String get contactNumber => 'Contact Number';

  @override
  String get updated => 'Updated successfully';

  @override
  String get writeNotice => 'Write Notice';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get deleteNoticeQ => 'Delete this notice?';

  @override
  String get catJanaza => 'Janaza';

  @override
  String get catRecruitment => 'Recruitment';

  @override
  String get catQuran => 'Quran Class';

  @override
  String get catQuranShort => 'Quran';

  @override
  String get catMahfil => 'Mahfil';

  @override
  String get catTalim => 'Talim';

  @override
  String get catTafsir => 'Tafsir';

  @override
  String get catGeneral => 'General';

  @override
  String get janazaNotice => 'Janaza Notice';

  @override
  String noticeFormTitle(String category) {
    return '$category Notice';
  }

  @override
  String get enterCarefully => 'Please enter below information carefully.';

  @override
  String get personName => 'Person Name';

  @override
  String get fathersName => 'Father\'s Name';

  @override
  String get diedOn => 'Died On';

  @override
  String get address => 'Address';

  @override
  String get janazaTime => 'Janaza Time';

  @override
  String get janazaDate => 'Janaza Date';

  @override
  String get noticeTitle => 'Title';

  @override
  String get noticeDetails => 'Details';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String deadline(String date) {
    return 'Deadline: $date';
  }

  @override
  String startingDate(String date) {
    return 'Starting Date: $date';
  }

  @override
  String timeAndDate(String value) {
    return 'Time & Date: $value';
  }

  @override
  String janazaOf(String name) {
    return 'Janaza of $name';
  }

  @override
  String sonOf(String name) {
    return 'Son/Daughter of $name';
  }

  @override
  String get noticePosted => 'Notice posted';

  @override
  String get required => 'Required';

  @override
  String get userAuth => 'User Authentication';

  @override
  String get userAuthBody => 'Please read & agree if below meets.';

  @override
  String get rule1 =>
      'I am a masjid committee member or masjid khadem/moazzin/imam';

  @override
  String get rule2 => 'I am able to update masjid jamat time regularly';

  @override
  String get rule3 => 'I understand the benefit of this app';

  @override
  String get rule4 => 'I am physically inside the masjid right now';

  @override
  String get agreeAll => 'Please confirm all the statements to continue.';

  @override
  String get registration => 'Registration';

  @override
  String get verifyMobile => 'Verify your mobile number';

  @override
  String get yourMobile => 'Your Mobile Number';

  @override
  String get otpWillBeSent =>
      'One Time Password (OTP) will be sent to this phone number for verification';

  @override
  String get getOtp => 'Get OTP';

  @override
  String get invalidPhone =>
      'Enter a valid Bangladeshi mobile number (01XXXXXXXXX).';

  @override
  String get verification => 'Verification';

  @override
  String get typeOtp => 'Please type the OTP code sent to your phone number';

  @override
  String get otp => 'One Time Password (OTP)';

  @override
  String get didntGetOtp => 'Didn\'t get the OTP?';

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendIn(String seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get verify => 'Verify';

  @override
  String get invalidOtp => 'The code is not correct. Please try again.';

  @override
  String get demoOtpHint => 'Demo mode: use code 123456';

  @override
  String get createMasjidProfile => 'Create Masjid Profile';

  @override
  String get stayInside =>
      'Stay inside of the masjid & enter below information carefully.';

  @override
  String get masjidName => 'Masjid Name';

  @override
  String get district => 'District';

  @override
  String get thana => 'Thana / Upazila';

  @override
  String get latLng => 'Latitude & Longitude';

  @override
  String get load => 'Load';

  @override
  String get reload => 'Reload';

  @override
  String get stayInsideLoading => 'Stay inside of the masjid during loading.';

  @override
  String accuracy(String meters) {
    return 'Accuracy ±$meters m';
  }

  @override
  String accuracyTooLow(String meters) {
    return 'Location is not accurate enough (±$meters m). Move to an open area inside the masjid and reload.';
  }

  @override
  String get loadLocationFirst => 'Please load the masjid location.';

  @override
  String get nidNumber => 'Your NID Number';

  @override
  String get invalidNid => 'NID must be 10, 13 or 17 digits.';

  @override
  String get yourRole => 'Your Role';

  @override
  String get roleCommittee => 'Committee member';

  @override
  String get roleKhadem => 'Khadem';

  @override
  String get roleMuazzin => 'Moazzin';

  @override
  String get roleImam => 'Imam';

  @override
  String get roleKhatib => 'Khatib';

  @override
  String get agreeTermsPrefix => 'I\'ve read & I agree to the ';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get mustAgreeTerms => 'Please agree to the Terms & Conditions.';

  @override
  String duplicateFound(String name) {
    return 'A masjid named \"$name\" is already registered at this location. If you are its authority, please contact support.';
  }

  @override
  String limitReached(String count) {
    return 'You can have at most $count masjid profiles.';
  }

  @override
  String get submittedTitle => 'Submitted for review';

  @override
  String get submittedBody =>
      'Jazakallahu khairan! Your masjid profile will be visible to everyone after our team verifies it. You will get a notification when it is approved.';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get termsBody =>
      '1. Only masjid committee members, imam, khatib, moazzin or khadem may create a masjid profile.\n2. The profile must be created from inside the masjid so its location is correct.\n3. Your NID and phone number are used only for verification and are never shown publicly.\n4. Jamat times and notices must be accurate and kept up to date.\n5. Notices must be related to masjid activities. Political, commercial or hateful content is not allowed.\n6. A profile stays hidden until it is verified by the Muslimin team. Profiles with false information will be removed.';

  @override
  String get statusPending => 'Pending review';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusSuspended => 'Suspended';

  @override
  String get pendingBanner =>
      'This profile is waiting for verification. Only you can see it.';

  @override
  String rejectedBanner(String reason) {
    return 'This profile was not approved: $reason';
  }

  @override
  String get myMasjids => 'My Masjids';

  @override
  String get registerMasjid => 'Register a Masjid';

  @override
  String get appSettings => 'App Settings';

  @override
  String get faq => 'FAQ';

  @override
  String get aboutApp => 'About the App';

  @override
  String get shareApp => 'Share this app';

  @override
  String get shareAppBody =>
      'This app might help your family & friends as well. Please share.';

  @override
  String shareText(String url) {
    return 'Find jamat times of masjids near you with Muslimin: $url';
  }

  @override
  String get language => 'Language';

  @override
  String get calcMethod => 'Prayer time calculation';

  @override
  String get asrMethod => 'Asr calculation';

  @override
  String get hanafi => 'Hanafi';

  @override
  String get shafi => 'Shafi\'i / Maliki / Hanbali';

  @override
  String get hijriAdjust => 'Hijri date adjustment';

  @override
  String days(String count) {
    return '$count days';
  }

  @override
  String get defaultReminder => 'Default jamat reminder';

  @override
  String get signOut => 'Sign out';

  @override
  String signedInAs(String phone) {
    return 'Signed in as $phone';
  }

  @override
  String version(String v) {
    return 'Version $v';
  }

  @override
  String get aboutBody =>
      'Muslimin helps Muslims find the jamat times of the masjids around them. Every masjid profile is created by its own authority and verified by our team before it becomes public.';

  @override
  String get faqQ1 => 'Where do the jamat times come from?';

  @override
  String get faqA1 =>
      'Each masjid\'s authority sets and updates its own jamat times. Prayer start times are calculated for your location.';

  @override
  String get faqQ2 => 'Why is location mandatory?';

  @override
  String get faqA2 =>
      'Location is used to show masjids near you and to calculate accurate prayer times. It is never shared with anyone.';

  @override
  String get faqQ3 => 'How can I add my masjid?';

  @override
  String get faqA3 =>
      'Go to More → Register a Masjid. You must be a committee member, imam, moazzin, khatib or khadem, and you must be inside the masjid while registering.';

  @override
  String get faqQ4 => 'Why is my masjid not visible?';

  @override
  String get faqA4 =>
      'New profiles are verified by our team before they become public. This usually takes 1–2 days.';

  @override
  String get faqQ5 => 'How do jamat reminders work?';

  @override
  String get faqA5 =>
      'Open a masjid and tap the bell on Jamat Time. You will be notified 15, 30 or 45 minutes before each jamat, even when the app is closed.';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'Follow masjids to see their notices here.';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get adminPending => 'Pending';

  @override
  String get adminApproved => 'Approved';

  @override
  String get adminRejected => 'Rejected';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get suspend => 'Suspend';

  @override
  String get restore => 'Restore';

  @override
  String get rejectReason => 'Reason for rejection';

  @override
  String get submittedBy => 'Submitted by';

  @override
  String get phone => 'Phone';

  @override
  String get nid => 'NID';

  @override
  String get role => 'Role';

  @override
  String get location => 'Location';

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String get submittedOn => 'Submitted on';

  @override
  String get nothingHere => 'Nothing here';

  @override
  String get approvedToast => 'Masjid approved';

  @override
  String get rejectedToast => 'Masjid rejected';

  @override
  String get verifiedChecklist =>
      'Before approving, call the submitter and check the location on the map.';

  @override
  String get verse1Ar => 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ';

  @override
  String get verse1 => 'And seek help in patience and prayer';

  @override
  String get verse1Ref => 'Al-Baqarah 45';

  @override
  String get verse2Ar =>
      'إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَّوْقُوتًا';

  @override
  String get verse2 =>
      'Indeed, prayer has been decreed upon the believers at specified times';

  @override
  String get verse2Ref => 'An-Nisa 103';

  @override
  String get verse3Ar =>
      'حَافِظُوا عَلَى الصَّلَوَاتِ وَالصَّلَاةِ الْوُسْطَىٰ';

  @override
  String get verse3 =>
      'Guard strictly the prayers, especially the middle prayer';

  @override
  String get verse3Ref => 'Al-Baqarah 238';

  @override
  String get hijriMonths =>
      'Muharram,Safar,Rabi al-Awwal,Rabi al-Thani,Jumada al-Ula,Jumada al-Thani,Rajab,Sha\'ban,Ramadan,Shawwal,Dhul Qa\'dah,Dhul Hijjah';

  @override
  String get deadlineLabel => 'Deadline';

  @override
  String get startingDateLabel => 'Starting Date';

  @override
  String get masjidNameBn => 'Masjid Name in Bangla (optional)';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signIn => 'Sign In';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get signUpBody =>
      'Create your account to follow masjids and keep your settings safe.';

  @override
  String get signInBody => 'Welcome back! Sign in to continue.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetBody =>
      'Enter the email you signed up with. We will send you a link to set a new password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String resetSent(String email) {
    return 'A password reset link has been sent to $email. Please check your inbox (and spam folder).';
  }

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters.';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match.';

  @override
  String get errEmailInUse =>
      'An account already exists with this email. Try signing in.';

  @override
  String get errInvalidCredential => 'Email or password is incorrect.';

  @override
  String get errWeakPassword =>
      'Please choose a stronger password (at least 6 characters).';

  @override
  String get errTooManyRequests =>
      'Too many attempts. Please wait a few minutes and try again.';

  @override
  String get errNetwork => 'No internet connection. Please try again.';

  @override
  String get errPhoneInUse =>
      'This phone number is already linked to another account.';

  @override
  String get errUserDisabled =>
      'This account has been disabled. Please contact support.';

  @override
  String get myAccount => 'My Account';

  @override
  String get signInPrompt => 'For masjid authorities';

  @override
  String get signInPromptBody =>
      'Sign in or create an account to register and manage your masjid. Regular users don\'t need an account.';

  @override
  String get profile => 'Profile';

  @override
  String get emailNotVerified => 'Email not verified';

  @override
  String get emailVerified => 'Email verified';

  @override
  String get resendVerification => 'Send verification email';

  @override
  String verificationSent(String email) {
    return 'Verification email sent to $email.';
  }

  @override
  String get iVerified => 'I\'ve verified';

  @override
  String get changePassword => 'Change Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get passwordChanged => 'Password changed successfully.';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountBody =>
      'This permanently deletes your account and saved data. Masjid profiles you manage will stay but you will lose access. Enter your password to confirm.';

  @override
  String get accountDeleted => 'Your account has been deleted.';

  @override
  String get phoneNumber => 'Phone';

  @override
  String get notVerified => 'Not verified';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get signInToRegister =>
      'Please sign in or create an account to register a masjid.';

  @override
  String get verifyPhoneToContinue =>
      'Verify your phone number to register a masjid.';

  @override
  String accountCreated(String email) {
    return 'Account created! We sent a verification link to $email.';
  }

  @override
  String get nameRequired => 'Please enter your name.';

  @override
  String get credits => 'Credits';

  @override
  String get fontCredits =>
      'Logo & prayer names: Grenze Gotisch by Omnibus-Type. Text: Poppins by Indian Type Foundry & Jonny Pinhorn, Hind Siliguri by Indian Type Foundry, Galada by Black Foundry, Amiri by Khaled Hosny. All fonts are free under the SIL Open Font License 1.1.';

  @override
  String get designInspired =>
      'Original design font: Hidayatullah by Anthonie Van Hayu (ARToni).';

  @override
  String get openSourceLicenses => 'Open-source licences';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get orDivider => 'or';

  @override
  String get onb3Title => 'Prayer Times & Reminders';

  @override
  String get onb3Body =>
      'Accurate prayer times for your location, and a reminder before every jamat at the masjids you follow.';

  @override
  String get appVersion => 'App version';

  @override
  String get checkingUpdates => 'Checking for updates…';

  @override
  String get upToDate => 'You have the latest version.';

  @override
  String updateAvailable(String version) {
    return 'New version $version is available';
  }

  @override
  String get downloadLatestApk => 'Download latest APK';

  @override
  String get updateApkHint =>
      'Open the downloaded file to install it over this version. Your settings are kept.';

  @override
  String get updateIosButton => 'How to update on iPhone';

  @override
  String get updateCheckFailed =>
      'Couldn’t check for updates. Check your internet connection.';

  @override
  String get releaseNotes => 'Release notes';

  @override
  String get selectAll => 'Select all';

  @override
  String get welcomeTitle => 'Assalamu Alaikum';

  @override
  String get welcomeBody =>
      'Sign in to follow your masjids, get jamat reminders and keep everything synced across your phones.';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get editMasjidInfo => 'Edit Masjid Info';

  @override
  String get editMasjidInfoBody =>
      'Update the details shown on your masjid profile.';

  @override
  String get followedMasjids => 'Followed Masjids';

  @override
  String get noFollowed => 'You are not following any masjid yet.';

  @override
  String get noFollowedHint =>
      'Open a masjid and tap Follow to see it here and get its notices.';

  @override
  String reminderBadge(String minutes) {
    return 'Reminder $minutes min';
  }
}
