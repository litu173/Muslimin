/// The dhikr the Prophet ﷺ kept, in two groups:
///
///  * after every salah ([Dhikr.afterSalah]) – the adhkar said after each
///    of the five salah, each with its own count, listed one by one;
///  * daily targets – a count for the whole day, split evenly over the
///    five salah so the day's sunnah is done a little at a time.
///
/// Bangla and English text are written here; other languages show English
/// (Arabic shows only the dhikr itself), the same as the duas. Quran text
/// (Ayat al-Kursi, the three Quls) is quran.com's Uthmani text.
class Dhikr {
  const Dhikr({
    required this.id,
    required this.ar,
    required this.tr,
    required this.nameEn,
    required this.nameBn,
    required this.en,
    required this.bn,
    required this.virtueEn,
    required this.virtueBn,
    required this.refEn,
    required this.refBn,
    required this.perSalah,
    required this.hisn,
    required this.clip,
    this.afterSalah = false,
  });

  final String id;
  final String ar;

  /// Transliteration.
  final String tr;
  final String nameEn;
  final String nameBn;

  /// Meaning.
  final String en;
  final String bn;
  final String virtueEn;
  final String virtueBn;
  final String refEn;
  final String refBn;

  /// Times after each salah.
  final int perSalah;

  /// Said after every salah (not a day's count split up): each salah is
  /// checked off on its own, never all at once.
  final bool afterSalah;

  /// Its number in Hisn al-Muslim, whose recitation the audio comes from.
  final int hisn;

  /// Just this dhikr's words, cut from Hisn al-Muslim's recitation
  /// (hisnmuslim.com) by tool/build_dhikr_audio.py – no narration.
  final String clip;

  String get audio => 'assets/dhikr/$clip.m4a';

  /// Times a day.
  int get perDay => perSalah * kPortions;
}

/// One portion after each of the five daily salah.
const kPortions = 5;

