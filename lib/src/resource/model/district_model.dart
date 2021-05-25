class DistrictModel {
  DistrictModel({
    this.districts,
  });

  List<District> districts;

  factory DistrictModel.fromJson(List<dynamic> districts) => DistrictModel(
      districts: districts
          .map((district) => District(
              code: district["code"],
              nameWithType: district["name_with_type"],
              deliveryStatus: district["delivery_status"],
              shipFeeBulky: district["ship_fee_bulky"],
              shipFeeNotBulky: district["ship_fee_not_bulky"]))
          .toList());
}

class District {
  District({
    this.code,
    this.nameWithType,
    this.deliveryStatus,
    this.shipFeeBulky,
    this.shipFeeNotBulky,
  });

  String code;
  String nameWithType;
  List<dynamic> deliveryStatus;
  int shipFeeBulky;
  int shipFeeNotBulky;

  factory District.fromJson(Map<String, dynamic> json) => District(
        code: json["code"],
        nameWithType: json["name_with_type"],
        deliveryStatus:
            List<dynamic>.from(json["delivery_status"].map((x) => x)),
        shipFeeBulky: json["ship_fee_bulky"],
        shipFeeNotBulky: json["ship_fee_not_bulky"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name_with_type": nameWithType,
        "delivery_status": List<dynamic>.from(deliveryStatus.map((x) => x)),
        "ship_fee_bulky": shipFeeBulky,
        "ship_fee_not_bulky": shipFeeNotBulky,
      };
}
