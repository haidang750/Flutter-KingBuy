class MyPromotionModel {
  MyPromotionModel({
    this.myPromotions,
    this.recordsTotal,
  });

  List<MyPromotion> myPromotions;
  int recordsTotal;

  factory MyPromotionModel.fromJson(Map<String, dynamic> json) => MyPromotionModel(
        myPromotions: List<MyPromotion>.from(json["promotions"].map((x) => MyPromotion.fromJson(x))),
        recordsTotal: json["recordsTotal"],
      );

  Map<String, dynamic> toJson() => {
        "promotions": List<dynamic>.from(myPromotions.map((x) => x.toJson())),
        "recordsTotal": recordsTotal,
      };
}

class MyPromotion {
  MyPromotion({
    this.id,
    this.title,
    this.imageSource,
    this.description,
    this.content,
    this.slug,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  String imageSource;
  String description;
  String content;
  String slug;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  factory MyPromotion.fromJson(Map<String, dynamic> json) => MyPromotion(
        id: json["id"],
        title: json["title"],
        imageSource: json["image_source"],
        description: json["description"],
        content: json["content"],
        slug: json["slug"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image_source": imageSource,
        "description": description,
        "content": content,
        "slug": slug,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
