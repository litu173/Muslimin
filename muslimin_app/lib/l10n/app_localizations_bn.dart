// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class L10nBn extends L10n {
  L10nBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'মুসলিমীন';

  @override
  String get tagline => 'একজন মুসলিমের প্রতিদিনের সঙ্গী';

  @override
  String get next => 'পরবর্তী';

  @override
  String get skip => 'এড়িয়ে যান';

  @override
  String get cancel => 'বাতিল';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get create => 'তৈরি করুন';

  @override
  String get update => 'আপডেট';

  @override
  String get edit => 'এডিট';

  @override
  String get post => 'পোস্ট';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get select => 'নির্বাচন করুন';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get close => 'বন্ধ';

  @override
  String get delete => 'মুছে ফেলুন';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String get viewDetails => 'বিস্তারিত দেখুন';

  @override
  String get dontShowAgain => 'আর দেখাবেন না';

  @override
  String get share => 'শেয়ার';

  @override
  String get addNew => 'নতুন যোগ';

  @override
  String get now => 'এখন';

  @override
  String get selected => 'নির্বাচিত';

  @override
  String get home => 'হোম';

  @override
  String get more => 'আরও';

  @override
  String get loading => 'লোড হচ্ছে…';

  @override
  String get somethingWrong => 'কিছু একটা ভুল হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get onb1Title => 'জামাতের সময় জানান';

  @override
  String get onb1Body =>
      'আশেপাশের মানুষ এই অ্যাপে মসজিদের জামাতের সময় দেখতে পাবেন।';

  @override
  String get onb2Title => 'মসজিদের নোটিশ দিন';

  @override
  String get onb2Body =>
      'এই অ্যাপে মসজিদের নোটিশ পাওয়া যাবে, যা বিভিন্ন আয়োজনে অংশ নিতে সাহায্য করবে।';

  @override
  String get permTitle => 'চালিয়ে যেতে অনুমতি দিন';

  @override
  String get permBody =>
      'আপনার আশেপাশের মসজিদ খুঁজতে লোকেশন এবং জামাতের আগে মনে করিয়ে দিতে নোটিফিকেশনের অনুমতি প্রয়োজন।';

  @override
  String get permLocation => 'লোকেশন';

  @override
  String get permLocationBody =>
      'নিকটতম মসজিদ খুঁজে বের করা ও সঠিক নামাজের সময় হিসাব করা।';

  @override
  String get permNotification => 'নোটিফিকেশন';

  @override
  String get permNotificationBody =>
      'ফলো করা মসজিদের জামাত রিমাইন্ডার ও নোটিশ।';

  @override
  String get permAllow => 'অনুমতি দিন';

  @override
  String get permGranted => 'অনুমোদিত';

  @override
  String get permOpenSettings => 'সেটিংস খুলুন';

  @override
  String get permLocationServiceOff =>
      'অনুগ্রহ করে ফোনের লোকেশন (GPS) চালু করুন।';

  @override
  String get permDeniedForever => 'অনুমতি দেওয়া হয়নি। সেটিংস থেকে চালু করুন।';

  @override
  String get permContinue => 'এগিয়ে যান';

  @override
  String get timeLeft => 'সময় বাকি';

  @override
  String get startsIn => 'শুরু হতে বাকি';

  @override
  String get allPrayers => 'সব নামাজ';

  @override
  String get nearestMasjid => 'নিকটতম মসজিদ';

  @override
  String get noMasjidNearby =>
      'আপনার কাছে এখনো কোনো যাচাইকৃত মসজিদ পাওয়া যায়নি।';

  @override
  String get noMasjidNearbyHint =>
      'মসজিদ কর্তৃপক্ষকে চেনেন? তাঁদের মুসলিমীনে মসজিদ নিবন্ধন করতে বলুন।';

  @override
  String minWalk(String minutes) {
    return '$minutes মিনিট হাঁটা';
  }

  @override
  String kmAway(String km) {
    return '$km কিমি দূরে';
  }

  @override
  String get jamatNotSet => 'জামাতের সময় দেওয়া হয়নি';

  @override
  String get nextJamat => 'পরবর্তী জামাত';

  @override
  String get notice => 'নোটিশ';

  @override
  String get notices => 'নোটিশ';

  @override
  String get noNotices => 'এখনো কোনো নোটিশ নেই।';

  @override
  String get all => 'সব';

  @override
  String get authorityTitle => 'মসজিদ কর্তৃপক্ষ';

  @override
  String get authorityBody =>
      'আপনার মসজিদ নিবন্ধন করুন এবং আশেপাশের মুসলিমদের এই অ্যাপে খুঁজে পেতে দিন।';

  @override
  String get yourLocation => 'আপনার লোকেশন';

  @override
  String get locating => 'লোকেশন খোঁজা হচ্ছে…';

  @override
  String get useCurrentLocation => 'বর্তমান লোকেশন ব্যবহার করুন';

  @override
  String get searchMasjid => 'মসজিদ খুঁজুন';

  @override
  String get nearbyMasjids => 'কাছের মসজিদ';

  @override
  String get fajr => 'ফজর';

  @override
  String get sunrise => 'সূর্যোদয়';

  @override
  String get dhuhr => 'যোহর';

  @override
  String get asr => 'আসর';

  @override
  String get maghrib => 'মাগরিব';

  @override
  String get isha => 'এশা';

  @override
  String get jumuah => 'জুমআ';

  @override
  String get forbiddenTime => 'নিষিদ্ধ সময়';

  @override
  String get forbiddenInfo =>
      'সূর্যোদয়ের সময়, সূর্য ঠিক মাথার উপরে থাকার সময় এবং সূর্যাস্তের সময় নামাজ পড়া নিষিদ্ধ।';

  @override
  String get morning => 'সকাল';

  @override
  String get noon => 'দুপুর';

  @override
  String get evening => 'সন্ধ্যা';

  @override
  String get naflPrayers => 'নফল নামাজ';

  @override
  String get tahajjud => 'তাহাজ্জুদ';

  @override
  String get duha => 'সালাতুদ দুহা';

  @override
  String get tahajjudHadith =>
      'রাসূলুল্লাহ (ﷺ) বলেছেন, \"আমাদের মহিমান্বিত ও বরকতময় রব প্রতি রাতে, যখন রাতের শেষ তৃতীয়াংশ বাকি থাকে, তখন নিকটতম আসমানে অবতরণ করেন এবং বলেন: \'কে আছে আমাকে ডাকবে, আমি তার ডাকে সাড়া দেব? কে আছে আমার কাছে চাইবে, আমি তাকে দেব? কে আছে আমার কাছে ক্ষমা চাইবে, আমি তাকে ক্ষমা করব?\'\"';

  @override
  String get tahajjudSource => 'সহিহ বুখারি ১১৪৫';

  @override
  String get duhaHadith1 =>
      'আবু হুরায়রা (রা.) বলেন: \"আমার বন্ধু রাসূলুল্লাহ (ﷺ) আমাকে তিনটি বিষয়ের উপদেশ দিয়েছেন: প্রতি মাসে তিন দিন রোজা রাখা, দুহার নামাজ পড়া এবং ঘুমানোর আগে বিতর পড়া।\"';

  @override
  String get duhaSource1 => 'সহিহ বুখারি ও মুসলিম';

  @override
  String get duhaHadith2 =>
      'নুআইম ইবনে হাম্মার (রা.) থেকে বর্ণিত, রাসূলুল্লাহ (ﷺ) বলেছেন, \"মহান আল্লাহ বলেন: হে আদম সন্তান! দিনের শুরুতে আমার জন্য চার রাকাত নামাজ পড়তে অপারগ হয়ো না, দিনের বাকি অংশে আমি তোমার জন্য যথেষ্ট হব।\"';

  @override
  String get duhaSource2 => 'সুনানে আবু দাউদ ১২৮৯';

  @override
  String get calcMethodNote =>
      'সময়গুলো আপনার লোকেশন অনুযায়ী হিসাব করা। জামাতের সময় প্রতিটি মসজিদ নির্ধারণ করে।';

  @override
  String get following => 'ফলো করছেন';

  @override
  String get follow => 'ফলো করুন';

  @override
  String get tabHome => 'হোম';

  @override
  String get tabNotice => 'নোটিশ';

  @override
  String get tabLive => 'লাইভ';

  @override
  String get tabAbout => 'সম্পর্কে';

  @override
  String get jamatTime => 'জামাতের সময়';

  @override
  String get maktabTime => 'মক্তবের সময়';

  @override
  String lastUpdated(String when) {
    return 'সর্বশেষ আপডেট $when';
  }

  @override
  String get today => 'আজ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String daysAgo(String count) {
    return '$count দিন আগে';
  }

  @override
  String get khatib => 'খতিব';

  @override
  String get imam => 'ইমাম';

  @override
  String get muazzin => 'মুয়াজ্জিন';

  @override
  String contact(String phone) {
    return 'যোগাযোগ: $phone';
  }

  @override
  String get notAdded => 'এখনো যোগ করা হয়নি';

  @override
  String get jamatReminder => 'জামাত রিমাইন্ডার';

  @override
  String get notifyBefore => 'কত আগে জানাবে';

  @override
  String minsBefore(String minutes) {
    return '$minutes মিনিট';
  }

  @override
  String get reminderOff => 'রিমাইন্ডার বন্ধ করুন';

  @override
  String reminderSet(String minutes) {
    return 'প্রতিটি জামাতের $minutes মিনিট আগে আপনাকে জানানো হবে।';
  }

  @override
  String followedToast(String name) {
    return 'আপনি এখন $name ফলো করছেন।';
  }

  @override
  String get directions => 'দিকনির্দেশনা';

  @override
  String get liveNow => 'এখন লাইভ';

  @override
  String get noLive => 'এখন কোনো লাইভ নেই';

  @override
  String get noLiveHint => 'মসজিদ খুতবা বা বয়ান লাইভ করলে এখানে দেখা যাবে।';

  @override
  String get watchLive => 'লাইভ দেখুন';

  @override
  String get liveLink => 'লাইভ লিংক (ইউটিউব / ফেসবুক)';

  @override
  String get liveToggle => 'আমরা এখন লাইভে আছি';

  @override
  String get maktabDays => 'মক্তবের দিন';

  @override
  String get weekdaysShort => 'শনি,রবি,সোম,মঙ্গল,বুধ,বৃহঃ,শুক্র';

  @override
  String get weekdaysLong =>
      'শনিবার,রবিবার,সোমবার,মঙ্গলবার,বুধবার,বৃহস্পতিবার,শুক্রবার';

  @override
  String dayRange(String from, String to) {
    return '$from ~ $to';
  }

  @override
  String get tapToSet => 'দিন';

  @override
  String get khatibName => 'খতিবের নাম';

  @override
  String get imamName => 'ইমামের নাম';

  @override
  String get muazzinName => 'মুয়াজ্জিনের নাম';

  @override
  String get contactNumber => 'যোগাযোগ নম্বর';

  @override
  String get updated => 'সফলভাবে আপডেট হয়েছে';

  @override
  String get writeNotice => 'নোটিশ লিখুন';

  @override
  String get selectCategory => 'ক্যাটাগরি নির্বাচন করুন';

  @override
  String get deleteNoticeQ => 'নোটিশটি মুছে ফেলবেন?';

  @override
  String get catJanaza => 'জানাজা';

  @override
  String get catRecruitment => 'নিয়োগ';

  @override
  String get catQuran => 'কুরআন ক্লাস';

  @override
  String get catQuranShort => 'কুরআন';

  @override
  String get catMahfil => 'মাহফিল';

  @override
  String get catTalim => 'তালিম';

  @override
  String get catTafsir => 'তাফসির';

  @override
  String get catGeneral => 'সাধারণ';

  @override
  String get janazaNotice => 'জানাজার নোটিশ';

  @override
  String noticeFormTitle(String category) {
    return '$category নোটিশ';
  }

  @override
  String get enterCarefully => 'অনুগ্রহ করে নিচের তথ্যগুলো সাবধানে দিন।';

  @override
  String get personName => 'মরহুম/মরহুমার নাম';

  @override
  String get fathersName => 'পিতার নাম';

  @override
  String get diedOn => 'মৃত্যুর তারিখ';

  @override
  String get address => 'ঠিকানা';

  @override
  String get janazaTime => 'জানাজার সময়';

  @override
  String get janazaDate => 'জানাজার তারিখ';

  @override
  String get noticeTitle => 'শিরোনাম';

  @override
  String get noticeDetails => 'বিস্তারিত';

  @override
  String get date => 'তারিখ';

  @override
  String get time => 'সময়';

  @override
  String deadline(String date) {
    return 'শেষ তারিখ: $date';
  }

  @override
  String startingDate(String date) {
    return 'শুরুর তারিখ: $date';
  }

  @override
  String timeAndDate(String value) {
    return 'সময় ও তারিখ: $value';
  }

  @override
  String janazaOf(String name) {
    return '$name-এর জানাজা';
  }

  @override
  String sonOf(String name) {
    return 'পিতা: $name';
  }

  @override
  String get noticePosted => 'নোটিশ পোস্ট হয়েছে';

  @override
  String get required => 'আবশ্যক';

  @override
  String get userAuth => 'ব্যবহারকারী যাচাই';

  @override
  String get userAuthBody =>
      'অনুগ্রহ করে পড়ুন এবং নিচের শর্তগুলো প্রযোজ্য হলে সম্মতি দিন।';

  @override
  String get rule1 =>
      'আমি মসজিদ কমিটির সদস্য অথবা মসজিদের খাদেম/মুয়াজ্জিন/ইমাম';

  @override
  String get rule2 => 'আমি নিয়মিত মসজিদের জামাতের সময় আপডেট করতে পারব';

  @override
  String get rule3 => 'আমি এই অ্যাপের উপকারিতা বুঝি';

  @override
  String get rule4 => 'আমি এই মুহূর্তে মসজিদের ভেতরে আছি';

  @override
  String get agreeAll => 'এগিয়ে যেতে সবগুলো শর্তে সম্মতি দিন।';

  @override
  String get registration => 'নিবন্ধন';

  @override
  String get verifyMobile => 'আপনার মোবাইল নম্বর যাচাই করুন';

  @override
  String get yourMobile => 'আপনার মোবাইল নম্বর';

  @override
  String get otpWillBeSent =>
      'যাচাইয়ের জন্য এই নম্বরে একটি ওটিপি (OTP) পাঠানো হবে';

  @override
  String get getOtp => 'ওটিপি নিন';

  @override
  String get invalidPhone => 'সঠিক বাংলাদেশি মোবাইল নম্বর দিন (01XXXXXXXXX)।';

  @override
  String get verification => 'যাচাইকরণ';

  @override
  String get typeOtp => 'আপনার ফোনে পাঠানো ওটিপি কোডটি লিখুন';

  @override
  String get otp => 'ওয়ান টাইম পাসওয়ার্ড (OTP)';

  @override
  String get didntGetOtp => 'ওটিপি পাননি?';

  @override
  String get resendCode => 'আবার পাঠান';

  @override
  String resendIn(String seconds) {
    return '$seconds সেকেন্ড পর আবার পাঠান';
  }

  @override
  String get verify => 'যাচাই করুন';

  @override
  String get invalidOtp => 'কোডটি সঠিক নয়। আবার চেষ্টা করুন।';

  @override
  String get demoOtpHint => 'ডেমো মোড: কোড 123456 ব্যবহার করুন';

  @override
  String get createMasjidProfile => 'মসজিদ প্রোফাইল তৈরি';

  @override
  String get stayInside =>
      'মসজিদের ভেতরে থাকুন এবং নিচের তথ্যগুলো সাবধানে দিন।';

  @override
  String get masjidName => 'মসজিদের নাম';

  @override
  String get district => 'জেলা';

  @override
  String get thana => 'থানা / উপজেলা';

  @override
  String get latLng => 'অক্ষাংশ ও দ্রাঘিমাংশ';

  @override
  String get load => 'লোড করুন';

  @override
  String get reload => 'আবার লোড';

  @override
  String get stayInsideLoading => 'লোড হওয়ার সময় মসজিদের ভেতরে থাকুন।';

  @override
  String accuracy(String meters) {
    return 'নির্ভুলতা ±$meters মি';
  }

  @override
  String accuracyTooLow(String meters) {
    return 'লোকেশন যথেষ্ট নির্ভুল নয় (±$meters মি)। মসজিদের ভেতরে খোলা জায়গায় গিয়ে আবার লোড করুন।';
  }

  @override
  String get loadLocationFirst => 'অনুগ্রহ করে মসজিদের লোকেশন লোড করুন।';

  @override
  String get nidNumber => 'আপনার এনআইডি নম্বর';

  @override
  String get invalidNid => 'এনআইডি ১০, ১৩ অথবা ১৭ সংখ্যার হতে হবে।';

  @override
  String get yourRole => 'আপনার দায়িত্ব';

  @override
  String get roleCommittee => 'কমিটির সদস্য';

  @override
  String get roleKhadem => 'খাদেম';

  @override
  String get roleMuazzin => 'মুয়াজ্জিন';

  @override
  String get roleImam => 'ইমাম';

  @override
  String get roleKhatib => 'খতিব';

  @override
  String get agreeTermsPrefix => 'আমি পড়েছি এবং সম্মত আছি ';

  @override
  String get termsAndConditions => 'শর্তাবলীতে';

  @override
  String get mustAgreeTerms => 'অনুগ্রহ করে শর্তাবলীতে সম্মতি দিন।';

  @override
  String duplicateFound(String name) {
    return 'এই লোকেশনে \"$name\" নামে একটি মসজিদ আগেই নিবন্ধিত আছে। আপনি এর কর্তৃপক্ষ হলে সাপোর্টে যোগাযোগ করুন।';
  }

  @override
  String limitReached(String count) {
    return 'আপনি সর্বোচ্চ $countটি মসজিদ প্রোফাইল রাখতে পারবেন।';
  }

  @override
  String get submittedTitle => 'যাচাইয়ের জন্য জমা হয়েছে';

  @override
  String get submittedBody =>
      'জাযাকাল্লাহু খাইরান! আমাদের টিম যাচাই করার পর আপনার মসজিদ প্রোফাইল সবার কাছে দৃশ্যমান হবে। অনুমোদন হলে আপনি নোটিফিকেশন পাবেন।';

  @override
  String get backToHome => 'হোমে ফিরে যান';

  @override
  String get termsBody =>
      '১. শুধুমাত্র মসজিদ কমিটির সদস্য, ইমাম, খতিব, মুয়াজ্জিন বা খাদেম মসজিদ প্রোফাইল তৈরি করতে পারবেন।\n২. সঠিক লোকেশনের জন্য প্রোফাইল অবশ্যই মসজিদের ভেতর থেকে তৈরি করতে হবে।\n৩. আপনার এনআইডি ও ফোন নম্বর শুধু যাচাইয়ের জন্য ব্যবহৃত হবে, কখনো প্রকাশ করা হবে না।\n৪. জামাতের সময় ও নোটিশ সঠিক এবং হালনাগাদ রাখতে হবে।\n৫. নোটিশ অবশ্যই মসজিদের কার্যক্রম সম্পর্কিত হতে হবে। রাজনৈতিক, বাণিজ্যিক বা বিদ্বেষমূলক কিছু পোস্ট করা যাবে না।\n৬. মুসলিমীন টিম যাচাই না করা পর্যন্ত প্রোফাইল প্রকাশ হবে না। ভুল তথ্যযুক্ত প্রোফাইল মুছে ফেলা হবে।';

  @override
  String get statusPending => 'যাচাই চলছে';

  @override
  String get statusApproved => 'অনুমোদিত';

  @override
  String get statusRejected => 'বাতিল';

  @override
  String get statusSuspended => 'স্থগিত';

  @override
  String get pendingBanner =>
      'এই প্রোফাইলটি যাচাইয়ের অপেক্ষায় আছে। শুধু আপনি এটি দেখতে পাচ্ছেন।';

  @override
  String rejectedBanner(String reason) {
    return 'এই প্রোফাইলটি অনুমোদিত হয়নি: $reason';
  }

  @override
  String get myMasjids => 'আমার মসজিদ';

  @override
  String get registerMasjid => 'মসজিদ নিবন্ধন করুন';

  @override
  String get appSettings => 'অ্যাপ সেটিংস';

  @override
  String get faq => 'সাধারণ জিজ্ঞাসা';

  @override
  String get aboutApp => 'অ্যাপ সম্পর্কে';

  @override
  String get shareApp => 'অ্যাপটি শেয়ার করুন';

  @override
  String get shareAppBody =>
      'এই অ্যাপটি আপনার পরিবার ও বন্ধুদেরও কাজে লাগতে পারে। শেয়ার করুন।';

  @override
  String shareText(String url) {
    return 'মুসলিমীন অ্যাপে আপনার কাছের মসজিদের জামাতের সময় দেখুন: $url';
  }

  @override
  String get language => 'ভাষা';

  @override
  String get calcMethod => 'নামাজের সময় গণনা পদ্ধতি';

  @override
  String get asrMethod => 'আসরের সময় গণনা';

  @override
  String get hanafi => 'হানাফি';

  @override
  String get shafi => 'শাফেয়ি / মালেকি / হাম্বলি';

  @override
  String get hijriAdjust => 'হিজরি তারিখ সমন্বয়';

  @override
  String days(String count) {
    return '$count দিন';
  }

  @override
  String get defaultReminder => 'ডিফল্ট জামাত রিমাইন্ডার';

  @override
  String get signOut => 'সাইন আউট';

  @override
  String signedInAs(String phone) {
    return '$phone নম্বরে সাইন ইন করা';
  }

  @override
  String version(String v) {
    return 'ভার্সন $v';
  }

  @override
  String get aboutBody =>
      'মুসলিমীন মুসলিমদের আশেপাশের মসজিদের জামাতের সময় জানতে সাহায্য করে। প্রতিটি মসজিদ প্রোফাইল সেই মসজিদের কর্তৃপক্ষ তৈরি করেন এবং প্রকাশের আগে আমাদের টিম যাচাই করে।';

  @override
  String get faqQ1 => 'জামাতের সময় কোথা থেকে আসে?';

  @override
  String get faqA1 =>
      'প্রতিটি মসজিদের কর্তৃপক্ষ নিজেরাই জামাতের সময় নির্ধারণ ও আপডেট করেন। নামাজের ওয়াক্ত শুরুর সময় আপনার লোকেশন অনুযায়ী হিসাব করা হয়।';

  @override
  String get faqQ2 => 'লোকেশন কেন আবশ্যক?';

  @override
  String get faqA2 =>
      'আপনার কাছের মসজিদ দেখাতে এবং সঠিক নামাজের সময় হিসাব করতে লোকেশন ব্যবহার করা হয়। এটি কারো সাথে শেয়ার করা হয় না।';

  @override
  String get faqQ3 => 'আমার মসজিদ কীভাবে যোগ করব?';

  @override
  String get faqA3 =>
      'আরও → মসজিদ নিবন্ধন করুন-এ যান। আপনাকে কমিটির সদস্য, ইমাম, মুয়াজ্জিন, খতিব বা খাদেম হতে হবে এবং নিবন্ধনের সময় মসজিদের ভেতরে থাকতে হবে।';

  @override
  String get faqQ4 => 'আমার মসজিদ কেন দেখা যাচ্ছে না?';

  @override
  String get faqA4 =>
      'নতুন প্রোফাইল প্রকাশের আগে আমাদের টিম যাচাই করে। সাধারণত ১–২ দিন সময় লাগে।';

  @override
  String get faqQ5 => 'জামাত রিমাইন্ডার কীভাবে কাজ করে?';

  @override
  String get faqA5 =>
      'মসজিদ খুলে জামাতের সময়ের ঘণ্টা আইকনে চাপ দিন। প্রতিটি জামাতের ১৫, ৩০ বা ৪৫ মিনিট আগে আপনাকে জানানো হবে, অ্যাপ বন্ধ থাকলেও।';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get noNotifications => 'মসজিদ ফলো করুন, তাদের নোটিশ এখানে দেখা যাবে।';

  @override
  String get adminPanel => 'অ্যাডমিন প্যানেল';

  @override
  String get adminPending => 'অপেক্ষমাণ';

  @override
  String get adminApproved => 'অনুমোদিত';

  @override
  String get adminRejected => 'বাতিল';

  @override
  String get approve => 'অনুমোদন';

  @override
  String get reject => 'বাতিল করুন';

  @override
  String get suspend => 'স্থগিত করুন';

  @override
  String get restore => 'পুনর্বহাল';

  @override
  String get rejectReason => 'বাতিলের কারণ';

  @override
  String get submittedBy => 'জমাদানকারী';

  @override
  String get phone => 'ফোন';

  @override
  String get nid => 'এনআইডি';

  @override
  String get role => 'দায়িত্ব';

  @override
  String get location => 'লোকেশন';

  @override
  String get openInMaps => 'ম্যাপে দেখুন';

  @override
  String get submittedOn => 'জমার তারিখ';

  @override
  String get nothingHere => 'এখানে কিছু নেই';

  @override
  String get approvedToast => 'মসজিদ অনুমোদিত হয়েছে';

  @override
  String get rejectedToast => 'মসজিদ বাতিল করা হয়েছে';

  @override
  String get verifiedChecklist =>
      'অনুমোদনের আগে জমাদানকারীকে ফোন করুন এবং ম্যাপে লোকেশন যাচাই করুন।';

  @override
  String get verse1Ar => 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ';

  @override
  String get verse1 => 'তোমরা ধৈর্য ও নামাজের মাধ্যমে সাহায্য প্রার্থনা কর';

  @override
  String get verse1Ref => 'আল-বাকারা ৪৫';

  @override
  String get verse2Ar =>
      'إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَّوْقُوتًا';

  @override
  String get verse2 =>
      'নিশ্চয়ই নির্ধারিত সময়ে নামাজ আদায় করা মুমিনদের উপর ফরজ';

  @override
  String get verse2Ref => 'আন-নিসা ১০৩';

  @override
  String get verse3Ar =>
      'حَافِظُوا عَلَى الصَّلَوَاتِ وَالصَّلَاةِ الْوُسْطَىٰ';

  @override
  String get verse3 =>
      'তোমরা নামাজসমূহের প্রতি যত্নবান হও, বিশেষ করে মধ্যবর্তী নামাজের';

  @override
  String get verse3Ref => 'আল-বাকারা ২৩৮';

  @override
  String get hijriMonths =>
      'মুহাররম,সফর,রবিউল আউয়াল,রবিউস সানি,জমাদিউল আউয়াল,জমাদিউস সানি,রজব,শাবান,রমজান,শাওয়াল,জিলকদ,জিলহজ';

  @override
  String get deadlineLabel => 'শেষ তারিখ';

  @override
  String get startingDateLabel => 'শুরুর তারিখ';

  @override
  String get masjidNameBn => 'মসজিদের নাম বাংলায় (ঐচ্ছিক)';

  @override
  String get createAccount => 'অ্যাকাউন্ট খুলুন';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get fullName => 'পূর্ণ নাম';

  @override
  String get email => 'ইমেইল';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get confirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get noAccount => 'অ্যাকাউন্ট নেই?';

  @override
  String get haveAccount => 'আগে থেকেই অ্যাকাউন্ট আছে?';

  @override
  String get signUpBody =>
      'মসজিদ ফলো করতে এবং আপনার সেটিংস নিরাপদ রাখতে অ্যাকাউন্ট খুলুন।';

  @override
  String get signInBody => 'আবার স্বাগতম! চালিয়ে যেতে সাইন ইন করুন।';

  @override
  String get resetPassword => 'পাসওয়ার্ড রিসেট';

  @override
  String get resetBody =>
      'যে ইমেইল দিয়ে অ্যাকাউন্ট খুলেছেন সেটি দিন। নতুন পাসওয়ার্ড দেওয়ার লিংক পাঠানো হবে।';

  @override
  String get sendResetLink => 'রিসেট লিংক পাঠান';

  @override
  String resetSent(String email) {
    return '$email-এ পাসওয়ার্ড রিসেট লিংক পাঠানো হয়েছে। ইনবক্স (এবং স্প্যাম ফোল্ডার) দেখুন।';
  }

  @override
  String get backToSignIn => 'সাইন ইনে ফিরে যান';

  @override
  String get invalidEmail => 'সঠিক ইমেইল ঠিকানা দিন।';

  @override
  String get passwordTooShort => 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে।';

  @override
  String get passwordsDontMatch => 'পাসওয়ার্ড মিলছে না।';

  @override
  String get errEmailInUse =>
      'এই ইমেইলে আগেই অ্যাকাউন্ট আছে। সাইন ইন করে দেখুন।';

  @override
  String get errInvalidCredential => 'ইমেইল বা পাসওয়ার্ড সঠিক নয়।';

  @override
  String get errWeakPassword =>
      'আরও শক্তিশালী পাসওয়ার্ড দিন (কমপক্ষে ৬ অক্ষর)।';

  @override
  String get errTooManyRequests =>
      'অনেকবার চেষ্টা করা হয়েছে। কয়েক মিনিট পর আবার চেষ্টা করুন।';

  @override
  String get errNetwork => 'ইন্টারনেট সংযোগ নেই। আবার চেষ্টা করুন।';

  @override
  String get errPhoneInUse =>
      'এই ফোন নম্বরটি অন্য একটি অ্যাকাউন্টের সাথে যুক্ত।';

  @override
  String get errUserDisabled =>
      'এই অ্যাকাউন্টটি বন্ধ করা হয়েছে। সাপোর্টে যোগাযোগ করুন।';

  @override
  String get myAccount => 'আমার অ্যাকাউন্ট';

  @override
  String get signInPrompt => 'মসজিদ কর্তৃপক্ষের জন্য';

  @override
  String get signInPromptBody =>
      'মসজিদ নিবন্ধন ও পরিচালনা করতে সাইন ইন করুন বা অ্যাকাউন্ট খুলুন। সাধারণ ব্যবহারকারীদের অ্যাকাউন্ট লাগবে না।';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get emailNotVerified => 'ইমেইল যাচাই হয়নি';

  @override
  String get emailVerified => 'ইমেইল যাচাইকৃত';

  @override
  String get resendVerification => 'যাচাইয়ের ইমেইল পাঠান';

  @override
  String verificationSent(String email) {
    return '$email-এ যাচাইয়ের ইমেইল পাঠানো হয়েছে।';
  }

  @override
  String get iVerified => 'যাচাই করেছি';

  @override
  String get changePassword => 'পাসওয়ার্ড পরিবর্তন';

  @override
  String get currentPassword => 'বর্তমান পাসওয়ার্ড';

  @override
  String get newPassword => 'নতুন পাসওয়ার্ড';

  @override
  String get passwordChanged => 'পাসওয়ার্ড সফলভাবে পরিবর্তন হয়েছে।';

  @override
  String get deleteAccount => 'অ্যাকাউন্ট মুছে ফেলুন';

  @override
  String get deleteAccountBody =>
      'এটি আপনার অ্যাকাউন্ট ও সংরক্ষিত তথ্য স্থায়ীভাবে মুছে ফেলবে। আপনার পরিচালিত মসজিদ প্রোফাইল থাকবে কিন্তু আপনি আর অ্যাক্সেস পাবেন না। নিশ্চিত করতে পাসওয়ার্ড দিন।';

  @override
  String get accountDeleted => 'আপনার অ্যাকাউন্ট মুছে ফেলা হয়েছে।';

  @override
  String get phoneNumber => 'ফোন';

  @override
  String get notVerified => 'যাচাই হয়নি';

  @override
  String welcomeUser(String name) {
    return 'স্বাগতম, $name!';
  }

  @override
  String get signInToRegister =>
      'মসজিদ নিবন্ধন করতে সাইন ইন করুন বা অ্যাকাউন্ট খুলুন।';

  @override
  String get verifyPhoneToContinue =>
      'মসজিদ নিবন্ধন করতে আপনার ফোন নম্বর যাচাই করুন।';

  @override
  String accountCreated(String email) {
    return 'অ্যাকাউন্ট খোলা হয়েছে! $email-এ যাচাইয়ের লিংক পাঠানো হয়েছে।';
  }

  @override
  String get nameRequired => 'অনুগ্রহ করে আপনার নাম দিন।';

  @override
  String get credits => 'কৃতজ্ঞতা';

  @override
  String get fontCredits =>
      'লোগো ও নামাজের নাম: Omnibus-Type-এর Grenze Gotisch। লেখা: Indian Type Foundry ও Jonny Pinhorn-এর Poppins, Indian Type Foundry-এর Hind Siliguri, Black Foundry-এর Galada, খালেদ হোসনির Amiri। সব ফন্ট SIL Open Font License 1.1-এর অধীনে ফ্রি।';

  @override
  String get designInspired =>
      'মূল ডিজাইন ফন্ট: Anthonie Van Hayu (ARToni)-এর Hidayatullah।';

  @override
  String get openSourceLicenses => 'ওপেন-সোর্স লাইসেন্স';

  @override
  String get continueWithGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get orDivider => 'অথবা';

  @override
  String get onb3Title => 'নামাজের সময় ও রিমাইন্ডার';

  @override
  String get onb3Body =>
      'আপনার লোকেশন অনুযায়ী সঠিক নামাজের সময়, আর ফলো করা মসজিদের প্রতিটি জামাতের আগে রিমাইন্ডার।';

  @override
  String get appVersion => 'অ্যাপ ভার্সন';

  @override
  String get checkingUpdates => 'আপডেট খোঁজা হচ্ছে…';

  @override
  String get upToDate => 'আপনার কাছে সর্বশেষ ভার্সন আছে।';

  @override
  String updateAvailable(String version) {
    return 'নতুন ভার্সন $version এসেছে';
  }

  @override
  String get downloadLatestApk => 'সর্বশেষ APK ডাউনলোড করুন';

  @override
  String get updateApkHint =>
      'ডাউনলোড হওয়া ফাইলটি খুলে এই ভার্সনের উপর ইনস্টল করুন। আপনার সেটিংস থেকে যাবে।';

  @override
  String get updateIosButton => 'আইফোনে কীভাবে আপডেট করবেন';

  @override
  String get updateCheckFailed => 'আপডেট খোঁজা যায়নি। ইন্টারনেট সংযোগ দেখুন।';

  @override
  String get releaseNotes => 'রিলিজ নোট';

  @override
  String get selectAll => 'সবগুলো নির্বাচন করুন';
}
