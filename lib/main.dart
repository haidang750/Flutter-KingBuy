import 'package:flutter/material.dart';
import 'package:projectui/src/configs/constants/app_values.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/splash/Splash.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:projectui/src/resource/model/NotificationModel.dart';
import 'package:projectui/src/resource/model/ProductQuestionModel.dart';
import 'package:projectui/src/resource/model/ViewedProductLocalStorage.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => Data(),
      ),
      ChangeNotifierProvider(
        create: (context) => AddressModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => NotificationModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => ViewedProductLocalStorage(),
      ),
      ChangeNotifierProvider(
        create: (context) => RatingModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => CommentModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => ProductQuestionModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => CartModel(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppValues.APP_NAME,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          );
        },
        home: SplashScreen(),
        onGenerateRoute: Routers.generateRoute,
    );
  }
}
// remove the glow when scroll on the whole application
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
