import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quran/quran_repository.dart';
import '../data/quran/surahs.dart';
import 'providers.dart';

final quranRepositoryProvider = Provider((_) => QuranRepository());

/// Journey order: the Mushaf order, Al-Fatihah (1) to An-Nas (114).
final List<Surah> kJourney = kSurahs;

/// A phase: up to three consecutive journey surahs, about 60 verses
/// (a long surah is a phase on its own). Ends with an optional quiz.
class QuranPhase {
  const QuranPhase(this.index, this.surahs);

  /// 0-based.
  final int index;
  final List<Surah> surahs;

  int get verses => surahs.fold(0, (s, x) => s + x.verses);
}

final List<QuranPhase> kPhases = () {
  const budget = 60;
  final phases = <QuranPhase>[];
  var cur = <Surah>[];
  var sum = 0;
  for (final s in kJourney) {
    if (cur.isNotEmpty && (cur.length == 3 || sum + s.verses > budget)) {
      phases.add(QuranPhase(phases.length, cur));
      cur = [];
      sum = 0;
    }
    cur.add(s);
    sum += s.verses;
  }
  phases.add(QuranPhase(phases.length, cur));
  return phases;
}();

QuranPhase phaseOf(int surahId) =>
    kPhases.firstWhere((p) => p.surahs.any((s) => s.id == surahId));

// ------------------------------------------------------------------ progress
String dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class QuranProgress {
  const QuranProgress({
    this.completed = const {},
    this.lastSurah,
    this.lastAyah = 1,
    this.quizBest = const {},
    this.daily = const {},
    this.today = '',
    this.todaySeen = const {},
    this.events = const {},
    this.achievedAt = const {},
  });

  /// Surah ids read to the end.
  final Set<int> completed;
  final int? lastSurah;
  final int lastAyah;

  /// Best quiz score (0-100) per phase index.
  final Map<int, int> quizBest;

  /// Verses read per day ("2026-10-04" -> 12).
  final Map<String, int> daily;

  /// Day of [todaySeen] and the verse keys ("2:255") read that day, so a
  /// verse counts once a day.
  final String today;
  final Set<String> todaySeen;

  /// Special moments: 'kahf_friday', 'mulk_night', 'listener'.
  final Set<String> events;

  /// Achievement id -> when it was earned (ISO date).
  final Map<String, String> achievedAt;

  /// Next surah to read on the journey (all surahs are open to read).
  Surah? get current =>
      kJourney.where((s) => !completed.contains(s.id)).firstOrNull;

  /// Every surah can be read at any time.
  bool isUnlocked(Surah s) => true;

  bool phaseDone(QuranPhase p) =>
      p.surahs.every((s) => completed.contains(s.id));

  int versesOn(DateTime d) => daily[dayKey(d)] ?? 0;

  int get versesToday => versesOn(DateTime.now());

  /// All verses read, ever (counted per day).
  int get versesRead => daily.values.fold(0, (a, b) => a + b);

  /// Days in a row with some reading, ending today (or yesterday, so the
  /// streak survives until the end of today).
  int get streak {
    var d = DateTime.now();
    if (versesOn(d) == 0) d = d.subtract(const Duration(days: 1));
    var n = 0;
    while (versesOn(d) > 0) {
      n++;
      d = d.subtract(const Duration(days: 1));
    }
    return n;
  }

  /// Longest run of reading days ever.
  int get bestStreak {
    final days =
        daily.entries
            .where((e) => e.value > 0)
            .map((e) => DateTime.parse(e.key))
            .toList()
          ..sort();
    var best = 0, run = 0;
    DateTime? prev;
    for (final d in days) {
      run = prev != null && d.difference(prev).inDays == 1 ? run + 1 : 1;
      if (run > best) best = run;
      prev = d;
    }
    return best;
  }

  Map<String, dynamic> toJson() => {
    'completed': completed.toList(),
    'lastSurah': lastSurah,
    'lastAyah': lastAyah,
    'quizBest': quizBest.map((k, v) => MapEntry('$k', v)),
    'daily': daily,
    'today': today,
    'todaySeen': todaySeen.toList(),
    'events': events.toList(),
    'achievedAt': achievedAt,
  };

  factory QuranProgress.fromJson(Map<String, dynamic> j) => QuranProgress(
    completed: {...((j['completed'] as List?) ?? []).cast<int>()},
    lastSurah: j['lastSurah'] as int?,
    lastAyah: (j['lastAyah'] as int?) ?? 1,
    quizBest: ((j['quizBest'] as Map?) ?? {}).map(
      (k, v) => MapEntry(int.parse('$k'), v as int),
    ),
    daily: ((j['daily'] as Map?) ?? {}).map(
      (k, v) => MapEntry('$k', (v as num).toInt()),
    ),
    today: (j['today'] as String?) ?? '',
    todaySeen: {...((j['todaySeen'] as List?) ?? []).cast<String>()},
    events: {...((j['events'] as List?) ?? []).cast<String>()},
    achievedAt: ((j['achievedAt'] as Map?) ?? {}).map(
      (k, v) => MapEntry('$k', '$v'),
    ),
  );

  QuranProgress copyWith({
    Set<int>? completed,
    int? lastSurah,
    int? lastAyah,
    Map<int, int>? quizBest,
    Map<String, int>? daily,
    String? today,
    Set<String>? todaySeen,
    Set<String>? events,
    Map<String, String>? achievedAt,
  }) => QuranProgress(
    completed: completed ?? this.completed,
    lastSurah: lastSurah ?? this.lastSurah,
    lastAyah: lastAyah ?? this.lastAyah,
    quizBest: quizBest ?? this.quizBest,
    daily: daily ?? this.daily,
    today: today ?? this.today,
    todaySeen: todaySeen ?? this.todaySeen,
    events: events ?? this.events,
    achievedAt: achievedAt ?? this.achievedAt,
  );
}

