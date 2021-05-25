class ContactModel {
  ContactModel({
    this.feedbacks,
    this.titleFirst,
    this.contentFirst,
  });

  List<Feedback> feedbacks;
  String titleFirst;
  String contentFirst;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    feedbacks: List<Feedback>.from(json["feedback"].map((x) => Feedback.fromJson(x))),
    titleFirst: json["titleFirst"],
    contentFirst: json["contentFirst"],
  );

  Map<String, dynamic> toJson() => {
    "feedback": List<dynamic>.from(feedbacks.map((x) => x.toJson())),
    "titleFirst": titleFirst,
    "contentFirst": contentFirst,
  };
}

class Feedback {
  Feedback({
    this.id,
    this.title,
    this.content,
    this.type,
  });

  int id;
  String title;
  String content;
  int type;

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "type": type,
  };
}

