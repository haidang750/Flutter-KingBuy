class ListProductsModel {
  ListProductsModel({
    this.id,
    this.name,
    this.products,
    this.recordsTotal,
  });

  int id;
  String name;
  List<Product> products;
  int recordsTotal;

  factory ListProductsModel.fromJson(Map<String, dynamic> json) => ListProductsModel(
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        recordsTotal: json["recordsTotal"],
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "recordsTotal": recordsTotal,
      };
}

class Product {
  Product({
    this.id,
    this.name,
    this.price,
    this.salePrice,
    this.productCategoryId,
    this.category,
    this.brandId,
    this.giftIds,
    this.imageSource,
    this.imageSourceList,
    this.description,
    this.content,
    this.specifications,
    this.videoLink,
    this.slug,
    this.status,
    this.goodsStatus,
    this.isBulky,
    this.isInstallment,
    this.installmentMonths,
    this.installmentPrepay,
    this.barcode,
    this.createdAt,
    this.updatedAt,
    this.productCategoryName,
    this.brandName,
    this.brandInfo,
    this.saleOff,
    this.gifts,
    this.star,
    this.colors,
  });

  int id;
  String name;
  int price;
  int salePrice;
  int productCategoryId;
  ProductCategory category;
  int brandId;
  List<int> giftIds;
  String imageSource;
  List<String> imageSourceList;
  String description;
  String content;
  String specifications;
  dynamic videoLink;
  String slug;
  int status;
  int goodsStatus;
  int isBulky;
  int isInstallment;
  List<String> installmentMonths;
  List<String> installmentPrepay;
  String barcode;
  String createdAt;
  String updatedAt;
  String productCategoryName;
  String brandName;
  dynamic brandInfo;
  int saleOff;
  List<Gift> gifts;
  int star;
  List<dynamic> colors;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        salePrice: json["sale_price"],
        productCategoryId: json["product_category_id"],
        category: ProductCategory.fromJson(json["category"]),
        brandId: json["brand_id"],
        giftIds: List<int>.from(json["gift_ids"].map((x) => x)),
        imageSource: json["image_source"],
        imageSourceList:
            List<String>.from(json["image_source_list"].map((x) => x)),
        description: json["description"],
        content: json["content"],
        specifications: json["specifications"],
        videoLink: json["video_link"],
        slug: json["slug"],
        status: json["status"],
        goodsStatus: json["goods_status"],
        isBulky: json["is_bulky"],
        isInstallment: json["is_installment"],
        installmentMonths:
            List<String>.from(json["installment_months"].map((x) => x)),
        installmentPrepay:
            List<String>.from(json["installment_prepay"].map((x) => x)),
        barcode: json["barcode"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        productCategoryName: json["product_category_name"],
        brandName: json["brand_name"],
        brandInfo: json["brand_info"],
        saleOff: json["sale_off"],
        gifts: List<Gift>.from(json["gifts"].map((x) => Gift.fromJson(x))),
        star: json["star"],
        colors: List<dynamic>.from(json["colors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "sale_price": salePrice,
        "product_category_id": productCategoryId,
        "category": category.toJson(),
        "brand_id": brandId,
        "gift_ids": List<dynamic>.from(giftIds.map((x) => x)),
        "image_source": imageSource,
        "image_source_list": List<dynamic>.from(imageSourceList.map((x) => x)),
        "description": description,
        "content": content,
        "specifications": specifications,
        "video_link": videoLink,
        "slug": slug,
        "status": status,
        "goods_status": goodsStatus,
        "is_bulky": isBulky,
        "is_installment": isInstallment,
        "installment_months":
            List<dynamic>.from(installmentMonths.map((x) => x)),
        "installment_prepay":
            List<dynamic>.from(installmentPrepay.map((x) => x)),
        "barcode": barcode,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "product_category_name": productCategoryName,
        "brand_name": brandName,
        "brand_info": brandInfo,
        "sale_off": saleOff,
        "gifts": List<dynamic>.from(gifts.map((x) => x.toJson())),
        "star": star,
        "colors": List<dynamic>.from(colors.map((x) => x)),
      };
}

class ProductCategory {
  ProductCategory({
    this.id,
    this.name,
    this.parent,
  });

  int id;
  String name;
  ProductCategory parent;

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
        id: json["id"],
        name: json["name"],
        parent:
            json["parent"] == null ? null : ProductCategory.fromJson(json["parent"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "parent": parent == null ? null : parent.toJson(),
      };
}

class Gift {
  Gift({
    this.id,
    this.name,
    this.price,
    this.imageSource,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  int price;
  String imageSource;
  dynamic description;
  DateTime createdAt;
  DateTime updatedAt;

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        imageSource: json["image_source"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image_source": imageSource,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
