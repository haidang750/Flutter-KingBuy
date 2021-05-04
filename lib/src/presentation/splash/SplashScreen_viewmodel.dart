import 'package:flutter/cupertino.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:provider/provider.dart';
import '../../resource/model/Data.dart';

class SplashScreenViewModel {
  initApp(BuildContext context) async {
    Provider.of<Data>(context, listen: false).setData(null, null, null, null);
    await AppShared.setAccessToken(null);
  }
}
