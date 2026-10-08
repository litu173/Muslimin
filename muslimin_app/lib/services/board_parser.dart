import '../data/models/hm.dart';
import '../data/models/prayer.dart';
import 'time_board_reader.dart' show normalizeBoardTime;

/// One line of text found in a photo, with its box (0..1, top-left origin).
class OcrLine {
  const OcrLine(this.text, this.x, this.y, this.w, this.h);

  final String text;
  final double x, y, w, h;

  factory OcrLine.fromMap(Map<Object?, Object?> m) => OcrLine(
    m['text']! as String,
    (m['x']! as num).toDouble(),
    (m['y']! as num).toDouble(),
    (m['w']! as num).toDouble(),
    (m['h']! as num).toDouble(),
  );
}

/// A row of a time board, top to bottom: its label (if read) and the times
/// on it, left to right.
class BoardRow {
  BoardRow({this.label, List<String>? times, this.y = 0, this.h = 0})
    : times = times ?? [];

  /// A prayer, [skipRow] (sunrise, sehri, date…) or null when unknown.
  Object? label;
  final List<String> times;
  double y, h;

  /// Horizontal boards: labels side by side, with their x positions.
  final labelsAcross = <(Prayer, double)>[];
  final timesX = <double>[];
}

/// Rows that look like a time but are not a jamat (sunrise, sehri…).
const skipRow = 'skip';

/// Prayers in the order boards list them.
const boardOrder = [
  Prayer.fajr,
  Prayer.dhuhr,
  Prayer.asr,
  Prayer.maghrib,
  Prayer.isha,
  Prayer.jumuah,
];

// Label spellings seen on boards: English, Bangla written in Latin letters,
// Arabic, Turkish. (Bangla script is matched too, for Gemini's rows.)
final _labels = <Object, RegExp>{
  Prayer.fajr: RegExp(
    r'\b(fa[jz]a?r|fozor|fojor|fajer|subh|sobh)\b|ফজর|الفجر|الصبح',
  ),
  Prayer.dhuhr: RegExp(
    r'\b(d?h?[zj]uh?u?r|zohr|zoh[ao]r|joh[ao]r|duhr|dhuhur|zuhur|ogle|öğle)\b'
    r'|যোহর|জোহর|যুহর|জুহর|الظهر',
  ),
  Prayer.asr: RegExp(r'\b(asr|asar|ashar|aser|ikindi)\b|আসর|আছর|العصر'),
  Prayer.maghrib: RegExp(
    r'\b(magh?rib|maghreb|mogh?rib|aksam|akşam)\b|মাগরিব|المغرب',
  ),
  Prayer.isha: RegExp(
    r'\b(isha+|esha+|ishaa|eshaa|yatsi|yatsı)\b|এশা|ইশা|এশার|العشاء',
  ),
  Prayer.jumuah: RegExp(
    r"\b(jum['’]?u?['’]?a+h?|jumm?a+h?|juma|jumah|cuma|friday)\b"
    r'|জুম|الجمعة',
  ),
  skipRow: RegExp(
    r'\b(sun\s?rise|shuruq|sh[uo]rooq|ishraq|gunes|güneş|sehri|sahri|suhoor'
    r'|iftar|zawal|zaval|tahajjud|imsak|date|temp)\b'
    r'|সূর্যোদয়|সূর্যাস্ত|সাহরি|সেহরি|ইফতার|তারিখ|الشروق',
  ),
};

/// The prayer a label names, [skipRow], or null.
Object? labelOf(String text) {
  final s = text.toLowerCase().replaceAll('.', '');
  // Jumuah before Dhuhr: "Jumuah" also contains "uh".
  for (final k in [
    Prayer.jumuah,
    skipRow,
    Prayer.fajr,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ]) {
    if (_labels[k]!.hasMatch(s)) return k;
  }
  return null;
}

