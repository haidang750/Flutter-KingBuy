class NotificationModel {
  NotificationModel({
    this.notifications,
    this.recordsTotal,
  });

  List<Notification> notifications;
  int recordsTotal;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notifications: List<Notification>.from(
            json["notifications"].map((x) => Notification.fromJson(x))),
        recordsTotal: json["recordsTotal"],
      );

  Map<String, dynamic> toJson() => {
        "notifications":
            List<dynamic>.from(notifications.map((x) => x.toJson())),
        "recordsTotal": recordsTotal,
      };
}

class Notification {
  Notification({
    this.title,
    this.description,
    this.content,
    this.slug,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String title;
  String description;
  String content;
  String slug;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        title: json["title"],
        description: json["description"],
        content: json["content"],
        slug: json["slug"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "content": content,
        "slug": slug,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
