import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/CategoriesScreens/ProductDetail_screen.dart';
import 'package:projectui/src/presentation/HomeSreens/MyBottomNavigationBar.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:projectui/src/resource/model/Data.dart';
import '../HomeSreens/MyBottomNavigationBar_viewmodel.dart';

class LoginViewModel {
  final authRepository = AuthRepository();
  final myBottomNavigationBarViewModel = MyBottomNavigationBarViewModel();

  getLoginData(BuildContext context, int productId, String productVideoLink, String email, String password) async {
    try {
      await authRepository.sendRequestLogin(email, password).then((value) {
        if (value.isSuccess) {
          // Sau khi đăng nhập thành công thì set data trả về vào Data
          Provider.of<Data>(context, listen: false)
              .setData(value.data.data.profile, value.data.data.shop, value.data.data.memberCardNumber, value.data.data.rewardPoints);

          getCountNotification(context);

          // Nếu từ màn hình ProductDetail navigate sang màn hình Login (có truyền param productId và productVideoLink) thì khi đăng nhập
          // thành công sẽ vào lại màn hình ProductDetail trước đó. Nếu từ các màn hình khác navigate sang màn hình Login thì khi đăng
          // nhập thành công sẽ vào màn hình Home
          if(productId == -1){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyBottomNavigationBar(),
                ));
          }else{
            Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetail(productId: productId, productVideoLink: productVideoLink),
                ));
            Navigator.pop(context); // pop lần nữa để tắt showDialog ở màn hình productDetail trước đó
          }
        } else {
          print("Đăng nhập không thành công!");
        }
      });
    } catch (e) {
      print("Exception: $e");
    }
  }

  // Get số lượng thông báo ngay khi đăng nhập thành công
  getCountNotification(BuildContext context) async {
    int countNotification = await myBottomNavigationBarViewModel.getCountNotification();
    Provider.of<NotificationModel>(context, listen: false).setCountNotification(countNotification);
  }
}
