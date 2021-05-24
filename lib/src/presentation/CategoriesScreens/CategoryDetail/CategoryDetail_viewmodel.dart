import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/BrandModel.dart';
import 'package:projectui/src/resource/model/SearchedProductModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:rxdart/rxdart.dart';
import '../../../resource/model/ListProductsModel.dart';

class CategoryDetailViewModel extends BaseViewModel {
  CategoryDetailViewModel(
      {this.productCategoryId, this.searchWord, this.limit = 10, this.brandId, this.priceFrom = 0, this.priceTo = 1000000000});
  int productCategoryId;
  String searchWord;
  int limit;
  int brandId;
  int priceFrom;
  int priceTo;

  final brandSubject = BehaviorSubject<BrandModel>();

  Stream<BrandModel> get brandStream => brandSubject.stream;

  // Dùng cho GridView Products của mỗi Category
  Future<List<Product>> initRequesterCategoryProduct() async {
    return await loadDataCategoryProduct(0);
  }

  Future<List<Product>> dataRequesterCategoryProduct(int currentSize) async {
    return await loadDataCategoryProduct(currentSize);
  }

  Future<List<Product>> loadDataCategoryProduct(int offset) async {
    NetworkState<ListProductsModel> result =
        await categoryRepository.getProductsByCategory(productCategoryId, searchWord, limit, offset, brandId, priceFrom, priceTo);
    if (result.isSuccess) {
      List<Product> products = result.data.products;
      return products;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return [];
    }
  }

  Future<List<Brand>> getBrands() async {
    NetworkState<BrandModel> result = await categoryRepository.getBrands();
    if (result.isSuccess) {
      brandSubject.sink.add(result.data);
      return result.data.brands;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return [];
    }
  }

  // Dùng cho GridView Searched Products
  Future<List<Product>> initRequesterSearchedProduct() async {
    return await loadDataSearchedProduct(0);
  }

  Future<List<Product>> dataRequesterSearchedProduct(int currentSize) async {
    return await loadDataSearchedProduct(currentSize);
  }

  Future<List<Product>> loadDataSearchedProduct(int offset) async {
    NetworkState<SearchedProductModel> result =
        await categoryRepository.searchProduct(searchWord, limit, offset, productCategoryId, brandId, priceFrom, priceTo);
    if (result.isSuccess) {
      print("Searched Products: ${result.data.products}");
      List<Product> products = result.data.products;
      return products;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return [];
    }
  }

  void dispose() {
    brandSubject.close();
  }
}