class QuranProgressNotifier extends Notifier<QuranProgress> {
  @override
  QuranProgress build() =>
      QuranProgress.fromJson(ref.watch(prefsProvider).quranProgress);

  void _save(QuranProgress p) {
    // Stamp any achievement that has just been earned.
    final now = DateTime.now().toIso8601String();
    final earned = {...p.achievedAt};
    for (final a in kAchievements) {
      if (!earned.containsKey(a.id) && a.progress(p) >= a.target) {
        earned[a.id] = now;
      }
    }
    if (earned.length != p.achievedAt.length) {
      p = p.copyWith(achievedAt: earned);
    }
    state = p;
    ref.read(prefsProvider).quranProgress = p.toJson();
  }

  /// An ayah was read (seen in the reader or recited by the player).
  void read(int surah, int ayah) {
    final now = DateTime.now();
    final key = dayKey(now);
    final seen = state.today == key ? state.todaySeen : <String>{};
    final verse = '$surah:$ayah';
    final isNew = !seen.contains(verse);
    final moved = !(state.lastSurah == surah && state.lastAyah >= ayah);
    if (!isNew && !moved) return;
    _save(
      state.copyWith(
        today: key,
        todaySeen: isNew ? {...seen, verse} : seen,
        daily: isNew
            ? {...state.daily, key: (state.daily[key] ?? 0) + 1}
            : state.daily,
        lastSurah: moved ? surah : null,
        lastAyah: moved ? ayah : null,
      ),
    );
  }

  void complete(int surah) {
    final now = DateTime.now();
    final events = {...state.events};
    if (surah == 18 && now.weekday == DateTime.friday) {
      events.add('kahf_friday');
    }
    if (surah == 67 && (now.hour >= 18 || now.hour < 4)) {
      events.add('mulk_night');
    }
    _save(
      state.copyWith(
        completed: {...state.completed, surah},
        lastAyah: 1,
        events: events,
      ),
    );
  }

  /// A whole surah was listened to with the player.
  void listened(int surah) {
    if (state.events.contains('listener')) return;
    _save(state.copyWith(events: {...state.events, 'listener'}));
  }

  void quizScore(int phase, int percent) {
    if ((state.quizBest[phase] ?? -1) >= percent) return;
    _save(state.copyWith(quizBest: {...state.quizBest, phase: percent}));
  }
}

