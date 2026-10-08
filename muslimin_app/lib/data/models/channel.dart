/// A masjid's channel: the Imam, Khatib and committee send messages to the
/// people who joined. Only members receive (and can read) messages.
///
/// Roles: the masjid's owner is always an admin. Admins post, delete any
/// message and set members' roles; editors post; members read.
enum ChannelRole { member, editor, admin }

extension ChannelRoleX on ChannelRole {
  bool get canPost => this != ChannelRole.member;
  bool get canManage => this == ChannelRole.admin;
}

class ChannelMember {
  const ChannelMember({
    required this.uid,
    required this.masjidId,
    required this.masjidName,
    required this.name,
    required this.role,
    required this.joinedAt,
  });

  final String uid;
  final String masjidId;

  /// Kept on the membership so "my channels" can be listed without loading
  /// every masjid.
  final String masjidName;
  final String name;
  final ChannelRole role;
  final DateTime joinedAt;

  ChannelMember copyWith({ChannelRole? role}) => ChannelMember(
    uid: uid,
    masjidId: masjidId,
    masjidName: masjidName,
    name: name,
    role: role ?? this.role,
    joinedAt: joinedAt,
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'masjidId': masjidId,
    'masjidName': masjidName,
    'name': name,
    'role': role.name,
  };

  factory ChannelMember.fromMap(Map<String, dynamic> m, DateTime joinedAt) =>
      ChannelMember(
        uid: (m['uid'] ?? '') as String,
        masjidId: (m['masjidId'] ?? '') as String,
        masjidName: (m['masjidName'] ?? '') as String,
        name: (m['name'] ?? '') as String,
        role: ChannelRole.values.asNameMap()[m['role']] ?? ChannelRole.member,
        joinedAt: joinedAt,
      );
}

class ChannelMessage {
  const ChannelMessage({
    required this.id,
    required this.masjidId,
    required this.masjidName,
    required this.text,
    required this.authorUid,
    required this.authorName,
    required this.authorRole,
    required this.createdAt,
  });

  final String id;
  final String masjidId;
  final String masjidName;
  final String text;
  final String authorUid;
  final String authorName;
  final ChannelRole authorRole;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
    'masjidId': masjidId,
    'masjidName': masjidName,
    'text': text,
    'authorUid': authorUid,
    'authorName': authorName,
    'authorRole': authorRole.name,
  };

  factory ChannelMessage.fromMap(
    String id,
    Map<String, dynamic> m,
    DateTime createdAt,
  ) => ChannelMessage(
    id: id,
    masjidId: (m['masjidId'] ?? '') as String,
    masjidName: (m['masjidName'] ?? '') as String,
    text: (m['text'] ?? '') as String,
    authorUid: (m['authorUid'] ?? '') as String,
    authorName: (m['authorName'] ?? '') as String,
    authorRole:
        ChannelRole.values.asNameMap()[m['authorRole']] ?? ChannelRole.admin,
    createdAt: createdAt,
  );
}

/// Longest channel message (also enforced by the Firestore rules).
const kMaxChannelMessage = 2000;
