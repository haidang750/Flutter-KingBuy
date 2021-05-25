class Shop {
  Shop({
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

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
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
