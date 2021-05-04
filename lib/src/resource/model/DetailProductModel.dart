import 'ListProductsModel.dart';

class DetailProductModel {
  DetailProductModel({
    this.product,
    this.shopAddress,
    this.rating,
  });

  Product product;
  List<ShopAddress> shopAddress;
  Rating rating;

  factory DetailProductModel.fromJson(Map<String, dynamic> json) => DetailProductModel(
    product: Product.fromJson(json["product"]),
    shopAddress: List<ShopAddress>.from(json["shop_address"].map((x) => ShopAddress.fromJson(x))),
    rating: Rating.fromJson(json["rating"]),
  );

  Map<String, dynamic> toJson() => {
    "product": product.toJson(),
    "shop_address": List<dynamic>.from(shopAddress.map((x) => x.toJson())),
    "rating": rating.toJson(),
  };
}

class Rating {
  Rating({
    this.totalRate,
    this.totalRateUser,
  });

  int totalRate;
  int totalRateUser;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    totalRate: json["totalRate"],
    totalRateUser: json["totalRateUser"],
  );

  Map<String, dynamic> toJson() => {
    "totalRate": totalRate,
    "totalRateUser": totalRateUser,
  };
}

class ShopAddress {
  ShopAddress({
    this.id,
    this.address,
    this.hotLine,
    this.openingHours,
    this.imageSource,
    this.latitude,
    this.longitude,
  });

  int id;
  String address;
  String hotLine;
  String openingHours;
  String imageSource;
  String latitude;
  String longitude;

  factory ShopAddress.fromJson(Map<String, dynamic> json) => ShopAddress(
    id: json["id"],
    address: json["address"],
    hotLine: json["hot_line"],
    openingHours: json["opening_hours"],
    imageSource: json["image_source"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "hot_line": hotLine,
    "opening_hours": openingHours,
    "image_source": imageSource,
    "latitude": latitude,
    "longitude": longitude,
  };
}
