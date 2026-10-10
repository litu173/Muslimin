// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class L10nTr extends L10n {
  L10nTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Muslimin';

  @override
  String get tagline => 'Ümmetten bir gün';

  @override
  String get next => 'İleri';

  @override
  String get skip => 'Atla';

  @override
  String get cancel => 'İptal';

  @override
  String get getStarted => 'Başla';

  @override
  String get create => 'Oluştur';

  @override
  String get update => 'Güncelle';

  @override
  String get edit => 'Düzenle';

  @override
  String get post => 'Yayınla';

  @override
  String get save => 'Kaydet';

  @override
  String get select => 'Seç';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get close => 'Kapat';

  @override
  String get delete => 'Sil';

  @override
  String get done => 'Tamam';

  @override
  String get viewAll => 'Tümünü Gör';

  @override
  String get viewDetails => 'Ayrıntıları Gör';

  @override
  String get dontShowAgain => 'Bir Daha Gösterme';

  @override
  String get share => 'Paylaş';

  @override
  String get addNew => 'Yeni Ekle';

  @override
  String get now => 'Şimdi';

  @override
  String get selected => 'Seçili';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get more => 'Daha Fazla';

  @override
  String get loading => 'Yükleniyor…';

  @override
  String get somethingWrong => 'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get onb1Title => 'Cemaat Vakitlerini Paylaşın';

  @override
  String get onb1Body =>
      'Yakındaki insanlar bu uygulamada caminin cemaat vakitlerini görebilecek.';

  @override
  String get onb2Title => 'Cami Duyurusu Yayınlayın';

  @override
  String get onb2Body =>
      'İnsanlar bu uygulamada cami duyurularını bulabilir ve farklı etkinliklere katılabilir.';

  @override
  String get permTitle => 'Devam etmek için izin verin';

  @override
  String get permBody =>
      'Muslimin, çevrenizdeki camileri bulmak için konumunuza, cemaatten önce sizi uyarmak için bildirimlere ihtiyaç duyar.';

  @override
  String get permLocation => 'Konum';

  @override
  String get permLocationBody =>
      'En yakın camileri bulun ve namaz vakitlerini doğru hesaplayın.';

  @override
  String get permNotification => 'Bildirimler';

  @override
  String get permNotificationBody =>
      'Takip ettiğiniz camilerin cemaat hatırlatmaları ve duyuruları.';

  @override
  String get permAllow => 'İzin ver';

  @override
  String get permGranted => 'İzin verildi';

  @override
  String get permOpenSettings => 'Ayarları Aç';

  @override
  String get permLocationServiceOff =>
      'Lütfen telefonunuzda konumu (GPS) açın.';

  @override
  String get permDeniedForever =>
      'İzin reddedildi. Lütfen Ayarlar\'dan etkinleştirin.';

  @override
  String get permContinue => 'Devam et';

  @override
  String get timeLeft => 'Kalan süre';

  @override
  String get startsIn => 'Başlamasına';

  @override
  String get allPrayers => 'Tüm Namazlar';

  @override
  String get nearestMasjid => 'En Yakın Cami';

  @override
  String get noMasjidNearby => 'Yakınınızda henüz doğrulanmış cami bulunamadı.';

  @override
  String get noMasjidNearbyHint =>
      'Bir cami yetkilisi tanıyor musunuz? Camiyi Muslimin\'e kaydetmesini isteyin.';

  @override
  String minWalk(String minutes) {
    return '$minutes dk yürüme';
  }

  @override
  String kmAway(String km) {
    return '$km km uzakta';
  }

  @override
  String get jamatNotSet => 'Cemaat vakti belirlenmedi';

  @override
  String get nextJamat => 'Sonraki cemaat';

  @override
  String get notice => 'Duyuru';

  @override
  String get notices => 'Duyurular';

  @override
  String get noNotices => 'Henüz duyuru yok.';

  @override
  String get all => 'Tümü';

  @override
  String get authorityTitle => 'Cami Yetkilileri';

  @override
  String get authorityBody =>
      'Caminizi kaydedin, çevredeki Müslümanlar onu bu uygulamada bulsun.';

  @override
  String get yourLocation => 'Konumunuz';

  @override
  String get locating => 'Konum bulunuyor…';

  @override
  String get useCurrentLocation => 'Mevcut konumu kullan';

  @override
  String get searchMasjid => 'Cami ara';

  @override
  String get nearbyMasjids => 'Yakındaki Camiler';

  @override
  String get fajr => 'Sabah';

  @override
  String get sunrise => 'Güneş';

  @override
  String get dhuhr => 'Öğle';

  @override
  String get asr => 'İkindi';

  @override
  String get maghrib => 'Akşam';

  @override
  String get isha => 'Yatsı';

  @override
  String get jumuah => 'Cuma';

  @override
  String get forbiddenTime => 'Kerahat Vakti';

  @override
  String get forbiddenInfo =>
      'Bu vakitlerde namaz kılınmaz: güneş doğarken, tam tepedeyken ve batarken.';

  @override
  String get morning => 'Sabah';

  @override
  String get noon => 'Öğle';

  @override
  String get evening => 'Akşam';

  @override
  String get naflPrayers => 'Nafile Namazlar';

  @override
  String get tahajjud => 'Teheccüd';

  @override
  String get duha => 'Kuşluk Namazı';

  @override
  String get tahajjudHadith =>
      'Resûlullah (ﷺ) buyurdu: \"Mübarek ve yüce Rabbimiz her gece, gecenin son üçte biri kaldığında dünya semasına iner ve şöyle buyurur: Bana dua eden yok mu, duasını kabul edeyim? Benden isteyen yok mu, ona vereyim? Benden bağışlanma dileyen yok mu, onu bağışlayayım?\"';

  @override
  String get tahajjudSource => 'Sahih-i Buhârî 1145';

  @override
  String get duhaHadith1 =>
      'Ebû Hüreyre şöyle dedi: \"Dostum Resûlullah (ﷺ) bana üç şeyi tavsiye etti: her ay üç gün oruç tutmayı, iki rekât kuşluk namazı kılmayı ve uyumadan önce vitir namazı kılmayı.\"';

  @override
  String get duhaSource1 => 'Sahih-i Buhârî ve Müslim';

  @override
  String get duhaHadith2 =>
      'Nuaym b. Hammâr rivayet etti: Resûlullah (ﷺ) buyurdu: \"Aziz ve celil olan Allah şöyle buyurur: Ey Âdemoğlu! Günün başında benim için dört rekât kılmaktan geri durma ki günün sonuna kadar sana yeteyim.\"';

  @override
  String get duhaSource2 => 'Sünen-i Ebû Dâvûd 1289';

  @override
  String get calcMethodNote =>
      'Vakitler konumunuza göre hesaplanır. Cemaat vakitlerini her cami kendisi belirler.';

  @override
  String get following => 'Takip ediliyor';

  @override
  String get follow => 'Takip et';

  @override
  String get tabHome => 'Ana Sayfa';

  @override
  String get tabNotice => 'Duyurular';

  @override
  String get tabLive => 'Canlı';

  @override
  String get tabAbout => 'Hakkında';

  @override
  String get jamatTime => 'Cemaat Vakitleri';

  @override
  String get maktabTime => 'Kur\'an Kursu Saatleri';

  @override
  String lastUpdated(String when) {
    return 'Son güncelleme $when';
  }

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String daysAgo(String count) {
    return '$count gün önce';
  }

  @override
  String get khatib => 'Hatip';

  @override
  String get imam => 'İmam';

  @override
  String get muazzin => 'Müezzin';

  @override
  String contact(String phone) {
    return 'İletişim: $phone';
  }

  @override
  String get notAdded => 'Henüz eklenmedi';

  @override
  String get jamatReminder => 'Cemaat Hatırlatıcısı';

  @override
  String get notifyBefore => 'Önceden hatırlat';

  @override
  String minsBefore(String minutes) {
    return '$minutes dk';
  }

  @override
  String get reminderOff => 'Hatırlatıcıyı kapat';

  @override
  String reminderSet(String minutes) {
    return 'Her cemaatten $minutes dakika önce hatırlatılacaksınız.';
  }

  @override
  String followedToast(String name) {
    return 'Artık $name camisini takip ediyorsunuz.';
  }

  @override
  String get directions => 'Yol tarifi';

  @override
  String get liveNow => 'Şu an canlı';

  @override
  String get noLive => 'Şu anda canlı yayın yok';

  @override
  String get noLiveHint =>
      'Cami bir hutbe veya sohbet yayınladığında burada görünecek.';

  @override
  String get watchLive => 'Canlı izle';

  @override
  String get liveLink => 'Canlı yayın bağlantısı (YouTube / Facebook)';

  @override
  String get liveToggle => 'Şu an canlı yayındayız';

  @override
  String get maktabDays => 'Kurs günleri';

  @override
  String get weekdaysShort => 'Cmt,Paz,Pzt,Sal,Çar,Per,Cum';

  @override
  String get weekdaysLong =>
      'Cumartesi,Pazar,Pazartesi,Salı,Çarşamba,Perşembe,Cuma';

  @override
  String dayRange(String from, String to) {
    return '$from ~ $to';
  }

  @override
  String get tapToSet => 'Ayarla';

  @override
  String get khatibName => 'Hatip Adı';

  @override
  String get imamName => 'İmam Adı';

  @override
  String get muazzinName => 'Müezzin Adı';

  @override
  String get contactNumber => 'İletişim Numarası';

  @override
  String get updated => 'Başarıyla güncellendi';

  @override
  String get writeNotice => 'Duyuru Yaz';

  @override
  String get selectCategory => 'Kategori Seç';

  @override
  String get deleteNoticeQ => 'Bu duyuru silinsin mi?';

  @override
  String get catJanaza => 'Cenaze';

  @override
  String get catRecruitment => 'İş İlanı';

  @override
  String get catQuran => 'Kur\'an Dersi';

  @override
  String get catQuranShort => 'Kur\'an';

  @override
  String get catMahfil => 'Mahfil';

  @override
  String get catTalim => 'Talim';

  @override
  String get catTafsir => 'Tefsir';

  @override
  String get catGeneral => 'Genel';

  @override
  String get janazaNotice => 'Cenaze Duyurusu';

  @override
  String noticeFormTitle(String category) {
    return '$category Duyurusu';
  }

  @override
  String get enterCarefully => 'Lütfen aşağıdaki bilgileri dikkatle girin.';

  @override
  String get personName => 'Merhumun Adı';

  @override
  String get fathersName => 'Baba Adı';

  @override
  String get diedOn => 'Vefat Tarihi';

  @override
  String get address => 'Adres';

  @override
  String get janazaTime => 'Cenaze Namazı Saati';

  @override
  String get janazaDate => 'Cenaze Namazı Tarihi';

  @override
  String get noticeTitle => 'Başlık';

  @override
  String get noticeDetails => 'Ayrıntılar';

  @override
  String get date => 'Tarih';

  @override
  String get time => 'Saat';

  @override
  String deadline(String date) {
    return 'Son tarih: $date';
  }

  @override
  String startingDate(String date) {
    return 'Başlangıç tarihi: $date';
  }

  @override
  String timeAndDate(String value) {
    return 'Saat ve Tarih: $value';
  }

  @override
  String janazaOf(String name) {
    return '$name cenazesi';
  }

  @override
  String sonOf(String name) {
    return '$name oğlu/kızı';
  }

  @override
  String get noticePosted => 'Duyuru yayınlandı';

  @override
  String get required => 'Zorunlu';

  @override
  String get userAuth => 'Kullanıcı Doğrulama';

  @override
  String get userAuthBody =>
      'Aşağıdakiler sizin için geçerliyse lütfen okuyup onaylayın.';

  @override
  String get rule1 =>
      'Cami dernek üyesiyim ya da caminin hizmetlisi/müezzini/imamıyım';

  @override
  String get rule2 =>
      'Caminin cemaat vakitlerini düzenli olarak güncelleyebilirim';

  @override
  String get rule3 => 'Bu uygulamanın faydasını anlıyorum';

  @override
  String get rule4 => 'Caminin tam konumunu işaretleyeceğim';

  @override
  String get agreeAll => 'Devam etmek için lütfen tüm ifadeleri onaylayın.';

  @override
  String get registration => 'Kayıt';

  @override
  String get verifyMobile => 'Cep telefonu numaranızı doğrulayın';

  @override
  String get yourMobile => 'Cep Telefonu Numaranız';

  @override
  String get otpWillBeSent =>
      'Doğrulama için bu numaraya tek kullanımlık şifre (OTP) gönderilecek';

  @override
  String get getOtp => 'OTP Al';

  @override
  String get invalidPhone =>
      'Geçerli bir Bangladeş cep telefonu numarası girin (01XXXXXXXXX).';

  @override
  String get verification => 'Doğrulama';

  @override
  String get typeOtp => 'Lütfen telefonunuza gönderilen OTP kodunu girin';

  @override
  String get otp => 'Tek Kullanımlık Şifre (OTP)';

  @override
  String get didntGetOtp => 'OTP gelmedi mi?';

  @override
  String get resendCode => 'Kodu Tekrar Gönder';

  @override
  String resendIn(String seconds) {
    return '$seconds sn sonra tekrar gönder';
  }

  @override
  String get verify => 'Doğrula';

  @override
  String get invalidOtp => 'Kod doğru değil. Lütfen tekrar deneyin.';

  @override
  String get demoOtpHint => 'Demo modu: 123456 kodunu kullanın';

  @override
  String get createMasjidProfile => 'Cami Profili Oluştur';

  @override
  String get stayInside =>
      'Aşağıdaki bilgileri dikkatle girin. Konumu caminin içinden veya harita üzerinden belirleyebilirsiniz.';

  @override
  String get masjidName => 'Cami Adı';

  @override
  String get district => 'Bölge (District)';

  @override
  String get thana => 'Thana / Upazila';

  @override
  String get latLng => 'Enlem ve Boylam';

  @override
  String get load => 'Yükle';

  @override
  String get reload => 'Yeniden yükle';

  @override
  String get stayInsideLoading => 'Yükleme sırasında caminin içinde kalın.';

  @override
  String accuracy(String meters) {
    return 'Doğruluk ±$meters m';
  }

  @override
  String accuracyTooLow(String meters) {
    return 'Konum yeterince doğru değil (±$meters m). Caminin içinde açık bir alana geçip yeniden yükleyin.';
  }

  @override
  String get loadLocationFirst => 'Lütfen caminin konumunu belirleyin.';

  @override
  String get nidNumber => 'Kimlik (NID) Numaranız';

  @override
  String get invalidNid => 'NID 10, 13 veya 17 haneli olmalıdır.';

  @override
  String get yourRole => 'Göreviniz';

  @override
  String get roleCommittee => 'Dernek üyesi';

  @override
  String get roleKhadem => 'Cami hizmetlisi';

  @override
  String get roleMuazzin => 'Müezzin';

  @override
  String get roleImam => 'İmam';

  @override
  String get roleKhatib => 'Hatip';

  @override
  String get agreeTermsPrefix => 'Okudum ve kabul ediyorum: ';

  @override
  String get termsAndConditions => 'Şartlar ve Koşullar';

  @override
  String get mustAgreeTerms => 'Lütfen Şartlar ve Koşulları kabul edin.';

  @override
  String duplicateFound(String name) {
    return 'Bu konumda \"$name\" adlı bir cami zaten kayıtlı. Yetkilisiyseniz lütfen destekle iletişime geçin.';
  }

  @override
  String limitReached(String count) {
    return 'En fazla $count cami profiliniz olabilir.';
  }

  @override
  String get submittedTitle => 'İncelemeye gönderildi';

  @override
  String get submittedBody =>
      'Allah razı olsun! Cami profiliniz ekibimiz doğruladıktan sonra herkese görünür olacak. Onaylandığında bildirim alacaksınız.';

  @override
  String get backToHome => 'Ana Sayfaya Dön';

  @override
  String get termsBody =>
      '1. Cami profilini yalnızca cami dernek üyeleri, imam, hatip, müezzin veya cami hizmetlisi oluşturabilir.\n2. Caminin konumu tam olmalıdır — caminin içinden GPS ile veya harita üzerinde göstererek belirleyin.\n3. NID ve telefon numaranız yalnızca doğrulama için kullanılır ve asla herkese gösterilmez.\n4. Cemaat vakitleri ve duyurular doğru ve güncel tutulmalıdır.\n5. Duyurular cami faaliyetleriyle ilgili olmalıdır. Siyasi, ticari veya nefret içeren içeriklere izin verilmez.\n6. Profil, Muslimin ekibi doğrulayana kadar gizli kalır. Yanlış bilgi içeren profiller kaldırılır.';

  @override
  String get statusPending => 'İncelemede';

  @override
  String get statusApproved => 'Onaylandı';

  @override
  String get statusRejected => 'Reddedildi';

  @override
  String get statusSuspended => 'Askıya alındı';

  @override
  String get pendingBanner =>
      'Bu profil doğrulama bekliyor. Yalnızca siz görebilirsiniz.';

  @override
  String rejectedBanner(String reason) {
    return 'Bu profil onaylanmadı: $reason';
  }

  @override
  String get myMasjids => 'Camilerim';

  @override
  String get registerMasjid => 'Cami Kaydet';

  @override
  String get appSettings => 'Uygulama Ayarları';

  @override
  String get faq => 'SSS';

  @override
  String get aboutApp => 'Uygulama Hakkında';

  @override
  String get shareApp => 'Bu uygulamayı paylaş';

  @override
  String get shareAppBody =>
      'Bu uygulama ailenize ve arkadaşlarınıza da faydalı olabilir. Lütfen paylaşın.';

  @override
  String shareText(String url) {
    return 'Muslimin ile yakınınızdaki camilerin cemaat vakitlerini öğrenin: $url';
  }

  @override
  String get language => 'Dil';

  @override
  String get calcMethod => 'Namaz vakti hesaplama';

  @override
  String get asrMethod => 'İkindi hesaplama';

  @override
  String get hanafi => 'Hanefi';

  @override
  String get shafi => 'Şafii / Maliki / Hanbeli';

  @override
  String get hijriAdjust => 'Hicri tarih düzeltmesi';

  @override
  String days(String count) {
    return '$count gün';
  }

  @override
  String get defaultReminder => 'Varsayılan cemaat hatırlatıcısı';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String signedInAs(String phone) {
    return '$phone olarak giriş yapıldı';
  }

  @override
  String version(String v) {
    return 'Sürüm $v';
  }

  @override
  String get aboutBody =>
      'Muslimin, Müslümanların çevrelerindeki camilerin cemaat vakitlerini bulmalarına yardımcı olur. Her cami profilini kendi yetkilisi oluşturur ve yayımlanmadan önce ekibimiz doğrular.';

  @override
  String get faqQ1 => 'Cemaat vakitleri nereden geliyor?';

  @override
  String get faqA1 =>
      'Her caminin yetkilisi kendi cemaat vakitlerini belirler ve günceller. Namaz vakitlerinin girişi konumunuza göre hesaplanır.';

  @override
  String get faqQ2 => 'Konum neden zorunlu?';

  @override
  String get faqA2 =>
      'Konum, yakınınızdaki camileri göstermek ve namaz vakitlerini doğru hesaplamak için kullanılır. Hiç kimseyle paylaşılmaz.';

  @override
  String get faqQ3 => 'Camimi nasıl eklerim?';

  @override
  String get faqA3 =>
      'Daha Fazla → Cami Kaydet\'e gidin. Dernek üyesi, imam, müezzin, hatip veya cami hizmetlisi olmalı ve caminin tam konumunu belirlemelisiniz — caminin içinden GPS ile veya harita üzerinden.';

  @override
  String get faqQ4 => 'Camim neden görünmüyor?';

  @override
  String get faqA4 =>
      'Yeni profiller yayımlanmadan önce ekibimiz tarafından doğrulanır. Bu genellikle 1–2 gün sürer.';

  @override
  String get faqQ5 => 'Cemaat hatırlatıcıları nasıl çalışır?';

  @override
  String get faqA5 =>
      'Bir camiyi açın ve Cemaat Vakitleri\'ndeki zile dokunun. Uygulama kapalı olsa bile her cemaatten 15, 30 veya 45 dakika önce bildirim alırsınız.';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get noNotifications =>
      'Duyurularını burada görmek için camileri takip edin.';

  @override
  String get adminPanel => 'Yönetim Paneli';

  @override
  String get adminPending => 'Bekleyen';

  @override
  String get adminApproved => 'Onaylanan';

  @override
  String get adminRejected => 'Reddedilen';

  @override
  String get approve => 'Onayla';

  @override
  String get reject => 'Reddet';

  @override
  String get suspend => 'Askıya al';

  @override
  String get restore => 'Geri yükle';

  @override
  String get rejectReason => 'Ret nedeni';

  @override
  String get submittedBy => 'Gönderen';

  @override
  String get phone => 'Telefon';

  @override
  String get nid => 'NID';

  @override
  String get role => 'Görev';

  @override
  String get location => 'Konum';

  @override
  String get openInMaps => 'Haritalarda Aç';

  @override
  String get submittedOn => 'Gönderim tarihi';

  @override
  String get nothingHere => 'Burada bir şey yok';

  @override
  String get approvedToast => 'Cami onaylandı';

  @override
  String get rejectedToast => 'Cami reddedildi';

  @override
  String get verifiedChecklist =>
      'Onaylamadan önce göndereni arayın ve konumu haritada kontrol edin.';

  @override
  String get verse1Ar => 'وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ';

  @override
  String get verse1 => 'Sabır ve namazla Allah\'a sığınıp yardım isteyin';

  @override
  String get verse1Ref => 'Bakara 2:45';

  @override
  String get verse2Ar =>
      'إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَـٰبًا مَّوْقُوتًا';

  @override
  String get verse2 =>
      'Namaz şüphesiz, inananlara belirli vakitlerde farz kılınmıştır.';

  @override
  String get verse2Ref => 'Nisâ 4:103';

  @override
  String get verse3Ar =>
      'حَـٰفِظُوا۟ عَلَى ٱلصَّلَوَٰتِ وَٱلصَّلَوٰةِ ٱلْوُسْطَىٰ';

  @override
  String get verse3 => 'Namazlara ve orta namaza devam edin';

  @override
  String get verse3Ref => 'Bakara 2:238';

  @override
  String get hijriMonths =>
      'Muharrem,Safer,Rebiülevvel,Rebiülahir,Cemaziyelevvel,Cemaziyelahir,Recep,Şaban,Ramazan,Şevval,Zilkade,Zilhicce';

  @override
  String get deadlineLabel => 'Son Tarih';

  @override
  String get startingDateLabel => 'Başlangıç Tarihi';

  @override
  String get masjidNameBn => 'Cami Adı Bengalce (isteğe bağlı)';

  @override
  String get createAccount => 'Hesap Oluştur';

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get fullName => 'Ad Soyad';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get confirmPassword => 'Şifreyi Onayla';

  @override
  String get forgotPassword => 'Şifrenizi mi unuttunuz?';

  @override
  String get noAccount => 'Hesabınız yok mu?';

  @override
  String get haveAccount => 'Zaten hesabınız var mı?';

  @override
  String get signUpBody =>
      'Camileri takip etmek ve ayarlarınızı güvende tutmak için hesap oluşturun.';

  @override
  String get signInBody => 'Tekrar hoş geldiniz! Devam etmek için giriş yapın.';

  @override
  String get resetPassword => 'Şifreyi Sıfırla';

  @override
  String get resetBody =>
      'Kaydolduğunuz e-postayı girin. Yeni şifre belirlemeniz için bir bağlantı göndereceğiz.';

  @override
  String get sendResetLink => 'Sıfırlama Bağlantısı Gönder';

  @override
  String resetSent(String email) {
    return 'Şifre sıfırlama bağlantısı $email adresine gönderildi. Lütfen gelen kutunuzu (ve spam klasörünü) kontrol edin.';
  }

  @override
  String get backToSignIn => 'Girişe Dön';

  @override
  String get invalidEmail => 'Geçerli bir e-posta adresi girin.';

  @override
  String get passwordTooShort => 'Şifre en az 6 karakter olmalıdır.';

  @override
  String get passwordsDontMatch => 'Şifreler eşleşmiyor.';

  @override
  String get errEmailInUse =>
      'Bu e-postayla zaten bir hesap var. Giriş yapmayı deneyin.';

  @override
  String get errInvalidCredential => 'E-posta veya şifre hatalı.';

  @override
  String get errWeakPassword =>
      'Lütfen daha güçlü bir şifre seçin (en az 6 karakter).';

  @override
  String get errTooManyRequests =>
      'Çok fazla deneme. Birkaç dakika bekleyip tekrar deneyin.';

  @override
  String get errNetwork => 'İnternet bağlantısı yok. Lütfen tekrar deneyin.';

  @override
  String get errPhoneInUse => 'Bu telefon numarası başka bir hesaba bağlı.';

  @override
  String get errUserDisabled =>
      'Bu hesap devre dışı bırakıldı. Lütfen destekle iletişime geçin.';

  @override
  String get myAccount => 'Hesabım';

  @override
  String get signInPrompt => 'Cami yetkilileri için';

  @override
  String get signInPromptBody =>
      'Caminizi kaydetmek ve yönetmek için giriş yapın veya hesap oluşturun. Normal kullanıcıların hesaba ihtiyacı yoktur.';

  @override
  String get profile => 'Profil';

  @override
  String get emailNotVerified => 'E-posta doğrulanmadı';

  @override
  String get emailVerified => 'E-posta doğrulandı';

  @override
  String get resendVerification => 'Doğrulama e-postası gönder';

  @override
  String verificationSent(String email) {
    return 'Doğrulama e-postası $email adresine gönderildi.';
  }

  @override
  String get changePassword => 'Şifreyi Değiştir';

  @override
  String get currentPassword => 'Mevcut Şifre';

  @override
  String get newPassword => 'Yeni Şifre';

  @override
  String get passwordChanged => 'Şifre başarıyla değiştirildi.';

  @override
  String get deleteAccount => 'Hesabı Sil';

  @override
  String get deleteAccountBody =>
      'Bu işlem hesabınızı ve kayıtlı verilerinizi kalıcı olarak siler. Yönettiğiniz cami profilleri kalır ancak erişiminizi kaybedersiniz. Onaylamak için şifrenizi girin.';

  @override
  String get accountDeleted => 'Hesabınız silindi.';

  @override
  String get phoneNumber => 'Telefon';

  @override
  String get notVerified => 'Doğrulanmadı';

  @override
  String welcomeUser(String name) {
    return 'Hoş geldiniz, $name!';
  }

  @override
  String get signInToRegister =>
      'Cami kaydetmek için lütfen giriş yapın veya hesap oluşturun.';

  @override
  String get verifyPhoneToContinue =>
      'Cami kaydetmek için telefon numaranızı doğrulayın.';

  @override
  String accountCreated(String email) {
    return 'Hesap oluşturuldu! $email adresine doğrulama bağlantısı gönderdik.';
  }

  @override
  String get nameRequired => 'Lütfen adınızı girin.';

  @override
  String get credits => 'Emeği Geçenler';

  @override
  String get fontCredits =>
      'Logo ve İngilizce namaz adları: Muslimin tasarımının yazısı, Anthonie Van Hayu\'nun (ARToni) Hidayatullah\'ına dayanır. Yazı tipleri: Omnibus-Type\'tan Grenze Gotisch, Indian Type Foundry ve Jonny Pinhorn\'dan Poppins, Indian Type Foundry\'den Hind Siliguri, Ek Type\'tan Anek Bangla (Bengalce rakamlar), Black Foundry\'den Galada, SIL International\'dan Scheherazade New. Tüm yazı tipleri SIL Open Font License 1.1 kapsamında ücretsizdir.';

  @override
  String get designInspired =>
      'Özgün tasarım yazı tipi: Anthonie Van Hayu\'nun (ARToni) Hidayatullah\'ı.';

  @override
  String get openSourceLicenses => 'Açık kaynak lisansları';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String get orDivider => 'veya';

  @override
  String get onb3Title => 'Namaz Vakitleri ve Hatırlatıcılar';

  @override
  String get onb3Body =>
      'Konumunuza göre doğru namaz vakitleri ve takip ettiğiniz camilerde her cemaatten önce hatırlatma.';

  @override
  String get appVersion => 'Uygulama sürümü';

  @override
  String get checkingUpdates => 'Güncellemeler kontrol ediliyor…';

  @override
  String get upToDate => 'En son sürümü kullanıyorsunuz.';

  @override
  String updateAvailable(String version) {
    return 'Yeni sürüm $version mevcut';
  }

  @override
  String get downloadLatestApk => 'En son APK\'yı indir';

  @override
  String get updateApkHint =>
      'İndirilen dosyayı açarak bu sürümün üzerine kurun. Ayarlarınız korunur.';

  @override
  String get updateIosButton => 'iPhone\'da nasıl güncellenir';

  @override
  String get updateCheckFailed =>
      'Güncellemeler kontrol edilemedi. İnternet bağlantınızı kontrol edin.';

  @override
  String get releaseNotes => 'Sürüm notları';

  @override
  String get selectAll => 'Tümünü seç';

  @override
  String get welcomeTitle => 'Esselâmü Aleyküm';

  @override
  String get welcomeBody =>
      'Camilerinizi takip etmek, cemaat hatırlatmaları almak ve her şeyi telefonlarınızda senkronize tutmak için giriş yapın.';

  @override
  String get continueAsGuest => 'Misafir olarak devam et';

  @override
  String get editMasjidInfo => 'Cami Bilgilerini Düzenle';

  @override
  String get editMasjidInfoBody =>
      'Cami profilinizde görünen bilgileri, konumu dahil (camide GPS ile veya haritadan seçerek), güncelleyin.';

  @override
  String get followedMasjids => 'Takip Edilen Camiler';

  @override
  String get noFollowed => 'Henüz hiçbir camiyi takip etmiyorsunuz.';

  @override
  String get noFollowedHint =>
      'Bir camiyi açıp Takip et\'e dokunun; burada görünsün ve duyurularını alın.';

  @override
  String reminderBadge(String minutes) {
    return 'Hatırlatıcı $minutes dk';
  }

  @override
  String get manageMasjids => 'Camileri Yönet';

  @override
  String get noMyMasjids => 'Henüz cami kaydetmediniz.';

  @override
  String get noMyMasjidsHint =>
      'Dernek üyeleri, imam, hatip, müezzin veya cami hizmetlisi camilerini kaydedebilir. Yayımlanmadan önce ekibimiz doğrular.';

  @override
  String get appearance => 'Görünüm';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get appearanceHint =>
      'Koyu mod sabah ve yatsı vakitlerinde gözü daha az yorar.';

  @override
  String get pullToRefresh => 'Yenilemek için aşağı çekin';

  @override
  String get verifyAutoCheck =>
      'E-postayla gönderdiğimiz bağlantıyı açın — doğrulandığınızda bu sayfa kendiliğinden güncellenir.';

  @override
  String get signOutTitle => 'Çıkış yapılsın mı?';

  @override
  String get signOutBody =>
      'Bu telefonda takip ettiğiniz camileri görmek ve cemaat hatırlatmaları almak için tekrar giriş yapmanız gerekecek.';

  @override
  String jamatLine(String prayer, String time) {
    return '$prayer cemaati $time';
  }

  @override
  String get scanBoard => 'Vakit tahtasını tara';

  @override
  String get scanBoardHint =>
      'Caminin vakit tahtasının fotoğrafını çekin, tüm cemaat vakitleri kendiliğinden dolsun — veya bir vakte dokunup elle belirleyin.';

  @override
  String get takePhoto => 'Fotoğraf çek';

  @override
  String get chooseGallery => 'Galeriden seç';

  @override
  String get scanStage1 => 'Vakit tahtası inceleniyor…';

  @override
  String get scanStage2 => 'Rakamlar okunuyor…';

  @override
  String get scanStage3 => 'Sabahtan yatsıya eşleştiriliyor…';

  @override
  String get scanStage4 => 'Cuma kontrol ediliyor…';

  @override
  String scanFound(String count) {
    return '$count vakit bulundu';
  }

  @override
  String get scanFailed =>
      'Bu fotoğraf okunamadı. Tahtanın net ve düz bir fotoğrafını deneyin ya da vakitleri elle girin.';

  @override
  String get enterManually => 'Elle gir';

  @override
  String get scanReview =>
      'Vakitler fotoğraftan dolduruldu (✦ işaretli). Kontrol edip Güncelle\'ye dokunun.';

  @override
  String get tabRead => 'Oku';

  @override
  String get readQuran => 'Kur\'an Oku';

  @override
  String get journeySub => '114 surelik yolculuğunuz';

  @override
  String surahsProgress(String done) {
    return '114 sureden $done';
  }

  @override
  String get versesRead => 'ayet okundu';

  @override
  String get phasesDone => 'aşama tamamlandı';

  @override
  String get continueReading => 'Devam et';

  @override
  String get startReading => 'Okumaya başla';

  @override
  String phaseN(String n) {
    return '$n. Aşama';
  }

  @override
  String versesN(String n) {
    return '$n ayet';
  }

  @override
  String get completed => 'Tamamlandı';

  @override
  String get locked => 'Kilitli';

  @override
  String ayahOf(String n, String total) {
    return 'Ayet $n / $total';
  }

  @override
  String unlockHint(String surah) {
    return 'Bu sureyi açmak için $surah suresini bitirin.';
  }

  @override
  String get quizUnlockHint =>
      'Testini açmak için bu aşamadaki tüm sureleri okuyun.';

  @override
  String phaseQuiz(String n) {
    return '$n. aşama testi';
  }

  @override
  String get quizOptional => 'İsteğe bağlı · okuduklarınızı sınayın';

  @override
  String bestScore(String score) {
    return 'En iyi %$score';
  }

  @override
  String get makki => 'Mekki';

  @override
  String get madani => 'Medeni';

  @override
  String get loadingSurah => 'Sure getiriliyor…';

  @override
  String get completeSurah => 'Bu sureyi bitirdim';

  @override
  String get nextSurah => 'Sonraki sure';

  @override
  String surahDone(String name) {
    return 'Maşallah! $name suresini bitirdiniz.';
  }

  @override
  String nextUnlocked(String name) {
    return '$name artık açık.';
  }

  @override
  String get takeQuiz => 'Aşama testini çöz';

  @override
  String get later => 'Sonra';

  @override
  String get wordByWord => 'Kelime kelime';

  @override
  String get quranSource =>
      'Mushaf metni ve kelime kelime: quran.com (Kral Fahd Kompleksi Osmanî hattı) · Meal: Diyanet İşleri';

  @override
  String get startHere => 'BAŞLA';

  @override
  String get quizWordMeaning => 'Bu kelime ne anlama gelir?';

  @override
  String get quizAyahMeaning => 'Bu ayet ne anlama gelir?';

  @override
  String get quizWhichSurah => 'Bu ayet hangi sureden?';

  @override
  String quizRevealed(String name) {
    return '$name suresi nerede indi?';
  }

  @override
  String get makkah => 'Mekke';

  @override
  String get madinah => 'Medine';

  @override
  String quizVerses(String name) {
    return '$name suresi kaç ayettir?';
  }

  @override
  String quizNameMeans(String name) {
    return '“$name” adı ne anlama gelir?';
  }

  @override
  String get kindVocabulary => 'KELİMELER';

  @override
  String get kindMeaning => 'ANLAM';

  @override
  String get kindSurah => 'HANGİ SURE';

  @override
  String get kindFacts => 'SURE BİLGİSİ';

  @override
  String get quizCorrect => 'Doğru — Maşallah!';

  @override
  String get quizWrong => 'Tam değil — doğru cevap vurgulandı.';

  @override
  String get continueBtn => 'Devam et';

  @override
  String quizScore(String score) {
    return 'Puanınız %$score';
  }

  @override
  String get quizDoneBody =>
      'Testler isteğe bağlıdır — okuduklarınızı hatırlamanıza yardımcı olur.';

  @override
  String get quizLoading => 'Testiniz hazırlanıyor…';

  @override
  String get tabQuran => 'Kur\'an';

  @override
  String get tabDua => 'Dua';

  @override
  String get specialSurahs => 'Okunması tavsiye edilen';

  @override
  String get chipMulk => 'Mülk';

  @override
  String get chipMulkWhen => 'Uyumadan önce';

  @override
  String get chipSajdah => 'Secde';

  @override
  String get chipKahf => 'Kehf';

  @override
  String get chipKahfWhen => 'Cuma';

  @override
  String get chipKursi => 'Âyete\'l-Kürsî';

  @override
  String get chipKursiWhen => 'Namazdan sonra ve uyurken';

  @override
  String get chipBaqarahEnd => 'Bakara\'nın son 2 ayeti';

  @override
  String get chipNight => 'Gece';

  @override
  String get chipYasin => 'Yâsîn';

  @override
  String get chipQuls => '3 Kul';

  @override
  String get chipQulsWhen => 'Sabah ve akşam';

  @override
  String get chipAnytime => 'Her zaman';

  @override
  String get chipToday => 'Bugün';

  @override
  String get chipTonight => 'Bu gece';

  @override
  String get revealedMakkah => 'Mekke\'de indi';

  @override
  String get revealedMadinah => 'Medine\'de indi';

  @override
  String get reciter => 'Kârî';

  @override
  String get chooseReciter => 'Kârî seçin';

  @override
  String get playAyah => 'Bu ayetten başlat';

  @override
  String recitingAyah(String n, String total) {
    return 'Ayet $n / $total';
  }

  @override
  String get audioError => 'Tilavet yüklenemedi. İnternetinizi kontrol edin.';

  @override
  String get dailyQuran => 'Günlük Kur\'an';

  @override
  String get energy0 => 'Kalbin bugün nur bekliyor';

  @override
  String get energy1 => 'Doluyor… birkaç ayet daha';

  @override
  String get energy2 => 'Neredeyse dolu — devam!';

  @override
  String get energy3 => 'Nurla dolu — Maşallah!';

  @override
  String get energy4 => 'Bugün pırıl pırıl ✨';

  @override
  String versesToday(String n, String goal) {
    return 'Bugün $n / $goal ayet';
  }

  @override
  String streakDays(String n) {
    return '$n gün üst üste';
  }

  @override
  String get readNow => 'Şimdi oku';

  @override
  String get keepReading => 'Daha fazla oku';

  @override
  String get achievements => 'Başarılar';

  @override
  String achievementsCount(String n, String total) {
    return '$total başarıdan $n';
  }

  @override
  String achievementEarned(String date) {
    return '$date tarihinde kazanıldı';
  }

  @override
  String achievementLocked(String done, String target) {
    return 'Devam ediyor · $done/$target';
  }

  @override
  String achievementUnlocked(String name) {
    return 'Başarı kazanıldı: $name';
  }

  @override
  String get ach_bismillah => 'Bismillah';

  @override
  String get ach_bismillah_desc => 'İlk ayetinizi okuyun';

  @override
  String get ach_fatiha => 'Fâtiha';

  @override
  String get ach_fatiha_desc => 'Fâtiha suresini bitirin';

  @override
  String get ach_quls => 'Üç Kul';

  @override
  String get ach_quls_desc => 'İhlâs, Felak ve Nâs surelerini bitirin';

  @override
  String get ach_streak3 => 'Sağlam Adımlar';

  @override
  String get ach_streak3_desc => '3 gün üst üste Kur\'an okuyun';

  @override
  String get ach_streak7 => 'Nurlu Hafta';

  @override
  String get ach_streak7_desc => '7 gün üst üste Kur\'an okuyun';

  @override
  String get ach_streak30 => 'Nurlu Ay';

  @override
  String get ach_streak30_desc => '30 gün üst üste Kur\'an okuyun';

  @override
  String get ach_verses100 => 'Yüz Ayet';

  @override
  String get ach_verses100_desc => '100 ayet okuyun';

  @override
  String get ach_verses1000 => 'Bin Ayet';

  @override
  String get ach_verses1000_desc => '1.000 ayet okuyun';

  @override
  String get ach_kahf => 'Cuma Nuru';

  @override
  String get ach_kahf_desc => 'Kehf suresini bir Cuma günü bitirin';

  @override
  String get ach_mulk => 'Gece Bekçisi';

  @override
  String get ach_mulk_desc => 'Mülk suresini gece bitirin';

  @override
  String get ach_yasin => 'Yâsîn';

  @override
  String get ach_yasin_desc => 'Yâsîn suresini bitirin';

  @override
  String get ach_listener => 'Dikkatli Dinleyici';

  @override
  String get ach_listener_desc => 'Bir surenin tilavetini baştan sona dinleyin';

  @override
  String get ach_quiz100 => 'Keskin Zekâ';

  @override
  String get ach_quiz100_desc => 'Bir aşama testinde %100 alın';

  @override
  String get ach_juzamma => 'Amme Cüzü';

  @override
  String get ach_juzamma_desc => '30. cüzün 37 suresinin hepsini bitirin';

  @override
  String get ach_phases10 => 'On Aşama';

  @override
  String get ach_phases10_desc => 'Yolculuğun 10 aşamasını tamamlayın';

  @override
  String get ach_khatm => 'Hatim';

  @override
  String get ach_khatm_desc => '114 surenin hepsini bitirin';

  @override
  String get duaHeader => 'Allah\'ı anarak geçen bir gün';

  @override
  String get duaSub =>
      'Uyanmaktan uyumaya — Peygamber ﷺ\'in her an için öğrettiği dualar.';

  @override
  String repeatTimes(String n) {
    return '$n kez okuyun';
  }

  @override
  String duaSource(String n) {
    return 'Hısnu\'l-Müslim #$n';
  }

  @override
  String get duaCredit =>
      'Dualar, Said b. Ali el-Kahtânî\'nin Hısnu\'l-Müslim (Müslüman\'ın Kalesi) eserinden, resmi sitesi hisnmuslim.com aracılığıyla alınmıştır. Meal İngilizcedir.';

  @override
  String get nowLabel => 'Şimdi';

  @override
  String get scene_wake => 'Uyanınca';

  @override
  String get scene_wake_story =>
      'Gün şükürle başlar — Allah uykudan sonra ruhu geri verdi.';

  @override
  String get scene_restroom => 'Tuvalet';

  @override
  String get scene_restroom_story =>
      'En küçük alışkanlık bile Allah\'a sığınarak başlar.';

  @override
  String get scene_wudu => 'Abdest';

  @override
  String get scene_wudu_story =>
      'Ellerde su, dilde O\'nun adı — Allah\'ın huzurunda durmaya hazırlık.';

  @override
  String get scene_dress => 'Giyinirken';

  @override
  String get scene_dress_story =>
      'Her elbise bir nimettir — seni giydirene şükret.';

  @override
  String get scene_athan => 'Ezan';

  @override
  String get scene_athan_story =>
      'Ezan mahallede yükselir — onu cevapla, sonra Peygamber ﷺ için dua et.';

  @override
  String get scene_masjid => 'Camiye giderken';

  @override
  String get scene_masjid_story =>
      'Camiye her adım nurdur — duayla gir ve çık.';

  @override
  String get scene_after_salah => 'Namazdan sonra';

  @override
  String get scene_after_salah_story =>
      'Kalkıp gitmeden önce namaz sonrası zikirlerle biraz otur.';

  @override
  String get scene_morning => 'Sabah zikirleri';

  @override
  String get scene_morning_story => 'Seni akşama kadar koruyan sözler.';

  @override
  String get scene_eating => 'Kahvaltı';

  @override
  String get scene_eating_story => 'O\'nun adıyla başla, O\'na hamdle bitir.';

  @override
  String get scene_leave_home => 'Evden çıkarken';

  @override
  String get scene_leave_home_story => 'Kapıda gününü Allah\'a emanet et.';

  @override
  String get scene_travel => 'Yolda';

  @override
  String get scene_travel_story =>
      'Otobüs, rikşa ya da araba — yokuş çıkarken Allahu Ekber, inerken Sübhanallah.';

  @override
  String get scene_meeting => 'İnsanlarla karşılaşınca';

  @override
  String get scene_meeting_story =>
      'Selamı yay ve kardeşinin hapşırığına karşılık ver.';

  @override
  String get scene_good_news => 'Sevindirici bir şey olunca';

  @override
  String get scene_good_news_story =>
      'Sevinç, nimeti verene bir hatırlatmadır — O\'na hamdet, insanlara da teşekkür et.';

  @override
  String get scene_hardship => 'Zorlanınca';

  @override
  String get scene_hardship_story =>
      'Kaygı, sıkıntı ya da başarısız bir plan — önce O\'na yönel.';

  @override
  String get scene_patience => 'Kayıp ve sabır';

  @override
  String get scene_patience_story =>
      'Bir şey alındığında, Allah\'a ait olduğumuzu hatırla.';

  @override
  String get scene_anger => 'Öfkeyi yenmek';

  @override
  String get scene_anger_story =>
      'Pişman olabileceğin sözlerden önce Allah\'a sığın.';

  @override
  String get scene_pain => 'Ağrı ve hastalık';

  @override
  String get scene_pain_story =>
      'Kendi ağrın için ve ziyaret ettiğin bir dost için.';

  @override
  String get scene_rain => 'Yağmur yağınca';

  @override
  String get scene_rain_story => 'Yağmur rahmettir — faydalı olmasını iste.';

  @override
  String get scene_home => 'Eve dönünce';

  @override
  String get scene_home_story => 'O\'nun adıyla gir ve ailene selam ver.';

  @override
  String get scene_gathering => 'Meclisten kalkarken';

  @override
  String get scene_gathering_story => 'Kalkmadan önce dilin sürçmelerini sil.';

  @override
  String get scene_forgiveness => 'Bağışlanma dilemek';

  @override
  String get scene_forgiveness_story => 'Günün hataları istiğfarla yıkanır.';

  @override
  String get scene_sleep => 'Uyumadan önce';

  @override
  String get scene_sleep_story =>
      'Günü başladığın gibi bitir — O\'nun adıyla, O\'nun korumasında.';

  @override
  String get scene_night => 'Gece';

  @override
  String get scene_night_story =>
      'Uyanırsan ya da kötü bir rüya görürsen, O yakındır.';

  @override
  String get part_dawn => 'Seher';

  @override
  String get part_morning => 'Sabah';

  @override
  String get part_day => 'Gündüz';

  @override
  String get part_evening => 'Akşam';

  @override
  String get part_night => 'Gece';

  @override
  String get removeSession => 'Kaldır';

  @override
  String addSession(String session) {
    return '$session ekle';
  }

  @override
  String get duaSearchHint => 'Dua ara';

  @override
  String duaPartCount(String topics, String duas) {
    return '$topics konu · $duas dua';
  }

  @override
  String duaNoResults(String q) {
    return '“$q” için dua bulunamadı';
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
      other: '$nString dua bulundu',
      one: '1 dua bulundu',
    );
    return '$_temp0';
  }

  @override
  String get part_dawn_sub => 'Uyanış, abdest ve sabah namazı';

  @override
  String get part_morning_sub => 'Zikirler, yemek ve dışarı çıkmak';

  @override
  String get part_day_sub => 'İnsanlar, sevinçler ve imtihanlar';

  @override
  String get part_evening_sub => 'Ev, meclisler, istiğfar';

  @override
  String get part_night_sub => 'Uyku ve gece';

  @override
  String duaCount(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString dua',
      one: '1 dua',
    );
    return '$_temp0';
  }

  @override
  String get noticeSearchHint => 'Duyuru, cami ara…';

  @override
  String get noticesSub => 'Çevrenizdeki camilerden';

  @override
  String get tabNotices => 'Duyurular';

  @override
  String get chooseSurah => 'Sureye git';

  @override
  String get surahSearchHint => 'Sureyi ad veya numarayla arayın';

  @override
  String get previousSurah => 'Önceki sure';

  @override
  String get pickOnMapTitle => 'Haritada seç';

  @override
  String get mapSearchHint => 'Cami veya bölge ara';

  @override
  String get useMyLocation => 'Konumum';

  @override
  String get mapPickHint =>
      'İğne camiye gelecek şekilde haritayı kaydırın, bir noktaya dokunun ya da bir cami simgesine dokunun.';

  @override
  String get mapMoving => 'Yer bulunuyor…';

  @override
  String get useThisLocation => 'Bu konumu kullan';

  @override
  String get masjidLocation => 'Cami konumu';

  @override
  String get chooseLocationWay => 'Tam konumu belirlemek için bir yol seçin:';

  @override
  String get atTheMasjid => 'Camideyim';

  @override
  String get atTheMasjidBody =>
      'Telefonunuzun GPS\'ini kullanın. Yüklenirken caminin içinde kalın.';

  @override
  String get onTheMap => 'Haritada seç';

  @override
  String get onTheMapBody =>
      'Camiyi haritada gösterin ya da görünen bir camiye dokunun.';

  @override
  String get locFromMap => 'Haritadan seçildi';

  @override
  String get locFromGps => 'GPS';

  @override
  String get locSaved => 'Kayıtlı konum';

  @override
  String get useGpsInstead => 'GPS kullan';

  @override
  String get adjustOnMap => 'Haritada düzelt';

  @override
  String get allMasjids => 'Tüm Camiler';

  @override
  String get nearestFirst => 'En yakın önce';

  @override
  String get duaForNow => 'Bu vaktin duaları';

  @override
  String get tabChannel => 'Kanal';

  @override
  String get channelInviteTitle => 'İmamınıza ve hatibinize yakın olun';

  @override
  String get channelInviteHadith =>
      '“İlim öğrenmek her Müslümana farzdır.” — Sünen-i İbn Mâce 224';

  @override
  String get channelInviteBody =>
      'Her Müslümanın farz-ı ayn olan bilgileri — iman, temizlik, namaz ve günlük hayatın temel esaslarını — öğrenmesi gerekir ve bunun en iyi yolu bir âlimin rehberliğidir. İmam ve hatibinin rehberliğini ve mesajlarını almak, mahallenizin camisine daha da yakınlaşmak için bu caminin kanalına katılın.';

  @override
  String get joinChannel => 'Kanala katıl';

  @override
  String get openChannel => 'Kanalı aç';

  @override
  String get joinedChannel => 'Bu caminin kanalındasınız';

  @override
  String get channelJoined => 'Katıldınız. İmam ve hatipten mesaj alacaksınız.';

  @override
  String get leaveChannel => 'Kanaldan ayrıl';

  @override
  String get leaveChannelQ =>
      'Bu kanaldan ayrılınsın mı? Artık mesajlarını almayacaksınız.';

  @override
  String get leave => 'Ayrıl';

  @override
  String get channelEmpty => 'Henüz mesaj yok.';

  @override
  String get channelEmptyAdmin => 'Üyelerinize ilk mesajı gönderin.';

  @override
  String get channelReadOnly =>
      'Burada yalnızca imam, hatip ve kanal yöneticileri paylaşım yapar.';

  @override
  String get messageHint => 'Bir mesaj yazın…';

  @override
  String get send => 'Gönder';

  @override
  String get deleteMessageQ => 'Bu mesaj herkes için silinsin mi?';

  @override
  String get members => 'Üyeler';

  @override
  String get noMembers =>
      'Henüz kimse katılmadı. Caminizin cemaatini davet edin.';

  @override
  String get roleMember => 'Üye';

  @override
  String get roleEditor => 'Editör';

  @override
  String get roleAdmin => 'Yönetici';

  @override
  String get roleMemberDesc => 'Mesajları okur';

  @override
  String get roleEditorDesc => 'Mesaj gönderebilir';

  @override
  String get roleAdminDesc => 'Mesaj gönderir ve üyeleri yönetir';

  @override
  String get removeMember => 'Kanaldan çıkar';

  @override
  String get you => 'Siz';

  @override
  String get channelMessages => 'Kanal mesajları';

  @override
  String get noticesHeading => 'Duyurular';

  @override
  String get signInToJoin => 'Kanala katılmak için giriş yapın.';

  @override
  String get monthNames =>
      'Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık';

  @override
  String get am => 'ÖÖ';

  @override
  String get pm => 'ÖS';

  @override
  String jamatReminderBody(String prayer, String minutes) {
    return '$prayer cemaatine $minutes dakika kaldı';
  }

  @override
  String get attach => 'Ekle';

  @override
  String get attachPhoto => 'Fotoğraf';

  @override
  String get attachVideo => 'Video';

  @override
  String get attachAudio => 'Ses';

  @override
  String get attachFile => 'Dosya';

  @override
  String fileTooLarge(String size) {
    return 'Dosya çok büyük. Sınır $size.';
  }

  @override
  String get cantOpenFile =>
      'Bu telefonda bu dosyayı açabilecek bir uygulama yok.';

  @override
  String get channelNotAllowed =>
      'Kanal şu anda kullanılamıyor (erişim reddedildi). Lütfen daha sonra tekrar deneyin.';

  @override
  String get duaForNowSub => 'Günün bu vakti için zikir ve dualar';

  @override
  String get approxLocation =>
      'Yaklaşık konum – Kesin Konum\'u açmak için dokunun';

  @override
  String get signInFirst => 'Lütfen önce giriş yapın.';

  @override
  String get volunteerTitleEmpty => 'Cemaat vakitleri henüz eklenmedi';

  @override
  String get volunteerBodyEmpty =>
      'Bu caminin yakınında mı yaşıyor ya da namaz kılıyorsunuz? Cemaat vakitlerini ekleyin ve herkes için güncel tutun.';

  @override
  String get volunteerTitle => 'Burada düzenli namaz kılıyor musunuz?';

  @override
  String get volunteerBody =>
      'Bu caminin cemaat vakitlerinin doğru kalmasına yardım edin.';

  @override
  String get volunteerButton => 'Cemaat vaktini güncellemek istiyorum';

  @override
  String get volunteerCheckTitle => 'Bu caminin vakitlerini güncelle';

  @override
  String volunteerCheckBody(String km) {
    return 'Caminin yakınındakiler vakitlerini güncel tutabilir. Camiye $km km içinde olduğunuzu kontrol edeceğiz – konumunuz yalnızca bu kontrol için kullanılır.';
  }

  @override
  String get volunteerCheckButton => 'Konumumu kontrol et';

  @override
  String get volunteerChecking => 'Konumunuz kontrol ediliyor…';

  @override
  String volunteerTooFar(String distance, String km) {
    return '$distance uzaktasınız. Vakitleri güncellemek için camiye $km km yaklaşın.';
  }

  @override
  String get volunteerApprox =>
      'Telefonunuz yalnızca yaklaşık konum paylaşıyor. Muslimin için Kesin Konum\'u açıp tekrar deneyin.';

  @override
  String get volunteerBlocked =>
      'Şu anda cami vakitlerini güncelleyemezsiniz. Bir hata olduğunu düşünüyorsanız yöneticiye başvurun.';

  @override
  String get volunteerWelcome =>
      'Teşekkürler! Artık bu caminin vakitlerini güncelleyebilirsiniz.';

  @override
  String get stopEditing => 'Bu camiyi güncellemeyi bırak';

  @override
  String get reportProblem => 'Sorun bildir';

  @override
  String get reportTitle => 'Sorun nedir?';

  @override
  String get reportWrongTime => 'Cemaat vakti yanlış';

  @override
  String get reportWrongLocation => 'Haritadaki konum yanlış';

  @override
  String get reportWrongInfo => 'Ad veya bilgiler yanlış';

  @override
  String get reportClosed => 'Kapalı veya yok';

  @override
  String get reportDuplicate => 'İki kez listelenmiş';

  @override
  String get reportOther => 'Başka bir şey';

  @override
  String get reportNote => 'Ayrıntı (isteğe bağlı) – ör. doğru vakit';

  @override
  String get reportSend => 'Bildirimi gönder';

  @override
  String get reportThanks => 'Teşekkürler – yönetici inceleyecek.';

  @override
  String get volunteers => 'Gönüllü editörler';

  @override
  String get noVolunteers => 'Henüz gönüllü yok.';

  @override
  String editorDistance(String distance) {
    return 'Katıldığında camiye $distance';
  }

  @override
  String get removeEditor => 'Kaldır';

  @override
  String get removeAndBlock => 'Kaldır ve düzenlemeyi engelle';

  @override
  String lastUpdatedBy(String when, String name) {
    return '$when güncelledi: $name';
  }

  @override
  String get adminReport => 'Rapor';

  @override
  String get adminProblems => 'Sorunlar';

  @override
  String get adminEdits => 'Düzenlemeler';

  @override
  String get statMasjids => 'Camiler';

  @override
  String get statWithTimes => 'Cemaat vakti olan';

  @override
  String get statVolunteers => 'Gönüllüler';

  @override
  String get statOpenReports => 'Açık sorunlar';

  @override
  String get statPending => 'İnceleme bekliyor';

  @override
  String get shareReport => 'Raporu paylaş';

  @override
  String get coverageTitle => 'İlçeye göre';

  @override
  String get coverageLoad => 'İlçeleri göster';

  @override
  String get resolve => 'Çözüldü olarak işaretle';

  @override
  String get revert => 'Değişikliği geri al';

  @override
  String get reverted => 'Değişiklik geri alındı';

  @override
  String get editFieldStaff => 'Görevliler';

  @override
  String get editFieldMaktab => 'Mektep';

  @override
  String timeLooksWrong(String prayers) {
    return 'Bu vakitler yanlış görünüyor: $prayers. Lütfen ÖÖ/ÖS\'yi kontrol edin.';
  }

  @override
  String get dataCredits =>
      'Cami konumları: © OpenStreetMap contributors (ODbL). İlçe sınırları: Bangladeş İstatistik Bürosu / OCHA, geoBoundaries (CC BY 3.0 IGO).';

  @override
  String get fromOsm =>
      'OpenStreetMap\'ten eklendi (© OpenStreetMap contributors). Vakitleri yakındakiler girer.';

  @override
  String get jumuahNote => 'Cuma günleri, öğle yerine';

  @override
  String get chooseThana => 'İlçe seçin';

  @override
  String get chooseThanaHint =>
      'O ilçenin camilerini gösterir – konumunuz değişmez.';

  @override
  String get searchThana => 'İlçe veya il ara';

  @override
  String get myThana => 'Şu an bulunduğunuz yer';

  @override
  String get missingMasjidTitle => 'Cami eksik mi?';

  @override
  String get missingMasjidBody =>
      'Listede olmayan yakındaki bir camiyi ekleyin – haritada işaretleyip adını yazın.';

  @override
  String get addMissingMasjid => 'Cami ekle';

  @override
  String alreadyListed(String name) {
    return '\"$name\" bu noktada zaten var.';
  }

  @override
  String get openIt => 'Aç';

  @override
  String get addAnyway => 'Farklı bir cami';

  @override
  String get suggestReviewNote =>
      'Yönetici görünmeden önce kontrol eder. Onaydan sonra cemaat vakitlerini ekleyebilirsiniz.';

  @override
  String get suggestNameShort => 'Caminin adını yazın.';

  @override
  String get suggestThanks => 'Teşekkürler! Yönetici yakında ekleyecek.';

  @override
  String get adminNewMasjids => 'Yeni camiler';

  @override
  String get seeOnMap => 'Harita';

  @override
  String get noMasjidInThana => 'Bu ilçede henüz cami yok.';

  @override
  String get allAreas => 'Tüm bölgeler';

  @override
  String get errorBusy =>
      'Uygulama şu an çok yoğun. Biraz sonra tekrar deneyin.';

  @override
  String get errorNoAccess => 'Buna erişiminiz yok.';

  @override
  String get errorOffline => 'İnternet bağlantısı yok.';

  @override
  String get walk => 'Yürüyerek';

  @override
  String get drive => 'Araçla';

  @override
  String get routeUnavailable => 'Rota yok – kuş uçuşu mesafe';

  @override
  String get openInMapsApp => 'Haritalar uygulamasında aç';

  @override
  String minutesShort(String minutes) {
    return '$minutes dk';
  }

  @override
  String hoursMinutes(String hours, String minutes) {
    return '$hours sa $minutes dk';
  }

  @override
  String get fixLocation => 'Konum yanlış mı? Düzelt';

  @override
  String get editFieldLocation => 'Konum';

  @override
  String get attachAnyFile => 'Dosya (video, ses, PDF…)';

  @override
  String get speechUnavailable => 'Bu telefonda konuşmayı yazıya çevirme yok.';

  @override
  String get speechNothing => 'Anlaşılmadı – mikrofona basılı tutup konuşun.';

  @override
  String get holdToTalk => 'Konuşmak için basılı tutun';

  @override
  String get listening => 'Dinleniyor…';

  @override
  String get slideToCancel => 'İptal için kaydırın';

  @override
  String get channelMembers => 'Kanal üyeleri';
}
