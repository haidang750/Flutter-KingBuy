import 'package:flutter/cupertino.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/cart_model.dart';

class OrderSuccessViewModel extends BaseViewModel {
  init(BuildContext context) {
    CartModel.of(context, listen: false).deleteAllProducts(); // xóa tất cả các cartItem có trong Cart
  }
}