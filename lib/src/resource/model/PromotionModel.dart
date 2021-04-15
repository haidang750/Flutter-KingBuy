class PromotionModel {
  PromotionModel({
    this.promotions,
    this.recordsTotal,
  });

  List<Promotion> promotions;
  int recordsTotal;

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
        promotions: List<Promotion>.from(
            json["news"].map((x) => Promotion.fromJson(x))),
        recordsTotal: json["recordsTotal"],
      );

  Map<String, dynamic> toJson() => {
        "news": List<dynamic>.from(promotions.map((x) => x.toJson())),
        "recordsTotal": recordsTotal,
      };
}

class Promotion {
  Promotion({
    this.id,
    this.title,
    this.imageSource,
    this.description,
    this.content,
    this.slug,
    this.isAutoSlug,
    this.seoTitle,
    this.seoDescription,
    this.checkPromotion,
    this.status,
    this.isFeatured,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  String imageSource;
  String description;
  String content;
  String slug;
  int isAutoSlug;
  String seoTitle;
  String seoDescription;
  int checkPromotion;
  int status;
  int isFeatured;
  int order;
  DateTime createdAt;
  DateTime updatedAt;

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        id: json["id"],
        title: json["title"],
        imageSource: json["image_source"],
        description: json["description"],
        content: json["content"],
        slug: json["slug"],
        isAutoSlug: json["is_auto_slug"],
        seoTitle: json["seo_title"],
        seoDescription:
            json["seo_description"] == null ? null : json["seo_description"],
        checkPromotion: json["check_promotion"],
        status: json["status"],
        isFeatured: json["is_featured"],
        order: json["order"],
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
        "is_auto_slug": isAutoSlug,
        "seo_title": seoTitle,
        "seo_description": seoDescription == null ? null : seoDescription,
        "check_promotion": checkPromotion,
        "status": status,
        "is_featured": isFeatured,
        "order": order,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
