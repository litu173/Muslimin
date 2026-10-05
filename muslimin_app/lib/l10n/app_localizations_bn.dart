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
  String get done => 'শেষ';

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
  String get rule4 => 'আমি মসজিদের সঠিক লোকেশন চিহ্নিত করব';

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
      'নিচের তথ্যগুলো সাবধানে দিন। লোকেশন মসজিদের ভেতর থেকে বা ম্যাপ থেকে দিতে পারেন।';

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
  String get loadLocationFirst => 'মসজিদের লোকেশন দিন।';

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
  String get verse1Ar => 'وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ';

  @override
  String get verse1 => 'আর তোমরা ধৈর্য ও সালাতের মাধ্যমে সাহায্য প্রার্থনা করো';

  @override
  String get verse1Ref => 'সূরা আল-বাকারা ২:৪৫';

  @override
  String get verse2Ar =>
      'إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَـٰبًا مَّوْقُوتًا';

  @override
  String get verse2 =>
      'নির্ধারিত সময়ে সালাত কায়েম করা মুমিনদের জন্য অবশ্য কর্তব্য';

  @override
  String get verse2Ref => 'সূরা আন-নিসা ৪:১০৩';

  @override
  String get verse3Ar =>
      'حَـٰفِظُوا۟ عَلَى ٱلصَّلَوَٰتِ وَٱلصَّلَوٰةِ ٱلْوُسْطَىٰ';

  @override
  String get verse3 =>
      'তোমরা সালাতের প্রতি যত্নবান হবে, বিশেষত মধ্যবর্তী সালাতের';

  @override
  String get verse3Ref => 'সূরা আল-বাকারা ২:২৩৮';

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
      'লোগো ও ইংরেজি নামাজের নাম: Muslimin ডিজাইনের লেটারিং, Anthonie Van Hayu (ARToni)-এর Hidayatullah অবলম্বনে। ফন্ট: Omnibus-Type-এর Grenze Gotisch, Indian Type Foundry ও Jonny Pinhorn-এর Poppins, Indian Type Foundry-এর Hind Siliguri, Ek Type-এর Anek Bangla (বাংলা সংখ্যা), Black Foundry-এর Galada, SIL International-এর Scheherazade New। সব ফন্ট SIL Open Font License 1.1-এর অধীনে ফ্রি।';

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

  @override
  String get welcomeTitle => 'আসসালামু আলাইকুম';

  @override
  String get welcomeBody =>
      'আপনার মসজিদ ফলো করতে, জামাত রিমাইন্ডার পেতে এবং সব ফোনে সিঙ্ক রাখতে সাইন ইন করুন।';

  @override
  String get continueAsGuest => 'অতিথি হিসেবে চালিয়ে যান';

  @override
  String get editMasjidInfo => 'মসজিদের তথ্য এডিট';

  @override
  String get editMasjidInfoBody =>
      'মসজিদ প্রোফাইলের তথ্য আপডেট করুন, লোকেশনসহ (মসজিদে GPS দিয়ে বা ম্যাপ থেকে)।';

  @override
  String get followedMasjids => 'ফলো করা মসজিদ';

  @override
  String get noFollowed => 'আপনি এখনো কোনো মসজিদ ফলো করেননি।';

  @override
  String get noFollowedHint =>
      'মসজিদ খুলে ফলো চাপুন — এখানে দেখা যাবে এবং নোটিশ পাবেন।';

  @override
  String reminderBadge(String minutes) {
    return 'রিমাইন্ডার $minutes মিনিট';
  }

  @override
  String get manageMasjids => 'মসজিদ পরিচালনা';

  @override
  String get noMyMasjids => 'আপনি এখনো কোনো মসজিদ নিবন্ধন করেননি।';

  @override
  String get noMyMasjidsHint =>
      'কমিটির সদস্য, ইমাম, খতিব, মুয়াজ্জিন বা খাদেম তাঁদের মসজিদ নিবন্ধন করতে পারবেন। প্রকাশের আগে আমাদের টিম যাচাই করে।';

  @override
  String get appearance => 'থিম';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get appearanceHint =>
      'ফজর ও এশার সময় ডার্ক মোড চোখের জন্য আরামদায়ক।';

  @override
  String get pullToRefresh => 'রিফ্রেশ করতে নিচে টানুন';

  @override
  String get verifyAutoCheck =>
      'ইমেইলে পাঠানো লিংকটি খুলুন — যাচাই হলে এই পেজ নিজেই আপডেট হবে।';

  @override
  String get signOutTitle => 'সাইন আউট করবেন?';

  @override
  String get signOutBody =>
      'এই ফোনে ফলো করা মসজিদ দেখতে ও জামাতের রিমাইন্ডার পেতে আবার সাইন ইন করতে হবে।';

  @override
  String jamatLine(String prayer, String time) {
    return '$prayer জামাত $time';
  }

  @override
  String get scanBoard => 'টাইম বোর্ড স্ক্যান';

  @override
  String get scanBoardHint =>
      'মসজিদের টাইম বোর্ডের ছবি তুলুন, সব জামাতের সময় নিজে থেকেই বসে যাবে — অথবা সময়ে চাপ দিয়ে নিজে ঠিক করুন।';

  @override
  String get takePhoto => 'ছবি তুলুন';

  @override
  String get chooseGallery => 'গ্যালারি থেকে নিন';

  @override
  String get scanStage1 => 'টাইম বোর্ড দেখছি…';

  @override
  String get scanStage2 => 'সংখ্যাগুলো পড়ছি…';

  @override
  String get scanStage3 => 'ফজর থেকে এশা মিলিয়ে দেখছি…';

  @override
  String get scanStage4 => 'জুম\'আর সময় দেখছি…';

  @override
  String scanFound(String count) {
    return '$countটি সময় পাওয়া গেছে';
  }

  @override
  String get scanFailed =>
      'ছবিটি পড়া যায়নি। বোর্ডের পরিষ্কার, সোজা ছবি তুলে আবার চেষ্টা করুন, অথবা নিজে সময় দিন।';

  @override
  String get enterManually => 'নিজে দিন';

  @override
  String get scanReview =>
      'ছবি থেকে সময় বসানো হয়েছে (✦ চিহ্নিত)। যাচাই করে আপডেট চাপুন।';

  @override
  String get tabRead => 'পড়ুন';

  @override
  String get readQuran => 'কুরআন পড়ুন';

  @override
  String get journeySub => '১১৪টি সূরা জুড়ে আপনার যাত্রা';

  @override
  String surahsProgress(String done) {
    return '১১৪টির মধ্যে $doneটি সূরা';
  }

  @override
  String get versesRead => 'আয়াত পড়া হয়েছে';

  @override
  String get phasesDone => 'ধাপ সম্পন্ন';

  @override
  String get continueReading => 'চালিয়ে যান';

  @override
  String get startReading => 'পড়া শুরু করুন';

  @override
  String phaseN(String n) {
    return 'ধাপ $n';
  }

  @override
  String versesN(String n) {
    return '$n আয়াত';
  }

  @override
  String get completed => 'সম্পন্ন';

  @override
  String get locked => 'লক করা';

  @override
  String ayahOf(String n, String total) {
    return 'আয়াত $n / $total';
  }

  @override
  String unlockHint(String surah) {
    return 'এই সূরা খুলতে আগে $surah শেষ করুন।';
  }

  @override
  String get quizUnlockHint => 'কুইজ খুলতে এই ধাপের সব সূরা পড়ুন।';

  @override
  String phaseQuiz(String n) {
    return 'ধাপ $n কুইজ';
  }

  @override
  String get quizOptional => 'ঐচ্ছিক · যা পড়েছেন তা যাচাই করুন';

  @override
  String bestScore(String score) {
    return 'সেরা $score%';
  }

  @override
  String get makki => 'মাক্কী';

  @override
  String get madani => 'মাদানী';

  @override
  String get loadingSurah => 'সূরা আনা হচ্ছে…';

  @override
  String get completeSurah => 'এই সূরা পড়া শেষ';

  @override
  String get nextSurah => 'পরের সূরা';

  @override
  String surahDone(String name) {
    return 'মাশাআল্লাহ! আপনি সূরা $name পড়া শেষ করেছেন।';
  }

  @override
  String nextUnlocked(String name) {
    return '$name এখন খোলা।';
  }

  @override
  String get takeQuiz => 'ধাপের কুইজ দিন';

  @override
  String get later => 'পরে';

  @override
  String get wordByWord => 'শব্দে শব্দে';

  @override
  String get quranSource =>
      'মুসহাফের টেক্সট ও শব্দার্থ: quran.com (বাদশাহ ফাহাদ কমপ্লেক্সের উসমানী লিপি) · অনুবাদ: ড. আবু বকর মুহাম্মাদ যাকারিয়া';

  @override
  String get startHere => 'শুরু';

  @override
  String get quizWordMeaning => 'এই শব্দের অর্থ কী?';

  @override
  String get quizAyahMeaning => 'এই আয়াতের অর্থ কী?';

  @override
  String get quizWhichSurah => 'এই আয়াতটি কোন সূরার?';

  @override
  String quizRevealed(String name) {
    return 'সূরা $name কোথায় নাযিল হয়েছে?';
  }

  @override
  String get makkah => 'মক্কা';

  @override
  String get madinah => 'মদিনা';

  @override
  String quizVerses(String name) {
    return 'সূরা $name-এ কয়টি আয়াত আছে?';
  }

  @override
  String quizNameMeans(String name) {
    return '“$name” নামের অর্থ কী?';
  }

  @override
  String get kindVocabulary => 'শব্দভান্ডার';

  @override
  String get kindMeaning => 'অর্থ';

  @override
  String get kindSurah => 'কোন সূরা';

  @override
  String get kindFacts => 'সূরার তথ্য';

  @override
  String get quizCorrect => 'সঠিক — মাশাআল্লাহ!';

  @override
  String get quizWrong => 'হয়নি — সঠিক উত্তরটি চিহ্নিত করা হলো।';

  @override
  String get continueBtn => 'চালিয়ে যান';

  @override
  String quizScore(String score) {
    return 'আপনার স্কোর $score%';
  }

  @override
  String get quizDoneBody =>
      'কুইজ ঐচ্ছিক — যা পড়েছেন তা মনে রাখতে সাহায্য করে।';

  @override
  String get quizLoading => 'কুইজ তৈরি হচ্ছে…';

  @override
  String get tabQuran => 'কুরআন';

  @override
  String get tabDua => 'দো‘আ';

  @override
  String get specialSurahs => 'নিয়মিত পড়ার সূরা';

  @override
  String get chipMulk => 'আল-মুলক';

  @override
  String get chipMulkWhen => 'ঘুমের আগে';

  @override
  String get chipSajdah => 'আস-সাজদা';

  @override
  String get chipKahf => 'আল-কাহফ';

  @override
  String get chipKahfWhen => 'জুমু‘আর দিন';

  @override
  String get chipKursi => 'আয়াতুল কুরসী';

  @override
  String get chipKursiWhen => 'সালাত ও ঘুমের পর';

  @override
  String get chipBaqarahEnd => 'আল-বাকারার শেষ ২ আয়াত';

  @override
  String get chipNight => 'রাতে';

  @override
  String get chipYasin => 'ইয়াসীন';

  @override
  String get chipQuls => 'তিন কুল';

  @override
  String get chipQulsWhen => 'সকাল-সন্ধ্যা';

  @override
  String get chipAnytime => 'যেকোনো সময়';

  @override
  String get chipToday => 'আজ';

  @override
  String get chipTonight => 'আজ রাতে';

  @override
  String get revealedMakkah => 'মক্কায় অবতীর্ণ';

  @override
  String get revealedMadinah => 'মদিনায় অবতীর্ণ';

  @override
  String get reciter => 'ক্বারী';

  @override
  String get chooseReciter => 'ক্বারী বেছে নিন';

  @override
  String get playAyah => 'এই আয়াত থেকে শুনুন';

  @override
  String recitingAyah(String n, String total) {
    return 'আয়াত $n / $total';
  }

  @override
  String get audioError => 'তিলাওয়াত লোড হয়নি। ইন্টারনেট সংযোগ দেখুন।';

  @override
  String get dailyQuran => 'দৈনিক কুরআন';

  @override
  String get energy0 => 'আজ আপনার অন্তর আলোর অপেক্ষায়';

  @override
  String get energy1 => 'চার্জ হচ্ছে… আরও কয়েকটি আয়াত';

  @override
  String get energy2 => 'প্রায় পূর্ণ — চালিয়ে যান!';

  @override
  String get energy3 => 'আলোয় পূর্ণ — মাশাআল্লাহ!';

  @override
  String get energy4 => 'আজ উজ্জ্বল আলোয় ভরপুর ✨';

  @override
  String versesToday(String n, String goal) {
    return 'আজ $n / $goal আয়াত';
  }

  @override
  String streakDays(String n) {
    return '$n দিনের ধারাবাহিকতা';
  }

  @override
  String get readNow => 'এখন পড়ুন';

  @override
  String get keepReading => 'আরও পড়ুন';

  @override
  String get achievements => 'অর্জন';

  @override
  String achievementsCount(String n, String total) {
    return '$totalটির মধ্যে $nটি অর্জিত';
  }

  @override
  String achievementEarned(String date) {
    return '$date তারিখে অর্জিত';
  }

  @override
  String achievementLocked(String done, String target) {
    return 'চলমান · $done/$target';
  }

  @override
  String achievementUnlocked(String name) {
    return 'নতুন অর্জন: $name';
  }

  @override
  String get ach_bismillah => 'বিসমিল্লাহ';

  @override
  String get ach_bismillah_desc => 'প্রথম আয়াত পড়ুন';

  @override
  String get ach_fatiha => 'সূচনা';

  @override
  String get ach_fatiha_desc => 'সূরা আল-ফাতিহা সম্পূর্ণ করুন';

  @override
  String get ach_quls => 'তিন কুল';

  @override
  String get ach_quls_desc => 'আল-ইখলাস, আল-ফালাক ও আন-নাস সম্পূর্ণ করুন';

  @override
  String get ach_streak3 => 'দৃঢ় পদক্ষেপ';

  @override
  String get ach_streak3_desc => 'টানা ৩ দিন কুরআন পড়ুন';

  @override
  String get ach_streak7 => 'আলোর সপ্তাহ';

  @override
  String get ach_streak7_desc => 'টানা ৭ দিন কুরআন পড়ুন';

  @override
  String get ach_streak30 => 'নূরের মাস';

  @override
  String get ach_streak30_desc => 'টানা ৩০ দিন কুরআন পড়ুন';

  @override
  String get ach_verses100 => 'একশো আয়াত';

  @override
  String get ach_verses100_desc => '১০০টি আয়াত পড়ুন';

  @override
  String get ach_verses1000 => 'এক হাজার আয়াত';

  @override
  String get ach_verses1000_desc => '১,০০০টি আয়াত পড়ুন';

  @override
  String get ach_kahf => 'জুমু‘আর আলো';

  @override
  String get ach_kahf_desc => 'জুমু‘আর দিনে সূরা আল-কাহফ সম্পূর্ণ করুন';

  @override
  String get ach_mulk => 'রাতের পাহারাদার';

  @override
  String get ach_mulk_desc => 'রাতে সূরা আল-মুলক সম্পূর্ণ করুন';

  @override
  String get ach_yasin => 'ইয়াসীন';

  @override
  String get ach_yasin_desc => 'সূরা ইয়াসীন সম্পূর্ণ করুন';

  @override
  String get ach_listener => 'মনোযোগী শ্রোতা';

  @override
  String get ach_listener_desc => 'একটি পূর্ণ সূরার তিলাওয়াত শুনুন';

  @override
  String get ach_quiz100 => 'তীক্ষ্ণ মেধা';

  @override
  String get ach_quiz100_desc => 'কোনো ধাপের কুইজে ১০০% পান';

  @override
  String get ach_juzamma => 'আম্মা পারা';

  @override
  String get ach_juzamma_desc => '৩০তম পারার ৩৭টি সূরা সম্পূর্ণ করুন';

  @override
  String get ach_phases10 => 'দশ ধাপ';

  @override
  String get ach_phases10_desc => 'যাত্রার ১০টি ধাপ সম্পূর্ণ করুন';

  @override
  String get ach_khatm => 'খতমে কুরআন';

  @override
  String get ach_khatm_desc => '১১৪টি সূরা সম্পূর্ণ করুন';

  @override
  String get duaHeader => 'আল্লাহর স্মরণে একটি দিন';

  @override
  String get duaSub =>
      'ঘুম থেকে জাগা থেকে ঘুমাতে যাওয়া — প্রতিটি মুহূর্তের জন্য নবী ﷺ-এর শেখানো দো‘আ।';

  @override
  String repeatTimes(String n) {
    return '$n বার';
  }

  @override
  String duaSource(String n) {
    return 'হিসনুল মুসলিম #$n';
  }

  @override
  String get duaCredit =>
      'দো‘আগুলো সা‘ঈদ ইবন আলী আল-কাহতানীর “হিসনুল মুসলিম” থেকে, এর অফিসিয়াল সাইট hisnmuslim.com অনুযায়ী।';

  @override
  String get nowLabel => 'এখন';

  @override
  String get scene_wake => 'ঘুম থেকে জাগা';

  @override
  String get scene_wake_story =>
      'দিনের শুরু কৃতজ্ঞতায় — ঘুমের পর আল্লাহ রূহ ফিরিয়ে দিলেন।';

  @override
  String get scene_restroom => 'প্রয়োজন সারতে';

  @override
  String get scene_restroom_story =>
      'ছোট্ট দৈনন্দিন কাজও শুরু হয় আল্লাহর আশ্রয় চেয়ে।';

  @override
  String get scene_wudu => 'অযু';

  @override
  String get scene_wudu_story =>
      'হাতে পানি, মুখে তাঁর নাম — আল্লাহর সামনে দাঁড়ানোর প্রস্তুতি।';

  @override
  String get scene_dress => 'কাপড় পরা';

  @override
  String get scene_dress_story =>
      'প্রতিটি পোশাক এক নি‘আমত — যিনি পরিয়েছেন তাঁর শুকরিয়া।';

  @override
  String get scene_athan => 'আযান';

  @override
  String get scene_athan_story =>
      'মহল্লা জুড়ে আযানের ধ্বনি — জবাব দিন, তারপর নবী ﷺ-এর জন্য দো‘আ করুন।';

  @override
  String get scene_masjid => 'মসজিদের পথে';

  @override
  String get scene_masjid_story =>
      'মসজিদের দিকে প্রতিটি পদক্ষেপ আলো — দো‘আ পড়ে প্রবেশ করুন ও বের হোন।';

  @override
  String get scene_after_salah => 'সালাতের পর';

  @override
  String get scene_after_salah_story =>
      'তাড়াহুড়ো না করে সালাতের পরের যিকিরে একটু বসুন।';

  @override
  String get scene_morning => 'সকালের যিকির';

  @override
  String get scene_morning_story =>
      'যে কথাগুলো সন্ধ্যা পর্যন্ত আপনাকে হেফাযত করে।';

  @override
  String get scene_eating => 'খাবার';

  @override
  String get scene_eating_story => 'শুরু তাঁর নামে, শেষ তাঁর প্রশংসায়।';

  @override
  String get scene_leave_home => 'ঘর থেকে বের হওয়া';

  @override
  String get scene_leave_home_story =>
      'দরজায় দাঁড়িয়ে পুরো দিনটা আল্লাহর ওপর সঁপে দিন।';

  @override
  String get scene_travel => 'পথে';

  @override
  String get scene_travel_story =>
      'বাস, রিকশা বা গাড়ি — উঠতে আল্লাহু আকবার, নামতে সুবহানাল্লাহ।';

  @override
  String get scene_meeting => 'মানুষের সাথে দেখা';

  @override
  String get scene_meeting_story =>
      'সালাম ছড়িয়ে দিন, ভাইয়ের হাঁচির জবাব দিন।';

  @override
  String get scene_good_news => 'ভালো কিছু হলে';

  @override
  String get scene_good_news_story =>
      'আনন্দ দাতার কথা মনে করিয়ে দেয় — তাঁর প্রশংসা করুন, মানুষেরও শুকরিয়া জানান।';

  @override
  String get scene_hardship => 'কঠিন সময়ে';

  @override
  String get scene_hardship_story =>
      'দুশ্চিন্তা, কাঠিন্য বা ব্যর্থতা — আগে তাঁর দিকে ফিরুন।';

  @override
  String get scene_patience => 'বিপদ ও সবর';

  @override
  String get scene_patience_story => 'কিছু হারালে মনে রাখুন — আমরা আল্লাহরই।';

  @override
  String get scene_anger => 'রাগ সামলানো';

  @override
  String get scene_anger_story => 'আফসোসের কথা বলার আগে আশ্রয় চান।';

  @override
  String get scene_pain => 'ব্যথা ও অসুস্থতা';

  @override
  String get scene_pain_story => 'নিজের কষ্টে এবং অসুস্থ বন্ধুকে দেখতে গেলে।';

  @override
  String get scene_rain => 'বৃষ্টি হলে';

  @override
  String get scene_rain_story => 'বৃষ্টি রহমত — উপকারী বৃষ্টি প্রার্থনা করুন।';

  @override
  String get scene_home => 'ঘরে ফেরা';

  @override
  String get scene_home_story => 'তাঁর নামে প্রবেশ করুন, পরিবারকে সালাম দিন।';

  @override
  String get scene_gathering => 'মজলিস শেষে';

  @override
  String get scene_gathering_story =>
      'উঠে যাওয়ার আগে কথার ভুলগুলোর কাফফারা দিন।';

  @override
  String get scene_forgiveness => 'ক্ষমা প্রার্থনা';

  @override
  String get scene_forgiveness_story => 'দিনের ভুলগুলো ইস্তিগফারে ধুয়ে নিন।';

  @override
  String get scene_sleep => 'ঘুমের আগে';

  @override
  String get scene_sleep_story =>
      'দিন যেভাবে শুরু হয়েছিল সেভাবেই শেষ — তাঁর নামে, তাঁর আশ্রয়ে।';

  @override
  String get scene_night => 'রাতে';

  @override
  String get scene_night_story =>
      'রাতে জেগে উঠলে বা খারাপ স্বপ্ন দেখলে — তিনি কাছেই আছেন।';

  @override
  String get part_dawn => 'ভোর';

  @override
  String get part_morning => 'সকাল';

  @override
  String get part_day => 'দিন';

  @override
  String get part_evening => 'সন্ধ্যা';

  @override
  String get part_night => 'রাত';

  @override
  String get removeSession => 'মুছে ফেলুন';

  @override
  String addSession(String session) {
    return '$session যোগ করুন';
  }

  @override
  String get duaSearchHint => 'দো‘আ খুঁজুন';

  @override
  String duaPartCount(String topics, String duas) {
    return '$topicsটি বিষয় · $duasটি দো‘আ';
  }

  @override
  String duaNoResults(String q) {
    return '“$q” দিয়ে কোনো দো‘আ পাওয়া যায়নি';
  }

  @override
  String duaResults(int n) {
    return '$nটি দো‘আ পাওয়া গেছে';
  }

  @override
  String get part_dawn_sub => 'জাগরণ, অযু ও ফজর';

  @override
  String get part_morning_sub => 'যিকির, খাবার ও বের হওয়া';

  @override
  String get part_day_sub => 'মানুষ, আনন্দ ও পরীক্ষা';

  @override
  String get part_evening_sub => 'ঘর, মজলিস, ইস্তিগফার';

  @override
  String get part_night_sub => 'ঘুম ও রাত';

  @override
  String duaCount(int n) {
    return '$nটি দো‘আ';
  }

  @override
  String get noticeSearchHint => 'নোটিশ, মসজিদ খুঁজুন…';

  @override
  String get noticesSub => 'আশেপাশের মসজিদ থেকে';

  @override
  String get tabNotices => 'নোটিশ';

  @override
  String get chooseSurah => 'সূরা বেছে নিন';

  @override
  String get surahSearchHint => 'নাম বা নম্বর দিয়ে সূরা খুঁজুন';

  @override
  String get previousSurah => 'আগের সূরা';

  @override
  String get pickOnMapTitle => 'ম্যাপে বেছে নিন';

  @override
  String get mapSearchHint => 'মসজিদ বা এলাকা খুঁজুন';

  @override
  String get useMyLocation => 'আমার লোকেশন';

  @override
  String get mapPickHint =>
      'পিনটি মসজিদের ওপর আনতে ম্যাপ সরান, কোনো জায়গায় চাপ দিন, অথবা মসজিদের আইকনে চাপ দিন।';

  @override
  String get mapMoving => 'জায়গাটি খোঁজা হচ্ছে…';

  @override
  String get useThisLocation => 'এই লোকেশন ব্যবহার করুন';

  @override
  String get masjidLocation => 'মসজিদের লোকেশন';

  @override
  String get chooseLocationWay =>
      'সঠিক লোকেশন দিতে যেকোনো একটি উপায় বেছে নিন:';

  @override
  String get atTheMasjid => 'আমি মসজিদে আছি';

  @override
  String get atTheMasjidBody =>
      'ফোনের GPS ব্যবহার করুন। লোড হওয়া পর্যন্ত মসজিদের ভেতরে থাকুন।';

  @override
  String get onTheMap => 'ম্যাপে বেছে নিন';

  @override
  String get onTheMapBody =>
      'ম্যাপে মসজিদটি চিহ্নিত করুন, বা দেখানো মসজিদে চাপ দিন।';

  @override
  String get locFromMap => 'ম্যাপ থেকে নেওয়া';

  @override
  String get locFromGps => 'GPS';

  @override
  String get locSaved => 'সংরক্ষিত লোকেশন';

  @override
  String get useGpsInstead => 'GPS ব্যবহার';

  @override
  String get adjustOnMap => 'ম্যাপে ঠিক করুন';

  @override
  String get allMasjids => 'সব মসজিদ';

  @override
  String get nearestFirst => 'কাছের মসজিদ আগে';
}
