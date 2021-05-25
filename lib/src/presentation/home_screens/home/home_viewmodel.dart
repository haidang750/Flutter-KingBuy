import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../../presentation.dart';

class HomeViewModel extends BaseViewModel {
  final cartBadgeSubject = BehaviorSubject<int>();
  final promotionSubject = BehaviorSubject<List<Promotion>>();
  CarouselController carouselController = CarouselController();
  final currentPromotionImage = BehaviorSubject<int>(); // lưu trữ hình ảnh đang hiển thị ở Carousel hiện tại

  // currentCategorySubject: lưu trữ Child Category (ví dụ: ghế massage thương gia) đang được chọn tại mỗi Category (ví dụ: ghế massage)
  final currentCategorySubject = BehaviorSubject<List<int>>();

  // currentCategoryIdSubject: lưu trữ id của Child Category đang được chọn tại mỗi Category
  final currentCategoryIdSubject = BehaviorSubject<List<int>>();

  // currentProductCategorySubject: lưu trữ luồng Stream chứa danh sách các sản phẩm của Child Category đang được chọn tại mỗi Category
  final currentProductCategorySubject = BehaviorSubject<List<Stream<List<Product>>>>();
  final myPromotionSubject = BehaviorSubject<List<MyPromotion>>();
  final newProductSubject = BehaviorSubject<List<Product>>();
  final sellingProductSubject = BehaviorSubject<List<Product>>();
  final popupSubject = BehaviorSubject<PopupData>();
  final productCategorySubject = BehaviorSubject<List<Product>>();
  final hotCategoriesSubject = BehaviorSubject<List<Category>>();

  Stream<List<Promotion>> get promotionStream => promotionSubject.stream;

  Stream<List<MyPromotion>> get myPromotionStream => myPromotionSubject.stream;

  Stream<List<Category>> get hotCategoriesStream => hotCategoriesSubject.stream;

  Stream<List<Product>> get newProductStream => newProductSubject.stream;

  Stream<List<Product>> get sellingProductStream => sellingProductSubject.stream;

  Stream<PopupData> get popupStream => popupSubject.stream;

  Stream<List<Product>> get productCategoryStream => productCategorySubject.stream;

  List<int> get currentCategoryId => currentCategoryIdSubject.stream.value;

  List<int> get currentCategory => currentCategorySubject.stream.value;

