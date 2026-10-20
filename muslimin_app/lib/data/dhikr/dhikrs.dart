/// The daily dhikr the Prophet ﷺ kept, each with the count he gave for a
/// day. Every target splits evenly into five portions – one after each
/// salah – so the whole day's sunnah is done a little at a time.
///
/// Bangla and English text are written here; other languages show English
/// (Arabic shows only the dhikr itself), the same as the duas.
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
    required this.perDay,
    this.splitEn,
    this.splitBn,
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

  /// Times a day (the sunnah count).
  final int perDay;

  /// How one portion is said, when it is more than one phrase.
  final String? splitEn;
  final String? splitBn;

  /// Times after each salah.
  int get perSalah => perDay ~/ kPortions;
}

/// One portion after each of the five daily salah.
const kPortions = 5;

const kDhikrs = <Dhikr>[
  Dhikr(
    id: 'after_salah',
    ar:
        'سُبْحَانَ اللَّهِ (٣٣)\n'
        'الْحَمْدُ لِلَّهِ (٣٣)\n'
        'اللَّهُ أَكْبَرُ (٣٣)\n'
        'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ '
        'وَلَهُ الْحَمْدُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ (١)',
    tr:
        'SubhanAllah ×33 · Alhamdulillah ×33 · Allahu Akbar ×33 · '
        'La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa '
        'lahul-hamd, wa huwa ʿala kulli shayʾin qadir ×1',
    nameEn: 'Tasbih after salah',
    nameBn: 'সালাতের পর তাসবিহ',
    en:
        'Glory be to Allah. All praise is for Allah. Allah is the Greatest. '
        'None has the right to be worshipped but Allah alone, without '
        'partner; His is the dominion and His is the praise, and He is able '
        'to do all things.',
    bn:
        'আল্লাহ পবিত্র। সকল প্রশংসা আল্লাহর। আল্লাহ সবচেয়ে মহান। আল্লাহ ছাড়া '
        'কোনো সত্য ইলাহ নেই, তিনি এক, তাঁর কোনো শরীক নেই; রাজত্ব তাঁরই, '
        'প্রশংসাও তাঁরই, আর তিনি সব কিছুর উপর ক্ষমতাবান।',
    virtueEn:
        'Whoever says this after every salah, his sins are forgiven even if '
        'they are like the foam of the sea.',
    virtueBn:
        'যে প্রত্যেক সালাতের পর এটি পড়বে, তার গুনাহ সমুদ্রের ফেনার সমান হলেও '
        'ক্ষমা করে দেওয়া হবে।',
    refEn: 'Sahih Muslim 597',
    refBn: 'সহীহ মুসলিম ৫৯৭',
    perDay: 500,
    splitEn: '33 · 33 · 33 · 1',
    splitBn: '৩৩ · ৩৩ · ৩৩ · ১',
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
    perDay: 100,
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
    perDay: 100,
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
    perDay: 100,
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
    perDay: 100,
  ),
];
