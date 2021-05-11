import 'package:dio/dio.dart';
import 'package:projectui/src/resource/model/BankModel.dart';
import 'package:projectui/src/resource/model/BrandModel.dart';
import 'package:projectui/src/resource/model/CategoryModel.dart';
import 'package:projectui/src/resource/model/CommentModel.dart';
import 'package:projectui/src/resource/model/CreditModel.dart';
import 'package:projectui/src/resource/model/DetailProductModel.dart';
import 'package:projectui/src/resource/model/InstallmentDetailModel.dart';
import 'package:projectui/src/resource/model/InstallmentModel.dart';
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
}
