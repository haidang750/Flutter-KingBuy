import 'package:dio/dio.dart';
import 'package:projectui/src/resource/model/BankModel.dart';
import 'package:projectui/src/resource/model/BrandModel.dart';
import 'package:projectui/src/resource/model/CategoryModel.dart';
import 'package:projectui/src/resource/model/CommentModel.dart';
import 'package:projectui/src/resource/model/CreditModel.dart';
import 'package:projectui/src/resource/model/DetailProductModel.dart';
import 'package:projectui/src/resource/model/InstallmentDetailModel.dart';
import 'package:projectui/src/resource/model/InstallmentModel.dart';
import 'package:projectui/src/resource/model/InvoiceModel.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/ProductQuestionModel.dart';
import 'package:projectui/src/resource/model/RatingModel.dart';
import 'package:projectui/src/resource/model/SearchedProductModel.dart';
import '../../utils/utils.dart';
import '../resource.dart';
import '../../configs/configs.dart';

class CategoryRepository {
  CategoryRepository._();

  static CategoryRepository _instance;

  factory CategoryRepository() {
    if (_instance == null) _instance = CategoryRepository._();
    return _instance;
  }

  Future<NetworkState<CategoryModel>> getHotCategories() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(AppEndpoint.GET_HOT_CATEGORIES);

      return NetworkState(
          status: response.statusCode, response: NetworkResponse.fromJson(response.data, converter: (data) => CategoryModel.fromJson(data)));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<CategoryModel>> getAllCategories() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(AppEndpoint.GET_ALL_CATEGORIES);

