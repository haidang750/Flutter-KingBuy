class CheckCouponModel {
  CheckCouponModel({
    this.status,
    this.checkCoupon,
    this.message,
  });

  int status;
  CheckCoupon checkCoupon;
  String message;

  factory CheckCouponModel.fromJson(Map<String, dynamic> json) => CheckCouponModel(
    status: json["status"],
    checkCoupon: CheckCoupon.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": checkCoupon.toJson(),
    "message": message,
  };
}

class CheckCoupon {
  CheckCoupon({
    this.type,
    this.discount,
  });

  int type;
  int discount;

  factory CheckCoupon.fromJson(Map<String, dynamic> json) => CheckCoupon(
    type: json["type"],
    discount: json["discount"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "discount": discount,
  };
}
