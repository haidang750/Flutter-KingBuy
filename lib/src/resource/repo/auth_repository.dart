import 'package:dio/dio.dart';
import 'package:projectui/src/resource/model/ContactModel.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:projectui/src/resource/model/DistrictModel.dart';
import 'package:projectui/src/resource/model/LoginModel.dart';
import 'package:projectui/src/resource/model/NotificationModel.dart';
import 'package:projectui/src/resource/model/OrderHistoryModel.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/ProvinceModel.dart';
import 'package:projectui/src/resource/model/WardModel.dart';
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

      print("data: ${response.data}");
      NetworkState<LoginData> result = NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => LoginData.fromJson(data),
        ),
      );
      print(
          "State.data: ${result.isSuccess} - ${result.isError} - ${result.data.token}");
      if (result.isSuccess && !result.isError && result.data.token != null) {
        await AppShared.setAccessToken(result.data.token);
        return result;
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

  Future<NetworkState<ProvinceModel>> getProvince() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(AppEndpoint.GET_PROVINCE);
      print("Province Data: ${response.data}");

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => ProvinceModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<DistrictModel>> getDistrict(String provinceCode) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response =
          await AppClients().get(AppEndpoint.GET_DISTRICT + "/$provinceCode");

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => DistrictModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<WardModel>> getWard(String districtCode) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response =
          await AppClients().get(AppEndpoint.GET_WARD + "/$districtCode");

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => WardModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<AddressModel>> getDeliveryAddress() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response =
          await AppClients().get(AppEndpoint.GET_DELIVERY_ADDRESS,
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => AddressModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<AddressModel>> createDeliveryAddress(
      String fullName,
      String firstPhone,
      String secondPhone,
      String provinceCode,
      String districtCode,
      String wardCode,
      String address,
      int isDefault,
      int isExportInvoice,
      String taxCode,
      String companyName,
      String companyAddress,
      String companyEmail) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      FormData data = FormData.fromMap({
        "fullname": fullName,
        "first_phone": firstPhone,
        "second_phone": secondPhone,
        "province_code": provinceCode,
        "district_code": districtCode,
        "ward_code": wardCode,
        "address": address,
        "is_default": isDefault,
        "is_export_invoice": isExportInvoice,
        "tax_code": taxCode,
        "company_name": companyName,
        "company_address": companyAddress,
        "company_email": companyEmail
      });
      Response response =
          await AppClients().post(AppEndpoint.CREATE_DELIVERY_ADDRESS,
              data: data,
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));
      print("Response: $response");
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => AddressModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<AddressModel>> updateDeliveryAddress(
      int deliveryAddressId,
      String fullName,
      String firstPhone,
      String secondPhone,
      String provinceCode,
      String districtCode,
      String wardCode,
      String address,
      int isDefault,
      int isExportInvoice,
      String taxCode,
      String companyName,
      String companyAddress,
      String companyEmail) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      FormData data = FormData.fromMap({
        "delivery_address_id": deliveryAddressId,
        "fullname": fullName,
        "first_phone": firstPhone,
        "second_phone": secondPhone,
        "province_code": provinceCode,
        "district_code": districtCode,
        "ward_code": wardCode,
        "address": address,
        "is_default": isDefault,
        "is_export_invoice": isExportInvoice,
        "tax_code": taxCode,
        "company_name": companyName,
        "company_address": companyAddress,
        "company_email": companyEmail
      });
      Response response =
          await AppClients().post(AppEndpoint.UPDATE_DELIVERY_ADDRESS,
              data: data,
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));
      print("Response: $response");
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => AddressModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<AddressModel>> deleteDeliveryAddress(
    int deliveryAddressId,
  ) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      FormData data = FormData.fromMap({
        "delivery_address_id": deliveryAddressId,
      });
      Response response =
          await AppClients().post(AppEndpoint.DELETE_DELIVERY_ADDRESS,
              data: data,
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));
      print("Response: $response");
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => AddressModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<ListProductsModel>> getViewedProducts(
      int limit, int offset) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response =
          await AppClients().get(AppEndpoint.GET_VIEWED_PRODUCTS,
              queryParameters: {"limit": limit, "offset": offset},
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));
      print("Response: $response");
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => ListProductsModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<int>> getCountNotification() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response =
          await AppClients().get(AppEndpoint.GET_COUNT_NOTIFICATION,
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));
      print("Count Notification: ${response.data["data"]}");
      return NetworkState(
          status: response.statusCode,
          response: NetworkResponse(data: response.data["data"]));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<NotificationModel>> getListNotification(
      int limit, int offset) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response =
          await AppClients().get(AppEndpoint.GET_LIST_NOTIFICATION,
              queryParameters: {"limit": limit, "offset": offset},
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));
      print("Response: $response");
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => NotificationModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<OrderHistoryModel>> getOrderHistory(
      int filter, int limit, int offset) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response = await AppClients().get(AppEndpoint.GET_ORDER_HISTORY,
          queryParameters: {"filter": filter, "limit": limit, "offset": offset},
          options: Options(headers: {
            "${AppEndpoint.keyAuthorization}": "Bearer $token",
          }));

      NetworkState<OrderHistoryModel> result = NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => OrderHistoryModel.fromJson(data),
        ),
      );

      if (result.isSuccess) {
        print("recordsTotal: ${result.data.recordsTotal}");
        return result;
      } else
        throw DioErrorType.cancel;
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<bool>> checkFeedbackOfUser() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response =
          await AppClients().get(AppEndpoint.CHECK_FEEDBACK_OF_USER,
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));

      return NetworkState(
          status: response.statusCode,
          response: NetworkResponse(data: response.data["data"]));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<String>> userSendContact(String fullName, String email,
      String phone, String subject, String body) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      FormData data = FormData.fromMap({
        "fullname": fullName,
        "email": email,
        "phone": phone,
        "subject": subject,
        "body": body
      });
      Response response =
          await AppClients().post(AppEndpoint.USER_SEND_CONTACT_FORM,
              data: data,
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));

      return NetworkState(
          status: response.statusCode,
          response: NetworkResponse(data: response.data["message"]));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState> getAllFeedback() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response = await AppClients().get(AppEndpoint.GET_ALL_FEEDBACK,
          options: Options(headers: {
            "${AppEndpoint.keyAuthorization}": "Bearer $token",
          }));

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => ContactModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState> userReplyFeedback(String contentRep) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      FormData data = FormData.fromMap({"contentRep": contentRep});
      Response response =
          await AppClients().post(AppEndpoint.USER_REPLY_FEEDBACK,
              data: data,
              options: Options(headers: {
                "${AppEndpoint.keyAuthorization}": "Bearer $token",
              }));

      return NetworkState(
          status: response.statusCode,
          response: NetworkResponse(data: response.data["status"]));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<int>> sendRequestLogout() async {
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
          status: response.statusCode,
          response: NetworkResponse(data: response.data["status"]));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }
}
