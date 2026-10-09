import 'hm.dart';
import 'prayer.dart';

enum MasjidStatus { pending, approved, rejected, suspended }

enum SubmitterRole { committee, khadem, muazzin, imam, khatib }

enum StaffRole { khatib, imam, muazzin }

class StaffMember {
  const StaffMember({required this.name, required this.phone});

  final String name;
  final String phone;

  bool get isEmpty => name.trim().isEmpty;

  factory StaffMember.fromMap(Map<String, dynamic>? m) => StaffMember(
    name: (m?['name'] ?? '') as String,
    phone: (m?['phone'] ?? '') as String,
  );

  Map<String, dynamic> toMap() => {'name': name, 'phone': phone};
}

class Maktab {
  const Maktab({this.days = const [], this.morning, this.evening});

  /// [DateTime.weekday] values (1 = Monday … 7 = Sunday).
  final List<int> days;
  final HMRange? morning;
  final HMRange? evening;

  bool get isEmpty => morning == null && evening == null;

  factory Maktab.fromMap(Map<String, dynamic>? m) => Maktab(
    days: ((m?['days'] as List?) ?? const [])
        .map((e) => (e as num).toInt())
        .toList(),
    morning: HMRange.tryParse(m?['morning']),
    evening: HMRange.tryParse(m?['evening']),
  );

  Map<String, dynamic> toMap() => {
    'days': days,
    'morning': morning?.toStorage(),
    'evening': evening?.toStorage(),
  };
}

class Masjid {
  const Masjid({
    required this.id,
    required this.name,
    this.nameBn = '',
    required this.address,
    required this.district,
    required this.thana,
    required this.lat,
    required this.lng,
    required this.status,
    required this.ownerUid,
    this.ownerPhone = '',
    this.phoneVerified = true,
    this.nid = '',
    this.submitterRole = SubmitterRole.committee,
    this.locationAccuracyM = 0,
    this.locationSource = 'gps',
    this.jamat = const {},
    this.jamatUpdatedAt,
    this.maktab = const Maktab(),
    this.staff = const {},
    this.liveUrl,
    this.isLive = false,
    this.createdAt,
    this.reviewedAt,
    this.rejectionReason,
    this.updatedByName = '',
    this.imported = false,
  });

  final String id;
  final String name;

  /// Optional Bangla name, shown when the UI is in Bangla.
  final String nameBn;
  final String address;
  final String district;
  final String thana;
  final double lat;
  final double lng;
  final MasjidStatus status;
  final String ownerUid;
  final String ownerPhone;

  /// False for beta registrations that skipped SMS OTP.
  final bool phoneVerified;
  final String nid;
  final SubmitterRole submitterRole;
  final double locationAccuracyM;

  /// How the location was set: 'gps' (on site) or 'map' (pinned on a map).
  final String locationSource;
  final Map<Prayer, HM> jamat;
  final DateTime? jamatUpdatedAt;
  final Maktab maktab;
  final Map<StaffRole, StaffMember> staff;
  final String? liveUrl;
  final bool isLive;
  final DateTime? createdAt;
  final DateTime? reviewedAt;
  final String? rejectionReason;

  /// Who last changed the times, staff or maktab (an editor, the owner…).
  final String updatedByName;

  /// Added from OpenStreetMap by the admin, not registered by the masjid.
  final bool imported;

  String displayName(bool bangla) =>
      bangla && nameBn.trim().isNotEmpty ? nameBn : name;

  String get fullAddress =>
      [address, thana, district].where((s) => s.trim().isNotEmpty).join(', ');

  /// Next jamat from [now] (today, or tomorrow's Fajr). Friday uses Jum'ah instead of Duhr.
  /// Jamat of the current waqt [prayer] (as in the Home header), even if it
  /// has already started; Jum'ah falls back to Dhuhr where no Jum'ah time is
  /// set. Without a waqt (or a time for it) – the next jamat.
  ({Prayer prayer, DateTime at})? jamatForWaqt(Prayer? prayer, DateTime now) {
    var p = prayer;
    if (p == Prayer.jumuah && jamat[Prayer.jumuah] == null) p = Prayer.dhuhr;
    final t = p == null ? null : jamat[p];
    if (p == null || t == null) return nextJamat(now);
    return (prayer: p, at: t.on(now));
  }

