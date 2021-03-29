import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text("Trang chủ"),
      ),
    );
  }
}
