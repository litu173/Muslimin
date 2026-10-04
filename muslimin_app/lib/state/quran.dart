import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quran/quran_repository.dart';
import '../data/quran/surahs.dart';
import 'providers.dart';

final quranRepositoryProvider = Provider((_) => QuranRepository());

/// Journey order: Al-Fatiha first, then from An-Nas (114) back to
/// Al-Baqarah (2) – short surahs first, the way most people learn.
final List<Surah> kJourney = [
  kSurahs.first,
  for (var i = 113; i >= 1; i--) kSurahs[i],
];

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
class QuranProgress {
  const QuranProgress({
    this.completed = const {},
    this.lastSurah,
    this.lastAyah = 1,
    this.quizBest = const {},
  });

  /// Surah ids read to the end.
  final Set<int> completed;
  final int? lastSurah;
  final int lastAyah;

  /// Best quiz score (0-100) per phase index.
  final Map<int, int> quizBest;

  /// The first surah of the journey that is not finished yet.
  Surah? get current =>
      kJourney.where((s) => !completed.contains(s.id)).firstOrNull;

  /// A surah opens when every surah before it in the journey is read.
  bool isUnlocked(Surah s) {
    final i = kJourney.indexOf(s);
    return i == 0 || completed.contains(kJourney[i - 1].id);
  }

  bool phaseDone(QuranPhase p) =>
      p.surahs.every((s) => completed.contains(s.id));

  int get versesRead => kSurahs
      .where((s) => completed.contains(s.id))
      .fold(0, (a, s) => a + s.verses);

  Map<String, dynamic> toJson() => {
    'completed': completed.toList(),
    'lastSurah': lastSurah,
    'lastAyah': lastAyah,
    'quizBest': quizBest.map((k, v) => MapEntry('$k', v)),
  };

  factory QuranProgress.fromJson(Map<String, dynamic> j) => QuranProgress(
    completed: {...((j['completed'] as List?) ?? []).cast<int>()},
    lastSurah: j['lastSurah'] as int?,
    lastAyah: (j['lastAyah'] as int?) ?? 1,
    quizBest: ((j['quizBest'] as Map?) ?? {}).map(
      (k, v) => MapEntry(int.parse('$k'), v as int),
    ),
  );

  QuranProgress copyWith({
    Set<int>? completed,
    int? lastSurah,
    int? lastAyah,
    Map<int, int>? quizBest,
  }) => QuranProgress(
    completed: completed ?? this.completed,
    lastSurah: lastSurah ?? this.lastSurah,
    lastAyah: lastAyah ?? this.lastAyah,
    quizBest: quizBest ?? this.quizBest,
  );
}

class QuranProgressNotifier extends Notifier<QuranProgress> {
  @override
  QuranProgress build() =>
      QuranProgress.fromJson(ref.watch(prefsProvider).quranProgress);

  void _save(QuranProgress p) {
    state = p;
    ref.read(prefsProvider).quranProgress = p.toJson();
  }

  void readUpTo(int surah, int ayah) {
    if (state.lastSurah == surah && state.lastAyah >= ayah) return;
    _save(state.copyWith(lastSurah: surah, lastAyah: ayah));
  }

  void complete(int surah) => _save(
    state.copyWith(completed: {...state.completed, surah}, lastAyah: 1),
  );

  void quizScore(int phase, int percent) {
    if ((state.quizBest[phase] ?? -1) >= percent) return;
    _save(state.copyWith(quizBest: {...state.quizBest, phase: percent}));
  }
}

final quranProgressProvider =
    NotifierProvider<QuranProgressNotifier, QuranProgress>(
      QuranProgressNotifier.new,
    );

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
