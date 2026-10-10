/// Volunteer editors, problem reports and the edit history – how jamat
/// times get filled in for masjids nobody has registered yet.
library;

/// How close (metres) someone must be to a masjid to volunteer as its
/// editor. The Firestore rules allow a little more (GPS jitter).
const kEditorRadiusM = 2000.0;

/// Someone near a masjid who keeps its jamat times up to date.
class MasjidEditor {
  const MasjidEditor({
    required this.uid,
    required this.name,
    required this.masjidId,
    required this.masjidName,
    required this.distanceM,
    this.createdAt,
  });

  final String uid;
  final String name;
  final String masjidId;
  final String masjidName;

  /// How far from the masjid they were when they volunteered.
  final double distanceM;
  final DateTime? createdAt;

  factory MasjidEditor.fromMap(Map<String, dynamic> m, {DateTime? createdAt}) =>
      MasjidEditor(
        uid: (m['uid'] ?? '') as String,
        name: (m['name'] ?? '') as String,
        masjidId: (m['masjidId'] ?? '') as String,
        masjidName: (m['masjidName'] ?? '') as String,
        distanceM: ((m['distanceM'] ?? 0) as num).toDouble(),
        createdAt: createdAt,
      );
}

enum ReportReason {
  wrongTime,
  wrongLocation,
  wrongInfo,
  closed,
  duplicate,
  other,
}

/// "This masjid's times are wrong" – one open report per user and masjid.
class MasjidReport {
  const MasjidReport({
    required this.id,
    required this.masjidId,
    required this.masjidName,
    required this.district,
    required this.uid,
    required this.userName,
    required this.reason,
    required this.note,
    required this.open,
    this.createdAt,
  });

  final String id;
  final String masjidId;
  final String masjidName;
  final String district;
  final String uid;
  final String userName;
  final ReportReason reason;
  final String note;
  final bool open;
  final DateTime? createdAt;

  static String idFor(String masjidId, String uid) => '${masjidId}_$uid';

  factory MasjidReport.fromMap(
    String id,
    Map<String, dynamic> m, {
    DateTime? createdAt,
  }) => MasjidReport(
    id: id,
    masjidId: (m['masjidId'] ?? '') as String,
    masjidName: (m['masjidName'] ?? '') as String,
    district: (m['district'] ?? '') as String,
    uid: (m['uid'] ?? '') as String,
    userName: (m['userName'] ?? '') as String,
    reason: ReportReason.values.asNameMap()[m['reason']] ?? ReportReason.other,
    note: (m['note'] ?? '') as String,
    open: m['status'] == 'open',
    createdAt: createdAt,
  );
}

/// One change to a masjid's times, staff or maktab – kept so the admin can
/// see who changed what, and put it back.
class MasjidEdit {
  const MasjidEdit({
    required this.id,
    required this.masjidId,
    required this.masjidName,
    required this.uid,
    required this.name,
    required this.field,
    required this.before,
    required this.after,
    this.at,
  });

  final String id;
  final String masjidId;
  final String masjidName;
  final String uid;
  final String name;

  /// `jamat`, `staff` or `maktab`.
  final String field;
  final Map<String, dynamic> before;
  final Map<String, dynamic> after;
  final DateTime? at;

  factory MasjidEdit.fromMap(
    String id,
    Map<String, dynamic> m, {
    DateTime? at,
  }) => MasjidEdit(
    id: id,
    masjidId: (m['masjidId'] ?? '') as String,
    masjidName: (m['masjidName'] ?? '') as String,
    uid: (m['uid'] ?? '') as String,
    name: (m['name'] ?? '') as String,
    field: (m['field'] ?? '') as String,
    before: Map<String, dynamic>.from((m['before'] as Map?) ?? const {}),
    after: Map<String, dynamic>.from((m['after'] as Map?) ?? const {}),
    at: at,
  );
}

/// Totals for the admin report.
class AdminStats {
  const AdminStats({
    required this.masjids,
    required this.withTimes,
    required this.editors,
    required this.openReports,
    required this.pending,
  });

  final int masjids;
  final int withTimes;
  final int editors;
  final int openReports;
  final int pending;
}

/// One district in the admin report: masjids, and how many have times.
typedef DistrictCoverage = ({String district, int masjids, int withTimes});

/// "This masjid is missing": a user pinned it on the map; the admin adds it.
class MasjidSuggestion {
  const MasjidSuggestion({
    required this.id,
    required this.name,
    required this.nameBn,
    required this.lat,
    required this.lng,
    required this.district,
    required this.thana,
    required this.uid,
    required this.userName,
    this.createdAt,
  });

  final String id;
  final String name;
  final String nameBn;
  final double lat;
  final double lng;
  final String district;
  final String thana;
  final String uid;
  final String userName;
  final DateTime? createdAt;

  Map<String, dynamic> toMap() => {
    'name': name,
    'nameBn': nameBn,
    'lat': lat,
    'lng': lng,
    'district': district,
    'thana': thana,
    'uid': uid,
    'userName': userName,
    'status': 'open',
  };

  factory MasjidSuggestion.fromMap(
    String id,
    Map<String, dynamic> m, {
    DateTime? createdAt,
  }) => MasjidSuggestion(
    id: id,
    name: (m['name'] ?? '') as String,
    nameBn: (m['nameBn'] ?? '') as String,
    lat: ((m['lat'] ?? 0) as num).toDouble(),
    lng: ((m['lng'] ?? 0) as num).toDouble(),
    district: (m['district'] ?? '') as String,
    thana: (m['thana'] ?? '') as String,
    uid: (m['uid'] ?? '') as String,
    userName: (m['userName'] ?? '') as String,
    createdAt: createdAt,
  );
}
