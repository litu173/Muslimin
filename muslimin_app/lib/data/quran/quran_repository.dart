import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// A word of an ayah with its meaning (word-by-word).
/// Bismillah exactly as in the Mushaf (Al-Fatihah 1:1, Uthmani script).
const kBismillah = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ';

class QuranWord {
  const QuranWord(this.arabic, this.meaning);
  final String arabic;
  final String meaning;

  Map<String, dynamic> toJson() => {'a': arabic, 'm': meaning};
  factory QuranWord.fromJson(Map<String, dynamic> j) =>
      QuranWord(j['a'] as String, j['m'] as String);
}

class Ayah {
  const Ayah(this.number, this.arabic, this.translation, this.words);

  final int number;
  final String arabic;
  final String translation;
  final List<QuranWord> words;

  Map<String, dynamic> toJson() => {
    'n': number,
    'a': arabic,
    't': translation,
    'w': [for (final w in words) w.toJson()],
  };

  factory Ayah.fromJson(Map<String, dynamic> j) =>
      Ayah(j['n'] as int, j['a'] as String, j['t'] as String, [
        for (final w in j['w'] as List)
          QuranWord.fromJson(Map<String, dynamic>.from(w as Map)),
      ]);
}

/// Quran text (Uthmani), translation and word-by-word meanings from the
/// public quran.com API v4. Each surah is downloaded once per language and
/// kept on the phone, so it reads offline afterwards.
///
/// Translations (both Sunni and widely relied upon):
/// English – Saheeh International (id 20);
/// Bangla – Dr. Abu Bakr Muhammad Zakaria, published by the King Fahd
/// Complex for the Printing of the Holy Quran (id 213).
class QuranRepository {
  static const _base = 'https://api.quran.com/api/v4';
  static const _translation = {'en': 20, 'bn': 213};

  final _memory = <String, List<Ayah>>{};

  Future<File> _file(int surah, String lang) async {
    final dir = await getApplicationSupportDirectory();
    final d = Directory('${dir.path}/quran');
    if (!d.existsSync()) d.createSync(recursive: true);
    return File('${d.path}/v2_${surah}_$lang.json');
  }

  /// Cached copy if there is one, without touching the network.
  Future<List<Ayah>?> cached(int surah, String lang) async {
    final key = '$surah:$lang';
    if (_memory[key] case final m?) return m;
    final f = await _file(surah, lang);
    if (!f.existsSync()) return null;
    try {
      final list = [
        for (final a in jsonDecode(await f.readAsString()) as List)
          // Older caches: re-take the word Arabic from the ayah text.
          switch (Ayah.fromJson(Map<String, dynamic>.from(a as Map))) {
            final x => _withAyahWords(
              x.number,
              x.arabic,
              x.translation,
              x.words,
            ),
          },
      ];
      return _memory[key] = list;
    } catch (_) {
      return null;
    }
  }

  Future<List<Ayah>> surah(
    int surah,
    String lang, {
    bool refresh = false,
  }) async {
    if (!refresh) {
      if (await cached(surah, lang) case final c?) return c;
    }
    final uri = Uri.parse(
      '$_base/verses/by_chapter/$surah'
      '?language=$lang&words=true&word_fields=text_uthmani'
      '&translations=${_translation[lang]}&fields=text_uthmani&per_page=300',
    );
    final res = await http.get(uri).timeout(const Duration(seconds: 25));
    if (res.statusCode != 200) {
      throw HttpException('quran.com ${res.statusCode}');
    }
    final verses =
        (jsonDecode(res.body) as Map<String, dynamic>)['verses'] as List;
    final list = [
      for (final v in verses.cast<Map<String, dynamic>>())
        _withAyahWords(
          v['verse_number'] as int,
          v['text_uthmani'] as String,
          _clean(
            ((v['translations'] as List).firstOrNull as Map?)?['text']
                    as String? ??
                '',
          ),
          [
            for (final w in (v['words'] as List).cast<Map<String, dynamic>>())
              if (w['char_type_name'] == 'word')
                QuranWord(
                  w['text_uthmani'] as String? ?? w['text'] as String? ?? '',
                  _clean((w['translation'] as Map?)?['text'] as String? ?? ''),
                ),
          ],
        ),
    ];
    _memory['$surah:$lang'] = list;
    await (await _file(
      surah,
      lang,
    )).writeAsString(jsonEncode([for (final a in list) a.toJson()]));
    return list;
  }

  /// Verse audio for a reciter: one URL per ayah, in order. Cached in
  /// memory for the session.
  final _audio = <String, List<String>>{};

  Future<List<String>> audioUrls(int surah, int reciter) async {
    final key = '$surah:$reciter';
    if (_audio[key] case final a?) return a;
    final res = await http
        .get(
          Uri.parse(
            '$_base/recitations/$reciter/by_chapter/$surah?per_page=300',
          ),
        )
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw HttpException('quran.com audio ${res.statusCode}');
    }
    final files = ((jsonDecode(res.body) as Map)['audio_files'] as List)
        .cast<Map<String, dynamic>>();
    files.sort(
      (a, b) =>
          _ayahOf(a['verse_key'] as String)
              .compareTo(_ayahOf(b['verse_key'] as String)),
    );
    return _audio[key] = [for (final f in files) _absolute(f['url'] as String)];
  }

  static int _ayahOf(String key) => int.parse(key.split(':').last);

  /// Word-by-word Arabic is taken from the ayah's own text (checked against
  /// the Tanzil Uthmani text) whenever the word counts match – the API's
  /// separate word field has a few slips (e.g. 80:25 written without its
  /// hamza). Pause and hizb marks stay attached to their word.
  static Ayah _withAyahWords(
    int number,
    String arabic,
    String translation,
    List<QuranWord> words,
  ) {
    final tokens = <String>[];
    var pending = '';
    for (final w in arabic.split(RegExp(r'\s+'))) {
      if (w.isEmpty) continue;
      if (!_letter.hasMatch(w)) {
        if (tokens.isEmpty) {
          pending += '$w ';
        } else {
          tokens[tokens.length - 1] += ' $w';
        }
      } else {
        tokens.add('$pending$w');
        pending = '';
      }
    }
    return Ayah(
      number,
      arabic,
      translation,
      tokens.length == words.length
          ? [
              for (var i = 0; i < words.length; i++)
                QuranWord(tokens[i], words[i].meaning),
            ]
          : words,
    );
  }

  static final _letter = RegExp('[\u0621-\u064A\u0671-\u06D3]');

  static String _absolute(String url) => url.startsWith('//')
      ? 'https:$url'
      : url.startsWith('http')
      ? url
      : 'https://verses.quran.com/$url';

  /// Drops footnote markers (<sup …>1</sup>, [১]) and any other tags.
  static String _clean(String s) => s
      .replaceAll(RegExp(r'<sup[^>]*>.*?</sup>'), '')
      .replaceAll(RegExp(r'\s*\[[০-৯0-9]+\]'), '')
      .replaceAllMapped(RegExp(r'\s+([,;।:.])'), (m) => m[1]!)
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
