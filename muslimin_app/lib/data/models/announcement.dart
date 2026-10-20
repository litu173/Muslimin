/// App news sent to every user (firebase/tools/broadcast.mjs) – kept so it
/// also shows on the Notifications page. `type: update` opens About the App.
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;

  bool get isUpdate => type == 'update';
}
