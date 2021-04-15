import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:projectui/src/resource/model/CouponModel.dart';
import 'package:projectui/src/resource/model/LoginModel.dart';
import 'package:projectui/src/utils/app_shared.dart';

class CouponRepository {
  final couponApiProvider = CouponApiProvider();
  Future<CouponData> getAllCoupons() => couponApiProvider._getAllCoupons();
}

class CouponApiProvider {
  Client client = Client();
  Response response;

  final String url = "https://kingbuy.vn/api/getMyCoupons";

  Future<CouponData> _getAllCoupons() async {
    String token = await AppShared.getAccessToken();

    response = await client.get(Uri.parse(url), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)["status"] == 1) {
        return CouponData.fromJson(json.decode(response.body)["data"]);
      } else {
        print("Get danh sách coupon không thành công!");
      }
    } else {
      throw Exception("Network Error!");
    }
  }
}
