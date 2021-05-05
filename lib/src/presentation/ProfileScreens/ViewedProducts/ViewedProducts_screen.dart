// Sản phẩm đã xem
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/ViewedProducts/ViewedProducts.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/MyGridView.dart';
import 'package:projectui/src/presentation/widgets/ShowOneProduct.dart';
import 'package:projectui/src/presentation/widgets/ShowPath.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';

class ViewedProducts extends StatefulWidget {
  @override
  ViewedProductsState createState() => ViewedProductsState();
}

class ViewedProductsState extends State<ViewedProducts> with ResponsiveWidget {
  final viewedProductsViewModel = ViewedProductsViewModel();
  final keyGridView = GlobalKey<MyGridViewState>();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: viewedProductsViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(titleSpacing: 0, title: Text("Sản phẩm đã xem")),
            body: Container(padding: EdgeInsets.symmetric(horizontal: 10), child: buildUi(context: context))));
  }

  Widget buildScreen() {
    return Column(
      children: [buildPath(), buildListProduct()],
    );
  }

  Widget buildPath() {
    return Container(
        height: 50,
        alignment: Alignment.centerLeft,
        child: ShowPath(
          rootTab: "Tài khoản",
          parentTab: null,
          childTab: "Sản phẩm đã xem",
        ));
  }

  Widget itemBuilder(List<Product> dataList, BuildContext context, int index) {
    Product product = dataList[index];
    return ShowOneProduct(
      product: product,
    );
  }

  Widget buildListProduct() {
    return Expanded(
      child: MyGridView(
        key: keyGridView,
        itemBuilder: itemBuilder,
        dataRequester: viewedProductsViewModel.dataRequester,
        initRequester: viewedProductsViewModel.initRequester,
        childAspectRatio: 1 / 2.2,
        crossAxisCount: 2,
      ),
    );
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
