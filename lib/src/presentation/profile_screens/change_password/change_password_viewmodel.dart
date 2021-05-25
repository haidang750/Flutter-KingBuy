import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:toast/toast.dart';

class ChangePasswordViewModel extends BaseViewModel {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  updatePassword(String oldPassword, String newPassword, String newConfirmPassword) async {
    NetworkState<int> result = await authRepository.updatePassword(oldPassword, newPassword, newConfirmPassword);
    if (result.isSuccess) {
      return result.data;
    } else {
      return 0;
    }
  }

  onPressUpdatePassword() async {
    int status = await updatePassword(oldPasswordController.text, newPasswordController.text, confirmNewPasswordController.text);
    if (status == 1) {
      Toast.show("Đổi mật khẩu thành công", context, gravity: Toast.CENTER);
    } else {
      if (newPasswordController.text != confirmNewPasswordController.text) {
        Toast.show("Mật khẩu xác nhận không hợp lệ", context, gravity: Toast.CENTER);
      } else {
        Toast.show("Mật khẩu cũ không hợp lệ", context, gravity: Toast.CENTER);
      }
    }
  }
}