/// Times in an OCR'd string, fixing what 7-segment LED digits do to OCR:
/// O / D for 0, I / l / | for 1, S for 5, B for 8, a lost colon
/// ("0130" → 1:30) and split digits ("0 1:15", "0 100").
List<(String, double)> timesIn(String raw) {
  const fix = {
    'O': '0', 'o': '0', 'D': '0', 'Q': '0', 'U': '0', //
    'I': '1', 'l': '1', '|': '1', '!': '1', 'i': '1', ']': '1', '[': '1',
    'S': '5', 's': '5', 'B': '8', 'Z': '2', 'z': '2', 'G': '6', 'b': '6',
    '০': '0', '১': '1', '২': '2', '৩': '3', '৪': '4', //
    '৫': '5', '৬': '6', '৭': '7', '৮': '8', '৯': '9',
    '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4', //
    '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9',
  };
  // Only fix letters inside number-like words, so labels stay intact.
  final words = raw
      .replaceAll('∶', ':')
      // "04: 15", "06 :10" – a space next to the colon.
      .replaceAll(RegExp(r'\s*:\s*'), ':')
      .trim()
      .split(RegExp(r'\s+'));
  final norm = <String>[];
  for (final w in words) {
    final digits = w.runes.where((r) {
      final c = String.fromCharCode(r);
      return RegExp(r'[0-9০-৯٠-٩]').hasMatch(c);
    }).length;
    final looksNumeric =
        digits > 0 && digits * 2 >= w.replaceAll(RegExp('[:.]'), '').length;
    norm.add(
      looksNumeric || w.length <= 1 && fix.containsKey(w)
          ? w.split('').map((c) => fix[c] ?? c).join()
          : w,
    );
  }

  final out = <(String, double)>[];
  final n = norm.length;
  var pending = '';
  var pendingAt = 0;
  void emitDigits(String d, int at) {
    final cut = d.length - 2;
    if ((cut == 1 || cut == 2) && RegExp(r'^\d+$').hasMatch(d)) {
      out.add(('${d.substring(0, cut)}:${d.substring(cut)}', (at + 0.5) / n));
    }
  }

  for (var i = 0; i < n; i++) {
    final w = norm[i];
    final colon = RegExp(r'^(\d{0,2})[:.](\d{2})$').firstMatch(w);
    if (colon != null) {
      var h = colon.group(1)!;
      // "0 1:15": a lone digit before belongs to the hour.
      if (h.length <= 1 && pending.length == 1) h = pending + h;
      pending = '';
      // "0:45" is a lost digit, not a time.
      if (h.isNotEmpty && int.parse(h) > 0) {
        out.add(('$h:${colon.group(2)}', (i + 0.5) / n));
      }
      continue;
    }
    if (RegExp(r'^\d+$').hasMatch(w)) {
      if (pending.isEmpty) pendingAt = i;
      pending += w;
      if (pending.length == 4) {
        emitDigits(pending, pendingAt);
        pending = '';
      } else if (pending.length > 4) {
        pending = w.length <= 4 ? w : '';
        pendingAt = i;
      }
      continue;
    }
    // Several times run together ("05:45012004:50"): each colon with
    // the digits around it, and 3–4 digits between two of them.
    final runs = RegExp(r'(\d{1,2})[:.](\d{2})').allMatches(w).toList();
    if (runs.isNotEmpty && RegExp(r'^[\d:.]+$').hasMatch(w)) {
      // Only when what lies between the times is clean (3–4 digits, a time
      // without its colon); anything else is OCR noise – skip the word.
      final gaps = [
        for (var j = 0; j <= runs.length; j++)
          w.substring(
            j == 0 ? 0 : runs[j - 1].end,
            j < runs.length ? runs[j].start : w.length,
          ),
      ];
      bool clean(String g) => g.isEmpty || RegExp(r'^\d{3,4}$').hasMatch(g);
      // The end may also hold a digit split off the next time ("…:000 1:15").
      if (clean(gaps.first) &&
          (clean(gaps.last) || gaps.last.length == 1) &&
          gaps.skip(1).take(gaps.length - 2).every(clean)) {
        for (final (j, m) in runs.indexed) {
          emitDigits(gaps[j], i);
          if (int.parse(m.group(1)!) > 0) {
            out.add(('${m.group(1)}:${m.group(2)}', (i + 0.5) / n));
          }
        }
        emitDigits(gaps.last, i);
        pending = gaps.last.length == 1 ? gaps.last : '';
        pendingAt = i;
      } else {
        pending = '';
      }
      continue;
    }
    if (pending.length == 3) emitDigits(pending, pendingAt);
    pending = '';
  }
  if (pending.length == 3) emitDigits(pending, pendingAt);
  return out;
}

