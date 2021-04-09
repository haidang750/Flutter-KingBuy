class AppEndpoint {
  AppEndpoint._();

  static const String BASE_URL = "https://kingbuy.vn";

  static const int connectionTimeout = 1000;
  static const int receiveTimeout = 1000;
  static const String keyAuthorization = "Authorization";

  static const int SUCCESS = 200;
  static const int ERROR_TOKEN = 401;
  static const int ERROR_VALIDATE = 422;
  static const int ERROR_SERVER = 500;
  static const int ERROR_DISCONNECT = -1;

  static const String LOGIN = "/api/loginApp";
  static const String LOGOUT = "/api/logoutApp";
  static const String GET_USER_PROFILE = "/api/getProfileOfUser";
  static const String USER_UPDATE_PROFILE = "/api/updateInfoOfUser";
  static const String GET_PROMOTION = "/api/getAllPromotion";
}
