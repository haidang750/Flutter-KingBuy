// Sản phẩm đã xem
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/ViewedProducts/ViewedProducts.dart';
import 'package:projectui/src/presentation/widgets/MyGridView.dart';
import 'package:projectui/src/presentation/widgets/ShowOneProduct.dart';
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
        appBar: AppBar(title: Text("Sản phẩm đã xem")),
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
      child: Row(
        children: [
          Image.asset(
            "assets/home.png",
            height: 22,
            width: 22,
            color: Colors.black,
          ),
          SizedBox(width: 5),
          Icon(
            Icons.arrow_forward_ios_outlined,
            size: 14,
          ),
          SizedBox(width: 5),
          Text(
            "Tài khoản",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            size: 14,
          ),
          SizedBox(width: 5),
          Text(
            "Sản phẩm đã xem",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget itemBuilder(List<Product> dataList, BuildContext context, int index) {
    Product product = dataList[index];
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 0.5, color: Colors.grey.shade400),
            top: BorderSide(width: 0.5, color: Colors.grey.shade400),
            right: BorderSide(width: 0.8, color: Colors.grey.shade500),
            bottom: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
        ),
        child: ShowOneProduct(
          imageSource: product.imageSource,
          saleOff: product.saleOff,
          name: product.name,
          brandName: product.brandName,
          star: product.star,
          salePrice: product.salePrice,
          price: product.price,
        ),
      ),
      onTap: () {
        print("Handle Tap Product $index");
      },
    );
  }

  Widget buildListProduct() {
    return Expanded(
      child: MyGridView(
        key: keyGridView,
        itemBuilder: itemBuilder,
        dataRequester: viewedProductsViewModel.dataRequester,
        initRequester: viewedProductsViewModel.initRequester,
        childAspectRatio: 3 / 5.8,
        crossAxisCount: 2,
      ),
    );
  }
}
