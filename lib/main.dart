import 'package:flutter/material.dart';
import 'src/presentation/HomeSreens/MyBottomNavigationBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "KingBuy", home: MyBottomNavigationBar());
  }
}
