class ProvinceModel {
  ProvinceModel({
    this.provinces,
  });

  List<Province> provinces;

  factory ProvinceModel.fromJson(List<dynamic> provinces) {
    return ProvinceModel(
        provinces: provinces
            .map((province) =>
                Province(code: province["code"], name: province["name"]))
            .toList());
  }
}

class Province {
  Province({
    this.code,
    this.name,
  });

  String code;
  String name;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
      };
}
