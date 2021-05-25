import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';
import 'profile.dart';
import 'shop.dart';

class LoginModel {
  LoginModel({
    this.status,
    this.loginData,
    this.message,
  });

  int status;
  LoginData loginData;
  String message;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        loginData: LoginData.fromJson(json["data"]),
        message: json["message"],
      );
}

class LoginData {
  LoginData({this.token, this.data});

  String token;
  Data data;

  static Future<bool> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
      token: json["token"],
      data: Data(
        profile: Profile.fromJson(json["profile"]),
        shop: List<Shop>.from(json["shop"].map((x) => Shop.fromJson(x))),
        memberCardNumber: json["member_card_number"],
        rewardPoints: json["reward_points"],
      ));

  Map<String, dynamic> toJson() => {
        "profile": data.profile.toJson(),
        "token": token,
        "shop": List<dynamic>.from(data.shop.map((x) => x.toJson())),
        "member_card_number": data.memberCardNumber,
        "reward_points": data.rewardPoints,
      };
}
