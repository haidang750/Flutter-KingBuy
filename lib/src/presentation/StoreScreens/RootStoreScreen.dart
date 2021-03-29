import 'package:flutter/material.dart';

class RootStoreScreen extends StatefulWidget {
  @override
  _RootStoreScreenState createState() => _RootStoreScreenState();
}

class _RootStoreScreenState extends State<RootStoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cửa hàng"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text("Cửa hàng"),
      ),
    );
  }
}
