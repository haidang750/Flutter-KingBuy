import 'package:flutter/material.dart';

class CommentModel with ChangeNotifier {
  CommentModel({
    this.comments,
    this.totalRecords,
  });

  List<Comment> comments;
  int totalRecords;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    comments: List<Comment>.from(json["rows"].map((x) => Comment.fromJson(x))),
    totalRecords: json["total_records"],
  );

  Map<String, dynamic> toJson() => {
    "rows": List<dynamic>.from(comments.map((x) => x.toJson())),
    "total_records": totalRecords,
  };

  setCommentInfo(CommentModel commentInfo){
    this.comments = commentInfo.comments;
    this.totalRecords = commentInfo.totalRecords;
    notifyListeners();
  }
}

class Comment {
  Comment({
    this.id,
    this.userId,
    this.productId,
    this.name,
    this.phoneNumber,
    this.comment,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.star,
    this.avatarSource,
    this.isBuy,
  });

  int id;
  int userId;
  int productId;
  String name;
  String phoneNumber;
  String comment;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  double star;
  String avatarSource;
  int isBuy;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    comment: json["comment"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    star: json["star"] * 1.0,
    avatarSource: json["avatar_source"],
    isBuy: json["is_buy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "name": name,
    "phone_number": phoneNumber,
    "comment": comment,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "star": star,
    "avatar_source": avatarSource,
    "is_buy": isBuy,
  };
}
