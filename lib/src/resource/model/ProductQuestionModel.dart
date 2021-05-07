class ProductQuestionModel {
  ProductQuestionModel({
    this.questions,
    this.totalRecords,
  });

  List<Question> questions;
  int totalRecords;

  factory ProductQuestionModel.fromJson(Map<String, dynamic> json) => ProductQuestionModel(
        questions: List<Question>.from(json["rows"].map((x) => Question.fromJson(x))),
        totalRecords: json["total_records"],
      );

  Map<String, dynamic> toJson() => {
        "rows": List<dynamic>.from(questions.map((x) => x.toJson())),
        "total_records": totalRecords,
      };
}

class Question {
  Question({
    this.id,
    this.userId,
    this.productId,
    this.content,
    this.status,
    this.type,
    this.isLike,
    this.createdAt,
    this.answers,
  });

  int id;
  int userId;
  int productId;
  String content;
  int status;
  int type;
  int isLike;
  DateTime createdAt;
  List<dynamic> answers;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        content: json["content"],
        status: json["status"],
        type: json["type"],
        isLike: json["is_like"],
        createdAt: DateTime.parse(json["created_at"]),
        answers: List<dynamic>.from(json["answers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "content": content,
        "status": status,
        "type": type,
        "is_like": isLike,
        "created_at": createdAt.toIso8601String(),
        "answers": List<dynamic>.from(answers.map((x) => x)),
      };
}
