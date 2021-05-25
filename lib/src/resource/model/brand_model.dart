class BrandModel {
  BrandModel({
    this.brands,
  });

  List<Brand> brands;

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
  };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.imageSource,
    this.content,
    this.slug,
    this.displayOrder,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String imageSource;
  String content;
  String slug;
  int displayOrder;
  DateTime createdAt;
  DateTime updatedAt;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    name: json["name"],
    imageSource: json["image_source"],
    content: json["content"] ?? null,
    slug: json["slug"],
    displayOrder: json["display_order"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_source": imageSource,
    "content": content ?? null,
    "slug": slug,
    "display_order": displayOrder,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
