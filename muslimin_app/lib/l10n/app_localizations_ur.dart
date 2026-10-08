// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class L10nUr extends L10n {
  L10nUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'Muslimin';

  @override
  String get tagline => 'امتِ مسلمہ کا ایک دن';

  @override
  String get next => 'آگے';

  @override
  String get skip => 'چھوڑیں';

  @override
  String get cancel => 'منسوخ';

  @override
  String get getStarted => 'شروع کریں';

  @override
  String get create => 'بنائیں';

  @override
  String get update => 'اپ ڈیٹ';

  @override
  String get edit => 'ترمیم';

  @override
  String get post => 'پوسٹ';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get select => 'منتخب کریں';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get close => 'بند کریں';

  @override
  String get delete => 'حذف کریں';

  @override
  String get done => 'ہو گیا';

  @override
  String get viewAll => 'سب دیکھیں';

  @override
  String get viewDetails => 'تفصیل دیکھیں';

  @override
  String get dontShowAgain => 'دوبارہ نہ دکھائیں';

  @override
  String get share => 'شیئر کریں';

  @override
  String get addNew => 'نیا شامل کریں';

  @override
  String get now => 'ابھی';

  @override
  String get selected => 'منتخب';

  @override
  String get home => 'ہوم';

  @override
  String get more => 'مزید';

  @override
  String get loading => 'لوڈ ہو رہا ہے…';

  @override
  String get somethingWrong => 'کچھ غلط ہو گیا۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get onb1Title => 'جماعت کے اوقات شیئر کریں';

  @override
  String get onb1Body =>
      'آس پاس کے لوگ اس ایپ میں مسجد کی جماعت کے اوقات دیکھ سکیں گے۔';

  @override
  String get onb2Title => 'مسجد کا اعلان پوسٹ کریں';

  @override
  String get onb2Body =>
      'لوگ اس ایپ میں مسجد کے اعلانات دیکھ سکیں گے، جس سے انہیں مختلف مواقع میں شریک ہونے میں مدد ملے گی۔';

  @override
  String get permTitle => 'جاری رکھنے کے لیے اجازت دیں';

  @override
  String get permBody =>
      'مسلمین کو آپ کے قریب کی مساجد تلاش کرنے کے لیے آپ کا مقام اور جماعت سے پہلے یاد دہانی کے لیے نوٹیفکیشن درکار ہیں۔';

  @override
  String get permLocation => 'مقام';

  @override
  String get permLocationBody =>
      'قریب ترین مساجد تلاش کریں اور نماز کے درست اوقات معلوم کریں۔';

  @override
  String get permNotification => 'نوٹیفکیشن';

  @override
  String get permNotificationBody =>
      'جن مساجد کو آپ فالو کرتے ہیں ان کی جماعت کی یاد دہانیاں اور اعلانات۔';

  @override
  String get permAllow => 'اجازت دیں';

  @override
  String get permGranted => 'اجازت دی گئی';

  @override
  String get permOpenSettings => 'سیٹنگز کھولیں';

  @override
  String get permLocationServiceOff =>
      'براہِ کرم اپنے فون میں لوکیشن (GPS) آن کریں۔';

  @override
  String get permDeniedForever =>
      'اجازت نہیں دی گئی۔ براہِ کرم سیٹنگز سے اسے فعال کریں۔';

  @override
  String get permContinue => 'جاری رکھیں';

  @override
  String get timeLeft => 'باقی وقت';

  @override
  String get startsIn => 'شروع ہونے میں';

  @override
  String get allPrayers => 'تمام نمازیں';

  @override
  String get nearestMasjid => 'قریب ترین مسجد';

  @override
  String get noMasjidNearby => 'آپ کے قریب ابھی کوئی تصدیق شدہ مسجد نہیں ملی۔';

  @override
  String get noMasjidNearbyHint =>
      'کسی مسجد کے ذمہ دار کو جانتے ہیں؟ ان سے کہیں کہ مسجد کو مسلمین میں رجسٹر کریں۔';

  @override
  String minWalk(String minutes) {
    return '$minutes منٹ پیدل';
  }

  @override
  String kmAway(String km) {
    return '$km کلومیٹر دور';
  }

  @override
  String get jamatNotSet => 'جماعت کا وقت مقرر نہیں';

  @override
  String get nextJamat => 'اگلی جماعت';

  @override
  String get notice => 'اعلان';

  @override
  String get notices => 'اعلانات';

  @override
  String get noNotices => 'ابھی کوئی اعلان نہیں۔';

  @override
  String get all => 'سب';

  @override
  String get authorityTitle => 'مسجد کے ذمہ داران';

  @override
  String get authorityBody =>
      'اپنی مسجد رجسٹر کریں تاکہ آس پاس کے مسلمان اسے اس ایپ میں تلاش کر سکیں۔';

  @override
  String get yourLocation => 'آپ کا مقام';

  @override
  String get locating => 'مقام معلوم کیا جا رہا ہے…';

  @override
  String get useCurrentLocation => 'موجودہ مقام استعمال کریں';

  @override
  String get searchMasjid => 'مسجد تلاش کریں';

  @override
  String get nearbyMasjids => 'قریبی مساجد';

  @override
  String get fajr => 'فجر';

  @override
  String get sunrise => 'طلوعِ آفتاب';

  @override
  String get dhuhr => 'ظہر';

  @override
  String get asr => 'عصر';

  @override
  String get maghrib => 'مغرب';

  @override
  String get isha => 'عشاء';

  @override
  String get jumuah => 'جمعہ';

  @override
  String get forbiddenTime => 'مکروہ اوقات';

  @override
  String get forbiddenInfo =>
      'ان اوقات میں نماز نہیں پڑھی جاتی: سورج نکلتے وقت، عین زوال کے وقت اور سورج ڈوبتے وقت۔';

  @override
  String get morning => 'صبح';

  @override
  String get noon => 'زوال';

  @override
  String get evening => 'شام';

  @override
  String get naflPrayers => 'نفل نمازیں';

  @override
  String get tahajjud => 'تہجد';

  @override
  String get duha => 'صلاۃ الضحیٰ (چاشت)';

  @override
  String get tahajjudHadith =>
      'رسول اللہ ﷺ نے فرمایا: \"ہمارا بزرگ و برتر رب ہر رات آسمانِ دنیا کی طرف نزول فرماتا ہے جب رات کا آخری تہائی حصہ باقی رہ جاتا ہے، اور فرماتا ہے: کون ہے جو مجھے پکارے کہ میں اس کی پکار قبول کروں؟ کون ہے جو مجھ سے مانگے کہ میں اسے عطا کروں؟ کون ہے جو مجھ سے مغفرت طلب کرے کہ میں اسے بخش دوں؟\"';

  @override
  String get tahajjudSource => 'صحیح بخاری 1145';

  @override
  String get duhaHadith1 =>
      'حضرت ابو ہریرہؓ نے فرمایا: \"میرے خلیل ﷺ نے مجھے تین باتوں کی وصیت فرمائی: ہر مہینے تین دن کے روزے، چاشت کی دو رکعتیں، اور سونے سے پہلے وتر پڑھنا۔\"';

  @override
  String get duhaSource1 => 'صحیح بخاری و مسلم';

  @override
  String get duhaHadith2 =>
      'حضرت نعیم بن ہمارؓ سے روایت ہے کہ رسول اللہ ﷺ نے فرمایا: \"اللہ عز و جل فرماتا ہے: اے ابنِ آدم! دن کے شروع میں میرے لیے چار رکعتیں پڑھنے سے عاجز نہ ہو، میں دن کے آخر تک تیرے لیے کافی ہو جاؤں گا۔\"';

  @override
  String get duhaSource2 => 'سنن ابی داؤد 1289';

  @override
  String get calcMethodNote =>
      'اوقات آپ کے مقام کے مطابق حساب کیے جاتے ہیں۔ جماعت کے اوقات ہر مسجد خود مقرر کرتی ہے۔';

  @override
  String get following => 'فالو کر رہے ہیں';

  @override
  String get follow => 'فالو کریں';

  @override
  String get tabHome => 'ہوم';

  @override
  String get tabNotice => 'اعلانات';

  @override
  String get tabLive => 'لائیو';

  @override
  String get tabAbout => 'تعارف';

  @override
  String get jamatTime => 'جماعت کے اوقات';

  @override
  String get maktabTime => 'مکتب کے اوقات';

  @override
  String lastUpdated(String when) {
    return 'آخری اپ ڈیٹ $when';
  }

  @override
  String get today => 'آج';

  @override
  String get yesterday => 'کل';

  @override
  String daysAgo(String count) {
    return '$count دن پہلے';
  }

  @override
  String get khatib => 'خطیب';

  @override
  String get imam => 'امام';

  @override
  String get muazzin => 'مؤذن';

  @override
  String contact(String phone) {
    return 'رابطہ: $phone';
  }

  @override
  String get notAdded => 'ابھی شامل نہیں کیا گیا';

  @override
  String get jamatReminder => 'جماعت کی یاد دہانی';

  @override
  String get notifyBefore => 'پہلے یاد دلائیں';

  @override
  String minsBefore(String minutes) {
    return '$minutes منٹ';
  }

  @override
  String get reminderOff => 'یاد دہانی بند کریں';

  @override
  String reminderSet(String minutes) {
    return 'ہر جماعت سے $minutes منٹ پہلے آپ کو یاد دلایا جائے گا۔';
  }

  @override
  String followedToast(String name) {
    return 'اب آپ $name کو فالو کر رہے ہیں۔';
  }

  @override
  String get directions => 'راستہ';

  @override
  String get liveNow => 'ابھی لائیو';

  @override
  String get noLive => 'اس وقت کوئی لائیو نشریات نہیں';

  @override
  String get noLiveHint =>
      'جب مسجد خطبہ یا بیان نشر کرے گی تو وہ یہاں نظر آئے گا۔';

  @override
  String get watchLive => 'لائیو دیکھیں';

  @override
  String get liveLink => 'لائیو اسٹریم لنک (YouTube / Facebook)';

  @override
  String get liveToggle => 'ہم ابھی لائیو ہیں';

  @override
  String get maktabDays => 'مکتب کے دن';

  @override
  String get weekdaysShort => 'ہفتہ,اتوار,پیر,منگل,بدھ,جمعرات,جمعہ';

  @override
  String get weekdaysLong => 'ہفتہ,اتوار,پیر,منگل,بدھ,جمعرات,جمعہ';

  @override
  String dayRange(String from, String to) {
    return '$from ~ $to';
  }

  @override
  String get tapToSet => 'مقرر کریں';

  @override
  String get khatibName => 'خطیب کا نام';

  @override
  String get imamName => 'امام کا نام';

  @override
  String get muazzinName => 'مؤذن کا نام';

  @override
  String get contactNumber => 'رابطہ نمبر';

  @override
  String get updated => 'کامیابی سے اپ ڈیٹ ہو گیا';

  @override
  String get writeNotice => 'اعلان لکھیں';

  @override
  String get selectCategory => 'زمرہ منتخب کریں';

  @override
  String get deleteNoticeQ => 'یہ اعلان حذف کریں؟';

  @override
  String get catJanaza => 'جنازہ';

  @override
  String get catRecruitment => 'بھرتی';

  @override
  String get catQuran => 'قرآن کلاس';

  @override
  String get catQuranShort => 'قرآن';

  @override
  String get catMahfil => 'محفل';

  @override
  String get catTalim => 'تعلیم';

  @override
  String get catTafsir => 'تفسیر';

  @override
  String get catGeneral => 'عام';

  @override
  String get janazaNotice => 'اعلانِ جنازہ';

  @override
  String noticeFormTitle(String category) {
    return '$category کا اعلان';
  }

  @override
  String get enterCarefully =>
      'براہِ کرم نیچے دی گئی معلومات احتیاط سے درج کریں۔';

  @override
  String get personName => 'مرحوم کا نام';

  @override
  String get fathersName => 'والد کا نام';

  @override
  String get diedOn => 'تاریخِ وفات';

  @override
  String get address => 'پتہ';

  @override
  String get janazaTime => 'جنازے کا وقت';

  @override
  String get janazaDate => 'جنازے کی تاریخ';

  @override
  String get noticeTitle => 'عنوان';

  @override
  String get noticeDetails => 'تفصیل';

  @override
  String get date => 'تاریخ';

  @override
  String get time => 'وقت';

  @override
  String deadline(String date) {
    return 'آخری تاریخ: $date';
  }

  @override
  String startingDate(String date) {
    return 'آغاز کی تاریخ: $date';
  }

  @override
  String timeAndDate(String value) {
    return 'وقت اور تاریخ: $value';
  }

  @override
  String janazaOf(String name) {
    return '$name کا جنازہ';
  }

  @override
  String sonOf(String name) {
    return '$name کے بیٹے/بیٹی';
  }

  @override
  String get noticePosted => 'اعلان پوسٹ ہو گیا';

  @override
  String get required => 'ضروری';

  @override
  String get userAuth => 'صارف کی تصدیق';

  @override
  String get userAuthBody =>
      'اگر درج ذیل باتیں آپ پر صادق آتی ہیں تو پڑھ کر متفق ہوں۔';

  @override
  String get rule1 => 'میں مسجد کمیٹی کا رکن یا مسجد کا خادم/مؤذن/امام ہوں';

  @override
  String get rule2 =>
      'میں مسجد کی جماعت کے اوقات باقاعدگی سے اپ ڈیٹ کر سکتا ہوں';

  @override
  String get rule3 => 'میں اس ایپ کا فائدہ سمجھتا ہوں';

  @override
  String get rule4 => 'میں مسجد کا درست مقام نشان زد کروں گا';

  @override
  String get agreeAll => 'جاری رکھنے کے لیے تمام باتوں کی تصدیق کریں۔';

  @override
  String get registration => 'رجسٹریشن';

  @override
  String get verifyMobile => 'اپنا موبائل نمبر تصدیق کریں';

  @override
  String get yourMobile => 'آپ کا موبائل نمبر';

  @override
  String get otpWillBeSent =>
      'تصدیق کے لیے اس نمبر پر ایک وقتی پاس ورڈ (OTP) بھیجا جائے گا';

  @override
  String get getOtp => 'OTP حاصل کریں';

  @override
  String get invalidPhone =>
      'درست بنگلہ دیشی موبائل نمبر درج کریں (01XXXXXXXXX)۔';

  @override
  String get verification => 'تصدیق';

  @override
  String get typeOtp => 'براہِ کرم اپنے فون پر بھیجا گیا OTP کوڈ درج کریں';

  @override
  String get otp => 'وقتی پاس ورڈ (OTP)';

  @override
  String get didntGetOtp => 'OTP نہیں ملا؟';

  @override
  String get resendCode => 'کوڈ دوبارہ بھیجیں';

  @override
  String resendIn(String seconds) {
    return '$seconds سیکنڈ میں دوبارہ بھیجیں';
  }

  @override
  String get verify => 'تصدیق کریں';

  @override
  String get invalidOtp => 'کوڈ درست نہیں۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get demoOtpHint => 'ڈیمو موڈ: کوڈ 123456 استعمال کریں';

  @override
  String get createMasjidProfile => 'مسجد کا پروفائل بنائیں';

  @override
  String get stayInside =>
      'نیچے کی تفصیلات احتیاط سے درج کریں۔ آپ مقام مسجد کے اندر سے یا نقشے پر مقرر کر سکتے ہیں۔';

  @override
  String get masjidName => 'مسجد کا نام';

  @override
  String get district => 'ضلع';

  @override
  String get thana => 'تھانہ / اپ ضلع';

  @override
  String get latLng => 'عرض بلد اور طول بلد';

  @override
  String get load => 'لوڈ کریں';

  @override
  String get reload => 'دوبارہ لوڈ کریں';

  @override
  String get stayInsideLoading => 'لوڈ ہونے تک مسجد کے اندر رہیں۔';

  @override
  String accuracy(String meters) {
    return 'درستگی ±$meters میٹر';
  }

  @override
  String accuracyTooLow(String meters) {
    return 'مقام کافی درست نہیں (±$meters میٹر)۔ مسجد کے اندر کھلی جگہ پر جا کر دوبارہ لوڈ کریں۔';
  }

  @override
  String get loadLocationFirst => 'براہِ کرم مسجد کا مقام مقرر کریں۔';

  @override
  String get nidNumber => 'آپ کا قومی شناختی نمبر';

  @override
  String get invalidNid =>
      'قومی شناختی نمبر 10، 13 یا 17 ہندسوں کا ہونا چاہیے۔';

  @override
  String get yourRole => 'آپ کی ذمہ داری';

  @override
  String get roleCommittee => 'کمیٹی رکن';

  @override
  String get roleKhadem => 'خادم';

  @override
  String get roleMuazzin => 'مؤذن';

  @override
  String get roleImam => 'امام';

  @override
  String get roleKhatib => 'خطیب';

  @override
  String get agreeTermsPrefix => 'میں نے پڑھ لیا ہے اور متفق ہوں ';

  @override
  String get termsAndConditions => 'شرائط و ضوابط';

  @override
  String get mustAgreeTerms => 'براہِ کرم شرائط و ضوابط سے اتفاق کریں۔';

  @override
  String duplicateFound(String name) {
    return 'اس مقام پر \"$name\" نام کی مسجد پہلے سے رجسٹر ہے۔ اگر آپ اس کے ذمہ دار ہیں تو سپورٹ سے رابطہ کریں۔';
  }

  @override
  String limitReached(String count) {
    return 'آپ زیادہ سے زیادہ $count مسجد پروفائل رکھ سکتے ہیں۔';
  }

  @override
  String get submittedTitle => 'جائزے کے لیے جمع کر دیا گیا';

  @override
  String get submittedBody =>
      'جزاک اللہ خیراً! ہماری ٹیم کی تصدیق کے بعد آپ کی مسجد کا پروفائل سب کو نظر آئے گا۔ منظوری پر آپ کو نوٹیفکیشن ملے گا۔';

  @override
  String get backToHome => 'ہوم پر واپس';

  @override
  String get termsBody =>
      '1۔ صرف مسجد کمیٹی کے ارکان، امام، خطیب، مؤذن یا خادم ہی مسجد کا پروفائل بنا سکتے ہیں۔\n2۔ مسجد کا مقام بالکل درست ہونا چاہیے — مسجد کے اندر سے GPS کے ذریعے یا نقشے پر نشان لگا کر۔\n3۔ آپ کا قومی شناختی نمبر اور فون نمبر صرف تصدیق کے لیے استعمال ہوتا ہے اور کبھی ظاہر نہیں کیا جاتا۔\n4۔ جماعت کے اوقات اور اعلانات درست اور تازہ رکھنا ضروری ہے۔\n5۔ اعلانات مسجد کی سرگرمیوں سے متعلق ہوں۔ سیاسی، تجارتی یا نفرت انگیز مواد کی اجازت نہیں۔\n6۔ مسلمین ٹیم کی تصدیق تک پروفائل پوشیدہ رہتا ہے۔ غلط معلومات والے پروفائل حذف کر دیے جائیں گے۔';

  @override
  String get statusPending => 'زیرِ جائزہ';

  @override
  String get statusApproved => 'منظور شدہ';

  @override
  String get statusRejected => 'مسترد';

  @override
  String get statusSuspended => 'معطل';

  @override
  String get pendingBanner =>
      'یہ پروفائل تصدیق کا منتظر ہے۔ اسے صرف آپ دیکھ سکتے ہیں۔';

  @override
  String rejectedBanner(String reason) {
    return 'یہ پروفائل منظور نہیں ہوا: $reason';
  }

  @override
  String get myMasjids => 'میری مساجد';

  @override
  String get registerMasjid => 'مسجد رجسٹر کریں';

  @override
  String get appSettings => 'ایپ سیٹنگز';

  @override
  String get faq => 'عام سوالات';

  @override
  String get aboutApp => 'ایپ کے بارے میں';

  @override
  String get shareApp => 'یہ ایپ شیئر کریں';

  @override
  String get shareAppBody =>
      'یہ ایپ آپ کے گھر والوں اور دوستوں کے لیے بھی مفید ہو سکتی ہے۔ براہِ کرم شیئر کریں۔';

  @override
  String shareText(String url) {
    return 'مسلمین کے ذریعے اپنے قریب کی مساجد میں جماعت کے اوقات معلوم کریں: $url';
  }

  @override
  String get language => 'زبان';

  @override
  String get calcMethod => 'اوقاتِ نماز کا حساب';

  @override
  String get asrMethod => 'عصر کا حساب';

  @override
  String get hanafi => 'حنفی';

  @override
  String get shafi => 'شافعی / مالکی / حنبلی';

  @override
  String get hijriAdjust => 'ہجری تاریخ میں تبدیلی';

  @override
  String days(String count) {
    return '$count دن';
  }

  @override
  String get defaultReminder => 'جماعت کی پہلے سے طے یاد دہانی';

  @override
  String get signOut => 'سائن آؤٹ';

  @override
  String signedInAs(String phone) {
    return 'بطور $phone سائن اِن';
  }

  @override
  String version(String v) {
    return 'ورژن $v';
  }

  @override
  String get aboutBody =>
      'مسلمین مسلمانوں کو اپنے آس پاس کی مساجد میں جماعت کے اوقات معلوم کرنے میں مدد دیتی ہے۔ ہر مسجد کا پروفائل اس کے اپنے ذمہ دار بناتے ہیں اور عام ہونے سے پہلے ہماری ٹیم اس کی تصدیق کرتی ہے۔';

  @override
  String get faqQ1 => 'جماعت کے اوقات کہاں سے آتے ہیں؟';

  @override
  String get faqA1 =>
      'ہر مسجد کے ذمہ دار خود جماعت کے اوقات مقرر اور اپ ڈیٹ کرتے ہیں۔ نماز کے شروع ہونے کے اوقات آپ کے مقام کے مطابق حساب کیے جاتے ہیں۔';

  @override
  String get faqQ2 => 'مقام لازمی کیوں ہے؟';

  @override
  String get faqA2 =>
      'مقام آپ کے قریب کی مساجد دکھانے اور نماز کے درست اوقات کے حساب کے لیے استعمال ہوتا ہے۔ یہ کبھی کسی سے شیئر نہیں کیا جاتا۔';

  @override
  String get faqQ3 => 'میں اپنی مسجد کیسے شامل کروں؟';

  @override
  String get faqA3 =>
      'مزید ← مسجد رجسٹر کریں پر جائیں۔ آپ کا کمیٹی رکن، امام، مؤذن، خطیب یا خادم ہونا ضروری ہے، اور آپ مسجد کا درست مقام مقرر کریں — مسجد کے اندر سے GPS کے ذریعے یا نقشے پر۔';

  @override
  String get faqQ4 => 'میری مسجد نظر کیوں نہیں آ رہی؟';

  @override
  String get faqA4 =>
      'نئے پروفائل عام ہونے سے پہلے ہماری ٹیم تصدیق کرتی ہے۔ عموماً اس میں 1 سے 2 دن لگتے ہیں۔';

  @override
  String get faqQ5 => 'جماعت کی یاد دہانیاں کیسے کام کرتی ہیں؟';

  @override
  String get faqA5 =>
      'کوئی مسجد کھولیں اور جماعت کے اوقات پر گھنٹی دبائیں۔ ہر جماعت سے 15، 30 یا 45 منٹ پہلے آپ کو اطلاع ملے گی، چاہے ایپ بند ہو۔';

  @override
  String get notifications => 'نوٹیفکیشن';

  @override
  String get noNotifications =>
      'مساجد کو فالو کریں تاکہ ان کے اعلانات یہاں دیکھ سکیں۔';

  @override
  String get adminPanel => 'ایڈمن پینل';

  @override
  String get adminPending => 'زیرِ التوا';

  @override
  String get adminApproved => 'منظور شدہ';

  @override
  String get adminRejected => 'مسترد';

  @override
  String get approve => 'منظور کریں';

  @override
  String get reject => 'مسترد کریں';

  @override
  String get suspend => 'معطل کریں';

  @override
  String get restore => 'بحال کریں';

  @override
  String get rejectReason => 'مسترد کرنے کی وجہ';

  @override
  String get submittedBy => 'جمع کرانے والا';

  @override
  String get phone => 'فون';

  @override
  String get nid => 'شناختی نمبر';

  @override
  String get role => 'ذمہ داری';

  @override
  String get location => 'مقام';

  @override
  String get openInMaps => 'نقشے میں کھولیں';

  @override
  String get submittedOn => 'جمع کرانے کی تاریخ';

  @override
  String get nothingHere => 'یہاں کچھ نہیں';

  @override
  String get approvedToast => 'مسجد منظور ہو گئی';

  @override
  String get rejectedToast => 'مسجد مسترد کر دی گئی';

  @override
  String get verifiedChecklist =>
      'منظوری سے پہلے جمع کرانے والے کو کال کریں اور نقشے پر مقام چیک کریں۔';

  @override
  String get verse1Ar => 'وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ';

  @override
  String get verse1 => 'اور (رنج وتکلیف میں) صبر اور نماز سے مدد لیا کرو';

  @override
  String get verse1Ref => 'البقرہ 2:45';

  @override
  String get verse2Ar =>
      'إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَـٰبًا مَّوْقُوتًا';

  @override
  String get verse2 =>
      'بےشک نماز کا مومنوں پر اوقات (مقررہ) میں ادا کرنا فرض ہے';

  @override
  String get verse2Ref => 'النساء 4:103';

  @override
  String get verse3Ar =>
      'حَـٰفِظُوا۟ عَلَى ٱلصَّلَوَٰتِ وَٱلصَّلَوٰةِ ٱلْوُسْطَىٰ';

  @override
  String get verse3 =>
      '(مسلمانو) سب نمازیں خصوصاً بیچ کی نماز (یعنی نماز عصر) پورے التزام کے ساتھ ادا کرتے رہو';

  @override
  String get verse3Ref => 'البقرہ 2:238';

  @override
  String get hijriMonths =>
      'محرم,صفر,ربیع الاول,ربیع الثانی,جمادی الاولیٰ,جمادی الثانیہ,رجب,شعبان,رمضان,شوال,ذوالقعدہ,ذوالحجہ';

  @override
  String get deadlineLabel => 'آخری تاریخ';

  @override
  String get startingDateLabel => 'آغاز کی تاریخ';

  @override
  String get masjidNameBn => 'مسجد کا نام بنگلہ میں (اختیاری)';

  @override
  String get createAccount => 'اکاؤنٹ بنائیں';

  @override
  String get signIn => 'سائن اِن';

  @override
  String get fullName => 'پورا نام';

  @override
  String get email => 'ای میل';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get confirmPassword => 'پاس ورڈ کی تصدیق';

  @override
  String get forgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get noAccount => 'اکاؤنٹ نہیں ہے؟';

  @override
  String get haveAccount => 'پہلے سے اکاؤنٹ ہے؟';

  @override
  String get signUpBody =>
      'مساجد کو فالو کرنے اور اپنی سیٹنگز محفوظ رکھنے کے لیے اکاؤنٹ بنائیں۔';

  @override
  String get signInBody => 'خوش آمدید! جاری رکھنے کے لیے سائن اِن کریں۔';

  @override
  String get resetPassword => 'پاس ورڈ ری سیٹ کریں';

  @override
  String get resetBody =>
      'وہ ای میل درج کریں جس سے آپ نے سائن اپ کیا تھا۔ ہم نیا پاس ورڈ بنانے کا لنک بھیجیں گے۔';

  @override
  String get sendResetLink => 'ری سیٹ لنک بھیجیں';

  @override
  String resetSent(String email) {
    return 'پاس ورڈ ری سیٹ کا لنک $email پر بھیج دیا گیا ہے۔ براہِ کرم اپنا ان باکس (اور اسپیم فولڈر) دیکھیں۔';
  }

  @override
  String get backToSignIn => 'سائن اِن پر واپس';

  @override
  String get invalidEmail => 'درست ای میل ایڈریس درج کریں۔';

  @override
  String get passwordTooShort => 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے۔';

  @override
  String get passwordsDontMatch => 'پاس ورڈ مطابقت نہیں رکھتے۔';

  @override
  String get errEmailInUse =>
      'اس ای میل سے پہلے ہی اکاؤنٹ موجود ہے۔ سائن اِن کر کے دیکھیں۔';

  @override
  String get errInvalidCredential => 'ای میل یا پاس ورڈ غلط ہے۔';

  @override
  String get errWeakPassword =>
      'براہِ کرم مضبوط پاس ورڈ منتخب کریں (کم از کم 6 حروف)۔';

  @override
  String get errTooManyRequests =>
      'بہت زیادہ کوششیں۔ چند منٹ انتظار کر کے دوبارہ کوشش کریں۔';

  @override
  String get errNetwork => 'انٹرنیٹ کنکشن نہیں۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get errPhoneInUse => 'یہ فون نمبر کسی دوسرے اکاؤنٹ سے منسلک ہے۔';

  @override
  String get errUserDisabled =>
      'یہ اکاؤنٹ غیر فعال کر دیا گیا ہے۔ براہِ کرم سپورٹ سے رابطہ کریں۔';

  @override
  String get myAccount => 'میرا اکاؤنٹ';

  @override
  String get signInPrompt => 'مسجد کے ذمہ داران کے لیے';

  @override
  String get signInPromptBody =>
      'اپنی مسجد رجسٹر اور منظم کرنے کے لیے سائن اِن کریں یا اکاؤنٹ بنائیں۔ عام صارفین کو اکاؤنٹ کی ضرورت نہیں۔';

  @override
  String get profile => 'پروفائل';

  @override
  String get emailNotVerified => 'ای میل تصدیق شدہ نہیں';

  @override
  String get emailVerified => 'ای میل تصدیق شدہ';

  @override
  String get resendVerification => 'تصدیقی ای میل بھیجیں';

  @override
  String verificationSent(String email) {
    return 'تصدیقی ای میل $email پر بھیج دی گئی۔';
  }

  @override
  String get changePassword => 'پاس ورڈ تبدیل کریں';

  @override
  String get currentPassword => 'موجودہ پاس ورڈ';

  @override
  String get newPassword => 'نیا پاس ورڈ';

  @override
  String get passwordChanged => 'پاس ورڈ کامیابی سے تبدیل ہو گیا۔';

  @override
  String get deleteAccount => 'اکاؤنٹ حذف کریں';

  @override
  String get deleteAccountBody =>
      'اس سے آپ کا اکاؤنٹ اور محفوظ ڈیٹا ہمیشہ کے لیے حذف ہو جائے گا۔ آپ کی منظم کردہ مسجد پروفائلز باقی رہیں گی لیکن آپ کی رسائی ختم ہو جائے گی۔ تصدیق کے لیے پاس ورڈ درج کریں۔';

  @override
  String get accountDeleted => 'آپ کا اکاؤنٹ حذف کر دیا گیا۔';

  @override
  String get phoneNumber => 'فون';

  @override
  String get notVerified => 'تصدیق شدہ نہیں';

  @override
  String welcomeUser(String name) {
    return 'خوش آمدید، $name!';
  }

  @override
  String get signInToRegister =>
      'مسجد رجسٹر کرنے کے لیے سائن اِن کریں یا اکاؤنٹ بنائیں۔';

  @override
  String get verifyPhoneToContinue =>
      'مسجد رجسٹر کرنے کے لیے اپنا فون نمبر تصدیق کریں۔';

  @override
  String accountCreated(String email) {
    return 'اکاؤنٹ بن گیا! ہم نے تصدیقی لنک $email پر بھیج دیا ہے۔';
  }

  @override
  String get nameRequired => 'براہِ کرم اپنا نام درج کریں۔';

  @override
  String get credits => 'اعترافات';

  @override
  String get fontCredits =>
      'لوگو اور انگریزی میں نمازوں کے نام: مسلمین ڈیزائن کی خطاطی، جو Anthonie Van Hayu (ARToni) کے Hidayatullah پر مبنی ہے۔ فونٹس: Omnibus-Type کا Grenze Gotisch، Indian Type Foundry اور Jonny Pinhorn کا Poppins، Indian Type Foundry کا Hind Siliguri، Ek Type کا Anek Bangla (بنگلہ ہندسے)، Black Foundry کا Galada، اور SIL International کا Scheherazade New۔ تمام فونٹس SIL Open Font License 1.1 کے تحت مفت ہیں۔';

  @override
  String get designInspired =>
      'اصل ڈیزائن فونٹ: Anthonie Van Hayu (ARToni) کا Hidayatullah۔';

  @override
  String get openSourceLicenses => 'اوپن سورس لائسنس';

  @override
  String get continueWithGoogle => 'Google کے ساتھ جاری رکھیں';

  @override
  String get orDivider => 'یا';

  @override
  String get onb3Title => 'نماز کے اوقات اور یاد دہانیاں';

  @override
  String get onb3Body =>
      'آپ کے مقام کے مطابق نماز کے درست اوقات، اور فالو کی گئی مساجد میں ہر جماعت سے پہلے یاد دہانی۔';

  @override
  String get appVersion => 'ایپ ورژن';

  @override
  String get checkingUpdates => 'اپ ڈیٹس چیک ہو رہی ہیں…';

  @override
  String get upToDate => 'آپ کے پاس تازہ ترین ورژن ہے۔';

  @override
  String updateAvailable(String version) {
    return 'نیا ورژن $version دستیاب ہے';
  }

  @override
  String get downloadLatestApk => 'تازہ ترین APK ڈاؤن لوڈ کریں';

  @override
  String get updateApkHint =>
      'ڈاؤن لوڈ کی گئی فائل کھول کر اسے اس ورژن پر انسٹال کریں۔ آپ کی سیٹنگز محفوظ رہیں گی۔';

  @override
  String get updateIosButton => 'iPhone پر اپ ڈیٹ کیسے کریں';

  @override
  String get updateCheckFailed =>
      'اپ ڈیٹس چیک نہیں ہو سکیں۔ اپنا انٹرنیٹ کنکشن چیک کریں۔';

  @override
  String get releaseNotes => 'ریلیز نوٹس';

  @override
  String get selectAll => 'سب منتخب کریں';

  @override
  String get welcomeTitle => 'السلام علیکم';

  @override
  String get welcomeBody =>
      'اپنی مساجد فالو کرنے، جماعت کی یاد دہانیاں پانے اور سب کچھ اپنے فونز پر ہم آہنگ رکھنے کے لیے سائن اِن کریں۔';

  @override
  String get continueAsGuest => 'بطور مہمان جاری رکھیں';

  @override
  String get editMasjidInfo => 'مسجد کی معلومات میں ترمیم';

  @override
  String get editMasjidInfoBody =>
      'اپنی مسجد کے پروفائل پر دکھائی جانے والی تفصیلات اپ ڈیٹ کریں، بشمول اس کا مقام (مسجد میں GPS سے یا نقشے پر منتخب کر کے)۔';

  @override
  String get followedMasjids => 'فالو کی گئی مساجد';

  @override
  String get noFollowed => 'آپ ابھی کسی مسجد کو فالو نہیں کر رہے۔';

  @override
  String get noFollowedHint =>
      'کوئی مسجد کھولیں اور فالو دبائیں تاکہ وہ یہاں نظر آئے اور اس کے اعلانات آپ تک پہنچیں۔';

  @override
  String reminderBadge(String minutes) {
    return 'یاد دہانی $minutes منٹ';
  }

  @override
  String get manageMasjids => 'مساجد کا انتظام';

  @override
  String get noMyMasjids => 'آپ نے ابھی کوئی مسجد رجسٹر نہیں کی۔';

  @override
  String get noMyMasjidsHint =>
      'کمیٹی ارکان، امام، خطیب، مؤذن یا خادم اپنی مسجد رجسٹر کر سکتے ہیں۔ عام ہونے سے پہلے ہماری ٹیم تصدیق کرتی ہے۔';

  @override
  String get appearance => 'ظاہری شکل';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تاریک';

  @override
  String get appearanceHint =>
      'فجر اور عشاء کے وقت ڈارک موڈ آنکھوں کے لیے آرام دہ ہے۔';

  @override
  String get pullToRefresh => 'ریفریش کے لیے نیچے کھینچیں';

  @override
  String get verifyAutoCheck =>
      'ہمارا ای میل کیا ہوا لنک کھولیں — تصدیق ہوتے ہی یہ صفحہ خود اپ ڈیٹ ہو جائے گا۔';

  @override
  String get signOutTitle => 'سائن آؤٹ کریں؟';

  @override
  String get signOutBody =>
      'اس فون پر فالو کی گئی مساجد دیکھنے اور جماعت کی یاد دہانیاں پانے کے لیے آپ کو دوبارہ سائن اِن کرنا ہوگا۔';

  @override
  String jamatLine(String prayer, String time) {
    return '$prayer کی جماعت $time';
  }

  @override
  String get scanBoard => 'اوقات کا بورڈ اسکین کریں';

  @override
  String get scanBoardHint =>
      'مسجد کے اوقات والے بورڈ کی تصویر لیں اور جماعت کے تمام اوقات خود بخود بھر جائیں گے — یا کسی وقت کو دبا کر خود مقرر کریں۔';

  @override
  String get takePhoto => 'تصویر لیں';

  @override
  String get chooseGallery => 'گیلری سے منتخب کریں';

  @override
  String get scanStage1 => 'اوقات کا بورڈ دیکھا جا رہا ہے…';

  @override
  String get scanStage2 => 'ہندسے پڑھے جا رہے ہیں…';

  @override
  String get scanStage3 => 'فجر سے عشاء تک ملایا جا رہا ہے…';

  @override
  String get scanStage4 => 'جمعہ چیک کیا جا رہا ہے…';

  @override
  String scanFound(String count) {
    return '$count اوقات ملے';
  }

  @override
  String get scanFailed =>
      'یہ تصویر پڑھی نہ جا سکی۔ بورڈ کی صاف اور سیدھی تصویر لیں، یا اوقات خود درج کریں۔';

  @override
  String get enterManually => 'خود درج کریں';

  @override
  String get scanReview =>
      'تصویر سے بھرے گئے اوقات (✦ کے نشان والے)۔ انہیں چیک کریں، پھر اپ ڈیٹ دبائیں۔';

  @override
  String get tabRead => 'پڑھیں';

  @override
  String get readQuran => 'قرآن پڑھیں';

  @override
  String get journeySub => 'تمام 114 سورتوں میں آپ کا سفر';

  @override
  String surahsProgress(String done) {
    return '114 میں سے $done سورتیں';
  }

  @override
  String get versesRead => 'آیات پڑھیں';

  @override
  String get phasesDone => 'مراحل مکمل';

  @override
  String get continueReading => 'جاری رکھیں';

  @override
  String get startReading => 'پڑھنا شروع کریں';

  @override
  String phaseN(String n) {
    return 'مرحلہ $n';
  }

  @override
  String versesN(String n) {
    return '$n آیات';
  }

  @override
  String get completed => 'مکمل';

  @override
  String get locked => 'مقفل';

  @override
  String ayahOf(String n, String total) {
    return 'آیت $n از $total';
  }

  @override
  String unlockHint(String surah) {
    return 'یہ سورت کھولنے کے لیے $surah مکمل کریں۔';
  }

  @override
  String get quizUnlockHint =>
      'اس مرحلے کا کوئز کھولنے کے لیے اس کی تمام سورتیں پڑھیں۔';

  @override
  String phaseQuiz(String n) {
    return 'مرحلہ $n کوئز';
  }

  @override
  String get quizOptional => 'اختیاری · جو پڑھا اسے جانچیں';

  @override
  String bestScore(String score) {
    return 'بہترین $score%';
  }

  @override
  String get makki => 'مکی';

  @override
  String get madani => 'مدنی';

  @override
  String get loadingSurah => 'سورت لائی جا رہی ہے…';

  @override
  String get completeSurah => 'میں نے یہ سورت مکمل کر لی';

  @override
  String get nextSurah => 'اگلی سورت';

  @override
  String surahDone(String name) {
    return 'ماشاء اللہ! آپ نے سورۃ $name مکمل کر لی۔';
  }

  @override
  String nextUnlocked(String name) {
    return '$name اب کھل گئی ہے۔';
  }

  @override
  String get takeQuiz => 'مرحلے کا کوئز دیں';

  @override
  String get later => 'بعد میں';

  @override
  String get wordByWord => 'لفظ بہ لفظ';

  @override
  String get quranSource =>
      'مصحف کا متن اور لفظ بہ لفظ: quran.com (شاہ فہد کمپلیکس کا رسمِ عثمانی) · ترجمہ: مولانا فتح محمد جالندھری';

  @override
  String get startHere => 'شروع';

  @override
  String get quizWordMeaning => 'اس لفظ کا مطلب کیا ہے؟';

  @override
  String get quizAyahMeaning => 'اس آیت کا مطلب کیا ہے؟';

  @override
  String get quizWhichSurah => 'یہ آیت کس سورت کی ہے؟';

  @override
  String quizRevealed(String name) {
    return 'سورۃ $name کہاں نازل ہوئی؟';
  }

  @override
  String get makkah => 'مکہ';

  @override
  String get madinah => 'مدینہ';

  @override
  String quizVerses(String name) {
    return 'سورۃ $name میں کتنی آیات ہیں؟';
  }

  @override
  String quizNameMeans(String name) {
    return 'نام \"$name\" کا مطلب کیا ہے؟';
  }

  @override
  String get kindVocabulary => 'الفاظ';

  @override
  String get kindMeaning => 'مطلب';

  @override
  String get kindSurah => 'کون سی سورت';

  @override
  String get kindFacts => 'سورت کے حقائق';

  @override
  String get quizCorrect => 'درست — ماشاء اللہ!';

  @override
  String get quizWrong => 'درست نہیں — صحیح جواب نمایاں ہے۔';

  @override
  String get continueBtn => 'جاری رکھیں';

  @override
  String quizScore(String score) {
    return 'آپ کا اسکور $score%';
  }

  @override
  String get quizDoneBody =>
      'کوئز اختیاری ہیں — یہ پڑھا ہوا یاد رکھنے میں مدد دیتے ہیں۔';

  @override
  String get quizLoading => 'آپ کا کوئز تیار ہو رہا ہے…';

  @override
  String get tabQuran => 'قرآن';

  @override
  String get tabDua => 'دعا';

  @override
  String get specialSurahs => 'پڑھنے کے لیے مستحب';

  @override
  String get chipMulk => 'الملک';

  @override
  String get chipMulkWhen => 'سونے سے پہلے';

  @override
  String get chipSajdah => 'السجدہ';

  @override
  String get chipKahf => 'الکہف';

  @override
  String get chipKahfWhen => 'جمعہ';

  @override
  String get chipKursi => 'آیت الکرسی';

  @override
  String get chipKursiWhen => 'نماز کے بعد اور سوتے وقت';

  @override
  String get chipBaqarahEnd => 'البقرہ کی آخری 2 آیات';

  @override
  String get chipNight => 'رات کو';

  @override
  String get chipYasin => 'یٰسین';

  @override
  String get chipQuls => 'تینوں قل';

  @override
  String get chipQulsWhen => 'صبح و شام';

  @override
  String get chipAnytime => 'کسی بھی وقت';

  @override
  String get chipToday => 'آج';

  @override
  String get chipTonight => 'آج رات';

  @override
  String get revealedMakkah => 'مکہ میں نازل ہوئی';

  @override
  String get revealedMadinah => 'مدینہ میں نازل ہوئی';

  @override
  String get reciter => 'قاری';

  @override
  String get chooseReciter => 'قاری منتخب کریں';

  @override
  String get playAyah => 'اس آیت سے چلائیں';

  @override
  String recitingAyah(String n, String total) {
    return 'آیت $n از $total';
  }

  @override
  String get audioError => 'تلاوت لوڈ نہ ہو سکی۔ اپنا انٹرنیٹ چیک کریں۔';

  @override
  String get dailyQuran => 'روزانہ قرآن';

  @override
  String get energy0 => 'آج آپ کا دل نور کا منتظر ہے';

  @override
  String get energy1 => 'چارج ہو رہا ہے… چند آیات اور';

  @override
  String get energy2 => 'تقریباً بھر گیا — جاری رکھیں!';

  @override
  String get energy3 => 'نور سے بھرپور — ماشاء اللہ!';

  @override
  String get energy4 => 'آج خوب چمک رہا ہے ✨';

  @override
  String versesToday(String n, String goal) {
    return 'آج $n / $goal آیات';
  }

  @override
  String streakDays(String n) {
    return '$n دن مسلسل';
  }

  @override
  String get readNow => 'ابھی پڑھیں';

  @override
  String get keepReading => 'مزید پڑھیں';

  @override
  String get achievements => 'کامیابیاں';

  @override
  String achievementsCount(String n, String total) {
    return '$total میں سے $n حاصل';
  }

  @override
  String achievementEarned(String date) {
    return '$date کو حاصل کی';
  }

  @override
  String achievementLocked(String done, String target) {
    return 'جاری · $done/$target';
  }

  @override
  String achievementUnlocked(String name) {
    return 'کامیابی حاصل ہوئی: $name';
  }

  @override
  String get ach_bismillah => 'بسم اللہ';

  @override
  String get ach_bismillah_desc => 'اپنی پہلی آیت پڑھیں';

  @override
  String get ach_fatiha => 'سورۃ الفاتحہ';

  @override
  String get ach_fatiha_desc => 'سورۃ الفاتحہ مکمل کریں';

  @override
  String get ach_quls => 'تینوں قل';

  @override
  String get ach_quls_desc => 'الاخلاص، الفلق اور الناس مکمل کریں';

  @override
  String get ach_streak3 => 'ثابت قدم';

  @override
  String get ach_streak3_desc => 'مسلسل 3 دن قرآن پڑھیں';

  @override
  String get ach_streak7 => 'نور کا ہفتہ';

  @override
  String get ach_streak7_desc => 'مسلسل 7 دن قرآن پڑھیں';

  @override
  String get ach_streak30 => 'نور کا مہینہ';

  @override
  String get ach_streak30_desc => 'مسلسل 30 دن قرآن پڑھیں';

  @override
  String get ach_verses100 => 'سو آیات';

  @override
  String get ach_verses100_desc => '100 آیات پڑھیں';

  @override
  String get ach_verses1000 => 'ہزار آیات';

  @override
  String get ach_verses1000_desc => '1,000 آیات پڑھیں';

  @override
  String get ach_kahf => 'جمعہ کا نور';

  @override
  String get ach_kahf_desc => 'جمعہ کے دن سورۃ الکہف مکمل کریں';

  @override
  String get ach_mulk => 'رات کا نگہبان';

  @override
  String get ach_mulk_desc => 'رات کو سورۃ الملک مکمل کریں';

  @override
  String get ach_yasin => 'یٰسین';

  @override
  String get ach_yasin_desc => 'سورۃ یٰسین مکمل کریں';

  @override
  String get ach_listener => 'توجہ سے سننے والا';

  @override
  String get ach_listener_desc => 'کسی پوری سورت کی تلاوت سنیں';

  @override
  String get ach_quiz100 => 'تیز ذہن';

  @override
  String get ach_quiz100_desc => 'کسی مرحلے کے کوئز میں 100% حاصل کریں';

  @override
  String get ach_juzamma => 'پارہ عمّ';

  @override
  String get ach_juzamma_desc => 'تیسویں پارے کی تمام 37 سورتیں مکمل کریں';

  @override
  String get ach_phases10 => 'دس مراحل';

  @override
  String get ach_phases10_desc => 'سفر کے 10 مراحل مکمل کریں';

  @override
  String get ach_khatm => 'ختمِ قرآن';

  @override
  String get ach_khatm_desc => 'تمام 114 سورتیں مکمل کریں';

  @override
  String get duaHeader => 'اللہ کے ذکر کے ساتھ ایک دن';

  @override
  String get duaSub =>
      'جاگنے سے سونے تک — ہر لمحے کے لیے نبی ﷺ کی سکھائی ہوئی دعائیں۔';

  @override
  String repeatTimes(String n) {
    return '$n بار پڑھیں';
  }

  @override
  String duaSource(String n) {
    return 'حصن المسلم #$n';
  }

  @override
  String get duaCredit =>
      'دعائیں سعید بن علی القحطانی کی کتاب حصن المسلم سے، اس کی سرکاری ویب سائٹ hisnmuslim.com کے ذریعے۔ ترجمہ انگریزی میں ہے۔';

  @override
  String get nowLabel => 'ابھی';

  @override
  String get scene_wake => 'جاگتے وقت';

  @override
  String get scene_wake_story =>
      'دن شکر سے شروع ہوتا ہے — اللہ نے نیند کے بعد روح لوٹا دی۔';

  @override
  String get scene_restroom => 'بیت الخلاء';

  @override
  String get scene_restroom_story =>
      'چھوٹے سے چھوٹا معمول بھی اللہ کی پناہ مانگ کر شروع ہوتا ہے۔';

  @override
  String get scene_wudu => 'وضو';

  @override
  String get scene_wudu_story =>
      'ہاتھوں پر پانی، زبان پر اس کا نام — اللہ کے سامنے کھڑے ہونے کی تیاری۔';

  @override
  String get scene_dress => 'لباس پہنتے وقت';

  @override
  String get scene_dress_story =>
      'ہر لباس ایک نعمت ہے — اس کا شکر ادا کریں جس نے پہنایا۔';

  @override
  String get scene_athan => 'اذان';

  @override
  String get scene_athan_story =>
      'محلے پر اذان بلند ہوتی ہے — اس کا جواب دیں، پھر نبی ﷺ کے لیے دعا کریں۔';

  @override
  String get scene_masjid => 'مسجد کی طرف';

  @override
  String get scene_masjid_story =>
      'مسجد کی طرف ہر قدم نور ہے — دعا کے ساتھ داخل ہوں اور نکلیں۔';

  @override
  String get scene_after_salah => 'نماز کے بعد';

  @override
  String get scene_after_salah_story =>
      'جلدی اٹھنے سے پہلے، نماز کے بعد کے اذکار کے ساتھ کچھ دیر بیٹھیں۔';

  @override
  String get scene_morning => 'صبح کے اذکار';

  @override
  String get scene_morning_story =>
      'ایسے کلمات جو شام تک آپ کی حفاظت کرتے ہیں۔';

  @override
  String get scene_eating => 'ناشتہ';

  @override
  String get scene_eating_story =>
      'اس کے نام سے شروع کریں، اس کی حمد پر ختم کریں۔';

  @override
  String get scene_leave_home => 'گھر سے نکلتے وقت';

  @override
  String get scene_leave_home_story => 'دروازے پر اپنا دن اللہ کے سپرد کر دیں۔';

  @override
  String get scene_travel => 'راستے میں';

  @override
  String get scene_travel_story =>
      'بس ہو، رکشہ یا گاڑی — چڑھتے وقت اللہ اکبر، اترتے وقت سبحان اللہ۔';

  @override
  String get scene_meeting => 'لوگوں سے ملاقات';

  @override
  String get scene_meeting_story =>
      'سلام عام کریں اور بھائی کی چھینک کا جواب دیں۔';

  @override
  String get scene_good_news => 'خوشی کے موقع پر';

  @override
  String get scene_good_news_story =>
      'خوشی عطا کرنے والے کی یاد دلاتی ہے — اس کی حمد کریں اور لوگوں کا بھی شکریہ ادا کریں۔';

  @override
  String get scene_hardship => 'مشکل وقت میں';

  @override
  String get scene_hardship_story =>
      'پریشانی، تنگی یا ناکام منصوبہ — پہلے اسی کی طرف رجوع کریں۔';

  @override
  String get scene_patience => 'نقصان اور صبر';

  @override
  String get scene_patience_story =>
      'جب کچھ چھن جائے تو یاد رکھیں کہ ہم اللہ ہی کے ہیں۔';

  @override
  String get scene_anger => 'غصہ ضبط کرنا';

  @override
  String get scene_anger_story =>
      'ایسی بات سے پہلے پناہ مانگیں جس پر بعد میں پچھتانا پڑے۔';

  @override
  String get scene_pain => 'درد اور بیماری';

  @override
  String get scene_pain_story =>
      'اپنے درد کے لیے، اور اس دوست کے لیے جس کی عیادت کریں۔';

  @override
  String get scene_rain => 'بارش کے وقت';

  @override
  String get scene_rain_story =>
      'بارش رحمت ہے — اسے نفع بخش بنانے کی دعا کریں۔';

  @override
  String get scene_home => 'گھر واپسی';

  @override
  String get scene_home_story =>
      'اس کے نام سے داخل ہوں اور گھر والوں کو سلام کریں۔';

  @override
  String get scene_gathering => 'مجلس سے اٹھتے وقت';

  @override
  String get scene_gathering_story => 'اٹھنے سے پہلے زبان کی لغزشیں مٹا دیں۔';

  @override
  String get scene_forgiveness => 'استغفار';

  @override
  String get scene_forgiveness_story => 'دن کی غلطیاں استغفار سے دھل جاتی ہیں۔';

  @override
  String get scene_sleep => 'سونے سے پہلے';

  @override
  String get scene_sleep_story =>
      'دن ویسے ہی ختم کریں جیسے شروع کیا — اس کے نام سے، اس کی حفاظت میں۔';

  @override
  String get scene_night => 'رات میں';

  @override
  String get scene_night_story =>
      'اگر آنکھ کھل جائے یا برا خواب دیکھیں تو وہ قریب ہے۔';

  @override
  String get part_dawn => 'فجر';

  @override
  String get part_morning => 'صبح';

  @override
  String get part_day => 'دن';

  @override
  String get part_evening => 'شام';

  @override
  String get part_night => 'رات';

  @override
  String get removeSession => 'ہٹائیں';

  @override
  String addSession(String session) {
    return '$session شامل کریں';
  }

  @override
  String get duaSearchHint => 'دعائیں تلاش کریں';

  @override
  String duaPartCount(String topics, String duas) {
    return '$topics موضوعات · $duas دعائیں';
  }

  @override
  String duaNoResults(String q) {
    return '\"$q\" کے لیے کوئی دعا نہیں ملی';
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
      other: '$nString دعائیں ملیں',
      one: '1 دعا ملی',
    );
    return '$_temp0';
  }

  @override
  String get part_dawn_sub => 'جاگنا، وضو اور فجر';

  @override
  String get part_morning_sub => 'اذکار، کھانا اور باہر نکلنا';

  @override
  String get part_day_sub => 'لوگ، خوشیاں اور آزمائشیں';

  @override
  String get part_evening_sub => 'گھر، مجالس، استغفار';

  @override
  String get part_night_sub => 'نیند اور رات';

  @override
  String duaCount(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString دعائیں',
      one: '1 دعا',
    );
    return '$_temp0';
  }

  @override
  String get noticeSearchHint => 'اعلانات، مساجد تلاش کریں…';

  @override
  String get noticesSub => 'آپ کے آس پاس کی مساجد سے';

  @override
  String get tabNotices => 'اعلانات';

  @override
  String get chooseSurah => 'سورت پر جائیں';

  @override
  String get surahSearchHint => 'سورت نام یا نمبر سے تلاش کریں';

  @override
  String get previousSurah => 'پچھلی سورت';

  @override
  String get pickOnMapTitle => 'نقشے پر منتخب کریں';

  @override
  String get mapSearchHint => 'مسجد یا علاقہ تلاش کریں';

  @override
  String get useMyLocation => 'میرا مقام';

  @override
  String get mapPickHint =>
      'نقشہ اس طرح ہلائیں کہ پن مسجد پر آ جائے، کسی جگہ کو دبائیں، یا مسجد کے آئیکن کو دبائیں۔';

  @override
  String get mapMoving => 'جگہ تلاش ہو رہی ہے…';

  @override
  String get useThisLocation => 'یہ مقام استعمال کریں';

  @override
  String get masjidLocation => 'مسجد کا مقام';

  @override
  String get chooseLocationWay =>
      'درست مقام مقرر کرنے کا ایک طریقہ منتخب کریں:';

  @override
  String get atTheMasjid => 'میں مسجد میں ہوں';

  @override
  String get atTheMasjidBody =>
      'اپنے فون کا GPS استعمال کریں۔ لوڈ ہونے تک مسجد کے اندر رہیں۔';

  @override
  String get onTheMap => 'نقشے پر منتخب کریں';

  @override
  String get onTheMapBody =>
      'نقشے پر مسجد کی نشاندہی کریں، یا پہلے سے دکھائی گئی مسجد کو دبائیں۔';

  @override
  String get locFromMap => 'نقشے سے منتخب';

  @override
  String get locFromGps => 'GPS';

  @override
  String get locSaved => 'محفوظ مقام';

  @override
  String get useGpsInstead => 'GPS استعمال کریں';

  @override
  String get adjustOnMap => 'نقشے پر درست کریں';

  @override
  String get allMasjids => 'تمام مساجد';

  @override
  String get nearestFirst => 'قریب ترین پہلے';

  @override
  String get duaForNow => 'اس وقت کی دعائیں';

  @override
  String get tabChannel => 'چینل';

  @override
  String get channelInviteTitle => 'اپنے امام اور خطیب کے قریب رہیں';

  @override
  String get channelInviteHadith =>
      '\"علم حاصل کرنا ہر مسلمان پر فرض ہے۔\" — سنن ابن ماجہ 224';

  @override
  String get channelInviteBody =>
      'ہر مسلمان پر فرضِ عین کا علم سیکھنا لازم ہے — ایمان، طہارت، نماز اور روزمرہ زندگی کے ضروری مسائل — اور اس کا بہترین طریقہ کسی عالم کی رہنمائی میں سیکھنا ہے۔ اس مسجد کے چینل میں شامل ہوں تاکہ اس کے امام اور خطیب کی رہنمائی اور پیغامات آپ تک پہنچیں، اور اپنے محلے کی مسجد سے آپ کا تعلق مضبوط ہو۔';

  @override
  String get joinChannel => 'چینل میں شامل ہوں';

  @override
  String get openChannel => 'چینل کھولیں';

  @override
  String get joinedChannel => 'آپ اس مسجد کے چینل میں ہیں';

  @override
  String get channelJoined =>
      'شامل ہو گئے۔ آپ کو امام اور خطیب کے پیغامات ملیں گے۔';

  @override
  String get leaveChannel => 'چینل چھوڑیں';

  @override
  String get leaveChannelQ =>
      'یہ چینل چھوڑیں؟ اس کے پیغامات آپ کو نہیں ملیں گے۔';

  @override
  String get leave => 'چھوڑیں';

  @override
  String get channelEmpty => 'ابھی کوئی پیغام نہیں۔';

  @override
  String get channelEmptyAdmin => 'اپنے ارکان کو پہلا پیغام بھیجیں۔';

  @override
  String get channelReadOnly =>
      'یہاں صرف امام، خطیب اور چینل ایڈمن پیغام بھیجتے ہیں۔';

  @override
  String get messageHint => 'پیغام لکھیں…';

  @override
  String get send => 'بھیجیں';

  @override
  String get deleteMessageQ => 'یہ پیغام سب کے لیے حذف کریں؟';

  @override
  String get members => 'ارکان';

  @override
  String get noMembers =>
      'ابھی کوئی شامل نہیں ہوا۔ اپنی مسجد کے نمازیوں کو دعوت دیں۔';

  @override
  String get roleMember => 'رکن';

  @override
  String get roleEditor => 'ایڈیٹر';

  @override
  String get roleAdmin => 'ایڈمن';

  @override
  String get roleMemberDesc => 'پیغامات پڑھتے ہیں';

  @override
  String get roleEditorDesc => 'پیغامات بھیج سکتے ہیں';

  @override
  String get roleAdminDesc => 'پیغامات بھیجتے اور ارکان کا انتظام کرتے ہیں';

  @override
  String get removeMember => 'چینل سے ہٹائیں';

  @override
  String get you => 'آپ';

  @override
  String get channelMessages => 'چینل کے پیغامات';

  @override
  String get noticesHeading => 'اعلانات';

  @override
  String get signInToJoin => 'چینل میں شامل ہونے کے لیے سائن اِن کریں۔';

  @override
  String get monthNames =>
      'جنوری,فروری,مارچ,اپریل,مئی,جون,جولائی,اگست,ستمبر,اکتوبر,نومبر,دسمبر';

  @override
  String get am => 'ق ظ';

  @override
  String get pm => 'ب ظ';

  @override
  String jamatReminderBody(String prayer, String minutes) {
    return '$prayer کی جماعت $minutes منٹ میں';
  }

  @override
  String get attach => 'منسلک کریں';

  @override
  String get attachPhoto => 'تصویر';

  @override
  String get attachVideo => 'ویڈیو';

  @override
  String get attachAudio => 'آڈیو';

  @override
  String get attachFile => 'فائل';

  @override
  String fileTooLarge(String size) {
    return 'یہ فائل بہت بڑی ہے۔ حد $size ہے۔';
  }

  @override
  String get cantOpenFile => 'اس فون پر یہ فائل کھولنے والی کوئی ایپ نہیں۔';

  @override
  String get channelNotAllowed =>
      'چینل اس وقت دستیاب نہیں (رسائی نہیں)۔ براہِ کرم بعد میں کوشش کریں۔';
}
