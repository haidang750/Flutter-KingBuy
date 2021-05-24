import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/routers.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:provider/provider.dart';

class RootProfileViewModel extends BaseViewModel {
  handleLogout(Data userData) async {
    if (userData.profile != null) {
      NetworkState<int> response = await authRepository.sendRequestLogout();
      if (response.data == 1) {
        // Xóa dữ liệu user và accessToken khi đăng xuất
        Provider.of<Data>(context, listen: false).setData(null, null, null, null);
        await AppShared.setAccessToken(null);

        // Xóa dữ liệu Notification khi đăng xuất
        Provider.of<NotificationModel>(context, listen: false).setCountNotification(null);
        await Navigator.pushNamed(context, Routers.Navigation);
      }
    } else {
      Navigator.pushNamed(context, Routers.Login);
    }
  }
}
