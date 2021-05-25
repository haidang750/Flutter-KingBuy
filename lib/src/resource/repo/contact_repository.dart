import 'dart:convert';
import 'package:http/http.dart' show Client, Response;

class ContactRepository {
  final contactApiProvider = ContactApiProvider();
  Future<List<dynamic>> getContactInfo() =>
      contactApiProvider._getContactInfo();
}

class ContactApiProvider {
  Client client = Client();
  Response response;

  final String url = "https://kingbuy.vn/api/contactUs";

  Future<List<dynamic>> _getContactInfo() async {
    response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      if (json.decode(response.body)["status"] == 1) {
        print(json.decode(response.body)["data"]);
        return json.decode(response.body)["data"];
      } else {
        print("Get thông tin liên hệ không thành công!");
      }
    } else {
      throw Exception("Network Error!");
    }
  }
}
