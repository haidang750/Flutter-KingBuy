import 'dart:convert';
import 'package:http/http.dart' show Client, Response;

class CommitmentRepository {
  final commitmentApiProvider = CommitmentApiProvider();
  Future<List<dynamic>> fetchCommitmentInfo() =>
      commitmentApiProvider._fetchCommitmentInfo();
}

class CommitmentApiProvider {
  Client client = Client();
  Response response;

  final String url = "https://kingbuy.vn/api/getCommitments";

  // ignore: missing_return
  Future<List<dynamic>> _fetchCommitmentInfo() async {
    response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      if (json.decode(response.body)["status"] == 1) {
        return json.decode(response.body)["data"]["rows"];
      } else {
        print("Get thông tin cam kết App không thành công!");
      }
    } else {
      throw Exception("Network Error!");
    }
  }
}
