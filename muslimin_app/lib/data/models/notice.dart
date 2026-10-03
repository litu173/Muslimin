enum NoticeCategory {
  janaza,
  recruitment,
  quran,
  mahfil,
  talim,
  tafsir,
  general,
}

class Notice {
  const Notice({
    required this.id,
    required this.masjidId,
    required this.masjidName,
    required this.category,
    required this.title,
    this.details = '',
    this.date,
    this.time,
    this.personName,
    this.fatherName,
    this.diedOn,
    this.address,
    required this.createdAt,
  });

  final String id;
  final String masjidId;
  final String masjidName;
  final NoticeCategory category;
  final String title;
  final String details;

  /// Event date: deadline (recruitment), starting date (classes), janaza date, etc.
  final DateTime? date;

  /// Event time "HH:mm" (janaza time, mahfil time…).
  final String? time;

  // Janaza-specific fields.
  final String? personName;
  final String? fatherName;
  final DateTime? diedOn;
  final String? address;

  final DateTime createdAt;

  factory Notice.fromMap(
    String id,
    Map<String, dynamic> m, {
    required DateTime createdAt,
    DateTime? date,
    DateTime? diedOn,
  }) => Notice(
    id: id,
    masjidId: (m['masjidId'] ?? '') as String,
    masjidName: (m['masjidName'] ?? '') as String,
    category:
        NoticeCategory.values.asNameMap()[m['category']] ??
        NoticeCategory.general,
    title: (m['title'] ?? '') as String,
    details: (m['details'] ?? '') as String,
    time: m['time'] as String?,
    personName: m['personName'] as String?,
    fatherName: m['fatherName'] as String?,
    address: m['address'] as String?,
    date: date,
    diedOn: diedOn,
    createdAt: createdAt,
  );

  Map<String, dynamic> toMap() => {
    'masjidId': masjidId,
    'masjidName': masjidName,
    'category': category.name,
    'title': title,
    'details': details,
    'time': time,
    'personName': personName,
    'fatherName': fatherName,
    'address': address,
  };
}
