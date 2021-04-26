import 'package:dio/dio.dart';
import 'package:projectui/src/resource/model/BrandModel.dart';
import 'package:projectui/src/resource/model/CategoryModel.dart';
import 'package:projectui/src/resource/model/ProductModel.dart';
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
          status: response.statusCode,
          response: NetworkResponse.fromJson(response.data, converter: (data) => CategoryModel.fromJson(data)));
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
          status: response.statusCode,
          response: NetworkResponse.fromJson(response.data, converter: (data) => CategoryModel.fromJson(data)));
    } on DioError catch (e) {
      return NetworkState.withError(e);
    }
  }

  Future<NetworkState<ProductModel>> getProductsByCategory(
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
          converter: (data) => ProductModel.fromJson(data),
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
}
