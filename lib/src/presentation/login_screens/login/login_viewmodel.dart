import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:projectui/src/presentation/categories_screens/product_detail/product_detail_screen.dart';
import 'package:projectui/src/presentation/navigation/navigation_viewmodel.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class LoginViewModel extends BaseViewModel {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final navigationViewModel = NavigationViewModel();

  init() {
    emailController.text = "";
    passwordController.text = "";
  }

  onTapLoginButton(int productId, String productVideoLink) async {
    if (emailController.text != "" && passwordController.text != "") {
      await getLoginData(
        context,
        productId,
        productVideoLink,
        emailController.text,
        passwordController.text,
      );
    } else {
      Toast.show("Vui lòng nhập đầy đủ tài khoản và mật khẩu", context, gravity: Toast.CENTER);
    }
  }

  getLoginData(BuildContext context, int productId, String productVideoLink, String email, String password) async {
    try {
      await authRepository.sendRequestLogin(email, password).then((value) {
        if (value.isSuccess) {
          Data userData = value.data.data;
          Provider.of<Data>(context, listen: false).setData(userData.profile, userData.shop, userData.memberCardNumber, userData.rewardPoints);
          getCountNotification(context, productId, productVideoLink);
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
        Navigator.pushNamedAndRemoveUntil(context, Routers.Navigation, (Route<dynamic> route) => false);
      } else {
        Navigator.pop(context, MaterialPageRoute(builder: (context) => ProductDetail(productId: productId, productVideoLink: productVideoLink)));
        Navigator.pop(context); // pop lần nữa để tắt showDialog ở màn hình productDetail trước đó
      }
    });
  }
}
