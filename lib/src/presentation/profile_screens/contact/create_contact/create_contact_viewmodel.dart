import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:toast/toast.dart';

class CreateContactViewModel extends BaseViewModel {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();
  final bodyController = TextEditingController();

  Future<String> userSendContact(String fullName, String email, String phone, String subject, String body) async {
    NetworkState<String> result = await authRepository.userSendContact(fullName, email, phone, subject, body);
    return result.data;
  }

  onSendContact() async {
    String message =
        await userSendContact(fullNameController.text, emailController.text, phoneController.text, subjectController.text, bodyController.text);
    Toast.show(message, context, gravity: Toast.CENTER);
  }
}
