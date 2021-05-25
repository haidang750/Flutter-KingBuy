import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/cart/cart_screen.dart';
import 'package:projectui/src/presentation/categories_screens/Installment/installment_screen.dart';
import 'package:projectui/src/presentation/categories_screens/product_questions/product_questions.dart';
import 'package:projectui/src/presentation/categories_screens/rating_and_comment/rating_and_comment.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/presentation/widgets/my_network_image.dart';
import 'package:projectui/src/presentation/widgets/show_money.dart';
import 'package:projectui/src/resource/model/cart_model.dart';
import 'package:projectui/src/resource/model/comment_model.dart';
import 'package:projectui/src/resource/model/detail_product_model.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';
import 'package:projectui/src/resource/model/product_question_model.dart';
import 'package:projectui/src/resource/model/profile.dart';
import 'package:projectui/src/resource/model/viewed_product_local_storage.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../routers.dart';

class ProductDetailViewModel extends BaseViewModel {
  final subImageProductSubject = BehaviorSubject<List<dynamic>>(); // list ảnh phụ
  final currentSubImageSubject = BehaviorSubject<int>();
  final currentColorProductSubject = BehaviorSubject<int>();
  CarouselController carouselController = CarouselController();
  final showFullProductInfoSubject = BehaviorSubject<bool>();
  YoutubePlayerController youtubePlayerController;
  final showFullBrandInfoSubject = BehaviorSubject<bool>();
  final purchasedTogetherProductSubject = BehaviorSubject<List<bool>>();
  final showFullPurchasedTogetherProductSubject = BehaviorSubject<bool>();
  final countCheckPurchasedTogetherProductSubject = BehaviorSubject<int>();
  final countRelatedProductLoadedSubject = BehaviorSubject<int>();
  bool isLogin; // biến kiểm tra xem user đã login chưa để quyết định cách show phần Sản phẩm đã xem
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Product product;
  final productQuestionController = TextEditingController();
  final reloadQuestionSubject = BehaviorSubject<bool>();
  int productStatus;
  final isUserRatedSubject = BehaviorSubject<bool>();
  final productCommentSubject = BehaviorSubject<List<Comment>>();
  final userProfileSubject = BehaviorSubject<Profile>();
  final productQuestionSubject = BehaviorSubject<List<Question>>();
  final cartSubject = BehaviorSubject<CartModel>();
  final totalQuantitySubject = BehaviorSubject<int>();
  final cartBadgeSubject = BehaviorSubject<int>();
  final productDetailSubject = BehaviorSubject<DetailProductModel>();
  final purchasedTogetherProductsSubject = BehaviorSubject<List<Product>>();
  final relatedProductSubject = BehaviorSubject<List<Product>>();
  final viewedProductsSubject = BehaviorSubject<List<Product>>();
  final viewedProductsLocalSubject = BehaviorSubject<List<Product>>();

