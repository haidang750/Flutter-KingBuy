import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/CartModel.dart';

class CartScreen extends StatefulWidget {
  CartScreen({this.cartProducts});

  List<CartProduct> cartProducts;

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> with ResponsiveWidget {
  final cartViewModel = CartViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: cartViewModel,
        builder: (context, viewModel, child) => Scaffold(appBar: AppBar(title: Text("Giỏ hàng"), titleSpacing: 0), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Center(
        child: ListView.builder(
            itemCount: widget.cartProducts.length,
            itemBuilder: (context, index) => Column(
                  children: [
                    Text("Product: ${widget.cartProducts[index].product.name}", textAlign: TextAlign.center),
                    Text("Quantity: ${widget.cartProducts[index].total.toString()}", textAlign: TextAlign.center),
                    SizedBox(height: 20)
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