final quranProgressProvider =
    NotifierProvider<QuranProgressNotifier, QuranProgress>(
      QuranProgressNotifier.new,
    );

// --------------------------------------------------------------- achievements
/// Daily reading goal (verses) behind the Home energy card.
const kDailyGoal = 10;

class Achievement {
  const Achievement(this.id, this.icon, this.target, this.progress);

  final String id;

  /// Material icon code point name, resolved by the UI.
  final String icon;
  final int target;
  final int Function(QuranProgress p) progress;
}

int _done(QuranProgress p, Iterable<int> ids) =>
    ids.where(p.completed.contains).length;

final kAchievements = <Achievement>[
  Achievement('bismillah', 'auto_stories', 1, (p) => p.versesRead),
  Achievement('fatiha', 'menu_book', 1, (p) => _done(p, [1])),
  Achievement('quls', 'shield', 3, (p) => _done(p, [112, 113, 114])),
  Achievement('streak3', 'local_fire_department', 3, (p) => p.bestStreak),
  Achievement('streak7', 'whatshot', 7, (p) => p.bestStreak),
  Achievement('streak30', 'brightness_7', 30, (p) => p.bestStreak),
  Achievement('verses100', 'format_list_numbered', 100, (p) => p.versesRead),
  Achievement('verses1000', 'military_tech', 1000, (p) => p.versesRead),
  Achievement(
    'kahf',
    'wb_sunny',
    1,
    (p) => p.events.contains('kahf_friday') ? 1 : 0,
  ),
  Achievement(
    'mulk',
    'nights_stay',
    1,
    (p) => p.events.contains('mulk_night') ? 1 : 0,
  ),
  Achievement('yasin', 'favorite', 1, (p) => _done(p, [36])),
  Achievement(
    'listener',
    'headphones',
    1,
    (p) => p.events.contains('listener') ? 1 : 0,
  ),
  Achievement(
    'quiz100',
    'emoji_events',
    1,
    (p) => p.quizBest.values.any((v) => v == 100) ? 1 : 0,
  ),
  Achievement(
    'juzamma',
    'star',
    37,
    (p) => _done(p, [for (var i = 78; i <= 114; i++) i]),
  ),
  Achievement(
    'phases10',
    'route',
    10,
    (p) => kPhases.where(p.phaseDone).length,
  ),
  Achievement('khatm', 'workspace_premium', 114, (p) => p.completed.length),
];

// ---------------------------------------------------------------------- quiz
enum QuizKind { vocabulary, meaning, whichSurah, revelation, verses, name }

class QuizQuestion {
  const QuizQuestion({
    required this.kind,
    required this.prompt,
    this.arabic,
    required this.options,
    required this.answer,
    this.explain,
  });

  final QuizKind kind;

  /// Question text (already localized).
  final String prompt;

  /// Arabic word / ayah shown large, if any.
  final String? arabic;
  final List<String> options;

  /// Index into [options].
  final int answer;
  final String? explain;
}

/// Localized wording for generated questions.
class QuizTexts {
  const QuizTexts({
    required this.wordMeaning,
    required this.ayahMeaning,
    required this.whichSurah,
    required this.revealedWhere,
    required this.makkah,
    required this.madinah,
    required this.howManyVerses,
    required this.nameMeans,
    required this.surahName,
    required this.digits,
  });

  final String wordMeaning;
  final String ayahMeaning;
  final String whichSurah;
  final String Function(String surah) revealedWhere;
  final String makkah;
  final String madinah;
  final String Function(String surah) howManyVerses;
  final String Function(String surah) nameMeans;
  final String Function(Surah s) surahName;
  final String Function(Object) digits;
}