const kDhikrs = <Dhikr>[
  Dhikr(
    id: "salah_istighfar",
    afterSalah: true,
    ar: "أَسْتَغْفِرُ اللَّهَ",
    tr: "Astaghfirullah",
    nameEn: "Astaghfirullah",
    nameBn: "আস্তাগফিরুল্লাহ",
    en: "I seek Allah’s forgiveness.",
    bn: "আমি আল্লাহর কাছে ক্ষমা চাই।",
    virtueEn: "When the Messenger of Allah ﷺ finished his salah, he would seek Allah’s forgiveness three times and then say: “Allahumma antas-salam wa minkas-salam, tabarakta ya dhal-jalali wal-ikram.”",
    virtueBn: "রাসূলুল্লাহ ﷺ সালাত শেষ করে তিনবার ইস্তিগফার করতেন, তারপর বলতেন: “আল্লাহুম্মা আনতাস সালাম ওয়া মিনকাস সালাম, তাবারাকতা ইয়া যাল জালালি ওয়াল ইকরাম।”",
    refEn: "Sahih Muslim 591",
    refBn: "সহীহ মুসলিম ৫৯১",
    perSalah: 3,
    hisn: 66,
    clip: 'salah_istighfar',
  ),
  Dhikr(
    id: "salah_antas_salam",
    afterSalah: true,
    ar: "اللَّهُمَّ أَنْتَ السَّلَامُ، وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ",
    tr: "Allahumma antas-salam wa minkas-salam, tabarakta ya dhal-jalali wal-ikram",
    nameEn: "Allahumma antas-salam",
    nameBn: "আল্লাহুম্মা আনতাস সালাম",
    en: "O Allah, You are Peace and from You comes peace. Blessed are You, O Possessor of majesty and honour.",
    bn: "হে আল্লাহ! আপনিই শান্তি, আপনার কাছ থেকেই শান্তি। আপনি বরকতময়, হে মহিমা ও সম্মানের অধিকারী।",
    virtueEn: "When the Messenger of Allah ﷺ finished his salah, he would seek Allah’s forgiveness three times and then say: “Allahumma antas-salam wa minkas-salam, tabarakta ya dhal-jalali wal-ikram.”",
    virtueBn: "রাসূলুল্লাহ ﷺ সালাত শেষ করে তিনবার ইস্তিগফার করতেন, তারপর বলতেন: “আল্লাহুম্মা আনতাস সালাম ওয়া মিনকাস সালাম, তাবারাকতা ইয়া যাল জালালি ওয়াল ইকরাম।”",
    refEn: "Sahih Muslim 591, 592",
    refBn: "সহীহ মুসলিম ৫৯১, ৫৯২",
    perSalah: 1,
    hisn: 66,
    clip: 'salah_antas_salam',
  ),
  Dhikr(
    id: "salah_la_mania",
    afterSalah: true,
    ar: "لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ، اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ",
    tr: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa ʿala kulli shayʾin qadir. Allahumma la maniʿa lima aʿtayta, wa la muʿtiya lima manaʿta, wa la yanfaʿu dhal-jaddi minkal-jadd",
    nameEn: "Allahumma la maniʿa lima aʿtayta",
    nameBn: "আল্লাহুম্মা লা মানি‘আ লিমা আ‘তাইতা",
    en: "None has the right to be worshipped but Allah alone, without partner. His is the dominion and His is the praise, and He is able to do all things. O Allah, none can withhold what You give, none can give what You withhold, and the wealth of the wealthy cannot avail him against You.",
    bn: "আল্লাহ ছাড়া কোনো সত্য ইলাহ নেই, তিনি এক, তাঁর কোনো শরীক নেই। রাজত্ব তাঁরই এবং প্রশংসাও তাঁরই, আর তিনি সব কিছুর উপর ক্ষমতাবান। হে আল্লাহ! আপনি যা দেন তা ঠেকানোর কেউ নেই, আপনি যা আটকে রাখেন তা দেওয়ার কেউ নেই, আর কোনো সম্পদশালীর সম্পদ আপনার কাছে তার কোনো উপকারে আসে না।",
    virtueEn: "Al-Mughirah ibn Shuʿbah wrote that the Prophet ﷺ used to say this at the end of every obligatory salah.",
    virtueBn: "মুগীরা ইবনু শু‘বা রা. লিখে জানান যে, নবী ﷺ প্রত্যেক ফরজ সালাতের শেষে এটি বলতেন।",
    refEn: "Sahih al-Bukhari 844 · Sahih Muslim 593",
    refBn: "সহীহ বুখারী ৮৪৪ · সহীহ মুসলিম ৫৯৩",
    perSalah: 1,
    hisn: 67,
    clip: 'salah_la_mania',
  ),
  Dhikr(
    id: "salah_la_hawla",
    afterSalah: true,
    ar: "لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ، لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ، لَا إِلَٰهَ إِلَّا اللَّهُ، وَلَا نَعْبُدُ إِلَّا إِيَّاهُ، لَهُ النِّعْمَةُ وَلَهُ الْفَضْلُ وَلَهُ الثَّنَاءُ الْحَسَنُ، لَا إِلَٰهَ إِلَّا اللَّهُ مُخْلِصِينَ لَهُ الدِّينَ وَلَوْ كَرِهَ الْكَافِرُونَ",
    tr: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa ʿala kulli shayʾin qadir. La hawla wa la quwwata illa billah. La ilaha illallah, wa la naʿbudu illa iyyah. Lahun-niʿmatu wa lahul-fadlu wa lahuth-thanaʾul-hasan. La ilaha illallahu mukhlisina lahud-din wa law karihal-kafirun",
    nameEn: "La hawla wa la quwwata illa billah",
    nameBn: "লা হাওলা ওয়া লা কুওয়াতা ইল্লা বিল্লাহ",
    en: "None has the right to be worshipped but Allah alone, without partner. His is the dominion and His is the praise, and He is able to do all things. There is no might and no power except with Allah. None has the right to be worshipped but Allah, and we worship none but Him. His is the blessing, His the bounty and His the beautiful praise. None has the right to be worshipped but Allah; we make our religion sincerely His, even if the disbelievers dislike it.",
    bn: "আল্লাহ ছাড়া কোনো সত্য ইলাহ নেই, তিনি এক, তাঁর কোনো শরীক নেই। রাজত্ব তাঁরই এবং প্রশংসাও তাঁরই, আর তিনি সব কিছুর উপর ক্ষমতাবান। আল্লাহর সাহায্য ছাড়া কোনো শক্তি ও সামর্থ্য নেই। আল্লাহ ছাড়া কোনো সত্য ইলাহ নেই, আর আমরা শুধু তাঁরই ইবাদত করি। নিয়ামত তাঁরই, অনুগ্রহ তাঁরই, উত্তম প্রশংসাও তাঁরই। আল্লাহ ছাড়া কোনো সত্য ইলাহ নেই; আমরা দ্বীনকে একনিষ্ঠভাবে তাঁরই জন্য করি, যদিও কাফিররা তা অপছন্দ করে।",
    virtueEn: "ʿAbdullah ibn az-Zubayr said that the Messenger of Allah ﷺ would proclaim this after every salah.",
    virtueBn: "আবদুল্লাহ ইবনুয যুবাইর রা. বলেন, রাসূলুল্লাহ ﷺ প্রত্যেক সালাতের পর এটি বলতেন।",
    refEn: "Sahih Muslim 594",
    refBn: "সহীহ মুসলিম ৫৯৪",
    perSalah: 1,
    hisn: 68,
    clip: 'salah_la_hawla',
  ),
  Dhikr(
    id: "salah_subhanallah",
    afterSalah: true,
    ar: "سُبْحَانَ اللَّهِ",
    tr: "SubhanAllah",
    nameEn: "SubhanAllah",
    nameBn: "সুবহানাল্লাহ",
    en: "Glory be to Allah.",
    bn: "আল্লাহ পবিত্র।",
    virtueEn: "Whoever after every salah glorifies Allah 33 times, praises Him 33 times and declares His greatness 33 times – ninety-nine – and completes the hundred with “La ilaha illallahu wahdahu la sharika lah…”, his sins are forgiven even if they are like the foam of the sea.",
    virtueBn: "যে ব্যক্তি প্রত্যেক সালাতের পর ৩৩ বার সুবহানাল্লাহ, ৩৩ বার আলহামদুলিল্লাহ ও ৩৩ বার আল্লাহু আকবার বলে — মোট নিরানব্বই — এবং “লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারীকা লাহু…” বলে একশত পূর্ণ করে, তার গুনাহ সমুদ্রের ফেনার সমান হলেও ক্ষমা করে দেওয়া হয়।",
    refEn: "Sahih Muslim 597",
    refBn: "সহীহ মুসলিম ৫৯৭",
    perSalah: 33,
    hisn: 69,
    clip: 'salah_subhanallah',
  ),
  Dhikr(
    id: "salah_alhamdulillah",
    afterSalah: true,
    ar: "الْحَمْدُ لِلَّهِ",
    tr: "Alhamdulillah",
    nameEn: "Alhamdulillah",
    nameBn: "আলহামদুলিল্লাহ",
    en: "All praise is for Allah.",
    bn: "সকল প্রশংসা আল্লাহর।",
    virtueEn: "Whoever after every salah glorifies Allah 33 times, praises Him 33 times and declares His greatness 33 times – ninety-nine – and completes the hundred with “La ilaha illallahu wahdahu la sharika lah…”, his sins are forgiven even if they are like the foam of the sea.",
    virtueBn: "যে ব্যক্তি প্রত্যেক সালাতের পর ৩৩ বার সুবহানাল্লাহ, ৩৩ বার আলহামদুলিল্লাহ ও ৩৩ বার আল্লাহু আকবার বলে — মোট নিরানব্বই — এবং “লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারীকা লাহু…” বলে একশত পূর্ণ করে, তার গুনাহ সমুদ্রের ফেনার সমান হলেও ক্ষমা করে দেওয়া হয়।",
    refEn: "Sahih Muslim 597",
    refBn: "সহীহ মুসলিম ৫৯৭",
    perSalah: 33,
    hisn: 69,
    clip: 'salah_alhamdulillah',
  ),
  Dhikr(
    id: "salah_allahu_akbar",
    afterSalah: true,
    ar: "اللَّهُ أَكْبَرُ",
    tr: "Allahu Akbar",
    nameEn: "Allahu Akbar",
    nameBn: "আল্লাহু আকবার",
    en: "Allah is the Greatest.",
    bn: "আল্লাহ সবচেয়ে মহান।",
    virtueEn: "Whoever after every salah glorifies Allah 33 times, praises Him 33 times and declares His greatness 33 times – ninety-nine – and completes the hundred with “La ilaha illallahu wahdahu la sharika lah…”, his sins are forgiven even if they are like the foam of the sea.",
    virtueBn: "যে ব্যক্তি প্রত্যেক সালাতের পর ৩৩ বার সুবহানাল্লাহ, ৩৩ বার আলহামদুলিল্লাহ ও ৩৩ বার আল্লাহু আকবার বলে — মোট নিরানব্বই — এবং “লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারীকা লাহু…” বলে একশত পূর্ণ করে, তার গুনাহ সমুদ্রের ফেনার সমান হলেও ক্ষমা করে দেওয়া হয়।",
    refEn: "Sahih Muslim 597",
    refBn: "সহীহ মুসলিম ৫৯৭",
    perSalah: 33,
    hisn: 69,
    clip: 'salah_allahu_akbar',
  ),
  Dhikr(
    id: "salah_tahlil",
    afterSalah: true,
    ar: "لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ",
    tr: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa ʿala kulli shayʾin qadir",
    nameEn: "La ilaha illallahu wahdahu",
    nameBn: "লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু",
    en: "None has the right to be worshipped but Allah alone, without partner. His is the dominion and His is the praise, and He is able to do all things.",
    bn: "আল্লাহ ছাড়া কোনো সত্য ইলাহ নেই, তিনি এক, তাঁর কোনো শরীক নেই। রাজত্ব তাঁরই এবং প্রশংসাও তাঁরই, আর তিনি সব কিছুর উপর ক্ষমতাবান।",
    virtueEn: "Whoever after every salah glorifies Allah 33 times, praises Him 33 times and declares His greatness 33 times – ninety-nine – and completes the hundred with “La ilaha illallahu wahdahu la sharika lah…”, his sins are forgiven even if they are like the foam of the sea.",
    virtueBn: "যে ব্যক্তি প্রত্যেক সালাতের পর ৩৩ বার সুবহানাল্লাহ, ৩৩ বার আলহামদুলিল্লাহ ও ৩৩ বার আল্লাহু আকবার বলে — মোট নিরানব্বই — এবং “লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারীকা লাহু…” বলে একশত পূর্ণ করে, তার গুনাহ সমুদ্রের ফেনার সমান হলেও ক্ষমা করে দেওয়া হয়।",
    refEn: "Sahih Muslim 597",
    refBn: "সহীহ মুসলিম ৫৯৭",
    perSalah: 1,
    hisn: 69,
    clip: 'salah_tahlil',
  ),
  Dhikr(
    id: "salah_quls",
    afterSalah: true,
    ar: "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ\nقُلْ هُوَ ٱللَّهُ أَحَدٌ ۝ ٱللَّهُ ٱلصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُۥ كُفُوًا أَحَدٌۢ\nبِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ ۝ مِن شَرِّ مَا خَلَقَ ۝ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِن شَرِّ ٱلنَّفَّـٰثَـٰتِ فِى ٱلْعُقَدِ ۝ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\nبِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ\nقُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ ۝ مَلِكِ ٱلنَّاسِ ۝ إِلَـٰهِ ٱلنَّاسِ ۝ مِن شَرِّ ٱلْوَسْوَاسِ ٱلْخَنَّاسِ ۝ ٱلَّذِى يُوَسْوِسُ فِى صُدُورِ ٱلنَّاسِ ۝ مِنَ ٱلْجِنَّةِ وَٱلنَّاسِ",
    tr: "Bismillahir-rahmanir-rahim. Qul huwallahu ahad… (Al-Ikhlas) · Bismillahir-rahmanir-rahim. Qul aʿudhu bi rabbil-falaq… (Al-Falaq) · Bismillahir-rahmanir-rahim. Qul aʿudhu bi rabbin-nas… (An-Nas)",
    nameEn: "Al-Ikhlas, Al-Falaq, An-Nas",
    nameBn: "সূরা ইখলাস, ফালাক ও নাস",
    en: "In the name of Allah, the Most Gracious, the Most Merciful. Say: He is Allah, the One. Allah, the Eternal Refuge. He neither begets nor is born, and none is comparable to Him. — In the name of Allah, the Most Gracious, the Most Merciful. Say: I seek refuge in the Lord of daybreak, from the evil of what He created, from the evil of darkness when it settles, from the evil of those who blow on knots, and from the evil of an envier when he envies. — In the name of Allah, the Most Gracious, the Most Merciful. Say: I seek refuge in the Lord of mankind, the King of mankind, the God of mankind, from the evil of the retreating whisperer, who whispers in the hearts of mankind, from among the jinn and mankind.",
    bn: "পরম করুণাময় অসীম দয়ালু আল্লাহর নামে। বলুন, তিনি আল্লাহ, এক। আল্লাহ অমুখাপেক্ষী। তিনি কাউকে জন্ম দেননি, তাঁকেও জন্ম দেওয়া হয়নি, আর তাঁর সমতুল্য কেউ নেই। — পরম করুণাময় অসীম দয়ালু আল্লাহর নামে। বলুন, আমি আশ্রয় চাই ভোরের রবের কাছে, তিনি যা সৃষ্টি করেছেন তার অনিষ্ট থেকে, অন্ধকার রাতের অনিষ্ট থেকে যখন তা ছেয়ে যায়, গিরায় ফুঁক দেওয়া নারীদের অনিষ্ট থেকে, আর হিংসুকের অনিষ্ট থেকে যখন সে হিংসা করে। — পরম করুণাময় অসীম দয়ালু আল্লাহর নামে। বলুন, আমি আশ্রয় চাই মানুষের রবের কাছে, মানুষের অধিপতির কাছে, মানুষের ইলাহের কাছে, আত্মগোপনকারী কুমন্ত্রণাদাতার অনিষ্ট থেকে, যে মানুষের অন্তরে কুমন্ত্রণা দেয়, জিন ও মানুষের মধ্য থেকে।",
    virtueEn: "ʿUqbah ibn ʿAmir said: The Messenger of Allah ﷺ commanded me to recite the Muʿawwidhat after every salah.",
    virtueBn: "উকবা ইবনু আমির রা. বলেন: রাসূলুল্লাহ ﷺ আমাকে প্রত্যেক সালাতের পর মু‘আওয়িযাত (সূরা ইখলাস, ফালাক ও নাস) পড়তে আদেশ করেছেন।",
    refEn: "Abu Dawud 1523 · at-Tirmidhi 2903 · an-Nasaʾi 1336",
    refBn: "আবু দাউদ ১৫২৩ · তিরমিযী ২৯০৩ · নাসাঈ ১৩৩৬",
    perSalah: 1,
    hisn: 70,
    clip: 'salah_quls',
  ),
  Dhikr(
    id: "salah_ayatul_kursi",
    afterSalah: true,
    ar: "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ\nٱللَّهُ لَآ إِلَـٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ ۚ لَا تَأْخُذُهُۥ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُۥ مَا فِى ٱلسَّمَـٰوَٰتِ وَمَا فِى ٱلْأَرْضِ ۗ مَن ذَا ٱلَّذِى يَشْفَعُ عِندَهُۥٓ إِلَّا بِإِذْنِهِۦ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَىْءٍ مِّنْ عِلْمِهِۦٓ إِلَّا بِمَا شَآءَ ۚ وَسِعَ كُرْسِيُّهُ ٱلسَّمَـٰوَٰتِ وَٱلْأَرْضَ ۖ وَلَا يَـُٔودُهُۥ حِفْظُهُمَا ۚ وَهُوَ ٱلْعَلِىُّ ٱلْعَظِيمُ",
    tr: "Bismillahir-rahmanir-rahim. Allahu la ilaha illa huwal-hayyul-qayyum, la taʾkhudhuhu sinatun wa la nawm, lahu ma fis-samawati wa ma fil-ard, man dhal-ladhi yashfaʿu ʿindahu illa bi-idhnih, yaʿlamu ma bayna aydihim wa ma khalfahum, wa la yuhituna bi-shayʾin min ʿilmihi illa bima shaʾ, wasiʿa kursiyyuhus-samawati wal-ard, wa la yaʾuduhu hifzuhuma, wa huwal-ʿaliyyul-ʿazim",
    nameEn: "Ayat al-Kursi",
    nameBn: "আয়াতুল কুরসি",
    en: "In the name of Allah, the Most Gracious, the Most Merciful. Allah – none has the right to be worshipped but Him, the Ever-Living, the Sustainer of all. Neither drowsiness nor sleep overtakes Him. His is whatever is in the heavens and the earth. Who can intercede with Him except by His leave? He knows what is before them and what is behind them, and they grasp nothing of His knowledge except what He wills. His Kursi extends over the heavens and the earth, and guarding them does not tire Him. He is the Most High, the Most Great.",
    bn: "পরম করুণাময় অসীম দয়ালু আল্লাহর নামে। আল্লাহ, তিনি ছাড়া কোনো সত্য ইলাহ নেই, তিনি চিরঞ্জীব, সব কিছুর ধারক। তন্দ্রা ও নিদ্রা তাঁকে স্পর্শ করে না। আসমান ও জমিনে যা কিছু আছে সব তাঁরই। কে আছে যে তাঁর অনুমতি ছাড়া তাঁর কাছে সুপারিশ করবে? তাদের সামনে ও পেছনে যা আছে তিনি জানেন, আর তিনি যা চান তা ছাড়া তাঁর জ্ঞানের কিছুই তারা আয়ত্ত করতে পারে না। তাঁর কুরসি আসমান ও জমিন পরিব্যাপ্ত, আর এ দুটির রক্ষণাবেক্ষণ তাঁকে ক্লান্ত করে না। তিনি সর্বোচ্চ, মহান।",
    virtueEn: "Whoever recites Ayat al-Kursi after every obligatory salah, nothing keeps him from entering Paradise except death.",
    virtueBn: "যে ব্যক্তি প্রত্যেক ফরজ সালাতের পর আয়াতুল কুরসি পড়বে, মৃত্যু ছাড়া তার জান্নাতে প্রবেশের পথে আর কোনো বাধা থাকবে না।",
    refEn: "an-Nasaʾi, as-Sunan al-Kubra 9928 · graded sahih by al-Albani (Sahih al-Jamiʿ 6464)",
    refBn:
        "নাসাঈ, আস-সুনানুল কুবরা ৯৯২৮ · আলবানী সহীহ বলেছেন (সহীহুল জামি‘ ৬৪৬৪)",
    perSalah: 1,
    hisn: 71,
    clip: 'salah_ayatul_kursi',
  ),
  Dhikr(
    id: "salah_ainni",
    afterSalah: true,
    ar: "اللَّهُمَّ أَعِنِّي عَلَىٰ ذِكْرِكَ، وَشُكْرِكَ، وَحُسْنِ عِبَادَتِكَ",
    tr: "Allahumma aʿinni ʿala dhikrika wa shukrika wa husni ʿibadatik",
    nameEn: "Allahumma aʿinni",
    nameBn: "আল্লাহুম্মা আ‘ইন্নি",
    en: "O Allah, help me to remember You, to thank You, and to worship You well.",
    bn: "হে আল্লাহ! আপনার জিকির, আপনার শুকরিয়া এবং সুন্দরভাবে আপনার ইবাদত করতে আমাকে সাহায্য করুন।",
    virtueEn: "The Prophet ﷺ took Muʿadh by the hand and said: “O Muʿadh, by Allah, I love you. Never leave saying at the end of every salah: …”",
    virtueBn: "নবী ﷺ মু‘আয রা.-এর হাত ধরে বললেন: “হে মু‘আয! আল্লাহর কসম, আমি তোমাকে ভালোবাসি। প্রত্যেক সালাতের শেষে এটি বলা কখনো ছেড়ো না।”",
    refEn: "Abu Dawud 1522 · an-Nasaʾi 1303",
    refBn: "আবু দাউদ ১৫২২ · নাসাঈ ১৩০৩",
    perSalah: 1,
    hisn: 59,
    clip: 'salah_ainni',
  ),
  Dhikr(
    id: 'subhanallah_bihamdihi',
    ar: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    tr: 'SubhanAllahi wa bihamdihi',
    nameEn: 'SubhanAllahi wa bihamdihi',
    nameBn: 'সুবহানাল্লাহি ওয়া বিহামদিহি',
    en: 'Glory be to Allah, and all praise is His.',
    bn: 'আল্লাহ পবিত্র এবং সকল প্রশংসা তাঁরই।',
    virtueEn:
        'Whoever says it a hundred times a day, his sins are wiped away even '
        'if they are like the foam of the sea.',
    virtueBn:
        'যে দিনে একশত বার এটি বলবে, তার গুনাহ সমুদ্রের ফেনার সমান হলেও মুছে '
        'দেওয়া হবে।',
    refEn: 'Sahih al-Bukhari 6405 · Sahih Muslim 2691',
    refBn: 'সহীহ বুখারী ৬৪০৫ · সহীহ মুসলিম ২৬৯১',
    perSalah: 20,
    hisn: 91,
    clip: 'subhanallahi_wa_bihamdihi',
  ),
  Dhikr(
    id: 'tahlil',
    ar:
        'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ '
        'وَلَهُ الْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
    tr:
        'La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa '
        'lahul-hamd, wa huwa ʿala kulli shayʾin qadir',
    nameEn: 'La ilaha illallah',
    nameBn: 'লা ইলাহা ইল্লাল্লাহ',
    en:
        'None has the right to be worshipped but Allah alone, without '
        'partner. His is the dominion and His is the praise, and He is able '
        'to do all things.',
    bn:
        'আল্লাহ ছাড়া কোনো সত্য ইলাহ নেই, তিনি এক, তাঁর কোনো শরীক নেই। '
        'রাজত্ব তাঁরই এবং প্রশংসাও তাঁরই, আর তিনি সব কিছুর উপর ক্ষমতাবান।',
    virtueEn:
        'Whoever says it a hundred times a day: it equals freeing ten '
        'slaves, a hundred good deeds are written for him, a hundred sins '
        'are wiped away, and it guards him from Shaytan that day until '
        'evening.',
    virtueBn:
        'যে দিনে একশত বার এটি বলবে, সে দশজন দাস মুক্ত করার সমান সওয়াব পাবে, '
        'তার জন্য একশত নেকি লেখা হবে, একশত গুনাহ মুছে দেওয়া হবে এবং সেদিন '
        'সন্ধ্যা পর্যন্ত সে শয়তান থেকে নিরাপদ থাকবে।',
    refEn: 'Sahih al-Bukhari 3293 · Sahih Muslim 2691',
    refBn: 'সহীহ বুখারী ৩২৯৩ · সহীহ মুসলিম ২৬৯১',
    perSalah: 20,
    hisn: 93,
    clip: 'tahlil_100',
  ),
  Dhikr(
    id: 'istighfar',
    ar: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
    tr: 'Astaghfirullaha wa atubu ilayh',
    nameEn: 'Istighfar',
    nameBn: 'ইস্তিগফার',
    en: 'I seek Allah’s forgiveness and turn to Him in repentance.',
    bn: 'আমি আল্লাহর কাছে ক্ষমা চাই এবং তাঁর দিকে ফিরে আসি।',
    virtueEn:
        'The Prophet ﷺ said: “O people, turn to Allah in repentance, for I '
        'turn to Him a hundred times a day.”',
    virtueBn:
        'রাসূলুল্লাহ ﷺ বলেছেন: “হে লোকসকল! তোমরা আল্লাহর কাছে তওবা করো, '
        'কেননা আমি দিনে একশত বার তাঁর কাছে তওবা করি।”',
    refEn: 'Sahih Muslim 2702 · Sahih al-Bukhari 6307',
    refBn: 'সহীহ মুসলিম ২৭০২ · সহীহ বুখারী ৬৩০৭',
    perSalah: 20,
    hisn: 96,
    clip: 'istighfar_100',
  ),
  Dhikr(
    id: 'subhanallah',
    ar: 'سُبْحَانَ اللَّهِ',
    tr: 'SubhanAllah',
    nameEn: 'SubhanAllah',
    nameBn: 'সুবহানাল্লাহ',
    en: 'Glory be to Allah.',
    bn: 'আল্লাহ পবিত্র।',
    virtueEn:
        '“Is any of you unable to earn a thousand good deeds each day? Let '
        'him glorify Allah a hundred times: a thousand good deeds are '
        'written for him, or a thousand sins are wiped away.”',
    virtueBn:
        '“তোমাদের কেউ কি প্রতিদিন এক হাজার নেকি অর্জন করতে অক্ষম? সে একশত '
        'বার সুবহানাল্লাহ বলুক; তার জন্য এক হাজার নেকি লেখা হবে অথবা এক '
        'হাজার গুনাহ মুছে দেওয়া হবে।”',
    refEn: 'Sahih Muslim 2698',
    refBn: 'সহীহ মুসলিম ২৬৯৮',
    perSalah: 20,
    hisn: 258,
    clip: 'salah_subhanallah',
  ),
];
