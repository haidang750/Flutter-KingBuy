import 'package:dio/dio.dart';
import '../../configs/configs.dart';
import 'model.dart';

class NetworkState<T> {
  int status;
  String message;
  NetworkResponse<T> response;

  NetworkState({this.message, this.response, this.status});

  NetworkState.withError(DioError error) {
    try {
      String message;
      int code;
      Response response = error.response;
      if (response != null) {
        code = response.statusCode;
        message = response.data["code"];
      } else {
        code = AppEndpoint.ERROR_SERVER;
        message = "Không thể kết nối đến máy chủ!";
      }
      this.message = message;
      this.status = code;
      this.response = null;
    } catch (e) {}
  }

  NetworkState.withDisconnect() {
    print("=========== DISCONNECT ===========");
    this.message =
        "Mất kết nối internet, vui lòng kiểm tra wifi/3g và thử lại!";
    this.status = AppEndpoint.ERROR_DISCONNECT;
    this.response = null;
  }

  T get data => response?.data;

  bool get isSuccess =>
      status == AppEndpoint.SUCCESS;

  bool get isError =>
      status != AppEndpoint.SUCCESS;
}
