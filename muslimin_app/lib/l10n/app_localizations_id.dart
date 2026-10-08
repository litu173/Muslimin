// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class L10nId extends L10n {
  L10nId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Muslimin';

  @override
  String get tagline => 'Sehari bersama umat Islam';

  @override
  String get next => 'Lanjut';

  @override
  String get skip => 'Lewati';

  @override
  String get cancel => 'Batal';

  @override
  String get getStarted => 'Mulai';

  @override
  String get create => 'Buat';

  @override
  String get update => 'Perbarui';

  @override
  String get edit => 'Ubah';

  @override
  String get post => 'Kirim';

  @override
  String get save => 'Simpan';

  @override
  String get select => 'Pilih';

  @override
  String get retry => 'Coba lagi';

  @override
  String get close => 'Tutup';

  @override
  String get delete => 'Hapus';

  @override
  String get done => 'Selesai';

  @override
  String get viewAll => 'Lihat Semua';

  @override
  String get viewDetails => 'Lihat Detail';

  @override
  String get dontShowAgain => 'Jangan Tampilkan Lagi';

  @override
  String get share => 'Bagikan';

  @override
  String get addNew => 'Tambah Baru';

  @override
  String get now => 'Sekarang';

  @override
  String get selected => 'Terpilih';

  @override
  String get home => 'Beranda';

  @override
  String get more => 'Lainnya';

  @override
  String get loading => 'Memuat…';

  @override
  String get somethingWrong => 'Terjadi kesalahan. Silakan coba lagi.';

  @override
  String get onb1Title => 'Bagikan Waktu Jamaah';

  @override
  String get onb1Body =>
      'Orang-orang di sekitar dapat melihat waktu salat berjamaah masjid di aplikasi ini.';

  @override
  String get onb2Title => 'Umumkan Info Masjid';

  @override
  String get onb2Body =>
      'Orang-orang dapat menemukan pengumuman masjid di aplikasi ini sehingga mudah ikut serta dalam berbagai kegiatan.';

  @override
  String get permTitle => 'Izinkan akses untuk melanjutkan';

  @override
  String get permBody =>
      'Muslimin memerlukan lokasi Anda untuk menemukan masjid di sekitar, dan notifikasi untuk mengingatkan sebelum salat berjamaah.';

  @override
  String get permLocation => 'Lokasi';

  @override
  String get permLocationBody =>
      'Temukan masjid terdekat dan hitung waktu salat dengan akurat.';

  @override
  String get permNotification => 'Notifikasi';

  @override
  String get permNotificationBody =>
      'Pengingat jamaah dan pengumuman dari masjid yang Anda ikuti.';

  @override
  String get permAllow => 'Izinkan';

  @override
  String get permGranted => 'Diizinkan';

  @override
  String get permOpenSettings => 'Buka Pengaturan';

  @override
  String get permLocationServiceOff =>
      'Silakan aktifkan lokasi (GPS) di ponsel Anda.';

  @override
  String get permDeniedForever =>
      'Izin ditolak. Silakan aktifkan dari Pengaturan.';

  @override
  String get permContinue => 'Lanjutkan';

  @override
  String get timeLeft => 'Sisa waktu';

  @override
  String get startsIn => 'Dimulai dalam';

  @override
  String get allPrayers => 'Semua Salat';

  @override
  String get nearestMasjid => 'Masjid Terdekat';

  @override
  String get noMasjidNearby => 'Belum ada masjid terverifikasi di dekat Anda.';

  @override
  String get noMasjidNearbyHint =>
      'Kenal pengurus masjid? Minta mereka mendaftarkan masjidnya di Muslimin.';

  @override
  String minWalk(String minutes) {
    return '$minutes menit jalan kaki';
  }

  @override
  String kmAway(String km) {
    return '$km km lagi';
  }

  @override
  String get jamatNotSet => 'Waktu jamaah belum diatur';

  @override
  String get nextJamat => 'Jamaah berikutnya';

  @override
  String get notice => 'Pengumuman';

  @override
  String get notices => 'Pengumuman';

  @override
  String get noNotices => 'Belum ada pengumuman.';

  @override
  String get all => 'Semua';

  @override
  String get authorityTitle => 'Pengurus Masjid';

  @override
  String get authorityBody =>
      'Daftarkan masjid Anda agar umat Islam di sekitar dapat menemukannya di aplikasi ini.';

  @override
  String get yourLocation => 'Lokasi Anda';

  @override
  String get locating => 'Mencari lokasi…';

  @override
  String get useCurrentLocation => 'Gunakan lokasi saat ini';

  @override
  String get searchMasjid => 'Cari masjid';

  @override
  String get nearbyMasjids => 'Masjid Terdekat';

  @override
  String get fajr => 'Subuh';

  @override
  String get sunrise => 'Terbit';

  @override
  String get dhuhr => 'Zuhur';

  @override
  String get asr => 'Asar';

  @override
  String get maghrib => 'Magrib';

  @override
  String get isha => 'Isya';

  @override
  String get jumuah => 'Jumat';

  @override
  String get forbiddenTime => 'Waktu Terlarang';

  @override
  String get forbiddenInfo =>
      'Salat tidak dikerjakan pada waktu-waktu ini: saat matahari terbit, saat tepat di tengah langit, dan saat terbenam.';

  @override
  String get morning => 'Pagi';

  @override
  String get noon => 'Tengah hari';

  @override
  String get evening => 'Sore';

  @override
  String get naflPrayers => 'Salat Sunah';

  @override
  String get tahajjud => 'Tahajud';

  @override
  String get duha => 'Salat Duha';

  @override
  String get tahajjudHadith =>
      'Rasulullah (ﷺ) bersabda: \"Rabb kita Yang Mahaberkah lagi Mahatinggi turun setiap malam ke langit dunia ketika tersisa sepertiga malam terakhir, lalu berfirman: Siapa yang berdoa kepada-Ku, niscaya Aku kabulkan? Siapa yang meminta kepada-Ku, niscaya Aku beri? Siapa yang memohon ampun kepada-Ku, niscaya Aku ampuni?\"';

  @override
  String get tahajjudSource => 'Sahih al-Bukhari 1145';

  @override
  String get duhaHadith1 =>
      'Abu Hurairah berkata: \"Kekasihku, Rasulullah (ﷺ), berwasiat kepadaku tiga hal: puasa tiga hari setiap bulan, dua rakaat salat duha, dan salat witir sebelum tidur.\"';

  @override
  String get duhaSource1 => 'Sahih al-Bukhari & Muslim';

  @override
  String get duhaHadith2 =>
      'Nu\'aim bin Hammar meriwayatkan: Rasulullah (ﷺ) bersabda, \"Allah Yang Mahaperkasa berfirman: Wahai anak Adam, janganlah engkau lemah untuk mengerjakan empat rakaat untuk-Ku di awal harimu, niscaya Aku cukupkan engkau di akhir harimu.\"';

  @override
  String get duhaSource2 => 'Sunan Abu Dawud 1289';

  @override
  String get calcMethodNote =>
      'Waktu dihitung untuk lokasi Anda. Waktu jamaah ditentukan oleh masing-masing masjid.';

  @override
  String get following => 'Mengikuti';

  @override
  String get follow => 'Ikuti';

  @override
  String get tabHome => 'Beranda';

  @override
  String get tabNotice => 'Pengumuman';

  @override
  String get tabLive => 'Live';

  @override
  String get tabAbout => 'Tentang';

  @override
  String get jamatTime => 'Waktu Jamaah';

  @override
  String get maktabTime => 'Waktu TPA';

  @override
  String lastUpdated(String when) {
    return 'Terakhir diperbarui $when';
  }

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String daysAgo(String count) {
    return '$count hari lalu';
  }

  @override
  String get khatib => 'Khatib';

  @override
  String get imam => 'Imam';

  @override
  String get muazzin => 'Muazin';

  @override
  String contact(String phone) {
    return 'Kontak: $phone';
  }

  @override
  String get notAdded => 'Belum ditambahkan';

  @override
  String get jamatReminder => 'Pengingat Jamaah';

  @override
  String get notifyBefore => 'Ingatkan sebelum';

  @override
  String minsBefore(String minutes) {
    return '$minutes menit';
  }

  @override
  String get reminderOff => 'Matikan pengingat';

  @override
  String reminderSet(String minutes) {
    return 'Anda akan diingatkan $minutes menit sebelum setiap jamaah.';
  }

  @override
  String followedToast(String name) {
    return 'Anda sekarang mengikuti $name.';
  }

  @override
  String get directions => 'Petunjuk arah';

  @override
  String get liveNow => 'Sedang live';

  @override
  String get noLive => 'Tidak ada siaran langsung saat ini';

  @override
  String get noLiveHint =>
      'Saat masjid menyiarkan khutbah atau kajian, akan muncul di sini.';

  @override
  String get watchLive => 'Tonton live';

  @override
  String get liveLink => 'Tautan siaran langsung (YouTube / Facebook)';

  @override
  String get liveToggle => 'Kami sedang live';

  @override
  String get maktabDays => 'Hari TPA';

  @override
  String get weekdaysShort => 'Sab,Min,Sen,Sel,Rab,Kam,Jum';

  @override
  String get weekdaysLong => 'Sabtu,Minggu,Senin,Selasa,Rabu,Kamis,Jumat';

  @override
  String dayRange(String from, String to) {
    return '$from ~ $to';
  }

  @override
  String get tapToSet => 'Atur';

  @override
  String get khatibName => 'Nama Khatib';

  @override
  String get imamName => 'Nama Imam';

  @override
  String get muazzinName => 'Nama Muazin';

  @override
  String get contactNumber => 'Nomor Kontak';

  @override
  String get updated => 'Berhasil diperbarui';

  @override
  String get writeNotice => 'Tulis Pengumuman';

  @override
  String get selectCategory => 'Pilih Kategori';

  @override
  String get deleteNoticeQ => 'Hapus pengumuman ini?';

  @override
  String get catJanaza => 'Jenazah';

  @override
  String get catRecruitment => 'Lowongan';

  @override
  String get catQuran => 'Kelas Al-Qur\'an';

  @override
  String get catQuranShort => 'Al-Qur\'an';

  @override
  String get catMahfil => 'Majelis';

  @override
  String get catTalim => 'Taklim';

  @override
  String get catTafsir => 'Tafsir';

  @override
  String get catGeneral => 'Umum';

  @override
  String get janazaNotice => 'Pengumuman Jenazah';

  @override
  String noticeFormTitle(String category) {
    return 'Pengumuman $category';
  }

  @override
  String get enterCarefully => 'Silakan isi informasi di bawah dengan teliti.';

  @override
  String get personName => 'Nama Almarhum/Almarhumah';

  @override
  String get fathersName => 'Nama Ayah';

  @override
  String get diedOn => 'Tanggal Wafat';

  @override
  String get address => 'Alamat';

  @override
  String get janazaTime => 'Waktu Salat Jenazah';

  @override
  String get janazaDate => 'Tanggal Salat Jenazah';

  @override
  String get noticeTitle => 'Judul';

  @override
  String get noticeDetails => 'Detail';

  @override
  String get date => 'Tanggal';

  @override
  String get time => 'Waktu';

  @override
  String deadline(String date) {
    return 'Batas waktu: $date';
  }

  @override
  String startingDate(String date) {
    return 'Tanggal mulai: $date';
  }

  @override
  String timeAndDate(String value) {
    return 'Waktu & Tanggal: $value';
  }

  @override
  String janazaOf(String name) {
    return 'Jenazah $name';
  }

  @override
  String sonOf(String name) {
    return 'Putra/Putri $name';
  }

  @override
  String get noticePosted => 'Pengumuman terkirim';

  @override
  String get required => 'Wajib diisi';

  @override
  String get userAuth => 'Verifikasi Pengguna';

  @override
  String get userAuthBody =>
      'Silakan baca dan setujui jika pernyataan di bawah sesuai.';

  @override
  String get rule1 => 'Saya pengurus masjid atau marbot/muazin/imam masjid';

  @override
  String get rule2 => 'Saya dapat memperbarui waktu jamaah masjid secara rutin';

  @override
  String get rule3 => 'Saya memahami manfaat aplikasi ini';

  @override
  String get rule4 => 'Saya akan menandai lokasi masjid yang tepat';

  @override
  String get agreeAll =>
      'Silakan konfirmasi semua pernyataan untuk melanjutkan.';

  @override
  String get registration => 'Pendaftaran';

  @override
  String get verifyMobile => 'Verifikasi nomor ponsel Anda';

  @override
  String get yourMobile => 'Nomor Ponsel Anda';

  @override
  String get otpWillBeSent =>
      'Kata sandi sekali pakai (OTP) akan dikirim ke nomor ini untuk verifikasi';

  @override
  String get getOtp => 'Dapatkan OTP';

  @override
  String get invalidPhone =>
      'Masukkan nomor ponsel Bangladesh yang valid (01XXXXXXXXX).';

  @override
  String get verification => 'Verifikasi';

  @override
  String get typeOtp => 'Silakan ketik kode OTP yang dikirim ke nomor Anda';

  @override
  String get otp => 'Kata Sandi Sekali Pakai (OTP)';

  @override
  String get didntGetOtp => 'Belum menerima OTP?';

  @override
  String get resendCode => 'Kirim Ulang Kode';

  @override
  String resendIn(String seconds) {
    return 'Kirim ulang dalam $seconds dtk';
  }

  @override
  String get verify => 'Verifikasi';

  @override
  String get invalidOtp => 'Kode tidak benar. Silakan coba lagi.';

  @override
  String get demoOtpHint => 'Mode demo: gunakan kode 123456';

  @override
  String get createMasjidProfile => 'Buat Profil Masjid';

  @override
  String get stayInside =>
      'Isi detail di bawah dengan teliti. Lokasi dapat diatur dari dalam masjid atau di peta.';

  @override
  String get masjidName => 'Nama Masjid';

  @override
  String get district => 'Distrik';

  @override
  String get thana => 'Thana / Upazila';

  @override
  String get latLng => 'Lintang & Bujur';

  @override
  String get load => 'Muat';

  @override
  String get reload => 'Muat ulang';

  @override
  String get stayInsideLoading => 'Tetap di dalam masjid selama memuat.';

  @override
  String accuracy(String meters) {
    return 'Akurasi ±$meters m';
  }

  @override
  String accuracyTooLow(String meters) {
    return 'Lokasi kurang akurat (±$meters m). Pindah ke area terbuka di dalam masjid lalu muat ulang.';
  }

  @override
  String get loadLocationFirst => 'Silakan atur lokasi masjid.';

  @override
  String get nidNumber => 'Nomor KTP (NID) Anda';

  @override
  String get invalidNid => 'NID harus 10, 13, atau 17 digit.';

  @override
  String get yourRole => 'Peran Anda';

  @override
  String get roleCommittee => 'Pengurus';

  @override
  String get roleKhadem => 'Marbot';

  @override
  String get roleMuazzin => 'Muazin';

  @override
  String get roleImam => 'Imam';

  @override
  String get roleKhatib => 'Khatib';

  @override
  String get agreeTermsPrefix => 'Saya telah membaca & menyetujui ';

  @override
  String get termsAndConditions => 'Syarat & Ketentuan';

  @override
  String get mustAgreeTerms => 'Silakan setujui Syarat & Ketentuan.';

  @override
  String duplicateFound(String name) {
    return 'Masjid bernama \"$name\" sudah terdaftar di lokasi ini. Jika Anda pengurusnya, silakan hubungi dukungan.';
  }

  @override
  String limitReached(String count) {
    return 'Anda dapat memiliki paling banyak $count profil masjid.';
  }

  @override
  String get submittedTitle => 'Dikirim untuk ditinjau';

  @override
  String get submittedBody =>
      'Jazakallahu khairan! Profil masjid Anda akan terlihat oleh semua orang setelah diverifikasi tim kami. Anda akan menerima notifikasi saat disetujui.';

  @override
  String get backToHome => 'Kembali ke Beranda';

  @override
  String get termsBody =>
      '1. Hanya pengurus masjid, imam, khatib, muazin, atau marbot yang boleh membuat profil masjid.\n2. Lokasi masjid harus tepat — atur dengan GPS dari dalam masjid atau dengan menunjuknya di peta.\n3. NID dan nomor telepon Anda hanya digunakan untuk verifikasi dan tidak pernah ditampilkan secara publik.\n4. Waktu jamaah dan pengumuman harus akurat dan selalu diperbarui.\n5. Pengumuman harus terkait kegiatan masjid. Konten politik, komersial, atau kebencian tidak diperbolehkan.\n6. Profil tetap tersembunyi sampai diverifikasi tim Muslimin. Profil dengan informasi palsu akan dihapus.';

  @override
  String get statusPending => 'Menunggu tinjauan';

  @override
  String get statusApproved => 'Disetujui';

  @override
  String get statusRejected => 'Ditolak';

  @override
  String get statusSuspended => 'Ditangguhkan';

  @override
  String get pendingBanner =>
      'Profil ini menunggu verifikasi. Hanya Anda yang dapat melihatnya.';

  @override
  String rejectedBanner(String reason) {
    return 'Profil ini tidak disetujui: $reason';
  }

  @override
  String get myMasjids => 'Masjid Saya';

  @override
  String get registerMasjid => 'Daftarkan Masjid';

  @override
  String get appSettings => 'Pengaturan Aplikasi';

  @override
  String get faq => 'Tanya Jawab';

  @override
  String get aboutApp => 'Tentang Aplikasi';

  @override
  String get shareApp => 'Bagikan aplikasi ini';

  @override
  String get shareAppBody =>
      'Aplikasi ini mungkin bermanfaat bagi keluarga & teman Anda juga. Silakan bagikan.';

  @override
  String shareText(String url) {
    return 'Temukan waktu jamaah masjid di sekitar Anda dengan Muslimin: $url';
  }

  @override
  String get language => 'Bahasa';

  @override
  String get calcMethod => 'Perhitungan waktu salat';

  @override
  String get asrMethod => 'Perhitungan Asar';

  @override
  String get hanafi => 'Hanafi';

  @override
  String get shafi => 'Syafi\'i / Maliki / Hanbali';

  @override
  String get hijriAdjust => 'Penyesuaian tanggal Hijriah';

  @override
  String days(String count) {
    return '$count hari';
  }

  @override
  String get defaultReminder => 'Pengingat jamaah bawaan';

  @override
  String get signOut => 'Keluar';

  @override
  String signedInAs(String phone) {
    return 'Masuk sebagai $phone';
  }

  @override
  String version(String v) {
    return 'Versi $v';
  }

  @override
  String get aboutBody =>
      'Muslimin membantu umat Islam menemukan waktu jamaah masjid di sekitar mereka. Setiap profil masjid dibuat oleh pengurusnya sendiri dan diverifikasi tim kami sebelum ditampilkan untuk umum.';

  @override
  String get faqQ1 => 'Dari mana waktu jamaah berasal?';

  @override
  String get faqA1 =>
      'Pengurus setiap masjid menetapkan dan memperbarui waktu jamaahnya sendiri. Waktu masuk salat dihitung untuk lokasi Anda.';

  @override
  String get faqQ2 => 'Mengapa lokasi wajib?';

  @override
  String get faqA2 =>
      'Lokasi digunakan untuk menampilkan masjid di dekat Anda dan menghitung waktu salat yang akurat. Lokasi tidak pernah dibagikan kepada siapa pun.';

  @override
  String get faqQ3 => 'Bagaimana cara menambahkan masjid saya?';

  @override
  String get faqA3 =>
      'Buka Lainnya → Daftarkan Masjid. Anda harus pengurus, imam, muazin, khatib, atau marbot, dan menentukan lokasi masjid yang tepat — dengan GPS dari dalam masjid atau di peta.';

  @override
  String get faqQ4 => 'Mengapa masjid saya tidak terlihat?';

  @override
  String get faqA4 =>
      'Profil baru diverifikasi tim kami sebelum ditampilkan untuk umum. Biasanya memakan waktu 1–2 hari.';

  @override
  String get faqQ5 => 'Bagaimana pengingat jamaah bekerja?';

  @override
  String get faqA5 =>
      'Buka sebuah masjid dan ketuk lonceng pada Waktu Jamaah. Anda akan diberi tahu 15, 30, atau 45 menit sebelum setiap jamaah, bahkan saat aplikasi ditutup.';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get noNotifications =>
      'Ikuti masjid untuk melihat pengumumannya di sini.';

  @override
  String get adminPanel => 'Panel Admin';

  @override
  String get adminPending => 'Menunggu';

  @override
  String get adminApproved => 'Disetujui';

  @override
  String get adminRejected => 'Ditolak';

  @override
  String get approve => 'Setujui';

  @override
  String get reject => 'Tolak';

  @override
  String get suspend => 'Tangguhkan';

  @override
  String get restore => 'Pulihkan';

  @override
  String get rejectReason => 'Alasan penolakan';

  @override
  String get submittedBy => 'Diajukan oleh';

  @override
  String get phone => 'Telepon';

  @override
  String get nid => 'NID';

  @override
  String get role => 'Peran';

  @override
  String get location => 'Lokasi';

  @override
  String get openInMaps => 'Buka di Peta';

  @override
  String get submittedOn => 'Diajukan pada';

  @override
  String get nothingHere => 'Tidak ada apa-apa';

  @override
  String get approvedToast => 'Masjid disetujui';

  @override
  String get rejectedToast => 'Masjid ditolak';

  @override
  String get verifiedChecklist =>
      'Sebelum menyetujui, telepon pengaju dan periksa lokasinya di peta.';

  @override
  String get verse1Ar => 'وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ';

  @override
  String get verse1 =>
      'Dan mohonlah pertolongan (kepada Allah) dengan sabar dan salat.';

  @override
  String get verse1Ref => 'Al-Baqarah 2:45';

  @override
  String get verse2Ar =>
      'إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَـٰبًا مَّوْقُوتًا';

  @override
  String get verse2 =>
      'Sungguh, salat itu adalah kewajiban yang ditentukan waktunya bagi orang-orang yang beriman.';

  @override
  String get verse2Ref => 'An-Nisa\' 4:103';

  @override
  String get verse3Ar =>
      'حَـٰفِظُوا۟ عَلَى ٱلصَّلَوَٰتِ وَٱلصَّلَوٰةِ ٱلْوُسْطَىٰ';

  @override
  String get verse3 => 'Peliharalah semua salat dan salat wusṭa.';

  @override
  String get verse3Ref => 'Al-Baqarah 2:238';

  @override
  String get hijriMonths =>
      'Muharram,Safar,Rabiul Awal,Rabiul Akhir,Jumadil Awal,Jumadil Akhir,Rajab,Syakban,Ramadan,Syawal,Zulkaidah,Zulhijah';

  @override
  String get deadlineLabel => 'Batas Waktu';

  @override
  String get startingDateLabel => 'Tanggal Mulai';

  @override
  String get masjidNameBn => 'Nama Masjid dalam bahasa Bangla (opsional)';

  @override
  String get createAccount => 'Buat Akun';

  @override
  String get signIn => 'Masuk';

  @override
  String get fullName => 'Nama Lengkap';

  @override
  String get email => 'Email';

  @override
  String get password => 'Kata Sandi';

  @override
  String get confirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get noAccount => 'Belum punya akun?';

  @override
  String get haveAccount => 'Sudah punya akun?';

  @override
  String get signUpBody =>
      'Buat akun untuk mengikuti masjid dan menyimpan pengaturan Anda dengan aman.';

  @override
  String get signInBody => 'Selamat datang kembali! Masuk untuk melanjutkan.';

  @override
  String get resetPassword => 'Atur Ulang Kata Sandi';

  @override
  String get resetBody =>
      'Masukkan email yang Anda gunakan untuk mendaftar. Kami akan mengirim tautan untuk membuat kata sandi baru.';

  @override
  String get sendResetLink => 'Kirim Tautan';

  @override
  String resetSent(String email) {
    return 'Tautan atur ulang kata sandi telah dikirim ke $email. Silakan periksa kotak masuk (dan folder spam).';
  }

  @override
  String get backToSignIn => 'Kembali ke Masuk';

  @override
  String get invalidEmail => 'Masukkan alamat email yang valid.';

  @override
  String get passwordTooShort => 'Kata sandi minimal 6 karakter.';

  @override
  String get passwordsDontMatch => 'Kata sandi tidak cocok.';

  @override
  String get errEmailInUse => 'Akun dengan email ini sudah ada. Coba masuk.';

  @override
  String get errInvalidCredential => 'Email atau kata sandi salah.';

  @override
  String get errWeakPassword =>
      'Silakan pilih kata sandi yang lebih kuat (minimal 6 karakter).';

  @override
  String get errTooManyRequests =>
      'Terlalu banyak percobaan. Tunggu beberapa menit lalu coba lagi.';

  @override
  String get errNetwork => 'Tidak ada koneksi internet. Silakan coba lagi.';

  @override
  String get errPhoneInUse => 'Nomor telepon ini sudah terhubung ke akun lain.';

  @override
  String get errUserDisabled =>
      'Akun ini telah dinonaktifkan. Silakan hubungi dukungan.';

  @override
  String get myAccount => 'Akun Saya';

  @override
  String get signInPrompt => 'Untuk pengurus masjid';

  @override
  String get signInPromptBody =>
      'Masuk atau buat akun untuk mendaftarkan dan mengelola masjid Anda. Pengguna biasa tidak memerlukan akun.';

  @override
  String get profile => 'Profil';

  @override
  String get emailNotVerified => 'Email belum terverifikasi';

  @override
  String get emailVerified => 'Email terverifikasi';

  @override
  String get resendVerification => 'Kirim email verifikasi';

  @override
  String verificationSent(String email) {
    return 'Email verifikasi dikirim ke $email.';
  }

  @override
  String get changePassword => 'Ubah Kata Sandi';

  @override
  String get currentPassword => 'Kata Sandi Saat Ini';

  @override
  String get newPassword => 'Kata Sandi Baru';

  @override
  String get passwordChanged => 'Kata sandi berhasil diubah.';

  @override
  String get deleteAccount => 'Hapus Akun';

  @override
  String get deleteAccountBody =>
      'Ini akan menghapus akun dan data tersimpan Anda secara permanen. Profil masjid yang Anda kelola tetap ada, tetapi Anda kehilangan akses. Masukkan kata sandi untuk konfirmasi.';

  @override
  String get accountDeleted => 'Akun Anda telah dihapus.';

  @override
  String get phoneNumber => 'Telepon';

  @override
  String get notVerified => 'Belum terverifikasi';

  @override
  String welcomeUser(String name) {
    return 'Selamat datang, $name!';
  }

  @override
  String get signInToRegister =>
      'Silakan masuk atau buat akun untuk mendaftarkan masjid.';

  @override
  String get verifyPhoneToContinue =>
      'Verifikasi nomor telepon Anda untuk mendaftarkan masjid.';

  @override
  String accountCreated(String email) {
    return 'Akun dibuat! Kami mengirim tautan verifikasi ke $email.';
  }

  @override
  String get nameRequired => 'Silakan masukkan nama Anda.';

  @override
  String get credits => 'Kredit';

  @override
  String get fontCredits =>
      'Logo & nama salat berbahasa Inggris: huruf dari desain Muslimin, berdasarkan Hidayatullah karya Anthonie Van Hayu (ARToni). Fon: Grenze Gotisch karya Omnibus-Type, Poppins karya Indian Type Foundry & Jonny Pinhorn, Hind Siliguri karya Indian Type Foundry, Anek Bangla (angka Bangla) karya Ek Type, Galada karya Black Foundry, Scheherazade New karya SIL International. Semua fon gratis di bawah SIL Open Font License 1.1.';

  @override
  String get designInspired =>
      'Fon desain asli: Hidayatullah karya Anthonie Van Hayu (ARToni).';

  @override
  String get openSourceLicenses => 'Lisensi sumber terbuka';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get orDivider => 'atau';

  @override
  String get onb3Title => 'Waktu Salat & Pengingat';

  @override
  String get onb3Body =>
      'Waktu salat yang akurat untuk lokasi Anda, dan pengingat sebelum setiap jamaah di masjid yang Anda ikuti.';

  @override
  String get appVersion => 'Versi aplikasi';

  @override
  String get checkingUpdates => 'Memeriksa pembaruan…';

  @override
  String get upToDate => 'Anda memakai versi terbaru.';

  @override
  String updateAvailable(String version) {
    return 'Versi baru $version tersedia';
  }

  @override
  String get downloadLatestApk => 'Unduh APK terbaru';

  @override
  String get updateApkHint =>
      'Buka berkas yang diunduh untuk memasangnya di atas versi ini. Pengaturan Anda tetap tersimpan.';

  @override
  String get updateIosButton => 'Cara memperbarui di iPhone';

  @override
  String get updateCheckFailed =>
      'Tidak dapat memeriksa pembaruan. Periksa koneksi internet Anda.';

  @override
  String get releaseNotes => 'Catatan rilis';

  @override
  String get selectAll => 'Pilih semua';

  @override
  String get welcomeTitle => 'Assalamu\'alaikum';

  @override
  String get welcomeBody =>
      'Masuk untuk mengikuti masjid Anda, menerima pengingat jamaah, dan menyinkronkan semuanya di ponsel Anda.';

  @override
  String get continueAsGuest => 'Lanjutkan sebagai tamu';

  @override
  String get editMasjidInfo => 'Ubah Info Masjid';

  @override
  String get editMasjidInfoBody =>
      'Perbarui detail yang tampil di profil masjid Anda, termasuk lokasinya (GPS di masjid atau dipilih di peta).';

  @override
  String get followedMasjids => 'Masjid yang Diikuti';

  @override
  String get noFollowed => 'Anda belum mengikuti masjid mana pun.';

  @override
  String get noFollowedHint =>
      'Buka sebuah masjid lalu ketuk Ikuti agar muncul di sini dan Anda menerima pengumumannya.';

  @override
  String reminderBadge(String minutes) {
    return 'Pengingat $minutes mnt';
  }

  @override
  String get manageMasjids => 'Kelola Masjid';

  @override
  String get noMyMasjids => 'Anda belum mendaftarkan masjid.';

  @override
  String get noMyMasjidsHint =>
      'Pengurus, imam, khatib, muazin, atau marbot dapat mendaftarkan masjidnya. Tim kami memverifikasinya sebelum tampil untuk umum.';

  @override
  String get appearance => 'Tampilan';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get appearanceHint =>
      'Mode gelap lebih nyaman di mata saat Subuh dan Isya.';

  @override
  String get pullToRefresh => 'Tarik ke bawah untuk menyegarkan';

  @override
  String get verifyAutoCheck =>
      'Buka tautan yang kami kirim lewat email — halaman ini akan diperbarui sendiri setelah Anda terverifikasi.';

  @override
  String get signOutTitle => 'Keluar?';

  @override
  String get signOutBody =>
      'Anda perlu masuk lagi untuk melihat masjid yang diikuti dan menerima pengingat jamaah di ponsel ini.';

  @override
  String jamatLine(String prayer, String time) {
    return 'Jamaah $prayer $time';
  }

  @override
  String get scanBoard => 'Pindai papan jadwal';

  @override
  String get scanBoardHint =>
      'Foto papan jadwal masjid dan semua waktu jamaah terisi otomatis — atau ketuk sebuah waktu untuk mengaturnya manual.';

  @override
  String get takePhoto => 'Ambil foto';

  @override
  String get chooseGallery => 'Pilih dari galeri';

  @override
  String get scanStage1 => 'Melihat papan jadwal…';

  @override
  String get scanStage2 => 'Membaca angka…';

  @override
  String get scanStage3 => 'Mencocokkan Subuh hingga Isya…';

  @override
  String get scanStage4 => 'Memeriksa Jumat…';

  @override
  String scanFound(String count) {
    return 'Ditemukan $count waktu';
  }

  @override
  String get scanFailed =>
      'Foto ini tidak dapat dibaca. Coba foto papan yang jelas dan lurus, atau isi waktu secara manual.';

  @override
  String get enterManually => 'Isi manual';

  @override
  String get scanReview =>
      'Waktu diisi dari foto (bertanda ✦). Periksa, lalu ketuk Perbarui.';

  @override
  String get tabRead => 'Baca';

  @override
  String get readQuran => 'Baca Al-Qur\'an';

  @override
  String get journeySub => 'Perjalanan Anda melalui 114 surah';

  @override
  String surahsProgress(String done) {
    return '$done dari 114 surah';
  }

  @override
  String get versesRead => 'ayat dibaca';

  @override
  String get phasesDone => 'tahap selesai';

  @override
  String get continueReading => 'Lanjutkan';

  @override
  String get startReading => 'Mulai membaca';

  @override
  String phaseN(String n) {
    return 'Tahap $n';
  }

  @override
  String versesN(String n) {
    return '$n ayat';
  }

  @override
  String get completed => 'Selesai';

  @override
  String get locked => 'Terkunci';

  @override
  String ayahOf(String n, String total) {
    return 'Ayat $n dari $total';
  }

  @override
  String unlockHint(String surah) {
    return 'Selesaikan $surah untuk membuka surah ini.';
  }

  @override
  String get quizUnlockHint =>
      'Baca semua surah di tahap ini untuk membuka kuisnya.';

  @override
  String phaseQuiz(String n) {
    return 'Kuis tahap $n';
  }

  @override
  String get quizOptional => 'Opsional · uji bacaan Anda';

  @override
  String bestScore(String score) {
    return 'Terbaik $score%';
  }

  @override
  String get makki => 'Makkiyah';

  @override
  String get madani => 'Madaniyah';

  @override
  String get loadingSurah => 'Mengambil surah…';

  @override
  String get completeSurah => 'Saya sudah menyelesaikan surah ini';

  @override
  String get nextSurah => 'Surah berikutnya';

  @override
  String surahDone(String name) {
    return 'MasyaAllah! Anda menyelesaikan Surah $name.';
  }

  @override
  String nextUnlocked(String name) {
    return '$name sekarang terbuka.';
  }

  @override
  String get takeQuiz => 'Ikuti kuis tahap';

  @override
  String get later => 'Nanti';

  @override
  String get wordByWord => 'Kata per kata';

  @override
  String get quranSource =>
      'Teks mushaf & kata per kata: quran.com (rasm Utsmani Kompleks Raja Fahd) · Terjemahan: Kementerian Agama RI';

  @override
  String get startHere => 'MULAI';

  @override
  String get quizWordMeaning => 'Apa arti kata ini?';

  @override
  String get quizAyahMeaning => 'Apa arti ayat ini?';

  @override
  String get quizWhichSurah => 'Ayat ini dari surah apa?';

  @override
  String quizRevealed(String name) {
    return 'Di mana Surah $name diturunkan?';
  }

  @override
  String get makkah => 'Makkah';

  @override
  String get madinah => 'Madinah';

  @override
  String quizVerses(String name) {
    return 'Berapa jumlah ayat Surah $name?';
  }

  @override
  String quizNameMeans(String name) {
    return 'Apa arti nama “$name”?';
  }

  @override
  String get kindVocabulary => 'KOSAKATA';

  @override
  String get kindMeaning => 'MAKNA';

  @override
  String get kindSurah => 'SURAH APA';

  @override
  String get kindFacts => 'FAKTA SURAH';

  @override
  String get quizCorrect => 'Benar — MasyaAllah!';

  @override
  String get quizWrong => 'Belum tepat — jawaban yang benar disorot.';

  @override
  String get continueBtn => 'Lanjutkan';

  @override
  String quizScore(String score) {
    return 'Skor Anda $score%';
  }

  @override
  String get quizDoneBody =>
      'Kuis bersifat opsional — membantu Anda mengingat bacaan.';

  @override
  String get quizLoading => 'Menyiapkan kuis…';

  @override
  String get tabQuran => 'Al-Qur\'an';

  @override
  String get tabDua => 'Doa';

  @override
  String get specialSurahs => 'Dianjurkan dibaca';

  @override
  String get chipMulk => 'Al-Mulk';

  @override
  String get chipMulkWhen => 'Sebelum tidur';

  @override
  String get chipSajdah => 'As-Sajdah';

  @override
  String get chipKahf => 'Al-Kahf';

  @override
  String get chipKahfWhen => 'Jumat';

  @override
  String get chipKursi => 'Ayat Kursi';

  @override
  String get chipKursiWhen => 'Setelah salat & tidur';

  @override
  String get chipBaqarahEnd => '2 ayat terakhir Al-Baqarah';

  @override
  String get chipNight => 'Malam hari';

  @override
  String get chipYasin => 'Yasin';

  @override
  String get chipQuls => '3 Qul';

  @override
  String get chipQulsWhen => 'Pagi & petang';

  @override
  String get chipAnytime => 'Kapan saja';

  @override
  String get chipToday => 'Hari ini';

  @override
  String get chipTonight => 'Malam ini';

  @override
  String get revealedMakkah => 'Turun di Makkah';

  @override
  String get revealedMadinah => 'Turun di Madinah';

  @override
  String get reciter => 'Qari';

  @override
  String get chooseReciter => 'Pilih qari';

  @override
  String get playAyah => 'Putar dari ayat ini';

  @override
  String recitingAyah(String n, String total) {
    return 'Ayat $n dari $total';
  }

  @override
  String get audioError => 'Tidak dapat memuat murotal. Periksa internet Anda.';

  @override
  String get dailyQuran => 'Al-Qur\'an Harian';

  @override
  String get energy0 => 'Hatimu menanti cahaya hari ini';

  @override
  String get energy1 => 'Mengisi… beberapa ayat lagi';

  @override
  String get energy2 => 'Hampir penuh — teruskan!';

  @override
  String get energy3 => 'Penuh cahaya — MasyaAllah!';

  @override
  String get energy4 => 'Bersinar terang hari ini ✨';

  @override
  String versesToday(String n, String goal) {
    return '$n / $goal ayat hari ini';
  }

  @override
  String streakDays(String n) {
    return '$n hari berturut-turut';
  }

  @override
  String get readNow => 'Baca sekarang';

  @override
  String get keepReading => 'Baca lagi';

  @override
  String get achievements => 'Pencapaian';

  @override
  String achievementsCount(String n, String total) {
    return '$n dari $total diraih';
  }

  @override
  String achievementEarned(String date) {
    return 'Diraih pada $date';
  }

  @override
  String achievementLocked(String done, String target) {
    return 'Dalam proses · $done/$target';
  }

  @override
  String achievementUnlocked(String name) {
    return 'Pencapaian terbuka: $name';
  }

  @override
  String get ach_bismillah => 'Bismillah';

  @override
  String get ach_bismillah_desc => 'Baca ayat pertama Anda';

  @override
  String get ach_fatiha => 'Pembuka';

  @override
  String get ach_fatiha_desc => 'Selesaikan Surah Al-Fatihah';

  @override
  String get ach_quls => 'Tiga Qul';

  @override
  String get ach_quls_desc => 'Selesaikan Al-Ikhlas, Al-Falaq, dan An-Nas';

  @override
  String get ach_streak3 => 'Langkah Mantap';

  @override
  String get ach_streak3_desc => 'Baca Al-Qur\'an 3 hari berturut-turut';

  @override
  String get ach_streak7 => 'Sepekan Cahaya';

  @override
  String get ach_streak7_desc => 'Baca Al-Qur\'an 7 hari berturut-turut';

  @override
  String get ach_streak30 => 'Sebulan Cahaya';

  @override
  String get ach_streak30_desc => 'Baca Al-Qur\'an 30 hari berturut-turut';

  @override
  String get ach_verses100 => 'Seratus Ayat';

  @override
  String get ach_verses100_desc => 'Baca 100 ayat';

  @override
  String get ach_verses1000 => 'Seribu Ayat';

  @override
  String get ach_verses1000_desc => 'Baca 1.000 ayat';

  @override
  String get ach_kahf => 'Cahaya Jumat';

  @override
  String get ach_kahf_desc => 'Selesaikan Al-Kahf pada hari Jumat';

  @override
  String get ach_mulk => 'Penjaga Malam';

  @override
  String get ach_mulk_desc => 'Selesaikan Al-Mulk pada malam hari';

  @override
  String get ach_yasin => 'Yasin';

  @override
  String get ach_yasin_desc => 'Selesaikan Surah Yasin';

  @override
  String get ach_listener => 'Pendengar Setia';

  @override
  String get ach_listener_desc => 'Dengarkan murotal satu surah penuh';

  @override
  String get ach_quiz100 => 'Cerdas';

  @override
  String get ach_quiz100_desc => 'Raih 100% dalam kuis tahap';

  @override
  String get ach_juzamma => 'Juz \'Amma';

  @override
  String get ach_juzamma_desc => 'Selesaikan 37 surah juz ke-30';

  @override
  String get ach_phases10 => 'Sepuluh Tahap';

  @override
  String get ach_phases10_desc => 'Selesaikan 10 tahap perjalanan';

  @override
  String get ach_khatm => 'Khatam Al-Qur\'an';

  @override
  String get ach_khatm_desc => 'Selesaikan semua 114 surah';

  @override
  String get duaHeader => 'Sehari bersama zikir kepada Allah';

  @override
  String get duaSub =>
      'Dari bangun hingga tidur — doa-doa yang diajarkan Nabi ﷺ untuk setiap saat.';

  @override
  String repeatTimes(String n) {
    return 'Baca $n×';
  }

  @override
  String duaSource(String n) {
    return 'Hisnul Muslim #$n';
  }

  @override
  String get duaCredit =>
      'Doa dari Hisnul Muslim (Benteng Muslim) karya Sa\'id bin Ali al-Qahthani, melalui situs resminya hisnmuslim.com. Terjemahan dalam bahasa Inggris.';

  @override
  String get nowLabel => 'Sekarang';

  @override
  String get scene_wake => 'Bangun tidur';

  @override
  String get scene_wake_story =>
      'Hari dimulai dengan syukur — Allah mengembalikan ruh setelah tidur.';

  @override
  String get scene_restroom => 'Kamar kecil';

  @override
  String get scene_restroom_story =>
      'Rutinitas terkecil pun dimulai dengan memohon perlindungan Allah.';

  @override
  String get scene_wudu => 'Wudu';

  @override
  String get scene_wudu_story =>
      'Air di tangan, nama-Nya di lisan — bersiap berdiri di hadapan Allah.';

  @override
  String get scene_dress => 'Berpakaian';

  @override
  String get scene_dress_story =>
      'Setiap pakaian adalah karunia — bersyukurlah kepada Yang memberi pakaian.';

  @override
  String get scene_athan => 'Azan';

  @override
  String get scene_athan_story =>
      'Seruan berkumandang di lingkungan — jawablah, lalu mohonkan untuk Nabi ﷺ.';

  @override
  String get scene_masjid => 'Ke masjid';

  @override
  String get scene_masjid_story =>
      'Setiap langkah menuju masjid adalah cahaya — masuk dan keluar dengan doa.';

  @override
  String get scene_after_salah => 'Setelah salat';

  @override
  String get scene_after_salah_story =>
      'Sebelum bergegas, duduklah sejenak dengan zikir setelah salat.';

  @override
  String get scene_morning => 'Zikir pagi';

  @override
  String get scene_morning_story => 'Kalimat yang menjagamu hingga petang.';

  @override
  String get scene_eating => 'Sarapan';

  @override
  String get scene_eating_story =>
      'Mulai dengan nama-Nya, akhiri dengan pujian kepada-Nya.';

  @override
  String get scene_leave_home => 'Keluar rumah';

  @override
  String get scene_leave_home_story =>
      'Di pintu, serahkan harimu kepada Allah.';

  @override
  String get scene_travel => 'Di perjalanan';

  @override
  String get scene_travel_story =>
      'Bus, becak, atau mobil — Allahu Akbar saat naik, Subhanallah saat turun.';

  @override
  String get scene_meeting => 'Bertemu orang';

  @override
  String get scene_meeting_story =>
      'Sebarkan salam dan jawab bersin saudaramu.';

  @override
  String get scene_good_news => 'Saat mendapat kebaikan';

  @override
  String get scene_good_news_story =>
      'Kegembiraan mengingatkan pada Sang Pemberi — pujilah Dia, dan berterima kasihlah kepada orang-orang.';

  @override
  String get scene_hardship => 'Saat sulit';

  @override
  String get scene_hardship_story =>
      'Cemas, kesulitan, atau rencana yang gagal — kembalilah kepada-Nya terlebih dahulu.';

  @override
  String get scene_patience => 'Musibah dan sabar';

  @override
  String get scene_patience_story =>
      'Saat sesuatu diambil, ingatlah bahwa kita milik Allah.';

  @override
  String get scene_anger => 'Menahan marah';

  @override
  String get scene_anger_story =>
      'Berlindunglah sebelum mengucapkan kata yang mungkin kau sesali.';

  @override
  String get scene_pain => 'Sakit dan nyeri';

  @override
  String get scene_pain_story =>
      'Untuk sakitmu sendiri, dan untuk teman yang kau jenguk.';

  @override
  String get scene_rain => 'Saat hujan';

  @override
  String get scene_rain_story =>
      'Hujan adalah rahmat — mohonlah agar bermanfaat.';

  @override
  String get scene_home => 'Pulang ke rumah';

  @override
  String get scene_home_story =>
      'Masuklah dengan nama-Nya dan ucapkan salam kepada keluarga.';

  @override
  String get scene_gathering => 'Meninggalkan majelis';

  @override
  String get scene_gathering_story =>
      'Sebelum berdiri, hapus kekhilafan lisan.';

  @override
  String get scene_forgiveness => 'Memohon ampun';

  @override
  String get scene_forgiveness_story =>
      'Kesalahan hari ini dibasuh dengan istigfar.';

  @override
  String get scene_sleep => 'Sebelum tidur';

  @override
  String get scene_sleep_story =>
      'Akhiri hari seperti saat memulainya — dengan nama-Nya, dalam lindungan-Nya.';

  @override
  String get scene_night => 'Di malam hari';

  @override
  String get scene_night_story =>
      'Jika terbangun atau bermimpi buruk, Dia dekat.';

  @override
  String get part_dawn => 'Subuh';

  @override
  String get part_morning => 'Pagi';

  @override
  String get part_day => 'Siang';

  @override
  String get part_evening => 'Petang';

  @override
  String get part_night => 'Malam';

  @override
  String get removeSession => 'Hapus';

  @override
  String addSession(String session) {
    return 'Tambah $session';
  }

  @override
  String get duaSearchHint => 'Cari doa';

  @override
  String duaPartCount(String topics, String duas) {
    return '$topics topik · $duas doa';
  }

  @override
  String duaNoResults(String q) {
    return 'Tidak ada doa untuk “$q”';
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
      other: '$nString doa ditemukan',
      one: '1 doa ditemukan',
    );
    return '$_temp0';
  }

  @override
  String get part_dawn_sub => 'Bangun, wudu, dan Subuh';

  @override
  String get part_morning_sub => 'Zikir, makan, dan keluar rumah';

  @override
  String get part_day_sub => 'Orang, kegembiraan, dan ujian';

  @override
  String get part_evening_sub => 'Rumah, majelis, istigfar';

  @override
  String get part_night_sub => 'Tidur dan malam';

  @override
  String duaCount(int n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString doa',
      one: '1 doa',
    );
    return '$_temp0';
  }

  @override
  String get noticeSearchHint => 'Cari pengumuman, masjid…';

  @override
  String get noticesSub => 'Dari masjid di sekitar Anda';

  @override
  String get tabNotices => 'Pengumuman';

  @override
  String get chooseSurah => 'Ke surah';

  @override
  String get surahSearchHint => 'Cari surah berdasarkan nama atau nomor';

  @override
  String get previousSurah => 'Surah sebelumnya';

  @override
  String get pickOnMapTitle => 'Pilih di peta';

  @override
  String get mapSearchHint => 'Cari masjid atau daerah';

  @override
  String get useMyLocation => 'Lokasi saya';

  @override
  String get mapPickHint =>
      'Geser peta hingga pin tepat di masjid, ketuk sebuah titik, atau ketuk ikon masjid.';

  @override
  String get mapMoving => 'Mencari tempat…';

  @override
  String get useThisLocation => 'Gunakan lokasi ini';

  @override
  String get masjidLocation => 'Lokasi masjid';

  @override
  String get chooseLocationWay =>
      'Pilih satu cara untuk menentukan lokasi yang tepat:';

  @override
  String get atTheMasjid => 'Saya di masjid';

  @override
  String get atTheMasjidBody =>
      'Gunakan GPS ponsel. Tetap di dalam masjid selama memuat.';

  @override
  String get onTheMap => 'Pilih di peta';

  @override
  String get onTheMapBody =>
      'Tunjuk masjid di peta, atau ketuk masjid yang sudah tampil.';

  @override
  String get locFromMap => 'Dipilih di peta';

  @override
  String get locFromGps => 'GPS';

  @override
  String get locSaved => 'Lokasi tersimpan';

  @override
  String get useGpsInstead => 'Gunakan GPS';

  @override
  String get adjustOnMap => 'Sesuaikan di peta';

  @override
  String get allMasjids => 'Semua Masjid';

  @override
  String get nearestFirst => 'Terdekat dulu';

  @override
  String get duaForNow => 'Doa untuk saat ini';

  @override
  String get tabChannel => 'Kanal';

  @override
  String get channelInviteTitle => 'Tetap dekat dengan Imam & Khatib Anda';

  @override
  String get channelInviteHadith =>
      '“Menuntut ilmu wajib bagi setiap Muslim.” — Sunan Ibnu Majah 224';

  @override
  String get channelInviteBody =>
      'Setiap Muslim wajib mempelajari ilmu fardu ain — dasar-dasar iman, bersuci, salat, dan kehidupan sehari-hari — dan cara terbaik adalah di bawah bimbingan seorang alim. Bergabunglah dengan kanal masjid ini untuk menerima bimbingan dan pesan dari Imam dan Khatibnya, serta semakin dekat dengan masjid di lingkungan Anda.';

  @override
  String get joinChannel => 'Gabung kanal';

  @override
  String get openChannel => 'Buka kanal';

  @override
  String get joinedChannel => 'Anda tergabung di kanal masjid ini';

  @override
  String get channelJoined =>
      'Bergabung. Anda akan menerima pesan dari Imam dan Khatib.';

  @override
  String get leaveChannel => 'Keluar dari kanal';

  @override
  String get leaveChannelQ =>
      'Keluar dari kanal ini? Anda tidak akan menerima pesannya lagi.';

  @override
  String get leave => 'Keluar';

  @override
  String get channelEmpty => 'Belum ada pesan.';

  @override
  String get channelEmptyAdmin => 'Kirim pesan pertama kepada anggota Anda.';

  @override
  String get channelReadOnly =>
      'Hanya Imam, Khatib, dan admin kanal yang mengirim pesan di sini.';

  @override
  String get messageHint => 'Tulis pesan…';

  @override
  String get send => 'Kirim';

  @override
  String get deleteMessageQ => 'Hapus pesan ini untuk semua orang?';

  @override
  String get members => 'Anggota';

  @override
  String get noMembers =>
      'Belum ada yang bergabung. Undang jamaah masjid Anda.';

  @override
  String get roleMember => 'Anggota';

  @override
  String get roleEditor => 'Editor';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMemberDesc => 'Membaca pesan';

  @override
  String get roleEditorDesc => 'Dapat mengirim pesan';

  @override
  String get roleAdminDesc => 'Mengirim pesan dan mengelola anggota';

  @override
  String get removeMember => 'Keluarkan dari kanal';

  @override
  String get you => 'Anda';

  @override
  String get channelMessages => 'Pesan kanal';

  @override
  String get noticesHeading => 'Pengumuman';

  @override
  String get signInToJoin => 'Masuk untuk bergabung dengan kanal.';

  @override
  String get monthNames =>
      'Januari,Februari,Maret,April,Mei,Juni,Juli,Agustus,September,Oktober,November,Desember';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String jamatReminderBody(String prayer, String minutes) {
    return 'Jamaah $prayer dalam $minutes menit';
  }
}
