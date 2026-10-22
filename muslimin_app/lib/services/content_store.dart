import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../data/dhikr/dhikrs.dart' show Dhikr;

/// Content the admins can correct on the admin website (Content):
/// the refresh ayat, the Home verses, the duas and the dhikr.
///
/// The app ships with all of it (assets / built in). When an admin saves a
/// set, `config/app.contentVersion.<set>` changes; the app (which already
/// listens to config/app) then reads `content/<set>` once and keeps it on the
/// phone – one read per change, nothing on an ordinary start.
abstract final class ContentStore {
  static const refreshAyat = 'refreshAyat';
  static const homeVerses = 'homeVerses';
  static const duas = 'duas';
  static const dhikr = 'dhikr';
  static const sets = [refreshAyat, homeVerses, duas, dhikr];

  static final Map<String, Object?> _data = {};
  static final Map<String, int> _version = {};
  static Directory? _dir;

  /// Bumped when a set changes (pages read it the next time they open).
  static final revision = ValueNotifier<int>(0);

  /// Reads what the phone kept from earlier downloads. Quick and local.
  static Future<void> init() async {
    try {
      _dir = Directory(
        '${(await getApplicationSupportDirectory()).path}/content',
      );
      for (final k in sets) {
        final f = File('${_dir!.path}/$k.json');
        if (!await f.exists()) continue;
        final j = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
        _version[k] = (j['v'] as num?)?.toInt() ?? 0;
        _data[k] = j['data'];
      }
    } catch (_) {
      // No cache – the built-in content is used.
    }
  }

  /// The admins' version of [set] (JSON), or null for the built-in one.
  static Object? of(String set) => _data[set];

  /// [set] from the admins, else the bundled [asset] (decoded JSON).
  static Future<Object?> json(String set, String asset) async =>
      _data[set] ?? jsonDecode(await rootBundle.loadString(asset));

  /// Downloads every set whose version on the server is newer than the one
  /// on the phone. [fetch] returns null when the admins went back to the
  /// built-in content.
  static Future<void> sync(
    Map<String, int> versions,
    Future<Object?> Function(String set) fetch,
  ) async {
    var changed = false;
    for (final e in versions.entries) {
      if (!sets.contains(e.key) || e.value <= (_version[e.key] ?? 0)) continue;
      try {
        final data = await fetch(e.key);
        _version[e.key] = e.value;
        if (data == null) {
          _data.remove(e.key);
        } else {
          _data[e.key] = data;
        }
        _dhikrs = null;
        changed = true;
        if (_dir != null) {
          await _dir!.create(recursive: true);
          await File('${_dir!.path}/${e.key}.json')
              .writeAsString(jsonEncode({'v': e.value, 'data': data}));
        }
      } catch (_) {
        // Offline or not readable yet – tried again on the next change/start.
      }
    }
    if (changed) revision.value++;
  }

  static List<Dhikr>? _dhikrs;

  /// [defaults] with the admins' corrections, matched by id.
  static List<Dhikr> dhikrs(List<Dhikr> defaults) => _dhikrs ??= () {
    final items = (_data[dhikr] as Map?)?['items'];
    if (items is! List) return defaults;
    final byId = {
      for (final j in items.whereType<Map>())
        '${j['id']}': j.cast<String, dynamic>(),
    };
    return [
      for (final d in defaults)
        byId[d.id] == null ? d : d.withChanges(byId[d.id]!),
    ];
  }();
}
