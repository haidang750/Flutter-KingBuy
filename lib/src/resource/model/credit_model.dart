class CreditModel {
  CreditModel({
    this.status,
    this.credits,
    this.message,
  });

  int status;
  List<Credit> credits;
  String message;

  factory CreditModel.fromJson(Map<String, dynamic> json) => CreditModel(
        status: json["status"],
        credits: List<Credit>.from(json["data"].map((x) => Credit.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(credits.map((x) => x.toJson())),
        "message": message,
      };
}

class Credit {
  Credit({
    this.id,
    this.name,
    this.imageSource,
  });

  int id;
  String name;
  String imageSource;

  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        id: json["id"],
        name: json["name"],
        imageSource: json["image_source"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_source": imageSource,
      };
}