  init(BuildContext context, int productId, String productVideoLink, Product product) {
    checkLogin(context);
    getSingleProduct(productId);
    purchasedTogetherProducts(productId);
    getRelatedProducts(productId, 0);
    currentSubImageSubject.sink.add(0);
    currentColorProductSubject.sink.add(-1);
    showFullProductInfoSubject.sink.add(false);
    if (productVideoLink != null) {
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(productVideoLink),
        flags: YoutubePlayerFlags(mute: false, autoPlay: false, disableDragSeek: true, loop: false, enableCaption: false),
      );
    }
    showFullBrandInfoSubject.sink.add(false);
    reloadQuestionSubject.sink.add(false);
    productQuestionSubject.sink.add([]);
    showFullPurchasedTogetherProductSubject.sink.add(false);
    countCheckPurchasedTogetherProductSubject.sink.add(0);
    countRelatedProductLoadedSubject.sink.add(0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProductQuestions(context, productId, 30);
      AppUtils.ratingInfoByProduct(context, productId);
      AppUtils.getReviewByProduct(context, productId);
      Provider.of<ViewedProductLocalStorage>(context, listen: false).addViewedProduct(productId);
    });
    cartSubject.sink.add(CartModel.of(context));
    totalQuantitySubject.sink.add(CartModel.of(context, listen: false).totalQuantity);
    cartBadgeSubject.sink.add(CartModel.of(context).totalUnread);
  }

  getProductQuestions(BuildContext context, int productId, int limit) {
    AppUtils.getProductQuestions(context, productId, limit);
  }

  checkLogin(BuildContext context) async {
    List<int> idViewedProducts = Provider.of<ViewedProductLocalStorage>(context, listen: false).idViewedProducts;
    isLogin = await AppUtils.checkLogin();

    if (isLogin)
      getViewedProducts();
    else
      getViewedProductsLocal(idViewedProducts);
  }

  Stream<DetailProductModel> get productDetailStream => productDetailSubject.stream;

  Stream<List<Product>> get purchasedTogetherProductsStream => purchasedTogetherProductsSubject.stream;

  Stream<List<Product>> get relatedProductStream => relatedProductSubject.stream;

  Stream<List<Product>> get viewedProductsStream => viewedProductsSubject.stream;

  Stream<List<Product>> get viewedProductsLocalStream => viewedProductsLocalSubject.stream;

  getSingleProduct(int productId) async {
    NetworkState<DetailProductModel> result = await categoryRepository.getSingleProduct(productId);
    if (result.isSuccess) {
      productDetailSubject.sink.add(result.data);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  onTapShoppingCartIcon() async {
    CartModel.of(context).readAll();
    cartBadgeSubject.sink.add(CartModel.of(context).totalUnread);
    totalQuantitySubject.sink
        .add(await Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(totalQuantity: totalQuantitySubject.stream.value))));
  }

  onSwipeProductImage(int index) {
    currentSubImageSubject.sink.add(index);
  }

  onTapProductImage(int index) {
    carouselController.jumpToPage(index);
    currentSubImageSubject.sink.add(index);
  }

  onTapProductColor(int index, List<dynamic> colors) {
    currentColorProductSubject.sink.add(index);
    subImageProductSubject.sink.add(colors[index]["image_source"]);
    carouselController.jumpToPage(0);
  }

  String getGoodsStatus(int goodsStatus) {
    switch (goodsStatus) {
      case 1:
        return "Còn hàng";
      case 2:
        return "Hết hàng";
      case 3:
        return "Ngừng kinh doanh";
      default:
        return "";
    }
  }

  onTapShopPhone(BuildContext context, List<ShopAddress> shopAddress, int index) {
    AppUtils.handlePhone(context, shopAddress[index].hotLine);
  }

  showFullProductInfo() {
    showFullProductInfoSubject.sink.add(!showFullProductInfoSubject.stream.value);
  }

  showFullBrandInfo() {
    showFullBrandInfoSubject.sink.add(!showFullBrandInfoSubject.stream.value);
  }

  onTapWritingComment(int productId, String productVideoLink) async {
    if (await AppUtils.checkLogin()) {
      await Navigator.pushNamed(scaffoldKey.currentContext, Routers.Writing_Comment, arguments: productId);
    } else {
      AppUtils.myShowDialog(scaffoldKey.currentContext, productId, productVideoLink);
    }
  }

  showFullRatingAndComments(BuildContext context, int productId, String productVideoLink) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RatingAndComment(productId: productId, productVideoLink: productVideoLink, isUserRated: isUserRatedSubject.stream.value)));
  }

  // kiểm tra xem tài khoản đã Đánh giá một sản phẩm nào đó hay chưa
  bool isUserRated(int userId, List<Comment> comments) {
    return comments.any((comment) => comment.userId == userId ? true : false);
  }

  sendQuestion(int productId, String content) async {
    int status = await AppUtils.requestAnswerQuestion(productId, content);
    if (status == 1) {
      productQuestionController.clear();
      reloadQuestionSubject.sink.add(!reloadQuestionSubject.stream.value);
      Toast.show("Câu hỏi đã được gửi đi", context, gravity: Toast.CENTER);
      getProductQuestions(context, productId, 30);
      Navigator.pop(context);
    } else {
      Toast.show("Đặt câu hỏi thất bại", context, gravity: Toast.CENTER);
    }
  }

  purchasedTogetherProducts(int productId) async {
    NetworkState<ListProductsModel> result = await categoryRepository.purchasedTogetherProducts(productId);
    if (result.isSuccess) {
      purchasedTogetherProductsSubject.sink.add(result.data.products);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  onSelectPurchasedTogetherProduct(AsyncSnapshot snapshot, int index, List<bool> checkList) {
    if (snapshot.data[index]) {
      countCheckPurchasedTogetherProductSubject.sink.add(countCheckPurchasedTogetherProductSubject.stream.value - 1);
    } else {
      countCheckPurchasedTogetherProductSubject.sink.add(countCheckPurchasedTogetherProductSubject.stream.value + 1);
    }
    checkList.replaceRange(index, index + 1, [!snapshot.data[index]]);
    purchasedTogetherProductSubject.sink.add(checkList);
  }

  addPurchasedTogetherProductToCart(AsyncSnapshot snapshot, Product product) {
    List<Product> products = [];
    for (int i = 0; i < snapshot.data.length; i++) {
      if (purchasedTogetherProductSubject.stream.value[i]) {
        products.add(snapshot.data[i]);
      }
    }
    for (int i = 0; i < products.length; i++) {
      if (i == products.length - 1) {
        CartModel.of(context, listen: false).addProduct(products[i], colorId: -1);
        totalQuantitySubject.sink.add(totalQuantitySubject.stream.value + 1);
        cartBadgeSubject.sink.add(cartBadgeSubject.stream.value + 1);
        handleAddToCart(product, addMainProduct: false);
      } else {
        CartModel.of(context, listen: false).addProduct(products[i], colorId: -1);
        totalQuantitySubject.sink.add(totalQuantitySubject.stream.value + 1);
        cartBadgeSubject.sink.add(cartBadgeSubject.stream.value + 1);
      }
    }
  }

  showFullPurchasedTogetherProduct() {
    showFullPurchasedTogetherProductSubject.sink.add(!showFullPurchasedTogetherProductSubject.stream.value);
  }

  Future<List<Product>> getRelatedProducts(int productId, int offset) async {
    // Lấy dữ liệu theo filter, limit = 6, offset
    NetworkState<ListProductsModel> result = await categoryRepository.relatedProduct(productId, 6, offset);
    if (result.isSuccess) {
      List<Product> relatedProducts = result.data.products;
      relatedProductSubject.sink.add(relatedProducts);
      return relatedProducts;
    } else {
      return [];
    }
  }

  getViewedProductsLocal(List<int> productIds) async {
    if (productIds.length != 0) {
      List<Product> result = await AppUtils.getViewedProductsLocal(productIds);
      viewedProductsLocalSubject.sink.add(result);
    } else {
      viewedProductsLocalSubject.sink.add([]);
    }
  }

  getViewedProducts() async {
    NetworkState<ListProductsModel> result = await authRepository.getViewedProducts(10, 0);
    if (result.isSuccess) {
      viewedProductsSubject.sink.add(result.data.products);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      viewedProductsSubject.sink.add([]);
    }
  }

  navigateProductQuestionScreen(Product product, String productVideoLink) async {
    if (await AppUtils.checkLogin()) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductQuestions(
                    product: product,
                    cartQuantity: totalQuantitySubject.stream.value,
                  ))).then((dataBack) {
        totalQuantitySubject.sink.add(dataBack["totalQuantity"]);
        cartBadgeSubject.sink.add(dataBack["cartBadge"]);
      });
    } else {
      AppUtils.myShowDialog(context, product.id, productVideoLink);
    }
  }

  handleChatZalo(BuildContext context) {
    AppUtils.handleZalo(context);
  }

  handleMessenger(BuildContext context) {
    AppUtils.handleMessenger(context);
  }

  addMainProductToCart(Product product) {
    int colorId = currentColorProductSubject.stream.value != -1 ? product.colors[currentColorProductSubject.stream.value]["id"] : -1;
    CartModel.of(context).addProduct(product, colorId: colorId);
    totalQuantitySubject.sink.add(totalQuantitySubject.stream.value + 1);
    cartBadgeSubject.sink.add(cartBadgeSubject.stream.value + 1);
  }

  handleAddToCart(Product product, {bool addMainProduct = true}) {
    if (addMainProduct) {
      addMainProductToCart(product);
    }
    cartSubject.sink.add(CartModel.of(context));
    // CartModel.of(context, listen: false).deleteAllProducts(); // xóa tất cả các cartItem có trong Cart
    // CartProvider.instance.deleteCart(); // xóa Cart

    showMaterialModalBottomSheet(
        context: scaffoldKey.currentContext,
        builder: (context) => StreamBuilder(
              stream: cartSubject.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<CartItem> cartItems;
                  if (snapshot.data == null) {
                    print("zo if");
                    cartItems = [];
                  } else {
                    print("zo else");
                    cartItems = snapshot.data.products;
                  }

                  return Container(
                      height: 50.0 + 70 * cartItems.length + 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Container(
                              height: 40,
                              child: Row(
                                children: [
                                  Image.asset(AppImages.icSuccess, height: 16, width: 16),
                                  SizedBox(width: 5),
                                  Text("${totalQuantitySubject.stream.value} sản phẩm đã được thêm vào giỏ hàng",
                                      style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w600)),
                                  Spacer(),
                                  GestureDetector(
                                      child: Icon(Icons.cancel, size: 18, color: AppColors.black),
                                      onTap: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              )),
                          Container(
                              height: 70.0 * cartItems.length,
                              child: ListView.builder(
                                itemCount: cartItems.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  CartItem cartItem = cartItems[index];

                                  return Column(
                                    children: [
                                      Container(
                                          height: 60,
                                          transform: Matrix4.translationValues(0.0, -20, 0.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              MyNetworkImage(url: "${AppEndpoint.BASE_URL}${cartItem.product.imageSource}"),
                                              SizedBox(width: 10),
                                              Expanded(
                                                  child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                    Text(cartItem.product.name),
                                                    ShowMoney(
                                                        price: cartItem.product.salePrice,
                                                        fontSizeLarge: 14,
                                                        fontSizeSmall: 11,
                                                        color: AppColors.black,
                                                        fontWeight: FontWeight.bold,
                                                        isLineThrough: false)
                                                  ]))
                                            ],
                                          )),
                                      SizedBox(height: 10)
                                    ],
                                  );
                                },
                              )),
                          SizedBox(height: 10),
                          Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.7,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(20))),
                              child: GestureDetector(
                                  child: Text("Xem giỏ hàng",
                                      style: TextStyle(fontSize: 14, color: AppColors.buttonContent, fontWeight: FontWeight.bold)),
                                  onTap: () async {
                                    CartModel.of(context).readAll();
                                    cartBadgeSubject.sink.add(CartModel.of(context).totalUnread);
                                    totalQuantitySubject.sink.add(await Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => CartScreen(totalQuantity: totalQuantitySubject.stream.value))));
                                  })),
                        ],
                      ));
                } else {
                  return MyLoading();
                }
              },
            ));
  }

  // hàm này sử dụng cho cả 2 button "Đặt mua trả góp" và "Mua ngay"
  void handlePurchaseButton(String buttonContent, Product product) async {
    // nếu sản phẩm chưa hết hàng
    if (productStatus == 1) {
      if (buttonContent == "Mua ngay") {
        CartModel.of(context).readAll();
        cartBadgeSubject.sink.add(CartModel.of(context).totalUnread);
        totalQuantitySubject.sink.add(
            await Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(totalQuantity: totalQuantitySubject.stream.value))));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InstallmentScreen(
                    product: product,
                    productColor:
                        currentColorProductSubject.stream.value != -1 ? product.colors[currentColorProductSubject.stream.value]["name"] : "")));
      }
    } else {
      // ngược lại sản phẩm đã hết hàng thì hiện popup thông báo
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 50),
            child: Container(
                height: 110,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Sản phẩm đã hết hàng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                    GestureDetector(
                        child: Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: Text("Đồng ý", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.buttonContent))),
                        onTap: () {
                          Navigator.pop(context);
                        })
                  ],
                )),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    subImageProductSubject.close();
    currentSubImageSubject.close();
    currentColorProductSubject.close();
    showFullProductInfoSubject.close();
    showFullBrandInfoSubject.close();
    purchasedTogetherProductSubject.close();
    showFullPurchasedTogetherProductSubject.close();
    countCheckPurchasedTogetherProductSubject.close();
    countRelatedProductLoadedSubject.close();
    reloadQuestionSubject.close();
    isUserRatedSubject.close();
    productCommentSubject.close();
    userProfileSubject.close();
    productQuestionSubject.close();
    cartSubject.close();
    totalQuantitySubject.close();
    cartBadgeSubject.close();
    productDetailSubject.close();
    purchasedTogetherProductsSubject.close();
    relatedProductSubject.close();
    viewedProductsSubject.close();
    viewedProductsLocalSubject.close();
  }
}
