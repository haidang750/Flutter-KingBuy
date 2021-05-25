import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../../../routers.dart';

class ContactTypesViewModel extends BaseViewModel {
  final contactSubject = BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get contactStream => contactSubject.stream;

  init() {
    getContactInfo();
  }

  getContactInfo() async {
    List<dynamic> contactInfo = await contactRepository.getContactInfo();
    contactSubject.sink.add(contactInfo);
  }

  Future<bool> checkFeedbackOfUser() async {
    NetworkState<bool> result = await authRepository.checkFeedbackOfUser();
    return result.data;
  }

  handleMessenger(BuildContext context) {
    AppUtils.handleMessenger(context);
  }

  handlePhone(BuildContext context, String hotLine) {
    AppUtils.handlePhone(context, hotLine);
  }

  handleEmail() async {
    if (await AppUtils.checkLogin()) {
      bool isContacted = await checkFeedbackOfUser();
      isContacted ? Navigator.pushNamed(context, Routers.Detail_Contact) : Navigator.pushNamed(context, Routers.Create_Contact);
    } else {
      AppUtils.myShowDialog(context, -1, "");
    }
  }

  @override
  void dispose() {
    contactSubject.close();
    super.dispose();
  }
}
