class CategoryModel {
  CategoryModel({
    this.categories,
    this.recordsTotal,
  });

  List<Category> categories;
  int recordsTotal;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    recordsTotal: json["recordsTotal"],
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "recordsTotal": recordsTotal,
  };
}

class Category {
  Category({
    this.id,
    this.name,
    this.imageSource,
    this.iconSource,
    this.backgroundImage,
    this.parentId,
    this.parent,
    this.children,
    this.description,
    this.slug,
    this.videoLink,
  });

  int id;
  String name;
  String imageSource;
  String iconSource;
  String backgroundImage;
  int parentId;
  Parent parent;
  List<Category> children;
  String description;
  String slug;
  String videoLink;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    imageSource: json["image_source"],
    iconSource: json["icon_source"] == null ? null : json["icon_source"],
    backgroundImage: json["background_image"] == null ? null : json["background_image"],
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    parent: json["parent"] == null ? null : Parent.fromJson(json["parent"]),
    children: List<Category>.from(json["children"].map((x) => Category.fromJson(x))),
    description: json["description"] == null ? null : json["description"],
    slug: json["slug"],
    videoLink: json["video_link"] == null ? null : json["video_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_source": imageSource,
    "icon_source": iconSource == null ? null : iconSource,
    "background_image": backgroundImage == null ? null : backgroundImage,
    "parent_id": parentId == null ? null : parentId,
    "parent": parent == null ? null : parent.toJson(),
    "children": List<dynamic>.from(children.map((x) => x.toJson())),
    "description": description == null ? null : description,
    "slug": slug,
    "video_link": videoLink == null ? null : videoLink,
  };
}

class Parent {
  Parent({
    this.id,
    this.name,
    this.slug,
    this.videoLink,
    this.parent,
  });

  int id;
  String name;
  String slug;
  String videoLink;
  dynamic parent;

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    videoLink: json["video_link"],
    parent: json["parent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "video_link": videoLink,
    "parent": parent,
  };
}
