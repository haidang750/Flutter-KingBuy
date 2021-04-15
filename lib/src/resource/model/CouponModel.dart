class CouponModel {
  CouponModel({
    this.status,
    this.data,
  });

  int status;
  CouponData data;

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        status: json["status"],
        data: CouponData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class CouponData {
  CouponData({
    this.nonUse,
    this.used,
    this.expired,
  });

  TypeCoupon nonUse;
  TypeCoupon used;
  TypeCoupon expired;

  factory CouponData.fromJson(Map<String, dynamic> json) => CouponData(
        nonUse: TypeCoupon.fromJson(json["non_use"]),
        used: TypeCoupon.fromJson(json["used"]),
        expired: TypeCoupon.fromJson(json["expired"]),
      );

  Map<String, dynamic> toJson() => {
        "non_use": nonUse.toJson(),
        "used": used.toJson(),
        "expired": expired.toJson(),
      };
}

class TypeCoupon {
  TypeCoupon({
    this.count,
    this.coupons,
  });

  int count;
  List<Coupon> coupons;

  factory TypeCoupon.fromJson(Map<String, dynamic> json) => TypeCoupon(
        count: json["count"],
        coupons: List<Coupon>.from(json["rows"].map((x) => Coupon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "rows": List<dynamic>.from(coupons.map((x) => x.toJson())),
      };
}

class Coupon {
  Coupon({
    this.id,
    this.name,
    this.description,
    this.applyTarget,
    this.type,
    this.invoiceStatus,
    this.invoiceTotal,
    this.percentOff,
    this.maxSale,
    this.salePrice,
    this.status,
    this.expiresAt,
    this.imageSource,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String description;
  int applyTarget;
  int type;
  int invoiceStatus;
  int invoiceTotal;
  int percentOff;
  int maxSale;
  dynamic salePrice;
  int status;
  DateTime expiresAt;
  String imageSource;
  DateTime createdAt;
  DateTime updatedAt;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        applyTarget: json["apply_target"],
        type: json["type"],
        invoiceStatus: json["invoice_status"],
        invoiceTotal: json["invoice_total"],
        percentOff: json["percent_off"],
        maxSale: json["max_sale"],
        salePrice: json["sale_price"],
        status: json["status"],
        expiresAt: DateTime.parse(json["expires_at"]),
        imageSource: json["image_source"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "apply_target": applyTarget,
        "type": type,
        "invoice_status": invoiceStatus,
        "invoice_total": invoiceTotal,
        "percent_off": percentOff,
        "max_sale": maxSale,
        "sale_price": salePrice,
        "status": status,
        "expires_at":
            "${expiresAt.year.toString().padLeft(4, '0')}-${expiresAt.month.toString().padLeft(2, '0')}-${expiresAt.day.toString().padLeft(2, '0')}",
        "image_source": imageSource,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
