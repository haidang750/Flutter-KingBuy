import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/routers.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/CartModel.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/ProductQuestionModel.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

import '../../presentation.dart';

class ProductQuestions extends StatefulWidget {
  ProductQuestions({this.product, this.cartProducts});

  Product product;
  List<CartProduct> cartProducts;

  @override
  ProductQuestionsState createState() => ProductQuestionsState();
}

class ProductQuestionsState extends State<ProductQuestions> with ResponsiveWidget {
  final productQuestionsViewModel = ProductQuestionsViewModel();
  final productDetailViewModel = ProductDetailViewModel();
  final reloadQuestionSubject = BehaviorSubject<bool>();
  final productQuestionController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final productQuestionSubject = BehaviorSubject<List<Question>>();
  final cartProductsSubject = BehaviorSubject<List<CartProduct>>();

  @override
  void initState() {
    super.initState();
    reloadQuestionSubject.sink.add(false);
    productQuestionSubject.sink.add([]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProductQuestions(context, 30);
    });
  }

  getProductQuestions(BuildContext context, int limit) {
    productDetailViewModel.getProductQuestions(context, widget.product.id, limit);
  }

  @override
  void dispose() {
    super.dispose();
    reloadQuestionSubject.close();
    productQuestionSubject.close();
    cartProductsSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: productQuestionsViewModel,
        builder: (context, viewModel, child) => Scaffold(appBar: buildAppBar(), body: buildUi(context: context)));
  }

  Widget buildAppBar() {
    return AppBar(title: Text("Hỏi đáp về sản phẩm", style: TextStyle(fontSize: 17)), centerTitle: true, actions: [
      Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 15, 10),
          child: GestureDetector(
            child: Image.asset(AppImages.icShoppingCart, height: 28, width: 28, color: AppColors.white),
            onTap: () {
              Navigator.pushNamed(context, Routers.Cart);
            },
          ))
    ]);
  }

  Widget buildScreen() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          buildChatBox(),
          SizedBox(height: 20),
          buildButton(AppColors.grey, "Đặt câu hỏi cho sản phẩm", handleQuestionButton),
          SizedBox(height: 10),
          buildButton(AppColors.primary, "Chọn mua", handlePurchaseButton)
        ],
      ),
    );
  }

  Widget buildChatBox() {
    List<Question> productQuestions = Provider.of<ProductQuestionModel>(context, listen: true).questions;
    productQuestionSubject.sink.add(productQuestions);

    return Container(
      height: MediaQuery.of(context).size.height * 0.67,
      color: AppColors.grey2,
      child: StreamBuilder(
        stream: Rx.combineLatest2(productQuestionSubject.stream, reloadQuestionSubject.stream, (stream1, stream2) => stream1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            productQuestions = Provider.of<ProductQuestionModel>(context, listen: false).questions;
            productQuestionSubject.sink.add(productQuestions);

            return snapshot.data.length > 0
                ? ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Question productQuestion = snapshot.data[index];

                      return Container(
                          height: 50,
                          color: AppColors.grey2,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(16))),
                                  child: Icon(Icons.person, size: 20, color: AppColors.white)),
                              SizedBox(width: 10),
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: Text(productQuestion.content, style: TextStyle(fontSize: 14)))
                            ],
                          ));
                    })
                : Container(
                    height: 20, alignment: Alignment.center, child: Text("Chưa có câu hỏi nào!", style: TextStyle(fontSize: 14, color: Colors.red)));
          } else {
            return MyLoading();
          }
        },
      ),
    );
  }

  Widget buildButton(Color buttonColor, String buttonContent, Function action) {
    return GestureDetector(
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.7,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(buttonContent, style: TextStyle(fontSize: 15, color: AppColors.buttonContent, fontWeight: FontWeight.w500)),
      ),
      onTap: action,
    );
  }

  handleQuestionButton() {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => Container(
            height: 160,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Đặt câu hỏi", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                BorderTextField(
                  height: 75,
                  textController: productQuestionController,
                  color: AppColors.white,
                  borderColor: AppColors.black.withOpacity(0.5),
                  isChangeBorderColor: true,
                  borderRadius: 4,
                  borderWidth: 0.7,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  hintText: "Nội dung",
                  hintTextFontSize: 14,
                  hintTextFontWeight: FontWeight.normal,
                  textPaddingLeft: 5,
                  textPaddingRight: 5,
                  transformText: -12,
                ),
                SizedBox(height: 10),
                Center(
                    child: GestureDetector(
                  child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.7,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text("Gửi", style: TextStyle(color: AppColors.buttonContent, fontSize: 14, fontWeight: FontWeight.bold))),
                  onTap: () async {
                    int status = await productDetailViewModel.requestAnswerQuestion(widget.product.id, productQuestionController.text);
                    if (status == 1) {
                      productQuestionController.clear();
                      reloadQuestionSubject.sink.add(!reloadQuestionSubject.stream.value);
                      scrollController.animateTo(scrollController.position.minScrollExtent,
                          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                      Toast.show("Câu hỏi đã được gửi đi", context, gravity: Toast.CENTER);
                      getProductQuestions(context, 30);
                      Navigator.pop(context);
                    } else {
                      Toast.show("Đặt câu hỏi thất bại", context, gravity: Toast.CENTER);
                    }
                  },
                ))
              ],
            )));
  }

  handlePurchaseButton() {
    List<CartProduct> cartProducts = [];
    CartProduct cartProduct = CartProduct(product: widget.product, total: 1);
    cartProducts.add(cartProduct);
    Provider.of<CartModel>(context, listen: false).setCartModel(cartProducts);
    cartProductsSubject.sink.add(Provider.of<CartModel>(context, listen: false).getCartProducts);

    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => StreamBuilder(
            stream: cartProductsSubject.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                    height: 30.0 + 70 * snapshot.data.length + 60,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                            height: 30,
                            child: Row(
                              children: [
                                Image.asset(AppImages.icSuccess, height: 16, width: 16),
                                SizedBox(width: 5),
                                Text("${Provider.of<CartModel>(context, listen: false).getTotalProducts} sản phẩm đã được thêm vào giỏ hàng",
                                    style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w600)),
                                Spacer(),
                                GestureDetector(
                                    child: Icon(Icons.cancel, size: 18, color: AppColors.grey),
                                    onTap: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            )),
                        Container(
                            height: 70.0 * snapshot.data.length,
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Product product = snapshot.data[index].product;

                                return Column(
                                  children: [
                                    Container(
                                        height: 60,
                                        transform: Matrix4.translationValues(0.0, -20, 0.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            MyNetworkImage(url: "${AppEndpoint.BASE_URL}${product.imageSource}", height: 60, width: 60),
                                            SizedBox(width: 10),
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(product.name),
                                                ShowMoney(
                                                    price: product.salePrice,
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
                                child:
                                    Text("Xem giỏ hàng", style: TextStyle(fontSize: 14, color: AppColors.buttonContent, fontWeight: FontWeight.bold)),
                                onTap: () {
                                  Navigator.pushNamed(context, Routers.Cart, arguments: widget.cartProducts);
                                })),
                      ],
                    ));
              } else {
                return MyLoading();
              }
            }));
  }

  @override
  Widget buildDesktop(BuildContext context) {
    // TODO: implement buildDesktop
    return buildScreen();
  }

  @override
  Widget buildMobile(BuildContext context) {
    // TODO: implement buildMobile
    return buildScreen();
  }

  @override
  Widget buildTablet(BuildContext context) {
    // TODO: implement buildTablet
    return buildScreen();
  }
}
