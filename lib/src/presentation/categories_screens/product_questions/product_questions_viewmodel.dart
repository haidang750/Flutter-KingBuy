import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/cart/cart_screen.dart';
import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/presentation/widgets/my_network_image.dart';
import 'package:projectui/src/presentation/widgets/show_money.dart';
import 'package:projectui/src/resource/model/cart_model.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';
import 'package:projectui/src/resource/model/product_question_model.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class ProductQuestionsViewModel extends BaseViewModel {
  final reloadQuestionSubject = BehaviorSubject<bool>();
  final productQuestionController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final productQuestionSubject = BehaviorSubject<List<Question>>();
  final cartBadgeSubject = BehaviorSubject<int>();
  final cartSubject = BehaviorSubject<CartModel>();
  final totalQuantitySubject = BehaviorSubject<int>();

  init(BuildContext context, Product product, int cartQuantity) {
    reloadQuestionSubject.sink.add(false);
    productQuestionSubject.sink.add([]);
    totalQuantitySubject.sink.add(cartQuantity);
    cartSubject.sink.add(CartModel.of(context));
    cartBadgeSubject.sink.add(CartModel.of(context).totalUnread);
    getProductQuestions(context, product.id, 30);
  }

  getProductQuestions(BuildContext context, int productId, int limit) {
    AppUtils.getProductQuestions(context, productId, limit);
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

  handlePurchaseButton(Product product) {
    CartModel.of(context, listen: false).addProduct(product, colorId: -1);
    totalQuantitySubject.sink.add(totalQuantitySubject.stream.value + 1);
    cartBadgeSubject.sink.add(cartBadgeSubject.stream.value + 1);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      cartSubject.sink.add(CartModel.of(context));
    });

    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => StreamBuilder(
          stream: cartSubject.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CartItem> cartItems;
              if (snapshot.data == null) {
                cartItems = [];
              } else {
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
                                                ],
                                              ))
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
                                totalQuantitySubject.sink.add(await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CartScreen(totalQuantity: totalQuantitySubject.stream.value))));
                                ;
                              })),
                    ],
                  ));
            } else {
              return MyLoading();
            }
          },
        ));
  }

  @override
  void dispose() {
    super.dispose();
    reloadQuestionSubject.close();
    productQuestionSubject.close();
    cartSubject.close();
    cartBadgeSubject.close();
    totalQuantitySubject.close();
  }
}