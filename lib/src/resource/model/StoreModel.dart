class StoreModel {
  StoreModel({
    this.status,
    this.store,
  });

  int status;
  List<Store> store;

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    status: json["status"],
    store: List<Store>.from(json["data"].map((x) => Store.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(store.map((x) => x.toJson())),
  };
}

class Store {
  Store({
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

  factory Store.fromJson(Map<String, dynamic> json) => Store(
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
