// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class L10nHi extends L10n {
  L10nHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Muslimin';

  @override
  String get tagline => 'मुस्लिम उम्मत का एक दिन';

  @override
  String get next => 'आगे';

  @override
  String get skip => 'छोड़ें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get create => 'बनाएँ';

  @override
  String get update => 'अपडेट करें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get post => 'पोस्ट करें';

  @override
  String get save => 'सहेजें';

  @override
  String get select => 'चुनें';

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get close => 'बंद करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get done => 'हो गया';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get viewDetails => 'विवरण देखें';

  @override
  String get dontShowAgain => 'फिर न दिखाएँ';

  @override
  String get share => 'शेयर करें';

  @override
  String get addNew => 'नया जोड़ें';

  @override
  String get now => 'अभी';

  @override
  String get selected => 'चुना गया';

  @override
  String get home => 'होम';

  @override
  String get more => 'और';

  @override
  String get loading => 'लोड हो रहा है…';

  @override
  String get somethingWrong => 'कुछ गलत हो गया। कृपया फिर से कोशिश करें।';

  @override
  String get onb1Title => 'जमाअत का समय साझा करें';

  @override
  String get onb1Body =>
      'आसपास के लोग इस ऐप में मस्जिद की जमाअत का समय देख सकेंगे।';

  @override
  String get onb2Title => 'मस्जिद की सूचना पोस्ट करें';

  @override
  String get onb2Body =>
      'लोग इस ऐप में मस्जिद की सूचनाएँ देख सकेंगे, जिससे उन्हें अलग-अलग अवसरों में शामिल होने में मदद मिलेगी।';

  @override
  String get permTitle => 'जारी रखने के लिए अनुमति दें';

  @override
  String get permBody =>
      'आपके आसपास की मस्जिदें खोजने के लिए Muslimin को आपकी लोकेशन चाहिए, और जमाअत से पहले याद दिलाने के लिए नोटिफ़िकेशन।';

  @override
  String get permLocation => 'लोकेशन';

  @override
  String get permLocationBody =>
      'नज़दीकी मस्जिदें खोजें और नमाज़ का सही समय जानें।';

  @override
  String get permNotification => 'नोटिफ़िकेशन';

  @override
  String get permNotificationBody =>
      'जिन मस्जिदों को आप फ़ॉलो करते हैं, उनके जमाअत रिमाइंडर और सूचनाएँ।';

  @override
  String get permAllow => 'अनुमति दें';

  @override
  String get permGranted => 'अनुमति दी गई';

  @override
  String get permOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get permLocationServiceOff =>
      'कृपया अपने फ़ोन में लोकेशन (GPS) चालू करें।';

  @override
  String get permDeniedForever =>
      'अनुमति नहीं दी गई। कृपया इसे सेटिंग्स से चालू करें।';

  @override
  String get permContinue => 'जारी रखें';

  @override
  String get timeLeft => 'बचा समय';

  @override
  String get startsIn => 'शुरू होने में';

  @override
  String get allPrayers => 'सभी नमाज़ें';

  @override
  String get nearestMasjid => 'नज़दीकी मस्जिद';

  @override
  String get noMasjidNearby => 'आपके पास अभी कोई सत्यापित मस्जिद नहीं मिली।';

  @override
  String get noMasjidNearbyHint =>
      'किसी मस्जिद के ज़िम्मेदार को जानते हैं? उनसे Muslimin में मस्जिद रजिस्टर करने को कहें।';

  @override
  String minWalk(String minutes) {
    return '$minutes मिनट पैदल';
  }

  @override
  String kmAway(String km) {
    return '$km किमी दूर';
  }

  @override
  String get jamatNotSet => 'जमाअत का समय तय नहीं';

  @override
  String get nextJamat => 'अगली जमाअत';

  @override
  String get notice => 'सूचना';

  @override
  String get notices => 'सूचनाएँ';

  @override
  String get noNotices => 'अभी कोई सूचना नहीं।';

  @override
  String get all => 'सभी';

  @override
  String get authorityTitle => 'मस्जिद के ज़िम्मेदार';

  @override
  String get authorityBody =>
      'अपनी मस्जिद रजिस्टर करें ताकि आसपास के मुसलमान इस ऐप में उसे खोज सकें।';

  @override
  String get yourLocation => 'आपकी लोकेशन';

  @override
  String get locating => 'लोकेशन खोजी जा रही है…';

  @override
  String get useCurrentLocation => 'मौजूदा लोकेशन इस्तेमाल करें';

  @override
  String get searchMasjid => 'मस्जिद खोजें';

  @override
  String get nearbyMasjids => 'आसपास की मस्जिदें';

  @override
  String get fajr => 'फ़ज्र';

  @override
  String get sunrise => 'सूर्योदय';

  @override
  String get dhuhr => 'ज़ुहर';

  @override
  String get asr => 'अस्र';

  @override
  String get maghrib => 'मग़रिब';

  @override
  String get isha => 'इशा';

  @override
  String get jumuah => 'जुमा';

  @override
  String get forbiddenTime => 'मकरूह समय';

  @override
  String get forbiddenInfo =>
      'इन समयों में नमाज़ नहीं पढ़ी जाती: सूरज निकलते समय, ठीक दोपहर के समय और सूरज डूबते समय।';

  @override
  String get morning => 'सुबह';

  @override
  String get noon => 'दोपहर';

  @override
  String get evening => 'शाम';

  @override
  String get naflPrayers => 'नफ़्ल नमाज़ें';

  @override
  String get tahajjud => 'तहज्जुद';

  @override
  String get duha => 'सलातुज़-ज़ुहा (चाश्त)';

  @override
  String get tahajjudHadith =>
      'अल्लाह के रसूल (ﷺ) ने फ़रमाया: \"हमारा बरकत वाला और सर्वोच्च रब हर रात दुनिया के आसमान पर उतरता है जब रात का आख़िरी तिहाई हिस्सा बाक़ी रहता है, और फ़रमाता है: कौन है जो मुझे पुकारे कि मैं उसकी पुकार क़बूल करूँ? कौन है जो मुझसे माँगे कि मैं उसे दूँ? कौन है जो मुझसे माफ़ी माँगे कि मैं उसे माफ़ कर दूँ?\"';

  @override
  String get tahajjudSource => 'सहीह बुख़ारी 1145';

  @override
  String get duhaHadith1 =>
      'अबू हुरैरा (रज़ि.) ने कहा: \"मेरे ख़लील, अल्लाह के रसूल (ﷺ) ने मुझे तीन बातों की वसीयत की: हर महीने तीन दिन के रोज़े, चाश्त की नमाज़, और सोने से पहले वित्र पढ़ना।\"';

  @override
  String get duhaSource1 => 'सहीह बुख़ारी और मुस्लिम';

  @override
  String get duhaHadith2 =>
      'नुऐम बिन हम्मार (रज़ि.) से रिवायत है कि अल्लाह के रसूल (ﷺ) ने फ़रमाया: \"अल्लाह तआला फ़रमाता है: ऐ आदम के बेटे! दिन की शुरुआत में मेरे लिए चार रकअत पढ़ने से न थक, मैं दिन के आख़िर तक तेरे लिए काफ़ी हो जाऊँगा।\"';

  @override
  String get duhaSource2 => 'सुनन अबी दाऊद 1289';

  @override
  String get calcMethodNote =>
      'समय आपकी लोकेशन के अनुसार निकाले जाते हैं। जमाअत का समय हर मस्जिद ख़ुद तय करती है।';

  @override
  String get following => 'फ़ॉलो कर रहे हैं';

  @override
  String get follow => 'फ़ॉलो करें';

  @override
  String get tabHome => 'होम';

  @override
  String get tabNotice => 'सूचना';

  @override
  String get tabLive => 'लाइव';

  @override
  String get tabAbout => 'परिचय';

  @override
  String get jamatTime => 'जमाअत का समय';

  @override
  String get maktabTime => 'मकतब का समय';

  @override
  String lastUpdated(String when) {
    return 'अंतिम अपडेट $when';
  }

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String daysAgo(String count) {
    return '$count दिन पहले';
  }

  @override
  String get khatib => 'ख़तीब';

  @override
  String get imam => 'इमाम';

  @override
  String get muazzin => 'मुअज़्ज़िन';

  @override
  String contact(String phone) {
    return 'संपर्क: $phone';
  }

  @override
  String get notAdded => 'अभी जोड़ा नहीं गया';

  @override
  String get jamatReminder => 'जमाअत रिमाइंडर';

  @override
  String get notifyBefore => 'पहले याद दिलाएँ';

  @override
  String minsBefore(String minutes) {
    return '$minutes मिनट';
  }

  @override
  String get reminderOff => 'रिमाइंडर बंद करें';

  @override
  String reminderSet(String minutes) {
    return 'हर जमाअत से $minutes मिनट पहले आपको याद दिलाया जाएगा।';
  }

  @override
  String followedToast(String name) {
    return 'अब आप $name को फ़ॉलो कर रहे हैं।';
  }

  @override
  String get directions => 'रास्ता';

  @override
  String get liveNow => 'अभी लाइव';

  @override
  String get noLive => 'अभी कोई लाइव प्रसारण नहीं';

  @override
  String get noLiveHint =>
      'जब मस्जिद ख़ुत्बा या बयान प्रसारित करेगी, वह यहाँ दिखेगा।';

  @override
  String get watchLive => 'लाइव देखें';

  @override
  String get liveLink => 'लाइव स्ट्रीम लिंक (YouTube / Facebook)';

  @override
  String get liveToggle => 'हम अभी लाइव हैं';

  @override
  String get maktabDays => 'मकतब के दिन';

  @override
  String get weekdaysShort => 'शनि,रवि,सोम,मंगल,बुध,गुरु,शुक्र';

  @override
  String get weekdaysLong =>
      'शनिवार,रविवार,सोमवार,मंगलवार,बुधवार,गुरुवार,शुक्रवार';

  @override
  String dayRange(String from, String to) {
    return '$from ~ $to';
  }

  @override
  String get tapToSet => 'तय करें';

  @override
  String get khatibName => 'ख़तीब का नाम';

  @override
  String get imamName => 'इमाम का नाम';

  @override
  String get muazzinName => 'मुअज़्ज़िन का नाम';

  @override
  String get contactNumber => 'संपर्क नंबर';

  @override
  String get updated => 'सफलतापूर्वक अपडेट हुआ';

  @override
  String get writeNotice => 'सूचना लिखें';

  @override
  String get selectCategory => 'श्रेणी चुनें';

  @override
  String get deleteNoticeQ => 'यह सूचना हटाएँ?';

  @override
  String get catJanaza => 'जनाज़ा';

  @override
  String get catRecruitment => 'भर्ती';

  @override
  String get catQuran => 'क़ुरआन क्लास';

  @override
  String get catQuranShort => 'क़ुरआन';

  @override
  String get catMahfil => 'महफ़िल';

  @override
  String get catTalim => 'तालीम';

  @override
  String get catTafsir => 'तफ़सीर';

  @override
  String get catGeneral => 'सामान्य';

  @override
  String get janazaNotice => 'जनाज़े की सूचना';

  @override
  String noticeFormTitle(String category) {
    return '$category सूचना';
  }

  @override
  String get enterCarefully => 'कृपया नीचे दी गई जानकारी ध्यान से भरें।';

  @override
  String get personName => 'मरहूम का नाम';

  @override
  String get fathersName => 'पिता का नाम';

  @override
  String get diedOn => 'मृत्यु की तारीख़';

  @override
  String get address => 'पता';

  @override
  String get janazaTime => 'जनाज़े का समय';

  @override
  String get janazaDate => 'जनाज़े की तारीख़';

  @override
  String get noticeTitle => 'शीर्षक';

  @override
  String get noticeDetails => 'विवरण';

  @override
  String get date => 'तारीख़';

  @override
  String get time => 'समय';

  @override
  String deadline(String date) {
    return 'अंतिम तिथि: $date';
  }

  @override
  String startingDate(String date) {
    return 'शुरुआत की तारीख़: $date';
  }

  @override
  String timeAndDate(String value) {
    return 'समय और तारीख़: $value';
  }

  @override
  String janazaOf(String name) {
    return '$name का जनाज़ा';
  }

  @override
  String sonOf(String name) {
    return '$name के बेटे/बेटी';
  }

  @override
  String get noticePosted => 'सूचना पोस्ट हो गई';

  @override
  String get required => 'ज़रूरी';

  @override
  String get userAuth => 'उपयोगकर्ता सत्यापन';

  @override
  String get userAuthBody =>
      'अगर नीचे की बातें आप पर लागू होती हैं तो पढ़कर सहमति दें।';

  @override
  String get rule1 =>
      'मैं मस्जिद कमेटी का सदस्य या मस्जिद का ख़ादिम/मुअज़्ज़िन/इमाम हूँ';

  @override
  String get rule2 =>
      'मैं मस्जिद की जमाअत का समय नियमित रूप से अपडेट कर सकता हूँ';

  @override
  String get rule3 => 'मैं इस ऐप का फ़ायदा समझता हूँ';

  @override
  String get rule4 => 'मैं मस्जिद की सही लोकेशन चिह्नित करूँगा';

  @override
  String get agreeAll => 'जारी रखने के लिए सभी बातों की पुष्टि करें।';

  @override
  String get registration => 'रजिस्ट्रेशन';

  @override
  String get verifyMobile => 'अपना मोबाइल नंबर सत्यापित करें';

  @override
  String get yourMobile => 'आपका मोबाइल नंबर';

  @override
  String get otpWillBeSent =>
      'सत्यापन के लिए इस नंबर पर वन टाइम पासवर्ड (OTP) भेजा जाएगा';

  @override
  String get getOtp => 'OTP पाएँ';

  @override
  String get invalidPhone => 'सही बांग्लादेशी मोबाइल नंबर डालें (01XXXXXXXXX)।';

  @override
  String get verification => 'सत्यापन';

  @override
  String get typeOtp => 'कृपया अपने फ़ोन पर भेजा गया OTP कोड डालें';

  @override
  String get otp => 'वन टाइम पासवर्ड (OTP)';

  @override
  String get didntGetOtp => 'OTP नहीं मिला?';

  @override
  String get resendCode => 'कोड दोबारा भेजें';

  @override
  String resendIn(String seconds) {
    return '$seconds सेकंड में दोबारा भेजें';
  }

  @override
  String get verify => 'सत्यापित करें';

  @override
  String get invalidOtp => 'कोड सही नहीं है। कृपया फिर से कोशिश करें।';

  @override
  String get demoOtpHint => 'डेमो मोड: कोड 123456 इस्तेमाल करें';

  @override
  String get createMasjidProfile => 'मस्जिद प्रोफ़ाइल बनाएँ';

  @override
  String get stayInside =>
      'नीचे का विवरण ध्यान से भरें। आप लोकेशन मस्जिद के अंदर से या नक़्शे पर तय कर सकते हैं।';

  @override
  String get masjidName => 'मस्जिद का नाम';

  @override
  String get district => 'ज़िला';

  @override
  String get thana => 'थाना / उपज़िला';

  @override
  String get latLng => 'अक्षांश और देशांतर';

  @override
  String get load => 'लोड करें';

  @override
  String get reload => 'फिर से लोड करें';

  @override
  String get stayInsideLoading => 'लोड होने तक मस्जिद के अंदर रहें।';

  @override
  String accuracy(String meters) {
    return 'सटीकता ±$meters मी';
  }

  @override
  String accuracyTooLow(String meters) {
    return 'लोकेशन पर्याप्त सटीक नहीं है (±$meters मी)। मस्जिद के अंदर खुली जगह पर जाकर फिर से लोड करें।';
  }

  @override
  String get loadLocationFirst => 'कृपया मस्जिद की लोकेशन तय करें।';

  @override
  String get nidNumber => 'आपका राष्ट्रीय पहचान (NID) नंबर';

  @override
  String get invalidNid => 'NID 10, 13 या 17 अंकों का होना चाहिए।';

  @override
  String get yourRole => 'आपकी भूमिका';

  @override
  String get roleCommittee => 'कमेटी सदस्य';

  @override
  String get roleKhadem => 'ख़ादिम';

  @override
  String get roleMuazzin => 'मुअज़्ज़िन';

  @override
  String get roleImam => 'इमाम';

  @override
  String get roleKhatib => 'ख़तीब';

  @override
  String get agreeTermsPrefix => 'मैंने पढ़ लिया है और सहमत हूँ: ';

  @override
  String get termsAndConditions => 'नियम और शर्तें';

  @override
  String get mustAgreeTerms => 'कृपया नियम और शर्तों से सहमति दें।';

  @override
  String duplicateFound(String name) {
    return 'इस जगह \"$name\" नाम की मस्जिद पहले से रजिस्टर है। अगर आप इसके ज़िम्मेदार हैं तो सपोर्ट से संपर्क करें।';
  }

  @override
  String limitReached(String count) {
    return 'आप ज़्यादा से ज़्यादा $count मस्जिद प्रोफ़ाइल रख सकते हैं।';
  }

  @override
  String get submittedTitle => 'समीक्षा के लिए भेजा गया';

  @override
  String get submittedBody =>
      'जज़ाकल्लाहु ख़ैरन! हमारी टीम के सत्यापन के बाद आपकी मस्जिद की प्रोफ़ाइल सबको दिखेगी। मंज़ूरी मिलने पर आपको नोटिफ़िकेशन मिलेगा।';

  @override
  String get backToHome => 'होम पर वापस';

  @override
  String get termsBody =>
      '1. केवल मस्जिद कमेटी के सदस्य, इमाम, ख़तीब, मुअज़्ज़िन या ख़ादिम ही मस्जिद प्रोफ़ाइल बना सकते हैं।\n2. मस्जिद की लोकेशन बिल्कुल सही होनी चाहिए — मस्जिद के अंदर से GPS के ज़रिए या नक़्शे पर चिह्नित करके।\n3. आपका NID और फ़ोन नंबर केवल सत्यापन के लिए इस्तेमाल होता है और कभी सार्वजनिक नहीं किया जाता।\n4. जमाअत का समय और सूचनाएँ सही और अपडेट रखनी ज़रूरी हैं।\n5. सूचनाएँ मस्जिद की गतिविधियों से संबंधित होनी चाहिए। राजनीतिक, व्यावसायिक या नफ़रत भरी सामग्री की अनुमति नहीं है।\n6. Muslimin टीम के सत्यापन तक प्रोफ़ाइल छिपी रहती है। ग़लत जानकारी वाली प्रोफ़ाइल हटा दी जाएगी।';

  @override
  String get statusPending => 'समीक्षा लंबित';

  @override
  String get statusApproved => 'स्वीकृत';

  @override
  String get statusRejected => 'अस्वीकृत';

  @override
  String get statusSuspended => 'निलंबित';

  @override
  String get pendingBanner =>
      'यह प्रोफ़ाइल सत्यापन की प्रतीक्षा में है। इसे केवल आप देख सकते हैं।';

  @override
  String rejectedBanner(String reason) {
    return 'यह प्रोफ़ाइल स्वीकृत नहीं हुई: $reason';
  }

  @override
  String get myMasjids => 'मेरी मस्जिदें';

  @override
  String get registerMasjid => 'मस्जिद रजिस्टर करें';

  @override
  String get appSettings => 'ऐप सेटिंग्स';

  @override
  String get faq => 'अक्सर पूछे जाने वाले सवाल';

  @override
  String get aboutApp => 'ऐप के बारे में';

  @override
  String get shareApp => 'यह ऐप शेयर करें';

  @override
  String get shareAppBody =>
      'यह ऐप आपके परिवार और दोस्तों के लिए भी मददगार हो सकता है। कृपया शेयर करें।';

  @override
  String shareText(String url) {
    return 'Muslimin से अपने पास की मस्जिदों में जमाअत का समय जानें: $url';
  }

  @override
  String get language => 'भाषा';

  @override
  String get calcMethod => 'नमाज़ के समय की गणना';

  @override
  String get asrMethod => 'अस्र की गणना';

  @override
  String get hanafi => 'हनफ़ी';

  @override
  String get shafi => 'शाफ़ई / मालिकी / हंबली';

  @override
  String get hijriAdjust => 'हिजरी तारीख़ समायोजन';

  @override
  String days(String count) {
    return '$count दिन';
  }

  @override
  String get defaultReminder => 'डिफ़ॉल्ट जमाअत रिमाइंडर';

  @override
  String get signOut => 'साइन आउट';

  @override
  String signedInAs(String phone) {
    return '$phone के रूप में साइन इन';
  }

  @override
  String version(String v) {
    return 'संस्करण $v';
  }

  @override
  String get aboutBody =>
      'Muslimin मुसलमानों को उनके आसपास की मस्जिदों में जमाअत का समय जानने में मदद करता है। हर मस्जिद प्रोफ़ाइल उसके अपने ज़िम्मेदार बनाते हैं और सार्वजनिक होने से पहले हमारी टीम उसका सत्यापन करती है।';

  @override
  String get faqQ1 => 'जमाअत का समय कहाँ से आता है?';

  @override
  String get faqA1 =>
      'हर मस्जिद के ज़िम्मेदार अपनी जमाअत का समय तय और अपडेट करते हैं। नमाज़ शुरू होने का समय आपकी लोकेशन के अनुसार निकाला जाता है।';

  @override
  String get faqQ2 => 'लोकेशन ज़रूरी क्यों है?';

  @override
  String get faqA2 =>
      'लोकेशन से आपके पास की मस्जिदें दिखाई जाती हैं और नमाज़ का सही समय निकाला जाता है। इसे कभी किसी से साझा नहीं किया जाता।';

  @override
  String get faqQ3 => 'मैं अपनी मस्जिद कैसे जोड़ूँ?';

  @override
  String get faqA3 =>
      'और → मस्जिद रजिस्टर करें पर जाएँ। आपका कमेटी सदस्य, इमाम, मुअज़्ज़िन, ख़तीब या ख़ादिम होना ज़रूरी है, और आप मस्जिद की सही लोकेशन तय करें — मस्जिद के अंदर से GPS से या नक़्शे पर।';

  @override
  String get faqQ4 => 'मेरी मस्जिद क्यों नहीं दिख रही?';

  @override
  String get faqA4 =>
      'नई प्रोफ़ाइलें सार्वजनिक होने से पहले हमारी टीम सत्यापित करती है। इसमें आमतौर पर 1–2 दिन लगते हैं।';

  @override
  String get faqQ5 => 'जमाअत रिमाइंडर कैसे काम करते हैं?';

  @override
  String get faqA5 =>
      'कोई मस्जिद खोलें और जमाअत के समय पर घंटी दबाएँ। हर जमाअत से 15, 30 या 45 मिनट पहले आपको सूचना मिलेगी, ऐप बंद होने पर भी।';

  @override
  String get notifications => 'नोटिफ़िकेशन';

  @override
  String get noNotifications =>
      'मस्जिदों को फ़ॉलो करें ताकि उनकी सूचनाएँ यहाँ दिखें।';

  @override
  String get adminPanel => 'एडमिन पैनल';

  @override
  String get adminPending => 'लंबित';

  @override
  String get adminApproved => 'स्वीकृत';

  @override
  String get adminRejected => 'अस्वीकृत';

  @override
  String get approve => 'स्वीकृत करें';

  @override
  String get reject => 'अस्वीकार करें';

  @override
  String get suspend => 'निलंबित करें';

  @override
  String get restore => 'बहाल करें';

  @override
  String get rejectReason => 'अस्वीकार करने का कारण';

  @override
  String get submittedBy => 'भेजने वाले';

  @override
  String get phone => 'फ़ोन';

  @override
  String get nid => 'NID';

  @override
  String get role => 'भूमिका';

  @override
  String get location => 'लोकेशन';

  @override
  String get openInMaps => 'मैप्स में खोलें';

  @override
  String get submittedOn => 'भेजने की तारीख़';

  @override
  String get nothingHere => 'यहाँ कुछ नहीं';

  @override
  String get approvedToast => 'मस्जिद स्वीकृत';

  @override
  String get rejectedToast => 'मस्जिद अस्वीकृत';

  @override
  String get verifiedChecklist =>
      'स्वीकृति से पहले भेजने वाले को कॉल करें और नक़्शे पर लोकेशन जाँचें।';

  @override
  String get verse1Ar => 'وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ';

  @override
  String get verse1 => 'तथा सब्र और नमाज़ से मदद माँगो';

  @override
  String get verse1Ref => 'अल-बक़रा 2:45';

  @override
  String get verse2Ar =>
      'إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَـٰبًا مَّوْقُوتًا';

  @override
  String get verse2 =>
      'निःसंदेह नमाज़ ईमान वालों पर निर्धारित समय पर फ़र्ज़ की गई है।';

  @override
  String get verse2Ref => 'अन-निसा 4:103';

  @override
  String get verse3Ar =>
      'حَـٰفِظُوا۟ عَلَى ٱلصَّلَوَٰتِ وَٱلصَّلَوٰةِ ٱلْوُسْطَىٰ';

  @override
  String get verse3 =>
      'सब नमाज़ों का और (विशेषकर) बीच की नमाज़ (अस्र) का ध्यान रखो';

  @override
  String get verse3Ref => 'अल-बक़रा 2:238';

  @override
  String get hijriMonths =>
      'मुहर्रम,सफ़र,रबीउल अव्वल,रबीउस सानी,जुमादल ऊला,जुमादस सानिया,रजब,शाबान,रमज़ान,शव्वाल,ज़ुल क़अदा,ज़ुल हिज्जा';

  @override
  String get deadlineLabel => 'अंतिम तिथि';

  @override
  String get startingDateLabel => 'शुरुआत की तारीख़';

  @override
  String get masjidNameBn => 'मस्जिद का नाम बांग्ला में (वैकल्पिक)';

  @override
  String get createAccount => 'खाता बनाएँ';

  @override
  String get signIn => 'साइन इन';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get noAccount => 'खाता नहीं है?';

  @override
  String get haveAccount => 'पहले से खाता है?';

  @override
  String get signUpBody =>
      'मस्जिदें फ़ॉलो करने और अपनी सेटिंग्स सुरक्षित रखने के लिए खाता बनाएँ।';

  @override
  String get signInBody => 'फिर से स्वागत है! जारी रखने के लिए साइन इन करें।';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get resetBody =>
      'वह ईमेल डालें जिससे आपने साइन अप किया था। हम नया पासवर्ड बनाने का लिंक भेजेंगे।';

  @override
  String get sendResetLink => 'रीसेट लिंक भेजें';

  @override
  String resetSent(String email) {
    return 'पासवर्ड रीसेट लिंक $email पर भेज दिया गया है। कृपया अपना इनबॉक्स (और स्पैम फ़ोल्डर) देखें।';
  }

  @override
  String get backToSignIn => 'साइन इन पर वापस';

  @override
  String get invalidEmail => 'सही ईमेल पता डालें।';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए।';

  @override
  String get passwordsDontMatch => 'पासवर्ड मेल नहीं खाते।';

  @override
  String get errEmailInUse => 'इस ईमेल से पहले से खाता है। साइन इन करके देखें।';

  @override
  String get errInvalidCredential => 'ईमेल या पासवर्ड ग़लत है।';

  @override
  String get errWeakPassword =>
      'कृपया मज़बूत पासवर्ड चुनें (कम से कम 6 अक्षर)।';

  @override
  String get errTooManyRequests =>
      'बहुत ज़्यादा कोशिशें। कुछ मिनट रुककर फिर से कोशिश करें।';

  @override
  String get errNetwork => 'इंटरनेट कनेक्शन नहीं है। कृपया फिर से कोशिश करें।';

  @override
  String get errPhoneInUse => 'यह फ़ोन नंबर किसी दूसरे खाते से जुड़ा है।';

  @override
  String get errUserDisabled =>
      'यह खाता बंद कर दिया गया है। कृपया सपोर्ट से संपर्क करें।';

  @override
  String get myAccount => 'मेरा खाता';

  @override
  String get signInPrompt => 'मस्जिद के ज़िम्मेदारों के लिए';

  @override
  String get signInPromptBody =>
      'अपनी मस्जिद रजिस्टर और प्रबंधित करने के लिए साइन इन करें या खाता बनाएँ। आम उपयोगकर्ताओं को खाते की ज़रूरत नहीं है।';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get emailNotVerified => 'ईमेल सत्यापित नहीं';

  @override
  String get emailVerified => 'ईमेल सत्यापित';

  @override
  String get resendVerification => 'सत्यापन ईमेल भेजें';

  @override
  String verificationSent(String email) {
    return 'सत्यापन ईमेल $email पर भेजा गया।';
  }

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get currentPassword => 'मौजूदा पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get passwordChanged => 'पासवर्ड सफलतापूर्वक बदल गया।';

  @override
  String get deleteAccount => 'खाता हटाएँ';

  @override
  String get deleteAccountBody =>
      'इससे आपका खाता और सहेजा गया डेटा हमेशा के लिए हट जाएगा। आपकी प्रबंधित मस्जिद प्रोफ़ाइलें बनी रहेंगी, लेकिन आपकी पहुँच ख़त्म हो जाएगी। पुष्टि के लिए पासवर्ड डालें।';

  @override
  String get accountDeleted => 'आपका खाता हटा दिया गया है।';

  @override
  String get phoneNumber => 'फ़ोन';

  @override
  String get notVerified => 'सत्यापित नहीं';

  @override
  String welcomeUser(String name) {
    return 'स्वागत है, $name!';
  }

  @override
  String get signInToRegister =>
      'मस्जिद रजिस्टर करने के लिए साइन इन करें या खाता बनाएँ।';

  @override
  String get verifyPhoneToContinue =>
      'मस्जिद रजिस्टर करने के लिए अपना फ़ोन नंबर सत्यापित करें।';

  @override
  String accountCreated(String email) {
    return 'खाता बन गया! हमने $email पर सत्यापन लिंक भेजा है।';
  }

  @override
  String get nameRequired => 'कृपया अपना नाम डालें।';

  @override
  String get credits => 'आभार';

  @override
  String get fontCredits =>
      'लोगो और अंग्रेज़ी में नमाज़ों के नाम: Muslimin डिज़ाइन की लिखावट, Anthonie Van Hayu (ARToni) के Hidayatullah पर आधारित। फ़ॉन्ट: Omnibus-Type का Grenze Gotisch, Indian Type Foundry और Jonny Pinhorn का Poppins, Indian Type Foundry का Hind Siliguri, Ek Type का Anek Bangla (बांग्ला अंक), Black Foundry का Galada, SIL International का Scheherazade New। सभी फ़ॉन्ट SIL Open Font License 1.1 के तहत मुफ़्त हैं।';

  @override
  String get designInspired =>
      'मूल डिज़ाइन फ़ॉन्ट: Anthonie Van Hayu (ARToni) का Hidayatullah।';

  @override
  String get openSourceLicenses => 'ओपन-सोर्स लाइसेंस';

  @override
  String get continueWithGoogle => 'Google के साथ जारी रखें';

  @override
  String get orDivider => 'या';

  @override
  String get onb3Title => 'नमाज़ का समय और रिमाइंडर';

  @override
  String get onb3Body =>
      'आपकी लोकेशन के लिए नमाज़ का सही समय, और आपकी फ़ॉलो की गई मस्जिदों में हर जमाअत से पहले रिमाइंडर।';

  @override
  String get appVersion => 'ऐप संस्करण';

  @override
  String get checkingUpdates => 'अपडेट जाँचे जा रहे हैं…';

  @override
  String get upToDate => 'आपके पास नवीनतम संस्करण है।';

  @override
  String updateAvailable(String version) {
    return 'नया संस्करण $version उपलब्ध है';
  }

  @override
  String get downloadLatestApk => 'नवीनतम APK डाउनलोड करें';

  @override
  String get updateApkHint =>
      'डाउनलोड की गई फ़ाइल खोलकर इसे इस संस्करण के ऊपर इंस्टॉल करें। आपकी सेटिंग्स बनी रहेंगी।';

  @override
  String get updateIosButton => 'iPhone पर अपडेट कैसे करें';

  @override
  String get updateCheckFailed =>
      'अपडेट जाँचे नहीं जा सके। अपना इंटरनेट कनेक्शन जाँचें।';

  @override
  String get releaseNotes => 'रिलीज़ नोट्स';

  @override
  String get selectAll => 'सभी चुनें';

  @override
  String get welcomeTitle => 'अस्सलामु अलैकुम';

  @override
  String get welcomeBody =>
      'अपनी मस्जिदें फ़ॉलो करने, जमाअत रिमाइंडर पाने और सब कुछ अपने फ़ोनों पर सिंक रखने के लिए साइन इन करें।';

  @override
  String get continueAsGuest => 'मेहमान के रूप में जारी रखें';

  @override
  String get editMasjidInfo => 'मस्जिद की जानकारी संपादित करें';

  @override
  String get editMasjidInfoBody =>
      'अपनी मस्जिद प्रोफ़ाइल पर दिखने वाली जानकारी अपडेट करें, जिसमें उसकी लोकेशन भी है (मस्जिद में GPS से या नक़्शे पर चुनकर)।';

  @override
  String get followedMasjids => 'फ़ॉलो की गई मस्जिदें';

  @override
  String get noFollowed => 'आप अभी किसी मस्जिद को फ़ॉलो नहीं कर रहे।';

  @override
  String get noFollowedHint =>
      'कोई मस्जिद खोलें और फ़ॉलो दबाएँ ताकि वह यहाँ दिखे और उसकी सूचनाएँ मिलें।';

  @override
  String reminderBadge(String minutes) {
    return 'रिमाइंडर $minutes मिनट';
  }

  @override
  String get manageMasjids => 'मस्जिदें प्रबंधित करें';

  @override
  String get noMyMasjids => 'आपने अभी कोई मस्जिद रजिस्टर नहीं की है।';

  @override
  String get noMyMasjidsHint =>
      'कमेटी सदस्य, इमाम, ख़तीब, मुअज़्ज़िन या ख़ादिम अपनी मस्जिद रजिस्टर कर सकते हैं। सार्वजनिक होने से पहले हमारी टीम सत्यापन करती है।';

  @override
  String get appearance => 'रूप';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get appearanceHint =>
      'फ़ज्र और इशा के समय डार्क मोड आँखों के लिए आरामदायक है।';

  @override
  String get pullToRefresh => 'रीफ़्रेश के लिए नीचे खींचें';

  @override
  String get verifyAutoCheck =>
      'हमारे ईमेल किए गए लिंक को खोलें — सत्यापन होते ही यह पेज ख़ुद अपडेट हो जाएगा।';

  @override
  String get signOutTitle => 'साइन आउट करें?';

  @override
  String get signOutBody =>
      'इस फ़ोन पर फ़ॉलो की गई मस्जिदें देखने और जमाअत रिमाइंडर पाने के लिए आपको फिर से साइन इन करना होगा।';

  @override
  String jamatLine(String prayer, String time) {
    return '$prayer जमाअत $time';
  }

  @override
  String get scanBoard => 'समय बोर्ड स्कैन करें';

  @override
  String get scanBoardHint =>
      'मस्जिद के समय बोर्ड की फ़ोटो लें और जमाअत के सभी समय अपने आप भर जाएँगे — या किसी समय को दबाकर ख़ुद तय करें।';

  @override
  String get takePhoto => 'फ़ोटो लें';

  @override
  String get chooseGallery => 'गैलरी से चुनें';

  @override
  String get scanStage1 => 'समय बोर्ड देखा जा रहा है…';

  @override
  String get scanStage2 => 'अंक पढ़े जा रहे हैं…';

  @override
  String get scanStage3 => 'फ़ज्र से इशा तक मिलाया जा रहा है…';

  @override
  String get scanStage4 => 'जुमा जाँचा जा रहा है…';

  @override
  String scanFound(String count) {
    return '$count समय मिले';
  }

  @override
  String get scanFailed =>
      'यह फ़ोटो पढ़ी नहीं जा सकी। बोर्ड की साफ़ और सीधी फ़ोटो लें, या समय ख़ुद डालें।';

  @override
  String get enterManually => 'ख़ुद डालें';

  @override
  String get scanReview =>
      'फ़ोटो से भरे गए समय (✦ चिह्नित)। इन्हें जाँचें, फिर अपडेट दबाएँ।';

  @override
  String get tabRead => 'पढ़ें';

  @override
  String get readQuran => 'क़ुरआन पढ़ें';

  @override
  String get journeySub => 'सभी 114 सूरतों में आपकी यात्रा';

  @override
  String surahsProgress(String done) {
    return '114 में से $done सूरतें';
  }

  @override
  String get versesRead => 'आयतें पढ़ीं';

  @override
  String get phasesDone => 'चरण पूरे';

  @override
  String get continueReading => 'जारी रखें';

  @override
  String get startReading => 'पढ़ना शुरू करें';

  @override
  String phaseN(String n) {
    return 'चरण $n';
  }

  @override
  String versesN(String n) {
    return '$n आयतें';
  }

  @override
  String get completed => 'पूरा';

  @override
  String get locked => 'लॉक';

  @override
  String ayahOf(String n, String total) {
    return 'आयत $n / $total';
  }

  @override
  String unlockHint(String surah) {
    return 'यह सूरत खोलने के लिए $surah पूरी करें।';
  }

  @override
  String get quizUnlockHint =>
      'इस चरण का क्विज़ खोलने के लिए इसकी सभी सूरतें पढ़ें।';

  @override
  String phaseQuiz(String n) {
    return 'चरण $n क्विज़';
  }

  @override
  String get quizOptional => 'वैकल्पिक · जो पढ़ा उसे परखें';

  @override
  String bestScore(String score) {
    return 'सर्वश्रेष्ठ $score%';
  }

  @override
  String get makki => 'मक्की';

  @override
  String get madani => 'मदनी';

  @override
  String get loadingSurah => 'सूरत लाई जा रही है…';

  @override
  String get completeSurah => 'मैंने यह सूरत पूरी कर ली';

  @override
  String get nextSurah => 'अगली सूरत';

  @override
  String surahDone(String name) {
    return 'माशाअल्लाह! आपने सूरह $name पूरी कर ली।';
  }

  @override
  String nextUnlocked(String name) {
    return '$name अब खुल गई है।';
  }

  @override
  String get takeQuiz => 'चरण क्विज़ दें';

  @override
  String get later => 'बाद में';

  @override
  String get wordByWord => 'शब्द-दर-शब्द';

  @override
  String get quranSource =>
      'मुसहफ़ का पाठ और शब्द-दर-शब्द: quran.com (किंग फ़हद कॉम्प्लेक्स उस्मानी लिपि) · अनुवाद: मौलाना अज़ीज़ुल हक़ उमरी';

  @override
  String get startHere => 'शुरू';

  @override
  String get quizWordMeaning => 'इस शब्द का क्या अर्थ है?';

  @override
  String get quizAyahMeaning => 'इस आयत का क्या अर्थ है?';

  @override
  String get quizWhichSurah => 'यह आयत किस सूरत की है?';

  @override
  String quizRevealed(String name) {
    return 'सूरह $name कहाँ उतरी?';
  }

  @override
  String get makkah => 'मक्का';

  @override
  String get madinah => 'मदीना';

  @override
  String quizVerses(String name) {
    return 'सूरह $name में कितनी आयतें हैं?';
  }

  @override
  String quizNameMeans(String name) {
    return 'नाम “$name” का क्या अर्थ है?';
  }

  @override
  String get kindVocabulary => 'शब्दावली';

  @override
  String get kindMeaning => 'अर्थ';

  @override
  String get kindSurah => 'कौन-सी सूरत';

  @override
  String get kindFacts => 'सूरत के तथ्य';

  @override
  String get quizCorrect => 'सही — माशाअल्लाह!';

  @override
  String get quizWrong => 'सही नहीं — सही उत्तर हाइलाइट है।';

  @override
  String get continueBtn => 'जारी रखें';

  @override
  String quizScore(String score) {
    return 'आपका स्कोर $score%';
  }

  @override
  String get quizDoneBody =>
      'क्विज़ वैकल्पिक हैं — ये पढ़ा हुआ याद रखने में मदद करते हैं।';

  @override
  String get quizLoading => 'आपका क्विज़ तैयार हो रहा है…';

  @override
  String get tabQuran => 'क़ुरआन';

  @override
  String get tabDua => 'दुआ';

  @override
  String get specialSurahs => 'पढ़ने के लिए अनुशंसित';

  @override
  String get chipMulk => 'अल-मुल्क';

  @override
  String get chipMulkWhen => 'सोने से पहले';

  @override
  String get chipSajdah => 'अस-सज्दा';

  @override
  String get chipKahf => 'अल-कहफ़';

  @override
  String get chipKahfWhen => 'जुमा';

  @override
  String get chipKursi => 'आयतुल कुर्सी';

  @override
  String get chipKursiWhen => 'नमाज़ के बाद और सोते समय';

  @override
  String get chipBaqarahEnd => 'अल-बक़रा की आख़िरी 2 आयतें';

  @override
  String get chipNight => 'रात में';

  @override
  String get chipYasin => 'यासीन';

  @override
  String get chipQuls => 'तीनों क़ुल';

  @override
  String get chipQulsWhen => 'सुबह और शाम';

  @override
  String get chipAnytime => 'कभी भी';

  @override
  String get chipToday => 'आज';

  @override
  String get chipTonight => 'आज रात';

  @override
  String get revealedMakkah => 'मक्का में उतरी';

  @override
  String get revealedMadinah => 'मदीना में उतरी';

  @override
  String get reciter => 'क़ारी';

  @override
  String get chooseReciter => 'क़ारी चुनें';

  @override
  String get playAyah => 'इस आयत से चलाएँ';

  @override
  String recitingAyah(String n, String total) {
    return 'आयत $n / $total';
  }

  @override
  String get audioError => 'तिलावत लोड नहीं हो सकी। अपना इंटरनेट जाँचें।';

  @override
  String get dailyQuran => 'रोज़ाना क़ुरआन';

  @override
  String get energy0 => 'आज आपका दिल नूर का इंतज़ार कर रहा है';

  @override
  String get energy1 => 'चार्ज हो रहा है… कुछ आयतें और';

  @override
  String get energy2 => 'लगभग भर गया — जारी रखें!';

  @override
  String get energy3 => 'नूर से भरपूर — माशाअल्लाह!';

  @override
  String get energy4 => 'आज ख़ूब चमक रहा है ✨';

  @override
  String versesToday(String n, String goal) {
    return 'आज $n / $goal आयतें';
  }

  @override
  String streakDays(String n) {
    return '$n दिन लगातार';
  }

  @override
  String get readNow => 'अभी पढ़ें';

  @override
  String get keepReading => 'और पढ़ें';

  @override
  String get achievements => 'उपलब्धियाँ';

  @override
  String achievementsCount(String n, String total) {
    return '$total में से $n हासिल';
  }

  @override
  String achievementEarned(String date) {
    return '$date को हासिल';
  }

  @override
  String achievementLocked(String done, String target) {
    return 'जारी · $done/$target';
  }

  @override
  String achievementUnlocked(String name) {
    return 'उपलब्धि मिली: $name';
  }

  @override
  String get ach_bismillah => 'बिस्मिल्लाह';

  @override
  String get ach_bismillah_desc => 'अपनी पहली आयत पढ़ें';

  @override
  String get ach_fatiha => 'अल-फ़ातिहा';

  @override
  String get ach_fatiha_desc => 'सूरह अल-फ़ातिहा पूरी करें';

  @override
  String get ach_quls => 'तीनों क़ुल';

  @override
  String get ach_quls_desc => 'अल-इख़लास, अल-फ़लक़ और अन-नास पूरी करें';

  @override
  String get ach_streak3 => 'मज़बूत क़दम';

  @override
  String get ach_streak3_desc => 'लगातार 3 दिन क़ुरआन पढ़ें';

  @override
  String get ach_streak7 => 'नूर का हफ़्ता';

  @override
  String get ach_streak7_desc => 'लगातार 7 दिन क़ुरआन पढ़ें';

  @override
  String get ach_streak30 => 'नूर का महीना';

  @override
  String get ach_streak30_desc => 'लगातार 30 दिन क़ुरआन पढ़ें';

  @override
  String get ach_verses100 => 'सौ आयतें';

  @override
  String get ach_verses100_desc => '100 आयतें पढ़ें';

  @override
  String get ach_verses1000 => 'हज़ार आयतें';

  @override
  String get ach_verses1000_desc => '1,000 आयतें पढ़ें';

  @override
  String get ach_kahf => 'जुमा का नूर';

  @override
  String get ach_kahf_desc => 'जुमा के दिन अल-कहफ़ पूरी करें';

  @override
  String get ach_mulk => 'रात का पहरेदार';

  @override
  String get ach_mulk_desc => 'रात में अल-मुल्क पूरी करें';

  @override
  String get ach_yasin => 'यासीन';

  @override
  String get ach_yasin_desc => 'सूरह यासीन पूरी करें';

  @override
  String get ach_listener => 'ध्यान से सुनने वाला';

  @override
  String get ach_listener_desc => 'किसी पूरी सूरत की तिलावत सुनें';

  @override
  String get ach_quiz100 => 'तेज़ दिमाग़';

  @override
  String get ach_quiz100_desc => 'किसी चरण के क्विज़ में 100% पाएँ';

  @override
  String get ach_juzamma => 'जुज़ अम्म';

  @override
  String get ach_juzamma_desc => '30वें जुज़ की सभी 37 सूरतें पूरी करें';

  @override
  String get ach_phases10 => 'दस चरण';

  @override
  String get ach_phases10_desc => 'यात्रा के 10 चरण पूरे करें';

  @override
  String get ach_khatm => 'ख़त्मे क़ुरआन';

  @override
  String get ach_khatm_desc => 'सभी 114 सूरतें पूरी करें';

  @override
  String get duaHeader => 'अल्लाह की याद के साथ एक दिन';

  @override
  String get duaSub => 'जागने से सोने तक — हर पल के लिए नबी ﷺ की सिखाई दुआएँ।';

  @override
  String repeatTimes(String n) {
    return '$n× पढ़ें';
  }

  @override
  String duaSource(String n) {
    return 'हिस्नुल मुस्लिम #$n';
  }

  @override
  String get duaCredit =>
      'दुआएँ सईद बिन अली अल-क़हतानी की हिस्नुल मुस्लिम से, उसकी आधिकारिक साइट hisnmuslim.com के माध्यम से। अनुवाद अंग्रेज़ी में है।';

  @override
  String get nowLabel => 'अभी';

  @override
  String get scene_wake => 'जागते समय';

  @override
  String get scene_wake_story =>
      'दिन शुक्र से शुरू होता है — अल्लाह ने नींद के बाद रूह लौटा दी।';

  @override
  String get scene_restroom => 'शौचालय';

  @override
  String get scene_restroom_story =>
      'छोटी से छोटी आदत भी अल्लाह की पनाह माँगकर शुरू होती है।';

  @override
  String get scene_wudu => 'वुज़ू';

  @override
  String get scene_wudu_story =>
      'हाथों पर पानी, ज़ुबान पर उसका नाम — अल्लाह के सामने खड़े होने की तैयारी।';

  @override
  String get scene_dress => 'कपड़े पहनते समय';

  @override
  String get scene_dress_story =>
      'हर कपड़ा एक नेमत है — उसका शुक्र करें जिसने पहनाया।';

  @override
  String get scene_athan => 'अज़ान';

  @override
  String get scene_athan_story =>
      'मोहल्ले में अज़ान गूँजती है — उसका जवाब दें, फिर नबी ﷺ के लिए दुआ करें।';

  @override
  String get scene_masjid => 'मस्जिद की ओर';

  @override
  String get scene_masjid_story =>
      'मस्जिद की ओर हर क़दम नूर है — दुआ के साथ अंदर जाएँ और निकलें।';

  @override
  String get scene_after_salah => 'नमाज़ के बाद';

  @override
  String get scene_after_salah_story =>
      'जल्दी उठने से पहले, नमाज़ के बाद के अज़कार के साथ कुछ देर बैठें।';

  @override
  String get scene_morning => 'सुबह के अज़कार';

  @override
  String get scene_morning_story =>
      'ऐसे शब्द जो शाम तक आपकी हिफ़ाज़त करते हैं।';

  @override
  String get scene_eating => 'नाश्ता';

  @override
  String get scene_eating_story =>
      'उसके नाम से शुरू करें, उसकी हम्द पर ख़त्म करें।';

  @override
  String get scene_leave_home => 'घर से निकलते समय';

  @override
  String get scene_leave_home_story =>
      'दरवाज़े पर अपना दिन अल्लाह को सौंप दें।';

  @override
  String get scene_travel => 'रास्ते में';

  @override
  String get scene_travel_story =>
      'बस, रिक्शा या कार — चढ़ते समय अल्लाहु अकबर, उतरते समय सुब्हानल्लाह।';

  @override
  String get scene_meeting => 'लोगों से मिलना';

  @override
  String get scene_meeting_story => 'सलाम फैलाएँ और भाई की छींक का जवाब दें।';

  @override
  String get scene_good_news => 'ख़ुशी के मौक़े पर';

  @override
  String get scene_good_news_story =>
      'ख़ुशी देने वाले की याद दिलाती है — उसकी हम्द करें और लोगों का भी शुक्रिया अदा करें।';

  @override
  String get scene_hardship => 'मुश्किल में';

  @override
  String get scene_hardship_story =>
      'चिंता, तंगी या नाकाम योजना — पहले उसी की ओर रुजू करें।';

  @override
  String get scene_patience => 'नुक़सान और सब्र';

  @override
  String get scene_patience_story =>
      'जब कुछ छिन जाए तो याद रखें कि हम अल्लाह ही के हैं।';

  @override
  String get scene_anger => 'ग़ुस्सा रोकना';

  @override
  String get scene_anger_story =>
      'ऐसी बात से पहले पनाह माँगें जिस पर बाद में पछताना पड़े।';

  @override
  String get scene_pain => 'दर्द और बीमारी';

  @override
  String get scene_pain_story =>
      'अपने दर्द के लिए, और उस दोस्त के लिए जिसकी आप अयादत करें।';

  @override
  String get scene_rain => 'बारिश के समय';

  @override
  String get scene_rain_story =>
      'बारिश रहमत है — इसे फ़ायदेमंद बनाने की दुआ करें।';

  @override
  String get scene_home => 'घर लौटते समय';

  @override
  String get scene_home_story =>
      'उसके नाम से अंदर जाएँ और घरवालों को सलाम करें।';

  @override
  String get scene_gathering => 'मजलिस से उठते समय';

  @override
  String get scene_gathering_story =>
      'उठने से पहले ज़ुबान की ग़लतियाँ मिटा दें।';

  @override
  String get scene_forgiveness => 'इस्तिग़फ़ार';

  @override
  String get scene_forgiveness_story =>
      'दिन की ग़लतियाँ इस्तिग़फ़ार से धुल जाती हैं।';

  @override
  String get scene_sleep => 'सोने से पहले';

  @override
  String get scene_sleep_story =>
      'दिन वैसे ही ख़त्म करें जैसे शुरू किया — उसके नाम से, उसकी हिफ़ाज़त में।';

  @override
  String get scene_night => 'रात में';

  @override
  String get scene_night_story =>
      'अगर आँख खुल जाए या बुरा सपना देखें, तो वह क़रीब है।';

  @override
  String get part_dawn => 'फ़ज्र';

  @override
  String get part_morning => 'सुबह';

  @override
  String get part_day => 'दिन';

  @override
  String get part_evening => 'शाम';

  @override
  String get part_night => 'रात';

  @override
  String get removeSession => 'हटाएँ';

  @override
  String addSession(String session) {
    return '$session जोड़ें';
  }

  @override
  String get duaSearchHint => 'दुआएँ खोजें';

  @override
  String duaPartCount(String topics, String duas) {
    return '$topics विषय · $duas दुआएँ';
  }

  @override
  String duaNoResults(String q) {
    return '“$q” के लिए कोई दुआ नहीं मिली';
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
      other: '$nString दुआएँ मिलीं',
      one: '1 दुआ मिली',
    );
    return '$_temp0';
  }

  @override
  String get part_dawn_sub => 'जागना, वुज़ू और फ़ज्र';

  @override
  String get part_morning_sub => 'अज़कार, खाना और बाहर निकलना';

  @override
  String get part_day_sub => 'लोग, ख़ुशियाँ और आज़माइशें';

  @override
  String get part_evening_sub => 'घर, मजलिसें, इस्तिग़फ़ार';

  @override
  String get part_night_sub => 'नींद और रात';

  @override
  String duaCount(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString दुआएँ',
      one: '1 दुआ',
    );
    return '$_temp0';
  }

  @override
  String get noticeSearchHint => 'सूचनाएँ, मस्जिदें खोजें…';

  @override
  String get noticesSub => 'आपके आसपास की मस्जिदों से';

  @override
  String get tabNotices => 'सूचना';

  @override
  String get chooseSurah => 'सूरत पर जाएँ';

  @override
  String get surahSearchHint => 'नाम या नंबर से सूरत खोजें';

  @override
  String get previousSurah => 'पिछली सूरत';

  @override
  String get pickOnMapTitle => 'नक़्शे पर चुनें';

  @override
  String get mapSearchHint => 'मस्जिद या इलाक़ा खोजें';

  @override
  String get useMyLocation => 'मेरी लोकेशन';

  @override
  String get mapPickHint =>
      'नक़्शे को ऐसे खिसकाएँ कि पिन मस्जिद पर आ जाए, किसी जगह को दबाएँ, या मस्जिद के आइकन को दबाएँ।';

  @override
  String get mapMoving => 'जगह खोजी जा रही है…';

  @override
  String get useThisLocation => 'यह लोकेशन इस्तेमाल करें';

  @override
  String get masjidLocation => 'मस्जिद की लोकेशन';

  @override
  String get chooseLocationWay => 'सही लोकेशन तय करने का एक तरीक़ा चुनें:';

  @override
  String get atTheMasjid => 'मैं मस्जिद में हूँ';

  @override
  String get atTheMasjidBody =>
      'अपने फ़ोन का GPS इस्तेमाल करें। लोड होने तक मस्जिद के अंदर रहें।';

  @override
  String get onTheMap => 'नक़्शे पर चुनें';

  @override
  String get onTheMapBody =>
      'नक़्शे पर मस्जिद की ओर इशारा करें, या पहले से दिख रही मस्जिद को दबाएँ।';

  @override
  String get locFromMap => 'नक़्शे से चुनी गई';

  @override
  String get locFromGps => 'GPS';

  @override
  String get locSaved => 'सहेजी गई लोकेशन';

  @override
  String get useGpsInstead => 'GPS इस्तेमाल करें';

  @override
  String get adjustOnMap => 'नक़्शे पर ठीक करें';

  @override
  String get allMasjids => 'सभी मस्जिदें';

  @override
  String get nearestFirst => 'सबसे नज़दीकी पहले';

  @override
  String get duaForNow => 'इस समय की दुआएँ';

  @override
  String get tabChannel => 'चैनल';

  @override
  String get channelInviteTitle => 'अपने इमाम और ख़तीब के क़रीब रहें';

  @override
  String get channelInviteHadith =>
      '“इल्म हासिल करना हर मुसलमान पर फ़र्ज़ है।” — सुनन इब्न माजा 224';

  @override
  String get channelInviteBody =>
      'हर मुसलमान पर फ़र्ज़-ए-ऐन का इल्म सीखना ज़रूरी है — ईमान, पाकी, नमाज़ और रोज़मर्रा ज़िंदगी की बुनियादी बातें — और इसका सबसे अच्छा तरीक़ा किसी आलिम की रहनुमाई में सीखना है। इस मस्जिद के चैनल से जुड़ें ताकि इसके इमाम और ख़तीब की रहनुमाई और संदेश आप तक पहुँचें, और अपने मोहल्ले की मस्जिद से आपका रिश्ता गहरा हो।';

  @override
  String get joinChannel => 'चैनल से जुड़ें';

  @override
  String get openChannel => 'चैनल खोलें';

  @override
  String get joinedChannel => 'आप इस मस्जिद के चैनल में हैं';

  @override
  String get channelJoined => 'जुड़ गए। आपको इमाम और ख़तीब के संदेश मिलेंगे।';

  @override
  String get leaveChannel => 'चैनल छोड़ें';

  @override
  String get leaveChannelQ => 'यह चैनल छोड़ें? इसके संदेश आपको नहीं मिलेंगे।';

  @override
  String get leave => 'छोड़ें';

  @override
  String get channelEmpty => 'अभी कोई संदेश नहीं।';

  @override
  String get channelEmptyAdmin => 'अपने सदस्यों को पहला संदेश भेजें।';

  @override
  String get channelReadOnly =>
      'यहाँ केवल इमाम, ख़तीब और चैनल एडमिन संदेश भेजते हैं।';

  @override
  String get messageHint => 'संदेश लिखें…';

  @override
  String get send => 'भेजें';

  @override
  String get deleteMessageQ => 'यह संदेश सबके लिए हटाएँ?';

  @override
  String get members => 'सदस्य';

  @override
  String get noMembers =>
      'अभी कोई नहीं जुड़ा। अपनी मस्जिद के नमाज़ियों को आमंत्रित करें।';

  @override
  String get roleMember => 'सदस्य';

  @override
  String get roleEditor => 'एडिटर';

  @override
  String get roleAdmin => 'एडमिन';

  @override
  String get roleMemberDesc => 'संदेश पढ़ते हैं';

  @override
  String get roleEditorDesc => 'संदेश भेज सकते हैं';

  @override
  String get roleAdminDesc => 'संदेश भेजते हैं और सदस्य प्रबंधित करते हैं';

  @override
  String get removeMember => 'चैनल से हटाएँ';

  @override
  String get you => 'आप';

  @override
  String get channelMessages => 'चैनल संदेश';

  @override
  String get noticesHeading => 'सूचनाएँ';

  @override
  String get signInToJoin => 'चैनल से जुड़ने के लिए साइन इन करें।';

  @override
  String get monthNames =>
      'जनवरी,फ़रवरी,मार्च,अप्रैल,मई,जून,जुलाई,अगस्त,सितंबर,अक्टूबर,नवंबर,दिसंबर';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String jamatReminderBody(String prayer, String minutes) {
    return '$prayer की जमाअत $minutes मिनट में';
  }

  @override
  String get attach => 'अटैच करें';

  @override
  String get attachPhoto => 'फ़ोटो';

  @override
  String get attachVideo => 'वीडियो';

  @override
  String get attachAudio => 'ऑडियो';

  @override
  String get attachFile => 'फ़ाइल';

  @override
  String fileTooLarge(String size) {
    return 'यह फ़ाइल बहुत बड़ी है। सीमा $size है।';
  }

  @override
  String get cantOpenFile => 'इस फ़ोन पर यह फ़ाइल खोलने वाला कोई ऐप नहीं है।';

  @override
  String get channelNotAllowed =>
      'चैनल अभी उपलब्ध नहीं है (अनुमति नहीं)। कृपया बाद में कोशिश करें।';

  @override
  String get duaForNowSub => 'दिन के इस समय के ज़िक्र और दुआएँ';

  @override
  String get approxLocation =>
      'अनुमानित स्थान – सटीक स्थान चालू करने के लिए टैप करें';

  @override
  String get signInFirst => 'कृपया पहले साइन इन करें।';

  @override
  String get volunteerTitleEmpty => 'जमात का समय अभी नहीं जोड़ा गया';

  @override
  String get volunteerBodyEmpty =>
      'क्या आप इस मस्जिद के पास रहते या नमाज़ पढ़ते हैं? सबके लिए जमात का समय जोड़ें और अपडेट रखें।';

  @override
  String get volunteerTitle => 'क्या आप यहाँ नियमित नमाज़ पढ़ते हैं?';

  @override
  String get volunteerBody => 'इस मस्जिद के जमात के समय सही रखने में मदद करें।';

  @override
  String get volunteerButton => 'मैं जमात का समय अपडेट करना चाहता हूँ';

  @override
  String get volunteerCheckTitle => 'इस मस्जिद का समय अपडेट करें';

  @override
  String volunteerCheckBody(String km) {
    return 'मस्जिद के पास के लोग उसका समय अपडेट रख सकते हैं। हम जाँचेंगे कि आप उससे $km कि.मी. के अंदर हैं – आपका स्थान सिर्फ़ इसी जाँच के लिए इस्तेमाल होगा।';
  }

  @override
  String get volunteerCheckButton => 'मेरा स्थान जाँचें';

  @override
  String get volunteerChecking => 'आपका स्थान जाँचा जा रहा है…';

  @override
  String volunteerTooFar(String distance, String km) {
    return 'आप $distance दूर हैं। समय अपडेट करने के लिए मस्जिद के $km कि.मी. के अंदर आएँ।';
  }

  @override
  String get volunteerApprox =>
      'आपका फ़ोन सिर्फ़ अनुमानित स्थान दे रहा है। Muslimin के लिए सटीक स्थान चालू करें और फिर कोशिश करें।';

  @override
  String get volunteerBlocked =>
      'आप अभी मस्जिद का समय अपडेट नहीं कर सकते। अगर यह गलती है तो एडमिन से संपर्क करें।';

  @override
  String get volunteerWelcome =>
      'धन्यवाद! अब आप इस मस्जिद का समय अपडेट कर सकते हैं।';

  @override
  String get stopEditing => 'इस मस्जिद को अपडेट करना बंद करें';

  @override
  String get reportProblem => 'समस्या बताएँ';

  @override
  String get reportTitle => 'क्या गलत है?';

  @override
  String get reportWrongTime => 'जमात का समय गलत है';

  @override
  String get reportWrongLocation => 'नक्शे पर स्थान गलत है';

  @override
  String get reportWrongInfo => 'नाम या विवरण गलत है';

  @override
  String get reportClosed => 'बंद है या मौजूद नहीं';

  @override
  String get reportDuplicate => 'दो बार दर्ज है';

  @override
  String get reportOther => 'कुछ और';

  @override
  String get reportNote => 'विवरण (वैकल्पिक) – जैसे सही समय';

  @override
  String get reportSend => 'रिपोर्ट भेजें';

  @override
  String get reportThanks => 'धन्यवाद – एडमिन इसे देखेंगे।';

  @override
  String get volunteers => 'स्वयंसेवी एडिटर';

  @override
  String get noVolunteers => 'अभी कोई स्वयंसेवक नहीं।';

  @override
  String editorDistance(String distance) {
    return 'जुड़ते समय मस्जिद से $distance';
  }

  @override
  String get removeEditor => 'हटाएँ';

  @override
  String get removeAndBlock => 'हटाएँ और एडिट से रोकें';

  @override
  String lastUpdatedBy(String when, String name) {
    return '$when अपडेट किया $name ने';
  }

  @override
  String get adminReport => 'रिपोर्ट';

  @override
  String get adminProblems => 'समस्याएँ';

  @override
  String get adminEdits => 'बदलाव';

  @override
  String get statMasjids => 'मस्जिदें';

  @override
  String get statWithTimes => 'जमात के समय के साथ';

  @override
  String get statVolunteers => 'स्वयंसेवक';

  @override
  String get statOpenReports => 'खुली समस्याएँ';

  @override
  String get statPending => 'समीक्षा की प्रतीक्षा में';

  @override
  String get shareReport => 'रिपोर्ट शेयर करें';

  @override
  String get coverageTitle => 'ज़िले के अनुसार';

  @override
  String get coverageLoad => 'ज़िले दिखाएँ';

  @override
  String get resolve => 'हल हो गया';

  @override
  String get revert => 'बदलाव वापस लें';

  @override
  String get reverted => 'बदलाव वापस लिया गया';

  @override
  String get editFieldStaff => 'स्टाफ़';

  @override
  String get editFieldMaktab => 'मकतब';

  @override
  String timeLooksWrong(String prayers) {
    return 'ये समय गलत लगते हैं: $prayers। कृपया AM/PM जाँच लें।';
  }

  @override
  String get dataCredits =>
      'मस्जिदों के स्थान: © OpenStreetMap contributors (ODbL)। ज़िला और उपज़िला सीमाएँ: बांग्लादेश सांख्यिकी ब्यूरो / OCHA, geoBoundaries (CC BY 3.0 IGO)।';

  @override
  String get fromOsm =>
      'OpenStreetMap से जोड़ा गया (© OpenStreetMap contributors)। समय आसपास के लोग जोड़ते हैं।';
}
