import 'package:flutter/material.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Data data = Provider.of<Data>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ"),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        child: Center(child: Text("Trang chủ")),
        onTap: () {
          print(data.memberCardNumber);
        },
      ),
    );
  }
}
