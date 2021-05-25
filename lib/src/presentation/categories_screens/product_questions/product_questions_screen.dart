import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/categories_screens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/resource/model/cart_model.dart';
import 'package:projectui/src/resource/model/data.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';
import 'package:projectui/src/resource/model/product_question_model.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../../presentation.dart';

class ProductQuestions extends StatefulWidget {
  ProductQuestions({this.product, this.cartQuantity});

  Product product;
  int cartQuantity;

  @override
  ProductQuestionsState createState() => ProductQuestionsState();
}

class ProductQuestionsState extends State<ProductQuestions> with ResponsiveWidget {
  ProductQuestionsViewModel productQuestionsViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: ProductQuestionsViewModel(),
        onViewModelReady: (viewModel) => productQuestionsViewModel = viewModel..init(context, widget.product, widget.cartQuantity),
        builder: (context, viewModel, child) => Scaffold(appBar: buildAppBar(), body: buildUi(context: context)));
  }

  Widget buildAppBar() {
    return AppBar(
        title: Text("Hỏi đáp về sản phẩm", style: TextStyle(fontSize: 17)),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Map<String, int> dataBack = {
                  "totalQuantity": productQuestionsViewModel.totalQuantitySubject.stream.value,
                  "cartBadge": productQuestionsViewModel.cartBadgeSubject.stream.value
                };
                Navigator.pop(context, dataBack);
              },
            );
          },
        ),
        actions: [
          Stack(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 15, 10),
                  child: GestureDetector(
                    child: Image.asset(AppImages.icShoppingCart, height: 28, width: 28, color: AppColors.white),
                    onTap: () async {
                      CartModel.of(context).readAll();
                      productQuestionsViewModel.cartBadgeSubject.sink.add(CartModel.of(context).totalUnread);
                      productQuestionsViewModel.totalQuantitySubject.sink.add(await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen(totalQuantity: productQuestionsViewModel.totalQuantitySubject.stream.value))));
                    },
                  )),
              StreamBuilder(
                stream: productQuestionsViewModel.cartBadgeSubject.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == 0) {
                      return Container();
                    } else {
                      return Container(
                          height: 16,
                          width: 16,
                          transform: Matrix4.translationValues(18, 13, 0.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Text(snapshot.data.toString(),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.buttonContent)));
                    }
                  } else {
                    return Container();
                  }
                },
              )
            ],
          )
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
          buildButton(AppColors.primary, "Chọn mua", productQuestionsViewModel.handlePurchaseButton(widget.product))
        ],
      ),
    );
  }

  Widget buildChatBox() {
    Data userData = Provider.of<Data>(context);
    String userAvatar = userData.profile.avatarSource;
    List<Question> productQuestions = Provider.of<ProductQuestionModel>(context, listen: true).questions;
    productQuestionsViewModel.productQuestionSubject.sink.add(productQuestions);

    return Container(
      height: MediaQuery.of(context).size.height * 0.67,
      color: AppColors.grey2,
      child: StreamBuilder(
        stream: Rx.combineLatest2(productQuestionsViewModel.productQuestionSubject.stream, productQuestionsViewModel.reloadQuestionSubject.stream,
            (stream1, stream2) => stream1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            productQuestions = Provider.of<ProductQuestionModel>(context, listen: false).questions;
            productQuestionsViewModel.productQuestionSubject.sink.add(productQuestions);

            return snapshot.data.length > 0
                ? ListView.builder(
                    controller: productQuestionsViewModel.scrollController,
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
                              CircleAvatar(radius: 15, backgroundImage: NetworkImage("${AppEndpoint.BASE_URL}$userAvatar")),
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
                  textController: productQuestionsViewModel.productQuestionController,
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
                        onTap: () {
                          productQuestionsViewModel.sendQuestion(widget.product.id, productQuestionsViewModel.productQuestionController.text);
                        }))
              ],
            )));
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