final _azanHead = RegExp(
  r'\b(azan|adhan|azaan|athan|start|begins?|ezan)\b|আযান|আজান|الأذان|الاذان',
);
final _jamatHead = RegExp(
  r'\b(jama+t|jamaah|jama.?ah|iqa+mah?|ikamet)\b|জামাত|জামা.ত|الإقامة|الاقامة',
);

/// OCR lines → board rows, top to bottom.
List<BoardRow> rowsFromOcr(List<OcrLine> lines) {
  final sorted = [...lines]..sort((a, b) => a.y.compareTo(b.y));
  // Boards with an "Azan" and a "Jamat" column: only the Jamat column
  // counts – an unreadable jamat must not fall back to the azan time.
  double? azanX, jamatX;
  for (final l in sorted) {
    final s = l.text.toLowerCase();
    final a = _azanHead.firstMatch(s), j = _jamatHead.firstMatch(s);
    double at(Match m) => l.x + l.w * (m.start + m.end) / 2 / s.length;
    if (a != null) azanX ??= at(a);
    if (j != null) jamatX ??= at(j);
  }
  bool inJamatColumn(double x) =>
      jamatX == null ||
      (azanX != null
          ? (x - jamatX).abs() < (x - azanX).abs()
          : (x - jamatX).abs() < 0.15);

  // 1. Rows of times: lines whose middles line up.
  final rows = <BoardRow>[];
  final labelLines = <(OcrLine, List<(Object, double)>)>[];
  for (final l in sorted) {
    final times = [
      for (final (t, at) in timesIn(l.text))
        if (inJamatColumn(l.x + l.w * at)) (t, l.x + l.w * at),
    ];
    // Labels: whole line, or word by word for "FAJR ASR …" across a row.
    final words = l.text.split(RegExp(r'\s{2,}|\s(?=\S{3,})'));
    final found = <(Object, double)>[];
    for (final (i, w) in words.indexed) {
      final k = labelOf(w);
      if (k != null) found.add((k, l.x + l.w * (i + 0.5) / words.length));
    }
    if (found.isEmpty) {
      final k = labelOf(l.text);
      if (k != null) found.add((k, l.x + l.w / 2));
    }
    if (times.isEmpty) {
      if (found.isNotEmpty) labelLines.add((l, found));
      continue;
    }
    final cy = l.y + l.h / 2;
    BoardRow? row;
    for (final r in rows) {
      if ((r.y + r.h / 2 - cy).abs() < 0.5 * (l.h > r.h ? l.h : r.h)) {
        row = r;
        break;
      }
    }
    if (row == null) {
      row = BoardRow(y: l.y, h: l.h);
      rows.add(row);
    } else if (l.h > row.h) {
      row.h = l.h;
    }
    for (final (t, x) in times) {
      row.times.add(t);
      row.timesX.add(x);
    }
    // A label on the same line as its time.
    if (found.isNotEmpty) row.label ??= found.first.$1;
  }

  // 2. Labels on their own lines. Several prayer names side by side are a
  // header for the times below them; otherwise each label belongs to the
  // nearest row of times (photos are often tilted, so not exactly level).
  final across = <OcrLine, List<(Object, double)>>{};
  for (final (l, found) in labelLines) {
    final level = [
      for (final (o, f) in labelLines)
        if (((o.y + o.h / 2) - (l.y + l.h / 2)).abs() < l.h) ...f,
    ];
    if (level.whereType<(Prayer, double)>().length >= 3) {
      across[l] = found;
    }
  }
  if (across.isNotEmpty) {
    final top = across.keys.map((l) => l.y).reduce((a, b) => a < b ? a : b);
    final header = BoardRow(y: top, h: across.keys.first.h);
    for (final f in across.values) {
      for (final (k, x) in f) {
        if (k is Prayer) header.labelsAcross.add((k, x));
      }
    }
    header.labelsAcross.sort((a, b) => a.$2.compareTo(b.$2));
    rows.add(header);
  }
  final loose = [
    for (final (l, found) in labelLines)
      if (!across.containsKey(l)) (l, found.first.$1),
  ];
  final timed = [
    for (final r in rows)
      if (r.times.isNotEmpty) r,
  ];
  if (loose.isNotEmpty && timed.isNotEmpty) {
    double mid(BoardRow r) => r.y + r.h / 2;
    double lmid(OcrLine l) => l.y + l.h / 2;
    final rowH =
        [for (final r in timed) r.h].reduce((a, b) => a + b) / timed.length;
    // A tilted photo shifts every label by about the same amount: find
    // that shift – the one that puts the labels closest to rows overall.
    var shift = 0.0, best = double.infinity;
    for (final (l, _) in loose) {
      for (final r in timed) {
        final d = mid(r) - lmid(l);
        if (d.abs() > 1.5 * rowH) continue;
        var cost = 0.0;
        for (final (o, _) in loose) {
          var near = rowH;
          for (final q in timed) {
            final e = (lmid(o) + d - mid(q)).abs();
            if (e < near) near = e;
          }
          cost += near;
        }
        if (cost < best - 1e-9 ||
            (cost - best).abs() < 1e-9 && d.abs() < shift.abs()) {
          best = cost;
          shift = d;
        }
      }
    }
    final pairs = <(double, OcrLine, Object, BoardRow)>[];
    for (final (l, k) in loose) {
      for (final r in timed) {
        final e = (lmid(l) + shift - mid(r)).abs();
        if (e < 0.5 * rowH) pairs.add((e, l, k, r));
      }
    }
    pairs.sort((a, b) => a.$1.compareTo(b.$1));
    final usedLines = <OcrLine>{};
    for (final (_, l, k, r) in pairs) {
      if (r.label != null || usedLines.contains(l)) continue;
      r.label = k;
      usedLines.add(l);
    }
  }
  rows.sort((a, b) => a.y.compareTo(b.y));

  // Keep times in left-to-right order.
  for (final r in rows) {
    final idx = List.generate(r.times.length, (i) => i)
      ..sort((a, b) => r.timesX[a].compareTo(r.timesX[b]));
    final t = [for (final i in idx) r.times[i]];
    final x = [for (final i in idx) r.timesX[i]];
    r.times
      ..clear()
      ..addAll(t);
    r.timesX
      ..clear()
      ..addAll(x);
  }
  return rows;
}

