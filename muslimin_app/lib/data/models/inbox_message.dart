/// A message sent to this user personally from the admin website
/// (users/{uid}/inbox). [link] says where its "Open" goes.
class InboxMessage {
  const InboxMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.linkType = '',
    this.linkId = '',
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  /// 'masjid', 'about' or '' (no link).
  final String linkType;
  final String linkId;
}
