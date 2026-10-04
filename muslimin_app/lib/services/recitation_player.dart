import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../data/quran/quran_repository.dart';

/// A well-known reciter whose verse-by-verse audio is on quran.com.
class Reciter {
  const Reciter(this.id, this.name, this.nameBn);

  /// quran.com recitation id.
  final int id;
  final String name;
  final String nameBn;

  String label(bool bn) => bn ? nameBn : name;

  /// "MA", "AS" … – first and family name, ignoring al-/as-/ash- prefixes.
  String get initials {
    final words = name.split(' ').where((w) => w.isNotEmpty).toList();
    String first(String w) => w.contains('-') ? w.split('-').last[0] : w[0];
    return (first(words.first) + first(words.last)).toUpperCase();
  }
}

const kReciters = [
  Reciter(7, 'Mishary Rashid Alafasy', 'মিশারি রাশিদ আল-আফাসি'),
  Reciter(2, 'Abdul Basit Abdus Samad', 'আবদুল বাসিত আবদুস সামাদ'),
  Reciter(3, 'Abdur-Rahman as-Sudais', 'আবদুর রহমান আস-সুদাইস'),
  Reciter(10, "Sa'ud ash-Shuraym", 'সাউদ আশ-শুরাইম'),
  Reciter(6, 'Mahmoud Khalil al-Husary', 'মাহমুদ খলিল আল-হুসারি'),
  Reciter(9, 'Muhammad Siddiq al-Minshawi', 'মুহাম্মাদ সিদ্দিক আল-মিনশাবি'),
  Reciter(4, 'Abu Bakr ash-Shatri', 'আবু বকর আশ-শাতরি'),
  Reciter(5, 'Hani ar-Rifai', 'হানি আর-রিফাই'),
];

Reciter reciterById(int id) =>
    kReciters.firstWhere((r) => r.id == id, orElse: () => kReciters.first);

/// Verse-by-verse recitation of one surah. The UI listens to it to show
/// the player bar and to highlight / follow the ayah being recited.
class RecitationPlayer extends ChangeNotifier {
  RecitationPlayer({
    required this.repo,
    required this.surah,
    required this.verses,
    required this.reciter,
    required this.onAyah,
    required this.onFinished,
  }) {
    _subs = [
      _player.currentIndexStream.listen((i) {
        if (i == null || i == _index) return;
        _index = i;
        onAyah(i + 1);
        notifyListeners();
      }),
      _player.playerStateStream.listen((s) {
        if (s.processingState == ProcessingState.completed) {
          _playing = false;
          _finishedAll = true;
          onFinished();
          notifyListeners();
          return;
        }
        final playing =
            s.playing && s.processingState != ProcessingState.completed;
        final loading =
            s.processingState == ProcessingState.loading ||
            s.processingState == ProcessingState.buffering;
        if (playing != _playing || loading != _loading) {
          _playing = playing;
          _loading = loading;
          notifyListeners();
        }
      }),
      _player.positionStream.listen((p) {
        _position = p;
        notifyListeners();
      }),
      _player.durationStream.listen((d) => _duration = d),
    ];
  }

  final QuranRepository repo;
  final int surah;
  final int verses;

  /// Called with the 1-based ayah number whenever a new ayah starts.
  final void Function(int ayah) onAyah;

  /// Called when the last ayah has been recited.
  final VoidCallback onFinished;

  final _player = AudioPlayer();
  late final List<StreamSubscription> _subs;

  /// Chosen reciter (change with [setReciter]).
  Reciter reciter;
  int? _loadedFor;
  int _index = 0;
  bool _playing = false;
  bool _loading = false;
  bool _started = false;
  bool _finishedAll = false;
  bool _error = false;
  Duration _position = Duration.zero;
  Duration? _duration;

  bool get playing => _playing;
  bool get loading => _loading;
  bool get started => _started;
  bool get error => _error;

  /// 1-based ayah being recited (or about to be).
  int get ayah => _index + 1;

  /// Progress through the whole surah, 0…1.
  double get progress {
    final d = _duration?.inMilliseconds ?? 0;
    final within = d > 0 ? (_position.inMilliseconds / d).clamp(0.0, 1.0) : 0.0;
    return ((_index + within) / verses).clamp(0.0, 1.0);
  }

  static Future<void> _configureSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  Future<void> _load(int startIndex) async {
    _loading = true;
    _error = false;
    notifyListeners();
    await _configureSession();
    final urls = await repo.audioUrls(surah, reciter.id);
    await _player.setAudioSources([
      for (final u in urls) AudioSource.uri(Uri.parse(u)),
    ], initialIndex: startIndex.clamp(0, urls.length - 1));
    _loadedFor = reciter.id;
  }

  /// Plays from ayah [n] (1-based), loading the surah if needed.
  Future<void> playFrom(int n) async {
    try {
      _started = true;
      _finishedAll = false;
      final i = n - 1;
      if (_loadedFor != reciter.id) {
        await _load(i);
      } else {
        await _player.seek(Duration.zero, index: i);
      }
      _index = i;
      onAyah(n);
      notifyListeners();
      unawaited(_player.play());
    } catch (e) {
      debugPrint('recitation: $e');
      _error = true;
      _loading = false;
      _playing = false;
      notifyListeners();
    }
  }

  Future<void> toggle() async {
    if (_playing) {
      await _player.pause();
    } else if (!_started || _loadedFor != reciter.id || _finishedAll) {
      await playFrom(_finishedAll ? 1 : ayah);
    } else {
      unawaited(_player.play());
    }
  }

  Future<void> next() async {
    if (ayah < verses) await playFrom(ayah + 1);
  }

  Future<void> previous() async {
    if (ayah > 1) await playFrom(ayah - 1);
  }

  Future<void> setReciter(Reciter r) async {
    if (r.id == reciter.id) return;
    final wasPlaying = _playing;
    reciter = r;
    await _player.stop();
    _loadedFor = null;
    notifyListeners();
    if (wasPlaying || _started) await playFrom(ayah);
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }
}