/// The jamat of [p] among a row's times: the latest valid one (boards with
/// an azan and a jamat column show the jamat second).
HM? _jamat(Prayer p, Iterable<String> times) {
  HM? best;
  for (final t in times) {
    final v = normalizeBoardTime(p, t);
    if (v != null && (best == null || v.minutes > best.minutes)) best = v;
  }
  return best;
}

/// Board rows → jamat times. Uses the labels when it can read them;
/// otherwise the order: boards list Fajr, Dhuhr, Asr, Maghrib, Isha (and
/// Jumuah) from top to bottom, or left to right.
Map<Prayer, HM> assignBoard(List<BoardRow> rows) {
  // Digits the OCR cannot read (Bangla digits) come out as a run of
  // "6:00", "8:00"… – real boards are almost never all on the hour.
  final all = [for (final r in rows) ...r.times];
  if (all.length >= 5 &&
      all.where((t) => t.endsWith(':00')).length >= all.length * 0.7) {
    return const {};
  }

  // A clock or date in big digits above the table is not a prayer.
  final heights = [
    for (final r in rows)
      if (r.times.isNotEmpty && r.h > 0) r.h,
  ]..sort();
  if (heights.length >= 3) {
    final median = heights[heights.length ~/ 2];
    rows = [
      for (final r in rows)
        if (r.h <= median * 1.7 || r.times.isEmpty) r,
    ];
  }

  // 1. Labels across one row, times below them (column layout).
  for (final (i, r) in rows.indexed) {
    if (r.labelsAcross.length < 3) continue;
    final out = <Prayer, HM>{};
    for (final (p, x) in r.labelsAcross) {
      final near = <String>[];
      for (final below in rows.skip(i + 1).take(3)) {
        for (final (j, t) in below.times.indexed) {
          if ((below.timesX[j] - x).abs() < 0.07) near.add(t);
        }
      }
      final v = _jamat(p, near);
      if (v != null) out[p] = v;
    }
    if (out.length >= 3) return out;
  }

  // 2. One label per row.
  final labelled = <Prayer, HM>{};
  for (final r in rows) {
    final p = r.label;
    if (p is! Prayer || labelled.containsKey(p)) continue;
    final v = _jamat(p, r.times);
    if (v != null) labelled[p] = v;
  }

  // Labels read in the wrong rows put the prayers out of order (Asr after
  // Maghrib…): then trust the board's order instead.
  final daily = [
    for (final p in boardOrder.take(5))
      if (labelled[p] != null) labelled[p]!.minutes,
  ];
  for (var i = 1; i < daily.length; i++) {
    if (daily[i] <= daily[i - 1]) {
      labelled.clear();
      for (final r in rows) {
        if (r.label is Prayer) r.label = null;
      }
      break;
    }
  }

  // 3. By order: rows with 3+ times are a row of prayers (left to right);
  // a row with one or two times is one prayer (azan, jamat).
  final slots = <List<String>>[];
  for (final r in rows) {
    if (r.label == skipRow || r.times.isEmpty) continue;
    if (r.label is Prayer && labelled.containsKey(r.label)) {
      slots.add(const []); // keeps its place in the order
    } else if (r.times.length >= 3) {
      slots.addAll([
        for (final t in r.times) [t],
      ]);
    } else {
      slots.add(r.times);
    }
  }
  final ordered = _byOrder(slots, labelled);
  // Order alone, from only one or two readable times, is a guess.
  if (labelled.isEmpty && ordered.length < 3) return const {};
  return {...ordered, ...labelled};
}

