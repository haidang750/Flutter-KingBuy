import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/model/LoginModel.dart';
import 'package:projectui/src/utils/app_shared.dart';

class AddressRepository {
  final addressApiProvider = AddressApiProvider();
  Future<AddressList> fetchAllAddresses() =>
      addressApiProvider._fetchAllAddresses();
}

class AddressApiProvider {
  Client client = Client();
  Response response;

  final String url = "https://kingbuy.vn/api/getDeliveryAddress";

  Future<AddressList> _fetchAllAddresses() async {
    String token = await AppShared.getAccessToken();

    response = await client.get(Uri.parse(url), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      if (json.decode(response.body)["status"] == 1) {
        return AddressList.fromJson(json.decode(response.body)["data"]);
      } else {
        print(json.decode(response.body)["message"]);
      }
    } else {
      throw Exception("Network Error!");
    }
  }
}
