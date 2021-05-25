import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/data.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class DetailProfileViewModel extends BaseViewModel {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = TextEditingController();
  final emailController = TextEditingController();
  File image;
  final picker = ImagePicker();
  String radioValue = "";

  init(BuildContext context) {
    Data userData = Provider.of<Data>(context, listen: false);
    nameController.text = userData.profile.name;
    phoneController.text = userData.profile.phoneNumber;
    birthdayController.text = DateFormat("yyyy-MM-dd").format(userData.profile.dateOfBirth);
    emailController.text = userData.profile.email;
    radioValue = userData.profile.gender == 1 ? "Nam" : "Nữ";
  }

  getProfile() async {
    NetworkState<Data> result = await authRepository.getProfile();
    if (result.isSuccess) {
      print("Success: ${result.data}");
    } else if (result.isError) {
      print(result.message);
    }
  }

  updateProfile(
    String name,
    String phoneNumber,
    String dateOfBirth,
    int gender,
    String email,
    String avatarPath,
  ) async {
    NetworkState<Data> result = await authRepository.updateProfile(
        name: name, phoneNumber: phoneNumber, dateOfBirth: dateOfBirth, gender: gender, email: email, avatarPath: avatarPath);

    if (result.isSuccess) {
      // Sau khi update profile thành công thì set lại profile trong Data
      Provider.of<Data>(context, listen: false).setProfile(result.data.profile);
      Toast.show("Cập nhật thông tin thành công", context, gravity: Toast.CENTER);
    } else {
      Toast.show("Cập nhật thông tin thất bại", context, gravity: Toast.CENTER);
    }
  }
}
