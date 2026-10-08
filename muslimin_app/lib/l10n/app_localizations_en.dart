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
  String get rule4 => 'I will mark the exact location of the masjid';

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
      'Enter the details below carefully. You can set the location from inside the masjid or on the map.';

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
  String get loadLocationFirst => 'Please set the masjid location.';

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
      '1. Only masjid committee members, imam, khatib, moazzin or khadem may create a masjid profile.\n2. The masjid\'s location must be exact — set it with GPS inside the masjid or by pointing to it on the map.\n3. Your NID and phone number are used only for verification and are never shown publicly.\n4. Jamat times and notices must be accurate and kept up to date.\n5. Notices must be related to masjid activities. Political, commercial or hateful content is not allowed.\n6. A profile stays hidden until it is verified by the Muslimin team. Profiles with false information will be removed.';

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
      'Go to More → Register a Masjid. You must be a committee member, imam, moazzin, khatib or khadem, and you set the masjid\'s exact location — with GPS inside the masjid or on the map.';

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
  String get verse1Ar => 'وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ';

  @override
  String get verse1 => 'And seek help through patience and prayer';

  @override
  String get verse1Ref => 'Al-Baqarah 2:45';

  @override
  String get verse2Ar =>
      'إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَـٰبًا مَّوْقُوتًا';

  @override
  String get verse2 =>
      'Indeed, prayer has been decreed upon the believers a decree of specified times';

  @override
  String get verse2Ref => 'An-Nisa\' 4:103';

  @override
  String get verse3Ar =>
      'حَـٰفِظُوا۟ عَلَى ٱلصَّلَوَٰتِ وَٱلصَّلَوٰةِ ٱلْوُسْطَىٰ';

  @override
  String get verse3 =>
      'Maintain with care the [obligatory] prayers and [in particular] the middle prayer';

  @override
  String get verse3Ref => 'Al-Baqarah 2:238';

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
      'Logo & English prayer names: lettering from the Muslimin design, based on Hidayatullah by Anthonie Van Hayu (ARToni). Fonts: Grenze Gotisch by Omnibus-Type, Poppins by Indian Type Foundry & Jonny Pinhorn, Hind Siliguri by Indian Type Foundry, Anek Bangla (Bangla digits) by Ek Type, Galada by Black Foundry, Scheherazade New by SIL International. All fonts are free under the SIL Open Font License 1.1.';

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
      'Update the details shown on your masjid profile, including its location (GPS at the masjid or chosen on the map).';

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

  @override
  String get manageMasjids => 'Manage Masjids';

  @override
  String get noMyMasjids => 'You haven’t registered a masjid yet.';

  @override
  String get noMyMasjidsHint =>
      'Committee members, imam, khatib, moazzin or khadem can register their masjid. Our team verifies it before it goes public.';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get appearanceHint =>
      'Dark mode is easier on the eyes at Fajr and Isha.';

  @override
  String get pullToRefresh => 'Pull down to refresh';

  @override
  String get verifyAutoCheck =>
      'Open the link we emailed you — this page updates by itself once you\'re verified.';

  @override
  String get signOutTitle => 'Sign out?';

  @override
  String get signOutBody =>
      'You will need to sign in again to see your followed masjids and get jamat reminders on this phone.';

  @override
  String jamatLine(String prayer, String time) {
    return '$prayer Jamat $time';
  }

  @override
  String get scanBoard => 'Scan time board';

  @override
  String get scanBoardHint =>
      'Snap the masjid\'s time board and all jamat times fill in by themselves — or tap a time to set it manually.';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseGallery => 'Choose from gallery';

  @override
  String get scanStage1 => 'Looking at the time board…';

  @override
  String get scanStage2 => 'Reading the digits…';

  @override
  String get scanStage3 => 'Matching Fajr to Isha…';

  @override
  String get scanStage4 => 'Checking Jum\'ah…';

  @override
  String scanFound(String count) {
    return 'Found $count times';
  }

  @override
  String get scanFailed =>
      'Couldn\'t read this photo. Try a clear, straight photo of the board, or enter the times manually.';

  @override
  String get enterManually => 'Enter manually';

  @override
  String get scanReview =>
      'Times filled in from the photo (marked ✦). Check them, then tap Update.';

  @override
  String get tabRead => 'Read';

  @override
  String get readQuran => 'Read Quran';

  @override
  String get journeySub => 'Your journey through all 114 surahs';

  @override
  String surahsProgress(String done) {
    return '$done of 114 surahs';
  }

  @override
  String get versesRead => 'verses read';

  @override
  String get phasesDone => 'phases done';

  @override
  String get continueReading => 'Continue';

  @override
  String get startReading => 'Start reading';

  @override
  String phaseN(String n) {
    return 'Phase $n';
  }

  @override
  String versesN(String n) {
    return '$n verses';
  }

  @override
  String get completed => 'Completed';

  @override
  String get locked => 'Locked';

  @override
  String ayahOf(String n, String total) {
    return 'Ayah $n of $total';
  }

  @override
  String unlockHint(String surah) {
    return 'Finish $surah to unlock this surah.';
  }

  @override
  String get quizUnlockHint =>
      'Read every surah of this phase to unlock its quiz.';

  @override
  String phaseQuiz(String n) {
    return 'Phase $n quiz';
  }

  @override
  String get quizOptional => 'Optional · test what you read';

  @override
  String bestScore(String score) {
    return 'Best $score%';
  }

  @override
  String get makki => 'Makki';

  @override
  String get madani => 'Madani';

  @override
  String get loadingSurah => 'Getting the surah…';

  @override
  String get completeSurah => 'I\'ve finished this surah';

  @override
  String get nextSurah => 'Next surah';

  @override
  String surahDone(String name) {
    return 'MashaAllah! You finished Surah $name.';
  }

  @override
  String nextUnlocked(String name) {
    return '$name is now unlocked.';
  }

  @override
  String get takeQuiz => 'Take the phase quiz';

  @override
  String get later => 'Later';

  @override
  String get wordByWord => 'Word by word';

  @override
  String get quranSource =>
      'Mushaf text & word-by-word: quran.com (King Fahd Complex Uthmani script) · Translation: Saheeh International';

  @override
  String get startHere => 'START';

  @override
  String get quizWordMeaning => 'What does this word mean?';

  @override
  String get quizAyahMeaning => 'What does this ayah mean?';

  @override
  String get quizWhichSurah => 'Which surah is this ayah from?';

  @override
  String quizRevealed(String name) {
    return 'Where was Surah $name revealed?';
  }

  @override
  String get makkah => 'Makkah';

  @override
  String get madinah => 'Madinah';

  @override
  String quizVerses(String name) {
    return 'How many verses are in Surah $name?';
  }

  @override
  String quizNameMeans(String name) {
    return 'What does the name “$name” mean?';
  }

  @override
  String get kindVocabulary => 'VOCABULARY';

  @override
  String get kindMeaning => 'MEANING';

  @override
  String get kindSurah => 'WHICH SURAH';

  @override
  String get kindFacts => 'SURAH FACTS';

  @override
  String get quizCorrect => 'Correct — MashaAllah!';

  @override
  String get quizWrong => 'Not quite — the right answer is highlighted.';

  @override
  String get continueBtn => 'Continue';

  @override
  String quizScore(String score) {
    return 'You scored $score%';
  }

  @override
  String get quizDoneBody =>
      'Quizzes are optional — they help you remember what you read.';

  @override
  String get quizLoading => 'Preparing your quiz…';

  @override
  String get tabQuran => 'Quran';

  @override
  String get tabDua => 'Dua';

  @override
  String get specialSurahs => 'Recommended to read';

  @override
  String get chipMulk => 'Al-Mulk';

  @override
  String get chipMulkWhen => 'Before sleep';

  @override
  String get chipSajdah => 'As-Sajdah';

  @override
  String get chipKahf => 'Al-Kahf';

  @override
  String get chipKahfWhen => 'Friday';

  @override
  String get chipKursi => 'Ayatul Kursi';

  @override
  String get chipKursiWhen => 'After salah & sleep';

  @override
  String get chipBaqarahEnd => 'Last 2 of Al-Baqarah';

  @override
  String get chipNight => 'At night';

  @override
  String get chipYasin => 'Ya-Sin';

  @override
  String get chipQuls => '3 Quls';

  @override
  String get chipQulsWhen => 'Morning & evening';

  @override
  String get chipAnytime => 'Any time';

  @override
  String get chipToday => 'Today';

  @override
  String get chipTonight => 'Tonight';

  @override
  String get revealedMakkah => 'Revealed in Makkah';

  @override
  String get revealedMadinah => 'Revealed in Madinah';

  @override
  String get reciter => 'Reciter';

  @override
  String get chooseReciter => 'Choose a reciter';

  @override
  String get playAyah => 'Play from this ayah';

  @override
  String recitingAyah(String n, String total) {
    return 'Ayah $n of $total';
  }

  @override
  String get audioError =>
      'Couldn\'t load the recitation. Check your internet.';

  @override
  String get dailyQuran => 'Daily Quran';

  @override
  String get energy0 => 'Your heart is waiting for light today';

  @override
  String get energy1 => 'Charging… a few more ayat';

  @override
  String get energy2 => 'Almost full — keep going!';

  @override
  String get energy3 => 'Full of light — MashaAllah!';

  @override
  String get energy4 => 'Shining bright today ✨';

  @override
  String versesToday(String n, String goal) {
    return '$n / $goal ayat today';
  }

  @override
  String streakDays(String n) {
    return '$n-day streak';
  }

  @override
  String get readNow => 'Read now';

  @override
  String get keepReading => 'Read more';

  @override
  String get achievements => 'Achievements';

  @override
  String achievementsCount(String n, String total) {
    return '$n of $total earned';
  }

  @override
  String achievementEarned(String date) {
    return 'Earned on $date';
  }

  @override
  String achievementLocked(String done, String target) {
    return 'In progress · $done/$target';
  }

  @override
  String achievementUnlocked(String name) {
    return 'Achievement unlocked: $name';
  }

  @override
  String get ach_bismillah => 'Bismillah';

  @override
  String get ach_bismillah_desc => 'Read your first ayah';

  @override
  String get ach_fatiha => 'The Opener';

  @override
  String get ach_fatiha_desc => 'Complete Surah Al-Fatihah';

  @override
  String get ach_quls => 'Three Quls';

  @override
  String get ach_quls_desc => 'Complete Al-Ikhlas, Al-Falaq and An-Nas';

  @override
  String get ach_streak3 => 'Steady Steps';

  @override
  String get ach_streak3_desc => 'Read Quran 3 days in a row';

  @override
  String get ach_streak7 => 'Week of Light';

  @override
  String get ach_streak7_desc => 'Read Quran 7 days in a row';

  @override
  String get ach_streak30 => 'Month of Noor';

  @override
  String get ach_streak30_desc => 'Read Quran 30 days in a row';

  @override
  String get ach_verses100 => 'Hundred Ayat';

  @override
  String get ach_verses100_desc => 'Read 100 ayat';

  @override
  String get ach_verses1000 => 'Thousand Ayat';

  @override
  String get ach_verses1000_desc => 'Read 1,000 ayat';

  @override
  String get ach_kahf => 'Friday Light';

  @override
  String get ach_kahf_desc => 'Complete Al-Kahf on a Friday';

  @override
  String get ach_mulk => 'Night Guardian';

  @override
  String get ach_mulk_desc => 'Complete Al-Mulk at night';

  @override
  String get ach_yasin => 'Ya-Sin';

  @override
  String get ach_yasin_desc => 'Complete Surah Ya-Sin';

  @override
  String get ach_listener => 'Attentive Listener';

  @override
  String get ach_listener_desc => 'Listen to a whole surah recitation';

  @override
  String get ach_quiz100 => 'Sharp Mind';

  @override
  String get ach_quiz100_desc => 'Score 100% in a phase quiz';

  @override
  String get ach_juzamma => 'Juz \'Amma';

  @override
  String get ach_juzamma_desc => 'Complete all 37 surahs of the 30th juz';

  @override
  String get ach_phases10 => 'Ten Phases';

  @override
  String get ach_phases10_desc => 'Complete 10 phases of the journey';

  @override
  String get ach_khatm => 'Khatm al-Quran';

  @override
  String get ach_khatm_desc => 'Complete all 114 surahs';

  @override
  String get duaHeader => 'A day with the remembrance of Allah';

  @override
  String get duaSub =>
      'From waking up to sleeping — the duas the Prophet ﷺ taught for every moment.';

  @override
  String repeatTimes(String n) {
    return 'Say $n×';
  }

  @override
  String duaSource(String n) {
    return 'Hisn al-Muslim #$n';
  }

  @override
  String get duaCredit =>
      'Duas from Hisn al-Muslim (Fortress of the Muslim) by Sa’id bin Ali al-Qahtani, via its official site hisnmuslim.com.';

  @override
  String get nowLabel => 'Now';

  @override
  String get scene_wake => 'Waking up';

  @override
  String get scene_wake_story =>
      'The day begins with thanks — Allah returned the soul after sleep.';

  @override
  String get scene_restroom => 'Restroom';

  @override
  String get scene_restroom_story =>
      'Even the smallest routine begins by seeking Allah’s protection.';

  @override
  String get scene_wudu => 'Wudu';

  @override
  String get scene_wudu_story =>
      'Water on the hands, His name on the tongue — getting ready to stand before Allah.';

  @override
  String get scene_dress => 'Getting dressed';

  @override
  String get scene_dress_story =>
      'Every garment is a gift — thank the One who clothed you.';

  @override
  String get scene_athan => 'The adhan';

  @override
  String get scene_athan_story =>
      'The call rises over the neighbourhood — answer it, then ask for the Prophet ﷺ.';

  @override
  String get scene_masjid => 'To the masjid';

  @override
  String get scene_masjid_story =>
      'Each step toward the masjid is light — enter and leave with dua.';

  @override
  String get scene_after_salah => 'After salah';

  @override
  String get scene_after_salah_story =>
      'Before rushing off, sit a moment with the remembrance after salah.';

  @override
  String get scene_morning => 'Morning adhkar';

  @override
  String get scene_morning_story => 'Words that guard you until evening.';

  @override
  String get scene_eating => 'Breakfast';

  @override
  String get scene_eating_story => 'Begin with His name, end with His praise.';

  @override
  String get scene_leave_home => 'Stepping out';

  @override
  String get scene_leave_home_story =>
      'At the door, hand your day over to Allah.';

  @override
  String get scene_travel => 'On the way';

  @override
  String get scene_travel_story =>
      'Bus, rickshaw or car — Allahu Akbar going up, SubhanAllah coming down.';

  @override
  String get scene_meeting => 'Meeting people';

  @override
  String get scene_meeting_story =>
      'Spread salam and answer a brother’s sneeze.';

  @override
  String get scene_good_news => 'When good things happen';

  @override
  String get scene_good_news_story =>
      'Joy is a reminder of the Giver — praise Him, and thank the people too.';

  @override
  String get scene_hardship => 'When it gets hard';

  @override
  String get scene_hardship_story =>
      'Worry, difficulty or a plan that failed — turn to Him first.';

  @override
  String get scene_patience => 'Loss and patience';

  @override
  String get scene_patience_story =>
      'When something is taken, remember that we belong to Allah.';

  @override
  String get scene_anger => 'Holding back anger';

  @override
  String get scene_anger_story => 'Seek refuge before words you may regret.';

  @override
  String get scene_pain => 'Pain and sickness';

  @override
  String get scene_pain_story =>
      'For your own pain, and for a friend you visit.';

  @override
  String get scene_rain => 'When it rains';

  @override
  String get scene_rain_story => 'Rain is mercy — ask for it to be beneficial.';

  @override
  String get scene_home => 'Back home';

  @override
  String get scene_home_story => 'Enter with His name and greet your family.';

  @override
  String get scene_gathering => 'Leaving a gathering';

  @override
  String get scene_gathering_story =>
      'Before you stand up, wipe away the slips of the tongue.';

  @override
  String get scene_forgiveness => 'Seeking forgiveness';

  @override
  String get scene_forgiveness_story =>
      'The day’s mistakes, washed in istighfar.';

  @override
  String get scene_sleep => 'Before sleep';

  @override
  String get scene_sleep_story =>
      'End the day as it began — in His name, under His protection.';

  @override
  String get scene_night => 'In the night';

  @override
  String get scene_night_story =>
      'If you wake or have a bad dream, He is near.';

  @override
  String get part_dawn => 'Dawn';

  @override
  String get part_morning => 'Morning';

  @override
  String get part_day => 'Day';

  @override
  String get part_evening => 'Evening';

  @override
  String get part_night => 'Night';

  @override
  String get removeSession => 'Remove';

  @override
  String addSession(String session) {
    return 'Add $session';
  }

  @override
  String get duaSearchHint => 'Search duas';

  @override
  String duaPartCount(String topics, String duas) {
    return '$topics topics · $duas duas';
  }

  @override
  String duaNoResults(String q) {
    return 'No dua found for “$q”';
  }

  @override
  String duaResults(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString duas found',
      one: '1 dua found',
    );
    return '$_temp0';
  }

  @override
  String get part_dawn_sub => 'Waking, wudu and Fajr';

  @override
  String get part_morning_sub => 'Adhkar, food and going out';

  @override
  String get part_day_sub => 'People, joys and trials';

  @override
  String get part_evening_sub => 'Home, gatherings, istighfar';

  @override
  String get part_night_sub => 'Sleep and the night';

  @override
  String duaCount(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString duas',
      one: '1 dua',
    );
    return '$_temp0';
  }

  @override
  String get noticeSearchHint => 'Search notices, masjids…';

  @override
  String get noticesSub => 'From the masjids around you';

  @override
  String get tabNotices => 'Notice';

  @override
  String get chooseSurah => 'Go to surah';

  @override
  String get surahSearchHint => 'Search surah by name or number';

  @override
  String get previousSurah => 'Previous surah';

  @override
  String get pickOnMapTitle => 'Choose on map';

  @override
  String get mapSearchHint => 'Search a masjid or area';

  @override
  String get useMyLocation => 'My location';

  @override
  String get mapPickHint =>
      'Move the map so the pin sits on the masjid, tap a spot, or tap a masjid icon.';

  @override
  String get mapMoving => 'Finding the place…';

  @override
  String get useThisLocation => 'Use this location';

  @override
  String get masjidLocation => 'Masjid location';

  @override
  String get chooseLocationWay => 'Choose one way to set the exact location:';

  @override
  String get atTheMasjid => 'I\'m at the masjid';

  @override
  String get atTheMasjidBody =>
      'Use your phone\'s GPS. Stay inside the masjid while it loads.';

  @override
  String get onTheMap => 'Choose on map';

  @override
  String get onTheMapBody =>
      'Point to the masjid on the map, or tap one already shown.';

  @override
  String get locFromMap => 'Chosen on map';

  @override
  String get locFromGps => 'GPS';

  @override
  String get locSaved => 'Saved location';

  @override
  String get useGpsInstead => 'Use GPS';

  @override
  String get adjustOnMap => 'Adjust on map';

  @override
  String get allMasjids => 'All Masjids';

  @override
  String get nearestFirst => 'Nearest first';

  @override
  String get duaForNow => 'Duas for now';

  @override
  String get tabChannel => 'Channel';

  @override
  String get channelInviteTitle => 'Stay close to your Imam & Khatib';

  @override
  String get channelInviteHadith =>
      '“Seeking knowledge is an obligation upon every Muslim.” — Sunan Ibn Majah 224';

  @override
  String get channelInviteBody =>
      'Every Muslim must learn the Fard ʿAyn — the essentials of faith, purity, salah and daily life — and the best way is under the guidance of an Alim. Join this masjid\'s channel to receive guidance and messages from its Imam and Khatib, and grow closer to the masjid of your neighbourhood.';

  @override
  String get joinChannel => 'Join channel';

  @override
  String get openChannel => 'Open channel';

  @override
  String get joinedChannel => 'You\'re in this masjid\'s channel';

  @override
  String get channelJoined =>
      'Joined. You\'ll receive messages from the Imam and Khatib.';

  @override
  String get leaveChannel => 'Leave channel';

  @override
  String get leaveChannelQ =>
      'Leave this channel? You will stop receiving its messages.';

  @override
  String get leave => 'Leave';

  @override
  String get channelEmpty => 'No messages yet.';

  @override
  String get channelEmptyAdmin => 'Send the first message to your members.';

  @override
  String get channelReadOnly =>
      'Only the Imam, Khatib and channel admins post here.';

  @override
  String get messageHint => 'Write a message…';

  @override
  String get send => 'Send';

  @override
  String get deleteMessageQ => 'Delete this message for everyone?';

  @override
  String get members => 'Members';

  @override
  String get noMembers =>
      'No one has joined yet. Invite people from your masjid.';

  @override
  String get roleMember => 'Member';

  @override
  String get roleEditor => 'Editor';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMemberDesc => 'Reads messages';

  @override
  String get roleEditorDesc => 'Can send messages';

  @override
  String get roleAdminDesc => 'Sends messages and manages members';

  @override
  String get removeMember => 'Remove from channel';

  @override
  String get you => 'You';

  @override
  String get channelMessages => 'Channel messages';

  @override
  String get noticesHeading => 'Notices';

  @override
  String get signInToJoin => 'Sign in to join the channel.';

  @override
  String get monthNames =>
      'January,February,March,April,May,June,July,August,September,October,November,December';

  @override
  String get am => 'am';

  @override
  String get pm => 'pm';

  @override
  String jamatReminderBody(String prayer, String minutes) {
    return '$prayer Jamat in $minutes minutes';
  }
}
