import 'package:flutter/material.dart';

class ViewedProductLocalStorage with ChangeNotifier{
  List<int> idViewedProducts = [];

  addViewedProduct(int productId) {
    bool isProductExist = idViewedProducts.any((idViewProduct) => idViewProduct == productId ? true : false);
    // nếu sản phẩm chưa tồn tại trong danh sách sản phẩm đã xem thì add sản phẩm đó vào list, ngược lại thì không add nữa
    if(isProductExist == false){
      idViewedProducts.add(productId);
    }
    notifyListeners();
  }
}