/// Assigns the five prayers to [slots] in order (skipping slots that fit
/// nothing, like sunrise), keeping the times increasing; then Jumuah to any
/// later midday slot. Picks the assignment that fills the most prayers.
Map<Prayer, HM> _byOrder(List<List<String>> slots, Map<Prayer, HM> fixed) {
  const five = [
    Prayer.fajr,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ];
  final n = slots.length;
  // (prayers placed, [(prayer index, slot index, time)]) for slots i..
  // and prayers k.., with every time after [after].
  final memo = <(int, int, int), (int, List<(int, int, HM)>)>{};
  (int, List<(int, int, HM)>) go(int i, int k, int after) {
    if (k == five.length) return (0, const []);
    final p = five[k];
    if (fixed.containsKey(p)) {
      // Known from its label: it only keeps the order.
      return go(i, k + 1, fixed[p]!.minutes);
    }
    if (i >= n) return (0, const []);
    final key = (i, k, after);
    final hit = memo[key];
    if (hit != null) return hit;
    // Skip this slot (sunrise…), or leave this prayer out.
    var best = go(i + 1, k, after);
    final skipP = go(i, k + 1, after);
    if (skipP.$1 > best.$1) best = skipP;
    final v = _jamat(p, slots[i]);
    if (v != null && v.minutes > after) {
      final rest = go(i + 1, k + 1, v.minutes);
      // ">=": on a tie, the earlier slot wins (Fajr before sunrise).
      if (rest.$1 + 1 >= best.$1) {
        best = (rest.$1 + 1, [(k, i, v), ...rest.$2]);
      }
    }
    memo[key] = best;
    return best;
  }

  final picked = go(0, 0, -1).$2;
  final out = <Prayer, HM>{for (final (k, _, v) in picked) five[k]: v};
  if (!fixed.containsKey(Prayer.jumuah)) {
    // Jumuah: the last midday slot after Dhuhr's that no prayer took.
    final used = {for (final (_, i, _) in picked) i};
    final dhuhrAt = [
      for (final (k, i, _) in picked)
        if (five[k] == Prayer.dhuhr) i,
    ].firstOrNull;
    for (var i = n - 1; i > (dhuhrAt ?? -1); i--) {
      if (used.contains(i)) continue;
      final v = _jamat(Prayer.jumuah, slots[i]);
      if (v != null) {
        out[Prayer.jumuah] = v;
        break;
      }
    }
  }
  return out;
}

/// Jamat times from OCR'd lines.
Map<Prayer, HM> readOcr(List<OcrLine> lines) => assignBoard(rowsFromOcr(lines));
