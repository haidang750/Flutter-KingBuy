import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel {
  final myPromotionSubject = BehaviorSubject<List<MyPromotion>>();
  final newProductSubject = BehaviorSubject<List<Product>>();
  final sellingProductSubject = BehaviorSubject<List<Product>>();
  final popupSubject = BehaviorSubject<PopupData>();
  final productCategorySubject = BehaviorSubject<List<Product>>();

  Stream<List<MyPromotion>> get myPromotionStream => myPromotionSubject.stream;

  Stream<List<Product>> get newProductStream => newProductSubject.stream;

  Stream<List<Product>> get sellingProductStream => sellingProductSubject.stream;

  Stream<PopupData> get popupStream => popupSubject.stream;

  Stream<List<Product>> get productCategoryStream => productCategorySubject.stream;

  getAllMyPromotion() async {
    NetworkState<MyPromotionModel> result = await authRepository.getAllMyPromotion(10, 0); // limit = 10, offset = 0
    if (result.isSuccess) {
      List<MyPromotion> myPromotions = result.data.myPromotions;
      myPromotionSubject.sink.add(myPromotions);
    } else {
      myPromotionSubject.sink.add([]);
    }
  }

  getAllProductNew() async {
    NetworkState<List<Product>> result = await categoryRepository.getAllProductNew(10, 0);
    if (result.data.length > 0) {
      newProductSubject.sink.add(result.data);
    } else {
      newProductSubject.sink.add([]);
    }
  }

  getAllProductSelling() async {
    NetworkState<List<Product>> result = await categoryRepository.getAllProductSelling(10, 0);
    if (result.data.length > 0) {
      sellingProductSubject.sink.add(result.data);
    } else {
      sellingProductSubject.sink.add([]);
    }
  }

  getPopup() async {
    NetworkState<PopupModel> result = await categoryRepository.getPopup();
    if (result.isSuccess) {
      if (result.data.status == 1) {
        popupSubject.sink.add(result.data.popupData);
      } else {
        popupSubject.sink.add(null);
      }
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet");
    }
  }

  Future<Product> getPopupProduct(List<int> productIds) async {
    NetworkState<ListProductsModel> result = await categoryRepository.getProductById(productIds);
    if (result.isSuccess) {
      return result.data.products[0];
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return null;
    }
  }

  Future<List<Category>> initRequester() async {
    return await loadCategory(0);
  }

  Future<List<Category>> dataRequester(int currentSize) async {
    if (currentSize < 6) {
      return await loadCategory(currentSize);
    } else {
      return [];
    }
  }

  Future<List<Category>> loadCategory(int offset) async {
    NetworkState<CategoryModel> result = await categoryRepository.getAllCategories();
    List<Category> listCategories = [];
    if (result.data.categories != null && offset < 6) listCategories.add(result.data.categories[offset]);
    return listCategories;
  }

  Future<Stream<List<Product>>> getProductsByCategory(int productCategoryId) async {
    NetworkState<ListProductsModel> result = await categoryRepository.getProductsByCategory(productCategoryId, null, 10, 0, 0,
        0, 1000000000);
    if (result.isSuccess) {
      List<Product> products = result.data.products;
      productCategorySubject.sink.add(products);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      productCategorySubject.sink.add([]);
    }
    return productCategoryStream;
  }

  void dispose() {
    myPromotionSubject.close();
    newProductSubject.close();
    sellingProductSubject.close();
    popupSubject.close();
    productCategorySubject.close();
  }
}
