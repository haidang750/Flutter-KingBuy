import 'package:flutter/material.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:provider/provider.dart';
import './src/presentation/LoginScreens/LoginScreen.dart';
// import 'src/presentation/HomeSreens/MyBottomNavigationBar.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => Data(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "KingBuy", home: LoginScreen());
  }
}
