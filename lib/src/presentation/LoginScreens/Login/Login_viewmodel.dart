import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:projectui/src/presentation/CategoriesScreens/ProductDetail/ProductDetail_screen.dart';
import 'package:projectui/src/presentation/Navigation/Navigation_screen.dart';
import 'package:projectui/src/presentation/Navigation/Navigation_viewmodel.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:provider/provider.dart';
import 'package:projectui/src/resource/model/Data.dart';

class LoginViewModel extends BaseViewModel {
  final navigationViewModel = NavigationViewModel();

  getLoginData(BuildContext context, int productId, String productVideoLink, String email, String password) async {
    try {
      await authRepository.sendRequestLogin(email, password).then((value) {
        if (value.isSuccess) {
          // Sau khi đăng nhập thành công thì set data trả về vào Data
          Provider.of<Data>(context, listen: false)
              .setData(value.data.data.profile, value.data.data.shop, value.data.data.memberCardNumber, value.data.data.rewardPoints);

          getCountNotification(context, productId, productVideoLink);
        } else {
          print("Đăng nhập không thành công!");
        }
      });
    } catch (e) {
      print("Exception: $e");
    }
  }

  getCountNotification(BuildContext context, int productId, String productVideoLink) async {
    int countNotification = await navigationViewModel.getCountNotification();
    Provider.of<NotificationModel>(context, listen: false).setCountNotification(countNotification);

    // Nếu từ màn hình ProductDetail navigate sang màn hình Login (có truyền param productId và productVideoLink) thì khi đăng nhập
    // thành công sẽ vào lại màn hình ProductDetail trước đó. Nếu từ các màn hình khác navigate sang màn hình Login thì khi đăng
    // nhập thành công sẽ vào màn hình Home
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (productId == -1) {
        Navigator.pushNamed(context, Routers.Navigation);
      } else {
        Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(productId: productId, productVideoLink: productVideoLink),
            ));
        Navigator.pop(context); // pop lần nữa để tắt showDialog ở màn hình productDetail trước đó
      }
    });
  }
}
