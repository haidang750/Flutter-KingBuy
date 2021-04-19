class AppEndpoint {
  AppEndpoint._();

  static const String BASE_URL = "https://kingbuy.vn";

  static const int connectionTimeout = 10000;
  static const int receiveTimeout = 10000;
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
  static const String GET_PROVINCE = "/api/getAllProvince";
  static const String GET_DISTRICT = "/api/getDistrictByProvinceCode";
  static const String GET_WARD = "/api/getWardByDistrictCode";
  static const String GET_DELIVERY_ADDRESS = "/api/getDeliveryAddress";
  static const String CREATE_DELIVERY_ADDRESS = "/api/createDeliveryAddress";
  static const String UPDATE_DELIVERY_ADDRESS = "/api/updateDeliveryAddress";
  static const String DELETE_DELIVERY_ADDRESS = "/api/deleteDeliveryAddress";
  static const String GET_VIEWED_PRODUCTS = "/api/getViewedProducts";
  static const String GET_COUNT_NOTIFICATION = "/api/countNotification";
  static const String GET_LIST_NOTIFICATION = "/api/listNotification";
  static const String GET_ORDER_HISTORY = "/api/listBuyHistoryOfUser";
  static const String CHECK_FEEDBACK_OF_USER = "/api/checkFeedbackOfUser";
  static const String USER_SEND_CONTACT_FORM = "/api/userSendContactForm";
  static const String GET_ALL_FEEDBACK = "/api/getAllFeedback";
  static const String USER_REPLY_FEEDBACK = "/api/userReplyFeedback";
}
