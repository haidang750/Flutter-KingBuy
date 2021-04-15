import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/HomeSreens/MyBottomNavigationBar.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:provider/provider.dart';

class LoginViewModel {
  final authRepository = AuthRepository();

  getLoginData(BuildContext context, String email, String password) async {
    try {
      await authRepository.sendRequestLogin(email, password).then((value) {
        if (value.isSuccess) {
          // Sau khi đăng nhập thành công thì set data trả về vào Data
          Provider.of<Data>(context, listen: false).setData(
              value.data.data.profile,
              value.data.data.shop,
              value.data.data.memberCardNumber,
              value.data.data.rewardPoints);
          // Navigate sang Home
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyBottomNavigationBar(),
              ));
        } else {
          print("Đăng nhập không thành công!");
        }
      });
    } catch (e) {
      print("Exception: $e");
    }
  }
}
