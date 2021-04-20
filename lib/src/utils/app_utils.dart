import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/widgets/ShowDialog.dart';

import 'app_shared.dart';

class AppUtils {
  AppUtils._();

  static bool checkLogin() => AppShared.getAccessToken() != null ? true : false;
  static void myShowDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) {
      return ShowDialog();
    },
  );
}