      return NetworkState(
          status: response.statusCode, response: NetworkResponse.fromJson(response.data, converter: (data) => CategoryModel.fromJson(data)));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<ListProductsModel>> getProductsByCategory(
      int productCategoryId, String searchWord, int limit, int offset, int brandId, int priceFrom, int priceTo) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.GET_PRODUCTS_BY_CATEGORY,
        queryParameters: {
          "product_category_id": productCategoryId,
          "searchWord": searchWord,
          "limit": limit,
          "offset": offset,
          "brand_id": brandId,
          "price[from]": priceFrom,
          "price[to]": priceTo
        },
      );
      print("Category: ${response.data["name"]}");
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

  Future<NetworkState<BrandModel>> getBrands() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(AppEndpoint.GET_BRANDS);

      return NetworkState(
          status: response.statusCode, response: NetworkResponse.fromJson(response.data, converter: (data) => BrandModel.fromJson(data)));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<SearchedProductModel>> searchProduct(
      String searchWord, int limit, int offset, int productCategoryId, int brandId, int priceFrom, int priceTo) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.SEARCH_PRODUCT,
        queryParameters: {
          "searchWord": searchWord,
          "limit": limit,
          "offset": offset,
          "product_category_id": productCategoryId,
          "brand_id": brandId,
          "price[from]": priceFrom,
          "price[to]": priceTo
        },
      );
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => SearchedProductModel.fromJson(response.data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<DetailProductModel>> getSingleProduct(int productId) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.GET_SINGLE_PRODUCT,
        queryParameters: {"product_id": productId},
      );
      print("Product: ${response.data["product"]}");
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => DetailProductModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<RatingModel>> ratingInfoByProduct(int productId) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.RATING_INFO_BY_PRODUCT,
        queryParameters: {"product_id": productId},
      );
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => RatingModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<int>> userRatingProduct(int productId, String name, String phoneNumber, String comment, double rating) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response = await AppClients().post(AppEndpoint.USER_RATING_PRODUCT,
          queryParameters: {"product_id": productId, "name": name, "phone_number": phoneNumber, "comment": comment, "rating": rating},
          options: Options(headers: {
            "${AppEndpoint.keyAuthorization}": "Bearer $token",
          }));

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => response.data["status"],
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<CommentModel>> getReviewByProduct(int productId) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.GET_REVIEW_BY_PRODUCT,
        queryParameters: {"product_id": productId},
      );
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => CommentModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<ProductQuestionModel>> getProductQuestions(int productId, int limit, int offset) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.GET_PRODUCT_QUESTIONS,
        queryParameters: {"product_id": productId, "limit": limit, "offset": offset},
      );
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => ProductQuestionModel.fromJson(data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<int>> requestAnswerQuestion(int productId, String content) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response = await AppClients().post(AppEndpoint.REQUEST_ANSWER_QUESTION,
          queryParameters: {"product_id": productId, "content": content, "type": 1},
          options: Options(headers: {
            "${AppEndpoint.keyAuthorization}": "Bearer $token",
          }));

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => response.data["status"],
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<ListProductsModel>> purchasedTogetherProducts(int productId) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.PURCHASED_TOGETHER_PRODUCTS,
        queryParameters: {"product_id": productId, "limit": 10, "offset": 0},
      );
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

  Future<NetworkState<ListProductsModel>> relatedProduct(int productId, int limit, int offset) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.RELATED_PRODUCT + "/$productId",
        queryParameters: {"limit": limit, "offset": offset},
      );
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => ListProductsModel(
            products: List<Product>.from(data.map((x) => Product.fromJson(x))),
          ),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<ListProductsModel>> getProductById(List<int> productIds) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    Map<String, int> queryParameters = {};
    for (int i = 0; i < productIds.length; i++) {
      queryParameters.addAll({"product_ids[$i]": productIds[i]});
    }

    try {
      Response response = await AppClients().get(
        AppEndpoint.GET_PRODUCTS_BY_IDS,
        queryParameters: queryParameters,
      );

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => ListProductsModel(
            products: List<Product>.from(data.map((x) => Product.fromJson(x))),
          ),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<BankModel>> getBanks() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.GET_BANKS,
        queryParameters: {"type": 1},
      );
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => BankModel.fromJson(response.data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<CreditModel>> getCreditList() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(AppEndpoint.GET_CREDIT_LIST);
      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => CreditModel.fromJson(response.data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<InstallmentModel>> createInstallment(
      int productId, int installmentType, int bankId, int installmentCardType, int monthsInstallment, int prepayInstallment) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response = await AppClients().post(AppEndpoint.CREATE_INSTALLMENT,
          queryParameters: {
            "product_id": productId,
            "installment_type": installmentType,
            "bank_id": bankId,
            "installment_card_type": installmentCardType,
            "months_installment": monthsInstallment,
            "prepay_installment": prepayInstallment
          },
          options: Options(headers: {
            "${AppEndpoint.keyAuthorization}": "Bearer $token",
          }));

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => InstallmentModel.fromJson(response.data),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<InstallmentDetailModel>> detailInstallment(int invoiceId) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response = await AppClients().get(AppEndpoint.DETAIL_INSTALLMENT,
          queryParameters: {
            "invoice_id": invoiceId,
          },
          options: Options(headers: {
            "${AppEndpoint.keyAuthorization}": "Bearer $token",
          }));

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => InstallmentDetailModel.fromJson(response.data["data"]["detail"]),
        ),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<CheckCouponModel>> checkCoupon(int couponId, int total) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response = await AppClients().post(AppEndpoint.CHECK_COUPON,
          queryParameters: {"coupon_id": couponId, "total": total},
          options: Options(headers: {
            "${AppEndpoint.keyAuthorization}": "Bearer $token",
          }));

      return NetworkState(
          status: response.statusCode,
          response: NetworkResponse.fromJson(response.data, converter: (data) => CheckCouponModel.fromJson(response.data)));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<InvoiceModel>> createInvoiceToken(
      int deliveryAddressId, int paymentType, int deliveryStatus, String note, int isExportInvoice, int isUsePoint, List<CartItem> cartItems) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();
    List<Map<String, int>> products = [];
    cartItems.forEach((cartItem) {
      products.add({"product_id": cartItem.product.id, "color_id": cartItem.colorId == -1 ? null : cartItem.colorId, "qty": cartItem.qty});
    });
    Map<String, dynamic> params = {};
    params.addAll({
      "delivery_address_id": deliveryAddressId.toString(),
      "payment_type": paymentType.toString(),
      "delivery_status": deliveryStatus.toString(),
      "note": note,
      "is_export_invoice": isExportInvoice.toString(),
      "is_use_point": isUsePoint.toString(),
      "data": products
    });
    print("params: $params");

    try {
      Response response = await AppClients().post(AppEndpoint.CREATE_INVOICE,
          data: params,
          options: Options(headers: {
            "${AppEndpoint.keyAuthorization}": "Bearer $token",
          }));

      print("response: ${response.data}");

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => InvoiceModel.fromJson(response.data),
        ),
      );
    } on DioError catch (e) {
      print("DioError: $e");
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<InvoiceModel>> createInvoiceNotToken(
      int paymentType,
      int deliveryStatus,
      String note,
      String orderPhone,
      String orderPhone2,
      String orderName,
      String provinceCode,
      String districtCode,
      String wardCode,
      String address,
      int isExportInvoice,
      String taxCode,
      String companyName,
      String companyAddress,
      String companyEmail,
      List<CartItem> cartItems) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    List<Map<String, int>> products = [];
    cartItems.forEach((cartItem) {
      products.add({"product_id": cartItem.product.id, "qty": cartItem.qty});
    });
    Map<String, dynamic> params = {};
    params.addAll({
      "payment_type": paymentType.toString(),
      "delivery_status": deliveryStatus.toString(),
      "note": note,
      "order_phone": orderPhone,
      "order_phone_2": orderPhone2,
      "order_name": orderName,
      "province_code": provinceCode,
      "district_code": districtCode,
      "ward_code": wardCode,
      "address": address,
      "is_export_invoice": isExportInvoice.toString(),
      "tax_code": taxCode,
      "company_name": companyName,
      "company_address": companyAddress,
      "company_email": companyEmail,
      "data": products
    });
    print("params: $params");

    try {
      Response response = await AppClients().post(
        AppEndpoint.CREATE_INVOICE,
        data: params,
      );

      print("response: ${response.data}");

      return NetworkState(
        status: response.statusCode,
        response: NetworkResponse.fromJson(
          response.data,
          converter: (data) => InvoiceModel.fromJson(response.data),
        ),
      );
    } on DioError catch (e) {
      print("DioError: $e");
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<PaymentModel>> createPayment(int invoiceId) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();
    String token = await AppShared.getAccessToken();

    try {
      Response response = await AppClients().post(AppEndpoint.CREATE_PAYMENT,
          data: {"invoice_id": invoiceId},
          options: Options(headers: {
            "${AppEndpoint.keyAuthorization}": "Bearer $token",
          }));

      return NetworkState(
          status: response.statusCode, response: NetworkResponse.fromJson(response.data, converter: (data) => PaymentModel.fromJson(response.data)));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<List<Product>>> getAllProductNew(int limit, int offset) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.GET_ALL_PRODUCT_NEW,
        queryParameters: {"limit": limit, "offset": offset},
      );

      return NetworkState(
        status: response.statusCode,
        response:
            NetworkResponse(data: response.data["status"] == 1 ? List<Product>.from(response.data["data"].map((x) => Product.fromJson(x))) : []),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<List<Product>>> getAllProductSelling(int limit, int offset) async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(
        AppEndpoint.GET_ALL_PRODUCT_SELLING,
        queryParameters: {"limit": limit, "offset": offset},
      );

      return NetworkState(
        status: response.statusCode,
        response:
            NetworkResponse(data: response.data["status"] == 1 ? List<Product>.from(response.data["data"].map((x) => Product.fromJson(x))) : []),
      );
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<PopupModel>> getPopup() async {
    bool isDisconnect = await WifiService.isDisconnect();
    if (isDisconnect) return NetworkState.withDisconnect();

    try {
      Response response = await AppClients().get(AppEndpoint.GET_POPUP);

      return NetworkState(
          status: response.statusCode, response: NetworkResponse.fromJson(response.data, converter: (data) => PopupModel.fromJson(response.data)));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }
}
