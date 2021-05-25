class MemberCardModel {
  MemberCardModel({
    this.status,
    this.memberCard,
  });

  int status;
  MemberCard memberCard;

  factory MemberCardModel.fromJson(Map<String, dynamic> json) => MemberCardModel(
    status: json["status"],
    memberCard: MemberCard.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": memberCard.toJson(),
  };
}

class MemberCard {
  MemberCard({
    this.memberCardNumber,
    this.couponNoneUse,
  });

  String memberCardNumber;
  CouponNoneUse couponNoneUse;

  factory MemberCard.fromJson(Map<String, dynamic> json) => MemberCard(
    memberCardNumber: json["member_card_number"],
    couponNoneUse: CouponNoneUse.fromJson(json["coupon_none_use"]),
  );

  Map<String, dynamic> toJson() => {
    "member_card_number": memberCardNumber,
    "coupon_none_use": couponNoneUse.toJson(),
  };
}

class CouponNoneUse {
  CouponNoneUse({
    this.count,
    this.rows,
  });

  int count;
  List<dynamic> rows;

  factory CouponNoneUse.fromJson(Map<String, dynamic> json) => CouponNoneUse(
    count: json["count"],
    rows: List<dynamic>.from(json["rows"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "rows": List<dynamic>.from(rows.map((x) => x)),
  };
}
