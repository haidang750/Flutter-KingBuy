import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/HomeSreens/Home.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Data data = Provider.of<Data>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ"),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        child: Center(
            child: GestureDetector(
          child: Text("Trang chủ"),
          onTap: () {
            MainTabControlDelegate.getInstance().tabJumpTo(1);
          },
        )),
        onTap: () {
          print(data.memberCardNumber);
        },
      ),
    );
  }
}
