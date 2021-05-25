import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/database/cart_provider.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:provider/provider.dart';

import '../routers.dart';

class SplashScreenViewModel extends BaseViewModel {
  init(BuildContext context) {
    getCart(context);
    AppShared.setShowPopup(true);
    getProfileUser();
    getCountNotification();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Timer(Duration(seconds: 6), () => Navigator.pushNamedAndRemoveUntil(context, Routers.Navigation, (Route<dynamic> route) => false));
    });
  }

  getProfileUser() async {
    if (await AppShared.getAccessToken() != null) {
      NetworkState<Data> result = await authRepository.getProfile();

      if (result.isSuccess) {
        Data profile = result.data;
        Provider.of<Data>(context, listen: false).setData(profile.profile, profile.shop, profile.memberCardNumber, profile.rewardPoints);
      } else {
        print("Vui lòng kiểm tra lại kết nối Internet!");
      }
    } else {
      Provider.of<Data>(context, listen: false).setData(null, null, null, null);
    }
  }

  getCountNotification() async {
    if (await AppShared.getAccessToken() != null) {
      NetworkState<int> result = await authRepository.getCountNotification();
      if (result.isSuccess) {
        int countNotification = result.data;
        Provider.of<NotificationModel>(context, listen: false).setCountNotification(countNotification);
      } else {
        print("Vui lòng kiểm tra lại kết nối Internet");
        Provider.of<NotificationModel>(context, listen: false).setCountNotification(null);
      }
    } else {
      Provider.of<NotificationModel>(context, listen: false).setCountNotification(null);
    }
  }

  getCart(BuildContext context) async {
    CartModel cartModel = CartModel.of(context, listen: false);
    if (cartModel == null || cartModel.id == null) {
      print("HELLO");
      // chi load du lieu lan dau tien khi khoi dong ung dung, sau do se lay tu cache
      cartModel = await CartProvider.instance.getCart();
      if (cartModel != null) {
        print("zoIF");
        print("TEST totalUnread: ${cartModel.totalUnread}");
        CartModel.of(context, listen: false).setData(cartModel);
        // lay danh sach cart item
        List<CartItem> items = await CartProvider.instance.getCartItems();
        print("items: $items");
        // load lai danh sach cart item tu server theo ids
        if (items != null && items.length > 0) {
          List<int> ids = [];
          items.forEach((item) {
            print("item.productId: ${item.productId}");
            ids.add(item.productId);
          });
          if (ids.length > 0) {
            print("ids[0] : ${ids[0]}");
            NetworkState<ListProductsModel> result = await categoryRepository.getProductById(ids);
            if (result.isSuccess) {
              print("getProductById Success");
              List<Product> products = result.data.products;
              if (products.length > 0)
                for (int i = 0; i < items.length; i++) {
                  items[i].product = products.firstWhere((val) => val.id == items[i].productId, orElse: null);
                }
              CartModel.of(context).setProducts(items);
            }
          }
        }
      } else {
        print("zoELSE");
        cartModel = CartModel().initCart();
        cartModel.id = await CartProvider.instance.insertCart(cartModel);
        CartModel.of(context).setData(cartModel);
      }
    }
  }
}
