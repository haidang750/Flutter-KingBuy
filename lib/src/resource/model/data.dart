import 'package:flutter/material.dart';
import 'profile.dart';
import 'shop.dart';

class Data with ChangeNotifier {
  Data({
    this.profile,
    this.shop,
    this.memberCardNumber,
    this.rewardPoints,
  });

  Profile profile;
  List<Shop> shop;
  String memberCardNumber;
  int rewardPoints;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        profile: Profile.fromJson(json["profile"]),
        shop: List<Shop>.from(json["shop"].map((x) => Shop.fromJson(x))),
        memberCardNumber: json["member_card_number"],
        rewardPoints: json["reward_points"],
      );

  Map<String, dynamic> toJson() => {
        "profile": profile.toJson(),
        "shop": List<dynamic>.from(shop.map((x) => x.toJson())),
        "member_card_number": memberCardNumber,
        "reward_points": rewardPoints,
      };

  void setData(Profile profile, List<Shop> shop, String memberCardNumber,
      int rewardPoints) {
    this.profile = profile;
    this.shop = shop;
    this.memberCardNumber = memberCardNumber;
    this.rewardPoints = rewardPoints;
    notifyListeners();
  }

  void setProfile(Profile profile) {
    this.profile = profile;
    notifyListeners();
  }

  void setShop(List<Shop> shop) {
    this.shop = shop;
    notifyListeners();
  }

  void setMemberCardNumber(String memberCardNumber) {
    this.memberCardNumber = memberCardNumber;
    notifyListeners();
  }

  void setRewardPoints(int rewardPoints) {
    this.rewardPoints = rewardPoints;
    notifyListeners();
  }
}