  ({Prayer prayer, DateTime at})? nextJamat(DateTime now) {
    for (var dayOffset = 0; dayOffset < 2; dayOffset++) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(days: dayOffset));
      for (final p in PrayerX.daily) {
        var prayer = p;
        if (p == Prayer.dhuhr &&
            day.weekday == DateTime.friday &&
            jamat[Prayer.jumuah] != null) {
          prayer = Prayer.jumuah;
        }
        final t = jamat[prayer];
        if (t == null) continue;
        final at = t.on(day);
        if (at.isAfter(now)) return (prayer: prayer, at: at);
      }
    }
    return null;
  }

  Masjid copyWith({
    String? name,
    String? nameBn,
    String? address,
    String? district,
    String? thana,
    MasjidStatus? status,
    Map<Prayer, HM>? jamat,
    DateTime? jamatUpdatedAt,
    Maktab? maktab,
    Map<StaffRole, StaffMember>? staff,
    String? liveUrl,
    bool? isLive,
    String? rejectionReason,
    DateTime? reviewedAt,

    /// (lat, lng, accuracy in m).
    (double, double, double)? location,
    String? locationSource,
  }) => Masjid(
    id: id,
    name: name ?? this.name,
    nameBn: nameBn ?? this.nameBn,
    address: address ?? this.address,
    district: district ?? this.district,
    thana: thana ?? this.thana,
    lat: location?.$1 ?? lat,
    lng: location?.$2 ?? lng,
    status: status ?? this.status,
    ownerUid: ownerUid,
    ownerPhone: ownerPhone,
    phoneVerified: phoneVerified,
    nid: nid,
    submitterRole: submitterRole,
    locationAccuracyM: location?.$3 ?? locationAccuracyM,
    locationSource: locationSource ?? this.locationSource,
    jamat: jamat ?? this.jamat,
    jamatUpdatedAt: jamatUpdatedAt ?? this.jamatUpdatedAt,
    maktab: maktab ?? this.maktab,
    staff: staff ?? this.staff,
    liveUrl: liveUrl ?? this.liveUrl,
    isLive: isLive ?? this.isLive,
    createdAt: createdAt,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    rejectionReason: rejectionReason ?? this.rejectionReason,
    updatedByName: updatedByName,
    imported: imported,
  );

  static Map<Prayer, HM> jamatFromMap(Map<String, dynamic>? m) => {
    for (final p in Prayer.values) p: ?HM.tryParse(m?[p.name]),
  };

  static Map<String, dynamic> jamatToMap(Map<Prayer, HM> j) => {
    for (final e in j.entries) e.key.name: e.value.toStorage(),
  };

  static Map<StaffRole, StaffMember> staffFromMap(Map<String, dynamic>? m) => {
    for (final r in StaffRole.values)
      if (m?[r.name] is Map)
        r: StaffMember.fromMap(Map<String, dynamic>.from(m![r.name] as Map)),
  };

  static Map<String, dynamic> staffToMap(Map<StaffRole, StaffMember> s) => {
    for (final e in s.entries) e.key.name: e.value.toMap(),
  };

  /// Shared (de)serialisation. Timestamps are passed in already converted
  /// so this file stays free of Firebase imports.
  factory Masjid.fromMap(
    String id,
    Map<String, dynamic> m, {
    DateTime? createdAt,
    DateTime? jamatUpdatedAt,
    DateTime? reviewedAt,
    required double lat,
    required double lng,
  }) => Masjid(
    id: id,
    name: (m['name'] ?? '') as String,
    nameBn: (m['nameBn'] ?? '') as String,
    address: (m['address'] ?? '') as String,
    district: (m['district'] ?? '') as String,
    thana: (m['thana'] ?? '') as String,
    lat: lat,
    lng: lng,
    status:
        MasjidStatus.values.asNameMap()[m['status']] ?? MasjidStatus.pending,
    ownerUid: (m['ownerUid'] ?? '') as String,
    ownerPhone: (m['ownerPhone'] ?? '') as String,
    phoneVerified: (m['phoneVerified'] ?? true) as bool,
    nid: (m['nid'] ?? '') as String,
    submitterRole:
        SubmitterRole.values.asNameMap()[m['submitterRole']] ??
        SubmitterRole.committee,
    locationAccuracyM: ((m['locationAccuracyM'] ?? 0) as num).toDouble(),
    locationSource: (m['locationSource'] as String?) ?? 'gps',
    jamat: jamatFromMap((m['jamat'] as Map?)?.cast<String, dynamic>()),
    jamatUpdatedAt: jamatUpdatedAt,
    maktab: Maktab.fromMap((m['maktab'] as Map?)?.cast<String, dynamic>()),
    staff: staffFromMap((m['staff'] as Map?)?.cast<String, dynamic>()),
    liveUrl: m['liveUrl'] as String?,
    isLive: (m['isLive'] ?? false) as bool,
    createdAt: createdAt,
    reviewedAt: reviewedAt,
    rejectionReason: m['rejectionReason'] as String?,
    updatedByName: (m['updatedByName'] ?? '') as String,
    imported: m['source'] == 'osm',
  );

  /// Fields common to every backend (geo & timestamps are added by the backend).
  Map<String, dynamic> toMap() => {
    'name': name,
    'nameLower': name.toLowerCase(),
    'nameBn': nameBn,
    'address': address,
    'district': district,
    'thana': thana,
    'status': status.name,
    'ownerUid': ownerUid,
    'ownerPhone': ownerPhone,
    'phoneVerified': phoneVerified,
    'nid': nid,
    'submitterRole': submitterRole.name,
    'locationAccuracyM': locationAccuracyM,
    'locationSource': locationSource,
    'agreedToTerms': true,
    'jamat': jamatToMap(jamat),
    'hasJamat': jamat.isNotEmpty,
    'maktab': maktab.toMap(),
    'staff': staffToMap(staff),
    'liveUrl': liveUrl,
    'isLive': isLive,
    'rejectionReason': rejectionReason,
  };
}
