import 'package:flutter/material.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';

class CartModel with ChangeNotifier {
  int totalProducts;
  List<CartProduct> cartProducts;

  int get getTotalProducts => this.totalProducts;

  List<CartProduct> get getCartProducts => this.cartProducts;

  setTotalProducts(int totalProducts){
    this.totalProducts = totalProducts;
    notifyListeners();
  }

  setCartProducts(List<CartProduct> cartProducts){
    this.cartProducts = cartProducts;
    notifyListeners();
  }

  setCartModel(List<CartProduct> cartProducts) {
    for (int i = 0; i < cartProducts.length; i++) {
      if (this.cartProducts.any((element) => element.product.id == cartProducts[i].product.id)) {
        this.totalProducts = this.totalProducts + 1;
        for (int j = 0; j < this.cartProducts.length; j++) {
          if (this.cartProducts[j].product.id == cartProducts[i].product.id) {
            this.cartProducts[j].total = this.cartProducts[j].total + 1;
          }
        }
      } else {
        this.totalProducts = this.totalProducts + 1;
        this.cartProducts.add(cartProducts[i]);
        for (int k = 0; k < this.cartProducts.length; k++) {
          if (this.cartProducts[k].product.id == cartProducts[i].product.id) {
            this.cartProducts[k].total = 0;
            this.cartProducts[k].total = this.cartProducts[k].total + 1;
          }
        }
      }
    }
    notifyListeners();
  }
}

class CartProduct {
  CartProduct({this.total, this.product});
  int total;
  Product product;

  int get getTotal => this.total;

  Product get getProduct => this.product;
}
