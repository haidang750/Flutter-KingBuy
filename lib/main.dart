import 'package:flutter/material.dart';
import 'LoginScreen/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Đây là project tập dựng UI cứng", home: LoginScreen());
  }
}
