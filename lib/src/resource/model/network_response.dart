/// iserror : true
/// code : "Error_TokenInvalidate"
/// data : null

class NetworkResponse<T> {
  bool isError;
  String code;
  T data;

  NetworkResponse({this.isError, this.code, this.data});

  NetworkResponse.fromJson(dynamic json, {converter}) {
    isError = json["iserror"];
    code = json["code"];
    data = converter != null && json["data"] != null
        ? converter(json["data"])
        : json["data"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["iserror"] = isError;
    map["code"] = code;
    map["data"] = data;
    return map;
  }
}
