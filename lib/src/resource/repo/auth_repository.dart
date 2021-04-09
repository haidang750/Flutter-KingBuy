import 'package:dio/dio.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:projectui/src/resource/model/LoginModel.dart';
import '../../configs/configs.dart';
import '../../utils/utils.dart';
import '../resource.dart';
import '../model/PromotionModel.dart';

class AuthRepository {
  AuthRepository._();

  static AuthRepository _instance;

  factory AuthRepository() {
    if (_instance == null) _instance = AuthRepository._();
    return _instance;
  }

  Future<NetworkState<LoginData>> sendRequestLogin(
      String email, String password) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    Map<String, dynamic> params = {};
    params.addAll({"identity": email, "password": password});

    try {
      Response response =
          await AppClients().post(AppEndpoint.LOGIN, data: params);

      NetworkState<LoginData> state = NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => LoginData.fromJson(data),
        ),
      );
      print(
          "State.data: ${state.isSuccess} - ${state.isError} - ${state.data.token}");
      if (state.isSuccess && !state.isError && state.data.token != null) {
        await AppShared.setAccessToken(state.data.token);
        return state;
      } else
        throw DioErrorType.cancel;
    } on DioError catch (e) {
      print("DioError: $e");
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<Data>> getProfile() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(AppEndpoint.GET_USER_PROFILE);
      return NetworkState(
          status: response.statusCode,
          response: NetworkResponse.fromJson(response.data,
              converter: (data) => Data.fromJson(data)));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<Data>> updateProfile({
    String name,
    String phoneNumber,
    String dateOfBirth,
    int gender,
    String email,
    String avatarPath,
  }) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();
    try {
      FormData data = FormData.fromMap({
        "name": name,
        "phone_number": phoneNumber,
        "date_of_birth": dateOfBirth,
        "gender": gender,
        "email": email,
        "avatar": avatarPath != null
            ? await MultipartFile.fromFile(avatarPath)
            : null,
      });
      Response response =
          await AppClients().post(AppEndpoint.USER_UPDATE_PROFILE,
              data: data,
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));
      print("Response: $response");
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => Data.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<PromotionModel>> getPromotion(
      int limit, int offset) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(AppEndpoint.GET_PROMOTION,
          queryParameters: {"limit": limit, "offset": offset});
      print("Response: $response");
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => PromotionModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState> sendRequestLogout() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response = await AppClients().get(AppEndpoint.LOGOUT,
          options: Options(headers: {
            "${AppEndpoint.keyAuthorization}": "Bearer $token",
          }));
      print("Status Logout Request: ${response.data["status"]}");
      return NetworkState(
          status: response.data["status"],
          message: response.data["message"],
          response: null);
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }
}
