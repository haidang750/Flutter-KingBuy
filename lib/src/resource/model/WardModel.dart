class WardModel {
  WardModel({
    this.wards,
  });

  List<Ward> wards;

  factory WardModel.fromJson(List<dynamic> wards) => WardModel(
      wards: wards
          .map((ward) => Ward(
                code: ward["code"],
                nameWithType: ward["name_with_type"],
              ))
          .toList());
}

class Ward {
  Ward({
    this.code,
    this.nameWithType,
  });

  String code;
  String nameWithType;

  factory Ward.fromJson(Map<String, dynamic> json) => Ward(
        code: json["code"],
        nameWithType: json["name_with_type"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name_with_type": nameWithType,
      };
}