/// Builds a quiz for a phase from the Quran data itself, so every answer is
/// correct by construction: word meanings, ayah meanings, which surah an ayah
/// is from, place of revelation, number of verses and what the name means.
List<QuizQuestion> buildQuiz({
  required QuranPhase phase,
  required Map<int, List<Ayah>> ayahs,
  required QuizTexts tx,
  required bool bn,
  int count = 8,
  int? seed,
}) {
  final r = math.Random(seed);
  final qs = <QuizQuestion>[];

  List<String> options(String correct, Iterable<String> pool, int n) {
    final others = {...pool}..remove(correct);
    final picked = (others.toList()..shuffle(r)).take(n - 1).toList();
    return (picked..add(correct))..shuffle(r);
  }

  QuizQuestion q(
    QuizKind k,
    String prompt,
    String correct,
    Iterable<String> pool, {
    String? arabic,
    String? explain,
    int n = 4,
  }) {
    final o = options(correct, pool, n);
    return QuizQuestion(
      kind: k,
      prompt: prompt,
      arabic: arabic,
      options: o,
      answer: o.indexOf(correct),
      explain: explain,
    );
  }

  final allAyahs = [
    for (final s in phase.surahs)
      for (final a in ayahs[s.id] ?? const <Ayah>[]) (s, a),
  ];
  final words = [
    for (final (_, a) in allAyahs)
      for (final w in a.words)
        if (w.meaning.isNotEmpty && w.meaning.length <= 28) w,
  ];
  final wordPool = {for (final w in words) w.meaning};

  // Vocabulary (needs 4 different meanings).
  if (wordPool.length >= 4) {
    final ws = [...words]..shuffle(r);
    final seen = <String>{};
    for (final w in ws) {
      if (seen.length >= 3) break;
      if (!seen.add(w.meaning)) continue;
      qs.add(
        q(
          QuizKind.vocabulary,
          tx.wordMeaning,
          w.meaning,
          wordPool,
          arabic: w.arabic,
        ),
      );
    }
  }

  // Ayah meaning (short ayahs with short translations).
  final shortAyahs = [
    for (final (s, a) in allAyahs)
      if (a.translation.length <= 130 && a.words.length <= 14) (s, a),
  ]..shuffle(r);
  final meaningPool = {for (final (_, a) in shortAyahs) a.translation};
  if (meaningPool.length >= 3) {
    for (final (_, a) in shortAyahs.take(2)) {
      qs.add(
        q(
          QuizKind.meaning,
          tx.ayahMeaning,
          a.translation,
          meaningPool,
          arabic: a.arabic,
          n: math.min(4, meaningPool.length),
        ),
      );
    }
  }

  // Which surah is this ayah from?
  if (phase.surahs.length >= 2 && shortAyahs.isNotEmpty) {
    final (s, a) = shortAyahs.last;
    final pool = {
      for (final x in phase.surahs) tx.surahName(x),
      for (final x in [...kSurahs]..shuffle(r)) tx.surahName(x),
    }.take(8);
    qs.add(
      q(
        QuizKind.whichSurah,
        tx.whichSurah,
        tx.surahName(s),
        pool,
        arabic: a.arabic,
      ),
    );
  }

  // Facts about each surah.
  for (final s in phase.surahs) {
    final name = tx.surahName(s);
    qs.add(
      q(
        QuizKind.revelation,
        tx.revealedWhere(name),
        s.makki ? tx.makkah : tx.madinah,
        [tx.makkah, tx.madinah],
        n: 2,
      ),
    );
    final near = {
      for (final d in [-3, -2, -1, 1, 2, 3, 5])
        if (s.verses + d > 0) tx.digits(s.verses + d),
    };
    qs.add(
      q(QuizKind.verses, tx.howManyVerses(name), tx.digits(s.verses), near),
    );
    qs.add(
      q(QuizKind.name, tx.nameMeans(name), s.meaning(bn), {
        for (final x in kSurahs) x.meaning(bn),
      }),
    );
  }

  // Keep a mix: up to [count], spread across kinds.
  qs.shuffle(r);
  qs.sort((a, b) => a.kind.index.compareTo(b.kind.index));
  final out = <QuizQuestion>[];
  final byKind = <QuizKind, List<QuizQuestion>>{};
  for (final x in qs) {
    byKind.putIfAbsent(x.kind, () => []).add(x);
  }
  while (out.length < count && byKind.values.any((l) => l.isNotEmpty)) {
    for (final l in byKind.values) {
      if (l.isNotEmpty && out.length < count) out.add(l.removeAt(0));
    }
  }
  return out..shuffle(r);
}