  init(BuildContext context) {
    getPromotion();
    getHotCategories();
    cartBadgeSubject.sink.add(CartModel.of(context).totalUnread);
    currentPromotionImage.sink.add(0);
    getAllMyPromotion();
    getAllProductNew();
    getAllProductSelling();
    currentCategorySubject.sink.add([]);
    currentCategoryIdSubject.sink.add([]);
    currentProductCategorySubject.sink.add([]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isShowPopup = await AppShared.getShowPopup();
      if (isShowPopup) {
        getPopup();
        showPopup();
        AppShared.setShowPopup(false);
      }
    });
  }

  showPopup() {
    showDialog(
        context: context,
        builder: (context) => StreamBuilder(
              stream: popupStream,
              builder: (context, snapshot) {
                PopupData popup = snapshot.data;

                if (snapshot.hasData) {
                  return Dialog(
                      backgroundColor: Colors.white,
                      insetPadding: EdgeInsets.symmetric(horizontal: 25.5, vertical: MediaQuery.of(context).size.height * 0.18),
                      child: Stack(
                        children: [
                          GestureDetector(
                              child: MyNetworkImage(
                                  url: "${AppEndpoint.BASE_URL}${popup.popupImage}",
                                  height: MediaQuery.of(context).size.height * 0.64,
                                  width: MediaQuery.of(context).size.width - 30),
                              onTap: () async {
                                List<int> productIds = [];
                                productIds.add(popup.popupProductId);
                                Product popupProduct = await getPopupProduct(productIds);
                                if (popupProduct != null)
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetail(
                                              product: popupProduct, productId: popupProduct.id, productVideoLink: popupProduct.videoLink)));
                              }),
                          Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                  child: Icon(Icons.cancel, size: 20, color: AppColors.black),
                                  onTap: () {
                                    Navigator.pop(context);
                                  }))
                        ],
                      ));
                } else {
                  return MyLoading();
                }
              },
            ));
  }

  onTapShoppingCartIcon(BuildContext context) {
    CartModel.of(context).readAll();
    cartBadgeSubject.sink.add(CartModel.of(context).totalUnread);
    Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(totalQuantity: CartModel.of(context).totalQuantity)));
  }

  getPromotion() async {
    List<Promotion> promotions = await AppUtils.getPromotion();
    promotionSubject.sink.add(promotions);
  }

  getAllMyPromotion() async {
    NetworkState<MyPromotionModel> result = await authRepository.getAllMyPromotion(10, 0); // limit = 10, offset = 0
    if (result.isSuccess) {
      List<MyPromotion> myPromotions = result.data.myPromotions;
      myPromotionSubject.sink.add(myPromotions);
    } else {
      myPromotionSubject.sink.add([]);
    }
  }

  onTapPromotion(Promotion promotion) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PromotionDetail(
                  image: promotion.imageSource,
                  title: promotion.title,
                  description: promotion.description,
                )));
  }

  onTapMyPromotion(MyPromotion myPromotion) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PromotionDetail(
                  image: myPromotion.imageSource,
                  title: myPromotion.title,
                  description: myPromotion.description,
                )));
  }

  getHotCategories() async {
    CategoryModel categoryModel = await AppUtils.getHotCategories();
    hotCategoriesSubject.sink.add(categoryModel.categories);
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

  getProductByChildCategory(Category category, List<int> currentCategoryId) async {
    final currentHomeViewModel = HomeViewModel();
    List<Stream<List<Product>>> currentProductCategory = currentProductCategorySubject.stream.value;
    Stream<List<Product>> productCategory = await currentHomeViewModel.getProductsByCategory(currentCategoryId[currentCategoryId.length - 1]);
    currentProductCategory.add(productCategory);
    if (currentProductCategory.length > 6) {
      currentProductCategory = currentProductCategory.sublist(0, 6);
    }
    currentProductCategorySubject.sink.add(currentProductCategory);
  }

  Future<Stream<List<Product>>> getProductsByCategory(int productCategoryId) async {
    NetworkState<ListProductsModel> result = await categoryRepository.getProductsByCategory(productCategoryId, null, 10, 0, 0, 0, 1000000000);
    if (result.isSuccess) {
      List<Product> products = result.data.products;
      productCategorySubject.sink.add(products);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      productCategorySubject.sink.add([]);
    }
    return productCategoryStream;
  }

  onTapChildCategory(int childCategoryIndex, int categoryIndex, Category category) async {
    // Load lại danh sách sản phẩm khi nhấn chọn 1 Child Category
    if (childCategoryIndex > 0) {
      int childCategoryId = category.children[childCategoryIndex - 1].id;
      List<int> currentCategoryId = currentCategoryIdSubject.stream.value;
      currentCategoryId[categoryIndex] = childCategoryId;
      currentCategoryIdSubject.sink.add(currentCategoryId);
      //
      final currentHomeViewModel = HomeViewModel();
      List<Stream<List<Product>>> currentProductCategory = currentProductCategorySubject.stream.value;
      Stream<List<Product>> productCategoryStream = await currentHomeViewModel.getProductsByCategory(childCategoryId);
      currentProductCategory[categoryIndex] = productCategoryStream;
      currentProductCategorySubject.sink.add(currentProductCategory);
    } else {
      // Nếu nhấn chọn lại Tất cả (currentCategory = 0)
      List<int> currentCategoryId = currentCategoryIdSubject.stream.value;
      currentCategoryId[categoryIndex] = category.id;
      currentCategoryIdSubject.sink.add(currentCategoryId);
      //
      final currentHomeViewModel = HomeViewModel();
      List<Stream<List<Product>>> currentProductCategory = currentProductCategorySubject.stream.value;
      Stream<List<Product>> productCategoryStream = await currentHomeViewModel.getProductsByCategory(category.id);
      currentProductCategory[categoryIndex] = productCategoryStream;
      currentProductCategorySubject.sink.add(currentProductCategory);
    }
    List<int> currentCategory = currentCategorySubject.stream.value;
    currentCategory[categoryIndex] = childCategoryIndex;
    currentCategorySubject.sink.add(currentCategory);
    if (currentCategorySubject.stream.value.length > 6) {
      currentCategorySubject.sink.add(currentCategorySubject.stream.value.sublist(0, 6));
    }
    if (currentCategoryIdSubject.stream.value.length > 6) {
      currentCategoryIdSubject.sink.add(currentCategoryIdSubject.stream.value.sublist(0, 6));
    }
  }

  @override
  void dispose() {
    super.dispose();
    cartBadgeSubject.close();
    currentPromotionImage.close();
    currentCategorySubject.close();
    currentCategoryIdSubject.close();
    currentProductCategorySubject.close();
    myPromotionSubject.close();
    newProductSubject.close();
    sellingProductSubject.close();
    popupSubject.close();
    productCategorySubject.close();
    promotionSubject.close();
    hotCategoriesSubject.close();
  }
}
