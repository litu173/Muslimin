// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class L10nAr extends L10n {
  L10nAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Muslimin';

  @override
  String get tagline => 'يوم في حياة الأمة المسلمة';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطٍّ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get create => 'إنشاء';

  @override
  String get update => 'تحديث';

  @override
  String get edit => 'تعديل';

  @override
  String get post => 'نشر';

  @override
  String get save => 'حفظ';

  @override
  String get select => 'اختيار';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get close => 'إغلاق';

  @override
  String get delete => 'حذف';

  @override
  String get done => 'تم';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get dontShowAgain => 'لا تُظهر مرة أخرى';

  @override
  String get share => 'مشاركة';

  @override
  String get addNew => 'إضافة جديد';

  @override
  String get now => 'الآن';

  @override
  String get selected => 'مُختار';

  @override
  String get home => 'الرئيسية';

  @override
  String get more => 'المزيد';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get somethingWrong => 'حدث خطأ ما. يُرجى المحاولة مرة أخرى.';

  @override
  String get onb1Title => 'مشاركة أوقات الجماعة';

  @override
  String get onb1Body =>
      'سيتمكن من حولك من معرفة أوقات الجماعة في المساجد عبر هذا التطبيق.';

  @override
  String get onb2Title => 'نشر إعلانات المسجد';

  @override
  String get onb2Body =>
      'يجد الناس إعلانات المسجد في هذا التطبيق، مما يساعدهم على المشاركة في مختلف المناسبات.';

  @override
  String get permTitle => 'اسمح بالوصول للمتابعة';

  @override
  String get permBody =>
      'يحتاج تطبيق مسلمين إلى موقعك ليجد المساجد القريبة منك، وإلى الإشعارات ليذكّرك قبل الجماعة.';

  @override
  String get permLocation => 'الموقع';

  @override
  String get permLocationBody =>
      'العثور على أقرب المساجد وحساب مواقيت الصلاة بدقة.';

  @override
  String get permNotification => 'الإشعارات';

  @override
  String get permNotificationBody =>
      'تذكيرات الجماعة وإعلانات المساجد التي تتابعها.';

  @override
  String get permAllow => 'سماح';

  @override
  String get permGranted => 'مسموح';

  @override
  String get permOpenSettings => 'فتح الإعدادات';

  @override
  String get permLocationServiceOff =>
      'يُرجى تشغيل خدمة الموقع (GPS) في هاتفك.';

  @override
  String get permDeniedForever => 'تم رفض الإذن. يُرجى تفعيله من الإعدادات.';

  @override
  String get permContinue => 'متابعة';

  @override
  String get timeLeft => 'الوقت المتبقي';

  @override
  String get startsIn => 'يبدأ بعد';

  @override
  String get allPrayers => 'جميع الصلوات';

  @override
  String get nearestMasjid => 'أقرب مسجد';

  @override
  String get noMasjidNearby => 'لم يُعثر بعد على مسجد موثَّق بالقرب منك.';

  @override
  String get noMasjidNearbyHint =>
      'هل تعرف أحد القائمين على مسجد؟ اطلب منه تسجيل المسجد في تطبيق مسلمين.';

  @override
  String minWalk(String minutes) {
    return '$minutes دقيقة مشيًا';
  }

  @override
  String kmAway(String km) {
    return 'على بُعد $km كم';
  }

  @override
  String get jamatNotSet => 'لم يُحدَّد وقت الجماعة';

  @override
  String get nextJamat => 'الجماعة القادمة';

  @override
  String get notice => 'إعلان';

  @override
  String get notices => 'الإعلانات';

  @override
  String get noNotices => 'لا توجد إعلانات بعد.';

  @override
  String get all => 'الكل';

  @override
  String get authorityTitle => 'القائمون على المساجد';

  @override
  String get authorityBody =>
      'سجِّل مسجدك ليتعرف عليه المسلمون من حولك عبر هذا التطبيق.';

  @override
  String get yourLocation => 'موقعك';

  @override
  String get locating => 'جارٍ تحديد الموقع…';

  @override
  String get useCurrentLocation => 'استخدام الموقع الحالي';

  @override
  String get searchMasjid => 'ابحث عن مسجد';

  @override
  String get nearbyMasjids => 'المساجد القريبة';

  @override
  String get fajr => 'الفجر';

  @override
  String get sunrise => 'الشروق';

  @override
  String get dhuhr => 'الظهر';

  @override
  String get asr => 'العصر';

  @override
  String get maghrib => 'المغرب';

  @override
  String get isha => 'العشاء';

  @override
  String get jumuah => 'الجمعة';

  @override
  String get forbiddenTime => 'أوقات النهي';

  @override
  String get forbiddenInfo =>
      'لا تُصلّى الصلاة في هذه الأوقات: عند طلوع الشمس، وعند استوائها في كبد السماء، وعند غروبها.';

  @override
  String get morning => 'الصباح';

  @override
  String get noon => 'الظهيرة';

  @override
  String get evening => 'المساء';

  @override
  String get naflPrayers => 'صلوات النافلة';

  @override
  String get tahajjud => 'التهجد';

  @override
  String get duha => 'صلاة الضحى';

  @override
  String get tahajjudHadith =>
      'قال رسول الله ﷺ: «يَنْزِلُ رَبُّنَا تَبَارَكَ وَتَعَالَى كُلَّ لَيْلَةٍ إِلَى السَّمَاءِ الدُّنْيَا حِينَ يَبْقَى ثُلُثُ اللَّيْلِ الْآخِرُ يَقُولُ: مَنْ يَدْعُونِي فَأَسْتَجِيبَ لَهُ؟ مَنْ يَسْأَلُنِي فَأُعْطِيَهُ؟ مَنْ يَسْتَغْفِرُنِي فَأَغْفِرَ لَهُ؟»';

  @override
  String get tahajjudSource => 'صحيح البخاري 1145';

  @override
  String get duhaHadith1 =>
      'عن أبي هريرة رضي الله عنه قال: «أَوْصَانِي خَلِيلِي ﷺ بِثَلَاثٍ: صِيَامِ ثَلَاثَةِ أَيَّامٍ مِنْ كُلِّ شَهْرٍ، وَرَكْعَتَيِ الضُّحَى، وَأَنْ أُوتِرَ قَبْلَ أَنْ أَنَامَ»';

  @override
  String get duhaSource1 => 'صحيح البخاري ومسلم';

  @override
  String get duhaHadith2 =>
      'عن نُعَيم بن هَمّار رضي الله عنه قال: سمعت رسول الله ﷺ يقول: «يَقُولُ اللَّهُ عَزَّ وَجَلَّ: يَا ابْنَ آدَمَ، لَا تُعْجِزْنِي مِنْ أَرْبَعِ رَكَعَاتٍ فِي أَوَّلِ نَهَارِكَ أَكْفِكَ آخِرَهُ»';

  @override
  String get duhaSource2 => 'سنن أبي داود 1289';

  @override
  String get calcMethodNote =>
      'تُحسب المواقيت حسب موقعك. أما أوقات الجماعة فيحددها كل مسجد.';

  @override
  String get following => 'متابَع';

  @override
  String get follow => 'متابعة';

  @override
  String get tabHome => 'الرئيسية';

  @override
  String get tabNotice => 'الإعلانات';

  @override
  String get tabLive => 'مباشر';

  @override
  String get tabAbout => 'عن المسجد';

  @override
  String get jamatTime => 'أوقات الجماعة';

  @override
  String get maktabTime => 'أوقات الكُتّاب';

  @override
  String lastUpdated(String when) {
    return 'آخر تحديث $when';
  }

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(String count) {
    return 'قبل $count أيام';
  }

  @override
  String get khatib => 'الخطيب';

  @override
  String get imam => 'الإمام';

  @override
  String get muazzin => 'المؤذن';

  @override
  String contact(String phone) {
    return 'للتواصل: $phone';
  }

  @override
  String get notAdded => 'لم تتم الإضافة بعد';

  @override
  String get jamatReminder => 'تذكير الجماعة';

  @override
  String get notifyBefore => 'التذكير قبل';

  @override
  String minsBefore(String minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get reminderOff => 'إيقاف التذكير';

  @override
  String reminderSet(String minutes) {
    return 'سيصلك تذكير قبل كل جماعة بـ $minutes دقيقة.';
  }

  @override
  String followedToast(String name) {
    return 'أنت الآن تتابع $name.';
  }

  @override
  String get directions => 'الاتجاهات';

  @override
  String get liveNow => 'مباشر الآن';

  @override
  String get noLive => 'لا يوجد بث مباشر الآن';

  @override
  String get noLiveHint => 'عندما يبث المسجد خطبة أو درسًا، سيظهر هنا.';

  @override
  String get watchLive => 'شاهد البث';

  @override
  String get liveLink => 'رابط البث المباشر (YouTube / Facebook)';

  @override
  String get liveToggle => 'نحن على الهواء الآن';

  @override
  String get maktabDays => 'أيام الكُتّاب';

  @override
  String get weekdaysShort =>
      'السبت,الأحد,الإثنين,الثلاثاء,الأربعاء,الخميس,الجمعة';

  @override
  String get weekdaysLong =>
      'السبت,الأحد,الإثنين,الثلاثاء,الأربعاء,الخميس,الجمعة';

  @override
  String dayRange(String from, String to) {
    return '$from ~ $to';
  }

  @override
  String get tapToSet => 'تحديد';

  @override
  String get khatibName => 'اسم الخطيب';

  @override
  String get imamName => 'اسم الإمام';

  @override
  String get muazzinName => 'اسم المؤذن';

  @override
  String get contactNumber => 'رقم التواصل';

  @override
  String get updated => 'تم التحديث بنجاح';

  @override
  String get writeNotice => 'كتابة إعلان';

  @override
  String get selectCategory => 'اختر الفئة';

  @override
  String get deleteNoticeQ => 'حذف هذا الإعلان؟';

  @override
  String get catJanaza => 'جنازة';

  @override
  String get catRecruitment => 'توظيف';

  @override
  String get catQuran => 'حلقة قرآن';

  @override
  String get catQuranShort => 'قرآن';

  @override
  String get catMahfil => 'محفل';

  @override
  String get catTalim => 'تعليم';

  @override
  String get catTafsir => 'تفسير';

  @override
  String get catGeneral => 'عام';

  @override
  String get janazaNotice => 'إعلان جنازة';

  @override
  String noticeFormTitle(String category) {
    return 'إعلان $category';
  }

  @override
  String get enterCarefully => 'يُرجى إدخال المعلومات التالية بعناية.';

  @override
  String get personName => 'اسم المتوفى';

  @override
  String get fathersName => 'اسم الأب';

  @override
  String get diedOn => 'تاريخ الوفاة';

  @override
  String get address => 'العنوان';

  @override
  String get janazaTime => 'وقت الجنازة';

  @override
  String get janazaDate => 'تاريخ الجنازة';

  @override
  String get noticeTitle => 'العنوان';

  @override
  String get noticeDetails => 'التفاصيل';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String deadline(String date) {
    return 'آخر موعد: $date';
  }

  @override
  String startingDate(String date) {
    return 'تاريخ البدء: $date';
  }

  @override
  String timeAndDate(String value) {
    return 'الوقت والتاريخ: $value';
  }

  @override
  String janazaOf(String name) {
    return 'جنازة $name';
  }

  @override
  String sonOf(String name) {
    return 'ابن/ابنة $name';
  }

  @override
  String get noticePosted => 'تم نشر الإعلان';

  @override
  String get required => 'مطلوب';

  @override
  String get userAuth => 'التحقق من المستخدم';

  @override
  String get userAuthBody =>
      'يُرجى القراءة والموافقة إن كان ما يلي ينطبق عليك.';

  @override
  String get rule1 => 'أنا عضو في لجنة المسجد أو خادم/مؤذن/إمام المسجد';

  @override
  String get rule2 => 'أستطيع تحديث أوقات الجماعة في المسجد بانتظام';

  @override
  String get rule3 => 'أدرك فائدة هذا التطبيق';

  @override
  String get rule4 => 'سأحدد الموقع الدقيق للمسجد';

  @override
  String get agreeAll => 'يُرجى تأكيد جميع العبارات للمتابعة.';

  @override
  String get registration => 'التسجيل';

  @override
  String get verifyMobile => 'تحقق من رقم جوالك';

  @override
  String get yourMobile => 'رقم جوالك';

  @override
  String get otpWillBeSent =>
      'ستُرسل كلمة مرور لمرة واحدة (OTP) إلى هذا الرقم للتحقق';

  @override
  String get getOtp => 'احصل على الرمز';

  @override
  String get invalidPhone => 'أدخل رقم جوال بنغلاديشي صحيحًا (01XXXXXXXXX).';

  @override
  String get verification => 'التحقق';

  @override
  String get typeOtp => 'يُرجى كتابة الرمز المرسل إلى رقم هاتفك';

  @override
  String get otp => 'كلمة مرور لمرة واحدة (OTP)';

  @override
  String get didntGetOtp => 'لم يصلك الرمز؟';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String resendIn(String seconds) {
    return 'إعادة الإرسال بعد $seconds ث';
  }

  @override
  String get verify => 'تحقق';

  @override
  String get invalidOtp => 'الرمز غير صحيح. يُرجى المحاولة مرة أخرى.';

  @override
  String get demoOtpHint => 'الوضع التجريبي: استخدم الرمز 123456';

  @override
  String get createMasjidProfile => 'إنشاء ملف المسجد';

  @override
  String get stayInside =>
      'أدخل البيانات التالية بعناية. يمكنك تحديد الموقع من داخل المسجد أو على الخريطة.';

  @override
  String get masjidName => 'اسم المسجد';

  @override
  String get district => 'المحافظة';

  @override
  String get thana => 'المركز / الناحية';

  @override
  String get latLng => 'خط العرض وخط الطول';

  @override
  String get load => 'تحميل';

  @override
  String get reload => 'إعادة التحميل';

  @override
  String get stayInsideLoading => 'ابقَ داخل المسجد أثناء التحميل.';

  @override
  String accuracy(String meters) {
    return 'الدقة ±$meters م';
  }

  @override
  String accuracyTooLow(String meters) {
    return 'الموقع غير دقيق بما يكفي (±$meters م). انتقل إلى مكان مكشوف داخل المسجد وأعد التحميل.';
  }

  @override
  String get loadLocationFirst => 'يُرجى تحديد موقع المسجد.';

  @override
  String get nidNumber => 'رقم بطاقتك الوطنية';

  @override
  String get invalidNid =>
      'يجب أن يتكون رقم البطاقة الوطنية من 10 أو 13 أو 17 رقمًا.';

  @override
  String get yourRole => 'صفتك';

  @override
  String get roleCommittee => 'عضو اللجنة';

  @override
  String get roleKhadem => 'خادم المسجد';

  @override
  String get roleMuazzin => 'المؤذن';

  @override
  String get roleImam => 'الإمام';

  @override
  String get roleKhatib => 'الخطيب';

  @override
  String get agreeTermsPrefix => 'قرأت وأوافق على ';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get mustAgreeTerms => 'يُرجى الموافقة على الشروط والأحكام.';

  @override
  String duplicateFound(String name) {
    return 'يوجد مسجد مسجَّل باسم \"$name\" في هذا الموقع. إن كنت من القائمين عليه فيُرجى التواصل مع الدعم.';
  }

  @override
  String limitReached(String count) {
    return 'يمكنك امتلاك $count ملفات مساجد على الأكثر.';
  }

  @override
  String get submittedTitle => 'أُرسل للمراجعة';

  @override
  String get submittedBody =>
      'جزاكم الله خيرًا! سيظهر ملف مسجدك للجميع بعد أن يتحقق منه فريقنا، وسيصلك إشعار عند اعتماده.';

  @override
  String get backToHome => 'العودة إلى الرئيسية';

  @override
  String get termsBody =>
      '1. لا يُنشئ ملف المسجد إلا أعضاء لجنة المسجد أو الإمام أو الخطيب أو المؤذن أو الخادم.\n2. يجب أن يكون موقع المسجد دقيقًا — حدِّده عبر GPS من داخل المسجد أو بالإشارة إليه على الخريطة.\n3. يُستخدم رقم بطاقتك الوطنية ورقم هاتفك للتحقق فقط، ولا يُعرضان علنًا أبدًا.\n4. يجب أن تكون أوقات الجماعة والإعلانات صحيحة ومحدَّثة.\n5. يجب أن تتعلق الإعلانات بأنشطة المسجد، ولا يُسمح بالمحتوى السياسي أو التجاري أو المسيء.\n6. يبقى الملف مخفيًا حتى يتحقق منه فريق مسلمين، وتُحذف الملفات التي تحتوي على معلومات غير صحيحة.';

  @override
  String get statusPending => 'قيد المراجعة';

  @override
  String get statusApproved => 'معتمد';

  @override
  String get statusRejected => 'مرفوض';

  @override
  String get statusSuspended => 'موقوف';

  @override
  String get pendingBanner => 'هذا الملف بانتظار التحقق، ولا يراه أحد غيرك.';

  @override
  String rejectedBanner(String reason) {
    return 'لم يُعتمد هذا الملف: $reason';
  }

  @override
  String get myMasjids => 'مساجدي';

  @override
  String get registerMasjid => 'تسجيل مسجد';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get aboutApp => 'عن التطبيق';

  @override
  String get shareApp => 'شارك هذا التطبيق';

  @override
  String get shareAppBody =>
      'قد ينفع هذا التطبيق أهلك وأصدقاءك أيضًا. شاركه معهم.';

  @override
  String shareText(String url) {
    return 'اعرف أوقات الجماعة في المساجد القريبة منك مع تطبيق مسلمين: $url';
  }

  @override
  String get language => 'اللغة';

  @override
  String get calcMethod => 'طريقة حساب المواقيت';

  @override
  String get asrMethod => 'طريقة حساب العصر';

  @override
  String get hanafi => 'حنفي';

  @override
  String get shafi => 'شافعي / مالكي / حنبلي';

  @override
  String get hijriAdjust => 'تعديل التاريخ الهجري';

  @override
  String days(String count) {
    return '$count أيام';
  }

  @override
  String get defaultReminder => 'التذكير الافتراضي للجماعة';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String signedInAs(String phone) {
    return 'مسجَّل الدخول باسم $phone';
  }

  @override
  String version(String v) {
    return 'الإصدار $v';
  }

  @override
  String get aboutBody =>
      'يساعد تطبيق مسلمين المسلمين على معرفة أوقات الجماعة في المساجد من حولهم. ينشئ كل ملف مسجد القائمون عليه، ويتحقق منه فريقنا قبل نشره.';

  @override
  String get faqQ1 => 'من أين تأتي أوقات الجماعة؟';

  @override
  String get faqA1 =>
      'يحدد القائمون على كل مسجد أوقات الجماعة فيه ويحدّثونها. أما أوقات دخول الصلاة فتُحسب حسب موقعك.';

  @override
  String get faqQ2 => 'لماذا يلزم تحديد الموقع؟';

  @override
  String get faqA2 =>
      'يُستخدم الموقع لعرض المساجد القريبة منك وحساب مواقيت الصلاة بدقة، ولا يُشارَك مع أحد أبدًا.';

  @override
  String get faqQ3 => 'كيف أضيف مسجدي؟';

  @override
  String get faqA3 =>
      'اذهب إلى المزيد ← تسجيل مسجد. يجب أن تكون عضوًا في اللجنة أو إمامًا أو مؤذنًا أو خطيبًا أو خادمًا، وأن تحدد الموقع الدقيق للمسجد — عبر GPS من داخله أو على الخريطة.';

  @override
  String get faqQ4 => 'لماذا لا يظهر مسجدي؟';

  @override
  String get faqA4 =>
      'يتحقق فريقنا من الملفات الجديدة قبل نشرها، وعادةً ما يستغرق ذلك يومًا أو يومين.';

  @override
  String get faqQ5 => 'كيف تعمل تذكيرات الجماعة؟';

  @override
  String get faqA5 =>
      'افتح صفحة المسجد واضغط على الجرس في أوقات الجماعة. سيصلك تذكير قبل كل جماعة بـ 15 أو 30 أو 45 دقيقة، حتى لو كان التطبيق مغلقًا.';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get noNotifications => 'تابع المساجد لترى إعلاناتها هنا.';

  @override
  String get adminPanel => 'لوحة الإدارة';

  @override
  String get adminPending => 'قيد المراجعة';

  @override
  String get adminApproved => 'معتمدة';

  @override
  String get adminRejected => 'مرفوضة';

  @override
  String get approve => 'اعتماد';

  @override
  String get reject => 'رفض';

  @override
  String get suspend => 'إيقاف';

  @override
  String get restore => 'استعادة';

  @override
  String get rejectReason => 'سبب الرفض';

  @override
  String get submittedBy => 'مقدَّم من';

  @override
  String get phone => 'الهاتف';

  @override
  String get nid => 'البطاقة الوطنية';

  @override
  String get role => 'الصفة';

  @override
  String get location => 'الموقع';

  @override
  String get openInMaps => 'فتح في الخرائط';

  @override
  String get submittedOn => 'تاريخ التقديم';

  @override
  String get nothingHere => 'لا يوجد شيء هنا';

  @override
  String get approvedToast => 'تم اعتماد المسجد';

  @override
  String get rejectedToast => 'تم رفض المسجد';

  @override
  String get verifiedChecklist =>
      'قبل الاعتماد، اتصل بمقدِّم الطلب وتحقق من الموقع على الخريطة.';

  @override
  String get verse1Ar => 'وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ';

  @override
  String get verse1 => '';

  @override
  String get verse1Ref => 'البقرة 2:45';

  @override
  String get verse2Ar =>
      'إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَـٰبًا مَّوْقُوتًا';

  @override
  String get verse2 => '';

  @override
  String get verse2Ref => 'النساء 4:103';

  @override
  String get verse3Ar =>
      'حَـٰفِظُوا۟ عَلَى ٱلصَّلَوَٰتِ وَٱلصَّلَوٰةِ ٱلْوُسْطَىٰ';

  @override
  String get verse3 => '';

  @override
  String get verse3Ref => 'البقرة 2:238';

  @override
  String get hijriMonths =>
      'محرم,صفر,ربيع الأول,ربيع الآخر,جمادى الأولى,جمادى الآخرة,رجب,شعبان,رمضان,شوال,ذو القعدة,ذو الحجة';

  @override
  String get deadlineLabel => 'آخر موعد';

  @override
  String get startingDateLabel => 'تاريخ البدء';

  @override
  String get masjidNameBn => 'اسم المسجد بالبنغالية (اختياري)';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get haveAccount => 'لديك حساب بالفعل؟';

  @override
  String get signUpBody => 'أنشئ حسابك لتتابع المساجد وتحفظ إعداداتك.';

  @override
  String get signInBody => 'مرحبًا بعودتك! سجّل الدخول للمتابعة.';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetBody =>
      'أدخل البريد الإلكتروني الذي سجّلت به، وسنرسل إليك رابطًا لتعيين كلمة مرور جديدة.';

  @override
  String get sendResetLink => 'إرسال الرابط';

  @override
  String resetSent(String email) {
    return 'أُرسل رابط إعادة تعيين كلمة المرور إلى $email. يُرجى مراجعة البريد الوارد (ومجلد الرسائل غير المرغوب فيها).';
  }

  @override
  String get backToSignIn => 'العودة إلى تسجيل الدخول';

  @override
  String get invalidEmail => 'أدخل بريدًا إلكترونيًا صحيحًا.';

  @override
  String get passwordTooShort => 'يجب ألا تقل كلمة المرور عن 6 أحرف.';

  @override
  String get passwordsDontMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get errEmailInUse =>
      'يوجد حساب بهذا البريد الإلكتروني بالفعل. جرّب تسجيل الدخول.';

  @override
  String get errInvalidCredential =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get errWeakPassword =>
      'يُرجى اختيار كلمة مرور أقوى (6 أحرف على الأقل).';

  @override
  String get errTooManyRequests =>
      'محاولات كثيرة جدًا. انتظر بضع دقائق ثم حاول مجددًا.';

  @override
  String get errNetwork => 'لا يوجد اتصال بالإنترنت. يُرجى المحاولة مرة أخرى.';

  @override
  String get errPhoneInUse => 'رقم الهاتف هذا مرتبط بحساب آخر.';

  @override
  String get errUserDisabled => 'تم تعطيل هذا الحساب. يُرجى التواصل مع الدعم.';

  @override
  String get myAccount => 'حسابي';

  @override
  String get signInPrompt => 'للقائمين على المساجد';

  @override
  String get signInPromptBody =>
      'سجّل الدخول أو أنشئ حسابًا لتسجيل مسجدك وإدارته. المستخدمون العاديون لا يحتاجون إلى حساب.';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get emailNotVerified => 'البريد الإلكتروني غير موثَّق';

  @override
  String get emailVerified => 'البريد الإلكتروني موثَّق';

  @override
  String get resendVerification => 'إرسال بريد التوثيق';

  @override
  String verificationSent(String email) {
    return 'أُرسل بريد التوثيق إلى $email.';
  }

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get passwordChanged => 'تم تغيير كلمة المرور بنجاح.';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountBody =>
      'سيؤدي هذا إلى حذف حسابك وبياناتك المحفوظة نهائيًا. ستبقى ملفات المساجد التي تديرها، لكنك ستفقد صلاحية الوصول إليها. أدخل كلمة المرور للتأكيد.';

  @override
  String get accountDeleted => 'تم حذف حسابك.';

  @override
  String get phoneNumber => 'الهاتف';

  @override
  String get notVerified => 'غير موثَّق';

  @override
  String welcomeUser(String name) {
    return 'أهلًا، $name!';
  }

  @override
  String get signInToRegister =>
      'يُرجى تسجيل الدخول أو إنشاء حساب لتسجيل مسجد.';

  @override
  String get verifyPhoneToContinue => 'وثّق رقم هاتفك لتسجيل مسجد.';

  @override
  String accountCreated(String email) {
    return 'تم إنشاء الحساب! أرسلنا رابط التوثيق إلى $email.';
  }

  @override
  String get nameRequired => 'يُرجى إدخال اسمك.';

  @override
  String get credits => 'حقوق ومصادر';

  @override
  String get fontCredits =>
      'الشعار وأسماء الصلوات بالإنجليزية: خطوط من تصميم مسلمين، مستوحاة من خط Hidayatullah لأنتوني فان هايو (ARToni). الخطوط: Grenze Gotisch من Omnibus-Type، وPoppins من Indian Type Foundry وJonny Pinhorn، وHind Siliguri من Indian Type Foundry، وAnek Bangla (الأرقام البنغالية) من Ek Type، وGalada من Black Foundry، وScheherazade New من SIL International. جميع الخطوط مجانية بموجب رخصة SIL Open Font License 1.1.';

  @override
  String get designInspired =>
      'خط التصميم الأصلي: Hidayatullah لأنتوني فان هايو (ARToni).';

  @override
  String get openSourceLicenses => 'تراخيص المصادر المفتوحة';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get orDivider => 'أو';

  @override
  String get onb3Title => 'مواقيت الصلاة والتذكيرات';

  @override
  String get onb3Body =>
      'مواقيت صلاة دقيقة لموقعك، وتذكير قبل كل جماعة في المساجد التي تتابعها.';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get checkingUpdates => 'جارٍ البحث عن تحديثات…';

  @override
  String get upToDate => 'لديك أحدث إصدار.';

  @override
  String updateAvailable(String version) {
    return 'يتوفر الإصدار الجديد $version';
  }

  @override
  String get downloadLatestApk => 'تنزيل أحدث نسخة APK';

  @override
  String get updateApkHint =>
      'افتح الملف الذي نزّلته لتثبيته فوق هذا الإصدار، وستبقى إعداداتك كما هي.';

  @override
  String get updateIosButton => 'طريقة التحديث على iPhone';

  @override
  String get updateCheckFailed =>
      'تعذّر البحث عن تحديثات. تحقّق من اتصالك بالإنترنت.';

  @override
  String get releaseNotes => 'ملاحظات الإصدار';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get welcomeTitle => 'السلام عليكم';

  @override
  String get welcomeBody =>
      'سجّل الدخول لتتابع مساجدك، وتصلك تذكيرات الجماعة، وتبقى بياناتك متزامنة على أجهزتك.';

  @override
  String get continueAsGuest => 'المتابعة كضيف';

  @override
  String get editMasjidInfo => 'تعديل بيانات المسجد';

  @override
  String get editMasjidInfoBody =>
      'حدّث البيانات المعروضة في ملف مسجدك، بما في ذلك موقعه (عبر GPS في المسجد أو بالتحديد على الخريطة).';

  @override
  String get followedMasjids => 'المساجد المتابَعة';

  @override
  String get noFollowed => 'لا تتابع أي مسجد بعد.';

  @override
  String get noFollowedHint =>
      'افتح صفحة مسجد واضغط «متابعة» ليظهر هنا وتصلك إعلاناته.';

  @override
  String reminderBadge(String minutes) {
    return 'تذكير قبل $minutes د';
  }

  @override
  String get manageMasjids => 'إدارة المساجد';

  @override
  String get noMyMasjids => 'لم تسجّل أي مسجد بعد.';

  @override
  String get noMyMasjidsHint =>
      'يمكن لأعضاء اللجنة والإمام والخطيب والمؤذن والخادم تسجيل مسجدهم، ويتحقق منه فريقنا قبل نشره.';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get appearanceHint => 'الوضع الداكن أريح للعين وقت الفجر والعشاء.';

  @override
  String get pullToRefresh => 'اسحب للأسفل للتحديث';

  @override
  String get verifyAutoCheck =>
      'افتح الرابط الذي أرسلناه إلى بريدك — ستتحدث هذه الصفحة تلقائيًا بعد التوثيق.';

  @override
  String get signOutTitle => 'تسجيل الخروج؟';

  @override
  String get signOutBody =>
      'ستحتاج إلى تسجيل الدخول مجددًا لرؤية المساجد التي تتابعها وتلقي تذكيرات الجماعة على هذا الهاتف.';

  @override
  String jamatLine(String prayer, String time) {
    return 'جماعة $prayer $time';
  }

  @override
  String get scanBoard => 'مسح لوحة المواقيت';

  @override
  String get scanBoardHint =>
      'صوّر لوحة مواقيت المسجد لتُملأ أوقات الجماعة تلقائيًا — أو اضغط على أي وقت لتحديده يدويًا.';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseGallery => 'اختيار من المعرض';

  @override
  String get scanStage1 => 'جارٍ فحص لوحة المواقيت…';

  @override
  String get scanStage2 => 'جارٍ قراءة الأرقام…';

  @override
  String get scanStage3 => 'جارٍ مطابقة الفجر حتى العشاء…';

  @override
  String get scanStage4 => 'جارٍ التحقق من الجمعة…';

  @override
  String scanFound(String count) {
    return 'تم العثور على $count أوقات';
  }

  @override
  String get scanFailed =>
      'تعذّرت قراءة هذه الصورة. جرّب صورة واضحة ومستقيمة للوحة، أو أدخل الأوقات يدويًا.';

  @override
  String get enterManually => 'إدخال يدوي';

  @override
  String get scanReview =>
      'مُلئت الأوقات من الصورة (المعلّمة بـ ✦). راجعها ثم اضغط «تحديث».';

  @override
  String get tabRead => 'القراءة';

  @override
  String get readQuran => 'اقرأ القرآن';

  @override
  String get journeySub => 'رحلتك عبر سور القرآن الـ 114';

  @override
  String surahsProgress(String done) {
    return '$done من 114 سورة';
  }

  @override
  String get versesRead => 'آية مقروءة';

  @override
  String get phasesDone => 'مرحلة مكتملة';

  @override
  String get continueReading => 'متابعة';

  @override
  String get startReading => 'ابدأ القراءة';

  @override
  String phaseN(String n) {
    return 'المرحلة $n';
  }

  @override
  String versesN(String n) {
    return '$n آية';
  }

  @override
  String get completed => 'مكتملة';

  @override
  String get locked => 'مقفلة';

  @override
  String ayahOf(String n, String total) {
    return 'الآية $n من $total';
  }

  @override
  String unlockHint(String surah) {
    return 'أكمل سورة $surah لفتح هذه السورة.';
  }

  @override
  String get quizUnlockHint => 'اقرأ جميع سور هذه المرحلة لفتح اختبارها.';

  @override
  String phaseQuiz(String n) {
    return 'اختبار المرحلة $n';
  }

  @override
  String get quizOptional => 'اختياري · اختبر ما قرأت';

  @override
  String bestScore(String score) {
    return 'أفضل نتيجة $score%';
  }

  @override
  String get makki => 'مكية';

  @override
  String get madani => 'مدنية';

  @override
  String get loadingSurah => 'جارٍ تحميل السورة…';

  @override
  String get completeSurah => 'أتممتُ هذه السورة';

  @override
  String get nextSurah => 'السورة التالية';

  @override
  String surahDone(String name) {
    return 'ما شاء الله! أتممت سورة $name.';
  }

  @override
  String nextUnlocked(String name) {
    return 'تم فتح سورة $name.';
  }

  @override
  String get takeQuiz => 'خذ اختبار المرحلة';

  @override
  String get later => 'لاحقًا';

  @override
  String get wordByWord => 'كلمة بكلمة';

  @override
  String get quranSource =>
      'نص المصحف وكلمة بكلمة: quran.com (الرسم العثماني، مجمع الملك فهد)';

  @override
  String get startHere => 'ابدأ';

  @override
  String get quizWordMeaning => 'ما معنى هذه الكلمة؟';

  @override
  String get quizAyahMeaning => 'ما معنى هذه الآية؟';

  @override
  String get quizWhichSurah => 'من أي سورة هذه الآية؟';

  @override
  String quizRevealed(String name) {
    return 'أين نزلت سورة $name؟';
  }

  @override
  String get makkah => 'مكة';

  @override
  String get madinah => 'المدينة';

  @override
  String quizVerses(String name) {
    return 'كم عدد آيات سورة $name؟';
  }

  @override
  String quizNameMeans(String name) {
    return 'ما معنى اسم «$name»؟';
  }

  @override
  String get kindVocabulary => 'المفردات';

  @override
  String get kindMeaning => 'المعنى';

  @override
  String get kindSurah => 'أي سورة';

  @override
  String get kindFacts => 'معلومات السورة';

  @override
  String get quizCorrect => 'إجابة صحيحة — ما شاء الله!';

  @override
  String get quizWrong => 'ليست صحيحة — الإجابة الصحيحة مظلَّلة.';

  @override
  String get continueBtn => 'متابعة';

  @override
  String quizScore(String score) {
    return 'نتيجتك $score%';
  }

  @override
  String get quizDoneBody => 'الاختبارات اختيارية — تساعدك على تذكّر ما قرأت.';

  @override
  String get quizLoading => 'جارٍ تجهيز الاختبار…';

  @override
  String get tabQuran => 'القرآن';

  @override
  String get tabDua => 'الأدعية';

  @override
  String get specialSurahs => 'يُستحب قراءتها';

  @override
  String get chipMulk => 'الملك';

  @override
  String get chipMulkWhen => 'قبل النوم';

  @override
  String get chipSajdah => 'السجدة';

  @override
  String get chipKahf => 'الكهف';

  @override
  String get chipKahfWhen => 'يوم الجمعة';

  @override
  String get chipKursi => 'آية الكرسي';

  @override
  String get chipKursiWhen => 'بعد الصلاة وعند النوم';

  @override
  String get chipBaqarahEnd => 'خواتيم البقرة';

  @override
  String get chipNight => 'في الليل';

  @override
  String get chipYasin => 'يس';

  @override
  String get chipQuls => 'المعوذات';

  @override
  String get chipQulsWhen => 'صباحًا ومساءً';

  @override
  String get chipAnytime => 'في أي وقت';

  @override
  String get chipToday => 'اليوم';

  @override
  String get chipTonight => 'الليلة';

  @override
  String get revealedMakkah => 'نزلت في مكة';

  @override
  String get revealedMadinah => 'نزلت في المدينة';

  @override
  String get reciter => 'القارئ';

  @override
  String get chooseReciter => 'اختر القارئ';

  @override
  String get playAyah => 'التشغيل من هذه الآية';

  @override
  String recitingAyah(String n, String total) {
    return 'الآية $n من $total';
  }

  @override
  String get audioError => 'تعذّر تحميل التلاوة. تحقّق من اتصالك بالإنترنت.';

  @override
  String get dailyQuran => 'الورد اليومي';

  @override
  String get energy0 => 'قلبك ينتظر النور اليوم';

  @override
  String get energy1 => 'يمتلئ نورًا… بضع آيات أخرى';

  @override
  String get energy2 => 'أوشك على الامتلاء — واصل!';

  @override
  String get energy3 => 'ممتلئ نورًا — ما شاء الله!';

  @override
  String get energy4 => 'يتلألأ اليوم ✨';

  @override
  String versesToday(String n, String goal) {
    return '$n / $goal آيات اليوم';
  }

  @override
  String streakDays(String n) {
    return '$n أيام متتالية';
  }

  @override
  String get readNow => 'اقرأ الآن';

  @override
  String get keepReading => 'اقرأ المزيد';

  @override
  String get achievements => 'الإنجازات';

  @override
  String achievementsCount(String n, String total) {
    return '$n من $total مُحقَّقة';
  }

  @override
  String achievementEarned(String date) {
    return 'تحقّق في $date';
  }

  @override
  String achievementLocked(String done, String target) {
    return 'قيد التقدم · $done/$target';
  }

  @override
  String achievementUnlocked(String name) {
    return 'إنجاز جديد: $name';
  }

  @override
  String get ach_bismillah => 'بسم الله';

  @override
  String get ach_bismillah_desc => 'اقرأ أول آية';

  @override
  String get ach_fatiha => 'الفاتحة';

  @override
  String get ach_fatiha_desc => 'أتمّ سورة الفاتحة';

  @override
  String get ach_quls => 'المعوذات الثلاث';

  @override
  String get ach_quls_desc => 'أتمّ سور الإخلاص والفلق والناس';

  @override
  String get ach_streak3 => 'خطوات ثابتة';

  @override
  String get ach_streak3_desc => 'اقرأ القرآن 3 أيام متتالية';

  @override
  String get ach_streak7 => 'أسبوع من النور';

  @override
  String get ach_streak7_desc => 'اقرأ القرآن 7 أيام متتالية';

  @override
  String get ach_streak30 => 'شهر من النور';

  @override
  String get ach_streak30_desc => 'اقرأ القرآن 30 يومًا متتاليًا';

  @override
  String get ach_verses100 => 'مئة آية';

  @override
  String get ach_verses100_desc => 'اقرأ 100 آية';

  @override
  String get ach_verses1000 => 'ألف آية';

  @override
  String get ach_verses1000_desc => 'اقرأ 1000 آية';

  @override
  String get ach_kahf => 'نور الجمعة';

  @override
  String get ach_kahf_desc => 'أتمّ سورة الكهف يوم الجمعة';

  @override
  String get ach_mulk => 'حارس الليل';

  @override
  String get ach_mulk_desc => 'أتمّ سورة الملك ليلًا';

  @override
  String get ach_yasin => 'يس';

  @override
  String get ach_yasin_desc => 'أتمّ سورة يس';

  @override
  String get ach_listener => 'مستمع منصت';

  @override
  String get ach_listener_desc => 'استمع إلى تلاوة سورة كاملة';

  @override
  String get ach_quiz100 => 'ذهن حاضر';

  @override
  String get ach_quiz100_desc => 'احصل على 100% في اختبار مرحلة';

  @override
  String get ach_juzamma => 'جزء عمّ';

  @override
  String get ach_juzamma_desc => 'أتمّ سور الجزء الثلاثين الـ 37 كلها';

  @override
  String get ach_phases10 => 'عشر مراحل';

  @override
  String get ach_phases10_desc => 'أتمّ 10 مراحل من الرحلة';

  @override
  String get ach_khatm => 'ختم القرآن';

  @override
  String get ach_khatm_desc => 'أتمّ سور القرآن الـ 114 كلها';

  @override
  String get duaHeader => 'يوم مع ذكر الله';

  @override
  String get duaSub =>
      'من الاستيقاظ إلى النوم — الأدعية التي علّمها النبي ﷺ لكل لحظة.';

  @override
  String repeatTimes(String n) {
    return '$n مرات';
  }

  @override
  String duaSource(String n) {
    return 'حصن المسلم رقم $n';
  }

  @override
  String get duaCredit =>
      'الأدعية من كتاب «حصن المسلم» لسعيد بن علي القحطاني، عن موقعه الرسمي hisnmuslim.com.';

  @override
  String get nowLabel => 'الآن';

  @override
  String get scene_wake => 'الاستيقاظ';

  @override
  String get scene_wake_story =>
      'يبدأ اليوم بالشكر — ردّ الله الروح بعد النوم.';

  @override
  String get scene_restroom => 'الخلاء';

  @override
  String get scene_restroom_story => 'حتى أصغر العادات تبدأ بالاستعاذة بالله.';

  @override
  String get scene_wudu => 'الوضوء';

  @override
  String get scene_wudu_story =>
      'الماء على اليدين واسمه على اللسان — استعدادًا للوقوف بين يدي الله.';

  @override
  String get scene_dress => 'لبس الثوب';

  @override
  String get scene_dress_story => 'كل ثوب نعمة — فاشكر من كساك.';

  @override
  String get scene_athan => 'الأذان';

  @override
  String get scene_athan_story =>
      'يعلو النداء في الحي — أجِبه، ثم سل الوسيلة للنبي ﷺ.';

  @override
  String get scene_masjid => 'إلى المسجد';

  @override
  String get scene_masjid_story =>
      'كل خطوة إلى المسجد نور — ادخل واخرج بالدعاء.';

  @override
  String get scene_after_salah => 'بعد الصلاة';

  @override
  String get scene_after_salah_story =>
      'قبل أن تنصرف، اجلس قليلًا مع أذكار ما بعد الصلاة.';

  @override
  String get scene_morning => 'أذكار الصباح';

  @override
  String get scene_morning_story => 'كلمات تحفظك حتى المساء.';

  @override
  String get scene_eating => 'الطعام';

  @override
  String get scene_eating_story => 'ابدأ باسمه واختم بحمده.';

  @override
  String get scene_leave_home => 'الخروج من المنزل';

  @override
  String get scene_leave_home_story => 'عند الباب، فوّض يومك إلى الله.';

  @override
  String get scene_travel => 'في الطريق';

  @override
  String get scene_travel_story =>
      'حافلة أو ريكشا أو سيارة — الله أكبر صعودًا، وسبحان الله نزولًا.';

  @override
  String get scene_meeting => 'لقاء الناس';

  @override
  String get scene_meeting_story => 'أفشِ السلام وشمّت العاطس.';

  @override
  String get scene_good_news => 'عند الفرح';

  @override
  String get scene_good_news_story =>
      'الفرح تذكير بالمنعِم — فاحمده واشكر الناس أيضًا.';

  @override
  String get scene_hardship => 'عند الشدة';

  @override
  String get scene_hardship_story =>
      'همّ أو ضيق أو أمر لم يتمّ — الجأ إليه أولًا.';

  @override
  String get scene_patience => 'المصيبة والصبر';

  @override
  String get scene_patience_story => 'إذا أُخذ منك شيء، فتذكّر أننا لله.';

  @override
  String get scene_anger => 'كظم الغضب';

  @override
  String get scene_anger_story => 'استعذ بالله قبل كلام قد تندم عليه.';

  @override
  String get scene_pain => 'الألم والمرض';

  @override
  String get scene_pain_story => 'لألمك أنت، ولأخٍ تعوده.';

  @override
  String get scene_rain => 'عند نزول المطر';

  @override
  String get scene_rain_story => 'المطر رحمة — فاسأل الله أن يجعله نافعًا.';

  @override
  String get scene_home => 'العودة إلى البيت';

  @override
  String get scene_home_story => 'ادخل باسمه وسلّم على أهلك.';

  @override
  String get scene_gathering => 'قيام من المجلس';

  @override
  String get scene_gathering_story => 'قبل أن تقوم، امحُ زلات اللسان.';

  @override
  String get scene_forgiveness => 'الاستغفار';

  @override
  String get scene_forgiveness_story => 'أخطاء اليوم تُغسل بالاستغفار.';

  @override
  String get scene_sleep => 'قبل النوم';

  @override
  String get scene_sleep_story => 'اختم اليوم كما بدأته — باسمه وفي حفظه.';

  @override
  String get scene_night => 'في الليل';

  @override
  String get scene_night_story =>
      'إن استيقظت أو رأيت ما تكره في منامك، فهو قريب.';

  @override
  String get part_dawn => 'الفجر';

  @override
  String get part_morning => 'الصباح';

  @override
  String get part_day => 'النهار';

  @override
  String get part_evening => 'المساء';

  @override
  String get part_night => 'الليل';

  @override
  String get removeSession => 'إزالة';

  @override
  String addSession(String session) {
    return 'إضافة $session';
  }

  @override
  String get duaSearchHint => 'ابحث في الأدعية';

  @override
  String duaPartCount(String topics, String duas) {
    return '$topics موضوعات · $duas أدعية';
  }

  @override
  String duaNoResults(String q) {
    return 'لا يوجد دعاء لـ «$q»';
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
      other: 'تم العثور على $nString أدعية',
      one: 'تم العثور على دعاء واحد',
    );
    return '$_temp0';
  }

  @override
  String get part_dawn_sub => 'الاستيقاظ والوضوء والفجر';

  @override
  String get part_morning_sub => 'الأذكار والطعام والخروج';

  @override
  String get part_day_sub => 'الناس والأفراح والابتلاءات';

  @override
  String get part_evening_sub => 'البيت والمجالس والاستغفار';

  @override
  String get part_night_sub => 'النوم والليل';

  @override
  String duaCount(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString أدعية',
      one: 'دعاء واحد',
    );
    return '$_temp0';
  }

  @override
  String get noticeSearchHint => 'ابحث في الإعلانات والمساجد…';

  @override
  String get noticesSub => 'من المساجد من حولك';

  @override
  String get tabNotices => 'الإعلانات';

  @override
  String get chooseSurah => 'انتقل إلى سورة';

  @override
  String get surahSearchHint => 'ابحث عن سورة بالاسم أو الرقم';

  @override
  String get previousSurah => 'السورة السابقة';

  @override
  String get pickOnMapTitle => 'اختر على الخريطة';

  @override
  String get mapSearchHint => 'ابحث عن مسجد أو منطقة';

  @override
  String get useMyLocation => 'موقعي';

  @override
  String get mapPickHint =>
      'حرّك الخريطة حتى يقع الدبوس على المسجد، أو اضغط على مكان، أو على أيقونة مسجد.';

  @override
  String get mapMoving => 'جارٍ تحديد المكان…';

  @override
  String get useThisLocation => 'استخدم هذا الموقع';

  @override
  String get masjidLocation => 'موقع المسجد';

  @override
  String get chooseLocationWay => 'اختر طريقة لتحديد الموقع الدقيق:';

  @override
  String get atTheMasjid => 'أنا في المسجد';

  @override
  String get atTheMasjidBody =>
      'استخدم GPS هاتفك، وابقَ داخل المسجد أثناء التحميل.';

  @override
  String get onTheMap => 'اختر على الخريطة';

  @override
  String get onTheMapBody =>
      'أشِر إلى المسجد على الخريطة، أو اضغط على مسجد ظاهر فيها.';

  @override
  String get locFromMap => 'محدَّد على الخريطة';

  @override
  String get locFromGps => 'GPS';

  @override
  String get locSaved => 'الموقع المحفوظ';

  @override
  String get useGpsInstead => 'استخدم GPS';

  @override
  String get adjustOnMap => 'تعديل على الخريطة';

  @override
  String get allMasjids => 'جميع المساجد';

  @override
  String get nearestFirst => 'الأقرب أولًا';

  @override
  String get duaForNow => 'أدعية هذا الوقت';

  @override
  String get tabChannel => 'القناة';

  @override
  String get channelInviteTitle => 'كن قريبًا من إمامك وخطيبك';

  @override
  String get channelInviteHadith => 'سنن ابن ماجه 224';

  @override
  String get channelInviteBody =>
      'يجب على كل مسلم أن يتعلم فرض العين — أساسيات العقيدة والطهارة والصلاة وأحكام الحياة اليومية — وأفضل طريق لذلك أن يكون بتوجيه عالِم. انضم إلى قناة هذا المسجد لتصلك توجيهات إمامه وخطيبه ورسائلهما، وتزداد قربًا من مسجد حيّك.';

  @override
  String get joinChannel => 'انضم إلى القناة';

  @override
  String get openChannel => 'فتح القناة';

  @override
  String get joinedChannel => 'أنت عضو في قناة هذا المسجد';

  @override
  String get channelJoined => 'تم الانضمام. ستصلك رسائل الإمام والخطيب.';

  @override
  String get leaveChannel => 'مغادرة القناة';

  @override
  String get leaveChannelQ => 'مغادرة هذه القناة؟ لن تصلك رسائلها بعد ذلك.';

  @override
  String get leave => 'مغادرة';

  @override
  String get channelEmpty => 'لا توجد رسائل بعد.';

  @override
  String get channelEmptyAdmin => 'أرسل أول رسالة إلى الأعضاء.';

  @override
  String get channelReadOnly => 'لا ينشر هنا إلا الإمام والخطيب ومشرفو القناة.';

  @override
  String get messageHint => 'اكتب رسالة…';

  @override
  String get send => 'إرسال';

  @override
  String get deleteMessageQ => 'حذف هذه الرسالة لدى الجميع؟';

  @override
  String get members => 'الأعضاء';

  @override
  String get noMembers => 'لم ينضم أحد بعد. ادعُ المصلين في مسجدك.';

  @override
  String get roleMember => 'عضو';

  @override
  String get roleEditor => 'محرر';

  @override
  String get roleAdmin => 'مشرف';

  @override
  String get roleMemberDesc => 'يقرأ الرسائل';

  @override
  String get roleEditorDesc => 'يستطيع إرسال الرسائل';

  @override
  String get roleAdminDesc => 'يرسل الرسائل ويدير الأعضاء';

  @override
  String get removeMember => 'إزالة من القناة';

  @override
  String get you => 'أنت';

  @override
  String get channelMessages => 'رسائل القناة';

  @override
  String get noticesHeading => 'الإعلانات';

  @override
  String get signInToJoin => 'سجّل الدخول للانضمام إلى القناة.';

  @override
  String get monthNames =>
      'يناير,فبراير,مارس,أبريل,مايو,يونيو,يوليو,أغسطس,سبتمبر,أكتوبر,نوفمبر,ديسمبر';

  @override
  String get am => 'ص';

  @override
  String get pm => 'م';

  @override
  String jamatReminderBody(String prayer, String minutes) {
    return 'جماعة $prayer بعد $minutes دقيقة';
  }

  @override
  String get attach => 'إرفاق';

  @override
  String get attachPhoto => 'صورة';

  @override
  String get attachVideo => 'فيديو';

  @override
  String get attachAudio => 'صوت';

  @override
  String get attachFile => 'ملف';

  @override
  String fileTooLarge(String size) {
    return 'الملف كبير جدًا. الحد الأقصى $size.';
  }

  @override
  String get cantOpenFile => 'لا يوجد تطبيق على هذا الهاتف يفتح هذا الملف.';

  @override
  String get channelNotAllowed =>
      'القناة غير متاحة الآن (تم رفض الوصول). يُرجى المحاولة لاحقًا.';

  @override
  String get duaForNowSub => 'أذكار وأدعية هذا الوقت من اليوم';

  @override
  String get approxLocation => 'موقع تقريبي – اضغط لتفعيل الموقع الدقيق';

  @override
  String get signInFirst => 'يرجى تسجيل الدخول أولاً.';

  @override
  String get volunteerTitleEmpty => 'لم تُضف أوقات الجماعة بعد';

  @override
  String get volunteerBodyEmpty =>
      'هل تسكن أو تصلي قرب هذا المسجد؟ أضف أوقات الجماعة وحدّثها للجميع.';

  @override
  String get volunteerTitle => 'هل تصلي هنا بانتظام؟';

  @override
  String get volunteerBody =>
      'ساعد في إبقاء أوقات الجماعة في هذا المسجد صحيحة.';

  @override
  String get volunteerButton => 'أريد تحديث وقت الجماعة';

  @override
  String get volunteerCheckTitle => 'تحديث أوقات هذا المسجد';

  @override
  String volunteerCheckBody(String km) {
    return 'يمكن لمن هم قرب المسجد تحديث أوقاته. سنتحقق من أنك على بُعد $km كم منه – يُستخدم موقعك لهذا التحقق فقط.';
  }

  @override
  String get volunteerCheckButton => 'تحقق من موقعي';

  @override
  String get volunteerChecking => 'جارٍ التحقق من موقعك…';

  @override
  String volunteerTooFar(String distance, String km) {
    return 'أنت على بُعد $distance. اقترب إلى $km كم من المسجد لتحديث أوقاته.';
  }

  @override
  String get volunteerApprox =>
      'هاتفك يشارك موقعاً تقريبياً فقط. فعّل الموقع الدقيق لتطبيق Muslimin وحاول مجدداً.';

  @override
  String get volunteerBlocked =>
      'لا يمكنك تحديث أوقات المساجد حالياً. تواصل مع المشرف إن كان هذا خطأ.';

  @override
  String get volunteerWelcome => 'شكراً لك! يمكنك الآن تحديث أوقات هذا المسجد.';

  @override
  String get stopEditing => 'التوقف عن تحديث هذا المسجد';

  @override
  String get reportProblem => 'الإبلاغ عن مشكلة';

  @override
  String get reportTitle => 'ما المشكلة؟';

  @override
  String get reportWrongTime => 'وقت الجماعة خاطئ';

  @override
  String get reportWrongLocation => 'الموقع على الخريطة خاطئ';

  @override
  String get reportWrongInfo => 'الاسم أو التفاصيل خاطئة';

  @override
  String get reportClosed => 'مغلق أو غير موجود';

  @override
  String get reportDuplicate => 'مكرر';

  @override
  String get reportOther => 'شيء آخر';

  @override
  String get reportNote => 'تفاصيل (اختياري) – مثل الوقت الصحيح';

  @override
  String get reportSend => 'إرسال البلاغ';

  @override
  String get reportThanks => 'شكراً – سيراجعه المشرف.';

  @override
  String get volunteers => 'المحررون المتطوعون';

  @override
  String get noVolunteers => 'لا يوجد متطوعون بعد.';

  @override
  String editorDistance(String distance) {
    return '$distance من المسجد عند الانضمام';
  }

  @override
  String get removeEditor => 'إزالة';

  @override
  String get removeAndBlock => 'إزالة ومنعه من التحرير';

  @override
  String lastUpdatedBy(String when, String name) {
    return 'حُدّث $when بواسطة $name';
  }

  @override
  String get adminReport => 'التقرير';

  @override
  String get adminProblems => 'المشكلات';

  @override
  String get adminEdits => 'التعديلات';

  @override
  String get statMasjids => 'المساجد';

  @override
  String get statWithTimes => 'بأوقات الجماعة';

  @override
  String get statVolunteers => 'المتطوعون';

  @override
  String get statOpenReports => 'مشكلات مفتوحة';

  @override
  String get statPending => 'بانتظار المراجعة';

  @override
  String get shareReport => 'مشاركة التقرير';

  @override
  String get coverageTitle => 'حسب المنطقة';

  @override
  String get coverageLoad => 'عرض المناطق';

  @override
  String get resolve => 'تم الحل';

  @override
  String get revert => 'تراجع عن التغيير';

  @override
  String get reverted => 'تم التراجع عن التغيير';

  @override
  String get editFieldStaff => 'الأئمة والمؤذنون';

  @override
  String get editFieldMaktab => 'المكتب';

  @override
  String timeLooksWrong(String prayers) {
    return 'هذه الأوقات تبدو خاطئة: $prayers. يرجى التحقق من ص/م.';
  }

  @override
  String get dataCredits =>
      'مواقع المساجد: © OpenStreetMap contributors (ODbL). حدود المناطق: مكتب الإحصاء البنغلاديشي / OCHA عبر geoBoundaries (CC BY 3.0 IGO).';

  @override
  String get fromOsm =>
      'أُضيف من OpenStreetMap (© OpenStreetMap contributors). يضيف الأوقات أهل الحي.';

  @override
  String get jumuahNote => 'يوم الجمعة، بدلاً من الظهر';

  @override
  String get chooseThana => 'اختر المنطقة';

  @override
  String get chooseThanaHint => 'يعرض مساجد تلك المنطقة – يبقى موقعك كما هو.';

  @override
  String get searchThana => 'ابحث عن منطقة';

  @override
  String get myThana => 'موقعك الحالي';

  @override
  String get missingMasjidTitle => 'المسجد غير موجود؟';

  @override
  String get missingMasjidBody =>
      'أضف مسجداً قريباً غير مدرج – حدده على الخريطة واكتب اسمه.';

  @override
  String get addMissingMasjid => 'إضافة مسجد';

  @override
  String alreadyListed(String name) {
    return '\"$name\" موجود بالفعل في هذا الموقع.';
  }

  @override
  String get openIt => 'فتحه';

  @override
  String get addAnyway => 'مسجد آخر';

  @override
  String get suggestReviewNote =>
      'يراجعه المشرف قبل ظهوره. بعد الموافقة يمكنك إضافة أوقات الجماعة.';

  @override
  String get suggestNameShort => 'يرجى كتابة اسم المسجد.';

  @override
  String get suggestThanks => 'شكراً! سيضيفه المشرف قريباً.';

  @override
  String get adminNewMasjids => 'مساجد جديدة';

  @override
  String get seeOnMap => 'الخريطة';

  @override
  String get noMasjidInThana => 'لا توجد مساجد مدرجة في هذه المنطقة بعد.';

  @override
  String get allAreas => 'كل المناطق';

  @override
  String get errorBusy => 'التطبيق مشغول جداً الآن. حاول لاحقاً.';

  @override
  String get errorNoAccess => 'ليس لديك صلاحية لهذا.';

  @override
  String get errorOffline => 'لا يوجد اتصال بالإنترنت.';

  @override
  String get walk => 'مشياً';

  @override
  String get drive => 'بالسيارة';

  @override
  String get routeUnavailable => 'الطريق غير متاح – المسافة المباشرة';

  @override
  String get openInMapsApp => 'فتح في تطبيق الخرائط';

  @override
  String minutesShort(String minutes) {
    return '$minutes د';
  }

  @override
  String hoursMinutes(String hours, String minutes) {
    return '$hours س $minutes د';
  }

  @override
  String get fixLocation => 'الموقع خاطئ؟ صحّحه';

  @override
  String get editFieldLocation => 'الموقع';

  @override
  String get attachAnyFile => 'ملف (فيديو، صوت، PDF…)';

  @override
  String get speechUnavailable =>
      'تحويل الكلام إلى نص غير متاح على هذا الهاتف.';

  @override
  String get speechNothing => 'لم يُسمع شيء – اضغط على الميكروفون وتحدث.';

  @override
  String get holdToTalk => 'اضغط مطولاً للتحدث';

  @override
  String get listening => 'جارٍ الاستماع…';

  @override
  String get slideToCancel => 'اسحب للإلغاء';

  @override
  String get channelMembers => 'أعضاء القناة';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';
}
