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
  static const String UPDATE_PASSWORD = "/api/updatePassword";
  static const String GET_MEMBER_CARD_DETAIL = "/api/getMemberCardDetail";
  static const String GET_COUNT_NOTIFICATION = "/api/countNotification";
  static const String GET_LIST_NOTIFICATION = "/api/listNotification";
  static const String GET_ORDER_HISTORY = "/api/listBuyHistoryOfUser";
  static const String CHECK_FEEDBACK_OF_USER = "/api/checkFeedbackOfUser";
  static const String USER_SEND_CONTACT_FORM = "/api/userSendContactForm";
  static const String GET_ALL_FEEDBACK = "/api/getAllFeedback";
  static const String USER_REPLY_FEEDBACK = "/api/userReplyFeedback";
  static const String GET_HOT_CATEGORIES = "/api/getHotCategories";
  static const String GET_ALL_CATEGORIES = "/api/getAllCategories";
  static const String GET_PRODUCTS_BY_CATEGORY = "/api/getProductsByCategory";
  static const String GET_BRANDS = "/api/getBrands";
  static const String SEARCH_PRODUCT = "/api/searchProduct";
  static const String GET_SINGLE_PRODUCT = "/api/getSingleProduct";
  static const String RATING_INFO_BY_PRODUCT = "/api/ratingInfoByProduct";
  static const String USER_RATING_PRODUCT = "/api/userRatingProduct";
  static const String GET_REVIEW_BY_PRODUCT = "/api/getReviewByProduct";
  static const String GET_PRODUCT_QUESTIONS = "/api/getProductQuestions";
  static const String REQUEST_ANSWER_QUESTION = "/api/requestAnswerQuestion";
  static const String PURCHASED_TOGETHER_PRODUCTS = "/api/purchasedTogetherProducts";
  static const String RELATED_PRODUCT = "/api/relatedProduct";
  static const String GET_PRODUCTS_BY_IDS = "/api/getProductsByIds";
  static const String GET_BANKS = "/api/banks";
  static const String GET_CREDIT_LIST = "/api/creditList";
  static const String CREATE_INSTALLMENT = "/api/createInstallment";
  static const String DETAIL_INSTALLMENT = "/api/detailInstallment";
  static const String CHECK_COUPON = "/api/checkCoupon";
  static const String CREATE_INVOICE = "/api/createInvoice";
  static const String CREATE_PAYMENT = '/api/createPayment';
  static const String GET_ALL_ADDRESS = "/api/getAllAddress";
  static const String GET_ALL_MY_PROMOTION = "/api/getAllMyPromotion";
  static const String GET_ALL_PRODUCT_NEW = "/api/getAllProductNew";
  static const String GET_ALL_PRODUCT_SELLING = "/api/getAllProductSelling";
  static const String GET_POPUP = "/api/getPopup";
}
