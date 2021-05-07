import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/widgets/ShowDialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
import 'app_shared.dart';

class AppUtils {
  AppUtils._();

  static Future<bool> checkLogin() async => await AppShared.getAccessToken() != null ? true : false;

  static void myShowDialog(BuildContext context, int productId, String productVideoLink) => showDialog(
    context: context,
    builder: (context) {
      return ShowDialog(productId: productId, productVideoLink: productVideoLink);
    },
  );

  static handleMessenger(BuildContext context) async {
    if (await canLaunch('http://m.me/100040733580443')) {
      await launch('https://m.me/100040733580443');
    } else
      Toast.show("Không thể mở Messenger", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  static handleZalo(BuildContext context) async {
    print("handleZalo()");
  }

  static handlePhone(BuildContext context, String hotLine) async {
    if (await canLaunch('tel:$hotLine')) {

      await launch('tel:$hotLine');
    } else {
      Toast.show("Không thể mở điện thoại", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
