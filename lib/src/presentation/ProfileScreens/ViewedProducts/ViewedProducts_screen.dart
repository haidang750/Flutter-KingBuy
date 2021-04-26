// Sản phẩm đã xem
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/ViewedProducts/ViewedProducts.dart';
import 'package:projectui/src/presentation/widgets/MyGridView.dart';
import 'package:projectui/src/presentation/widgets/ShowOneProduct.dart';
import 'package:projectui/src/presentation/widgets/ShowPath.dart';
import 'package:projectui/src/resource/model/ProductModel.dart';

class ViewedProducts extends StatefulWidget {
  @override
  ViewedProductsState createState() => ViewedProductsState();
}

class ViewedProductsState extends State<ViewedProducts> {
  final viewedProductsViewModel = ViewedProductsViewModel();
  final keyGridView = GlobalKey<MyGridViewState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(titleSpacing: 0, title: Text("Sản phẩm đã xem")),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [buildPath(), buildListProduct()],
            )));
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
        childAspectRatio: 1 / 2.26,
        crossAxisCount: 2,
      ),
    );
  }
}
