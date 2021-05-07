import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';

class ProductQuestions extends StatefulWidget {
  @override
  ProductQuestionsState createState() => ProductQuestionsState();
}

class ProductQuestionsState extends State<ProductQuestions> with ResponsiveWidget {
  final productQuestionsViewModel = ProductQuestionsViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: productQuestionsViewModel,
        builder: (context, viewModel, child) =>
            Scaffold(appBar: AppBar(title: Text("Hỏi đáp về sản phẩm"), centerTitle: true), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Center(child: Text("Hỏi đáp về sản phẩm"));
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
