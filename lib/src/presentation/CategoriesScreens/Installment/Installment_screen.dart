import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';

class InstallmentScreen extends StatefulWidget {
  @override
  InstallmentScreenState createState() => InstallmentScreenState();
}

class InstallmentScreenState extends State<InstallmentScreen> with ResponsiveWidget {
  final installmentViewModel = InstallmentViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: installmentViewModel,
        builder: (context, viewModel, child) =>
            Scaffold(appBar: AppBar(title: Text("Đặt mua trả góp"), titleSpacing: 0), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Center(child: Text("Đặt mua trả góp"));
  }

  @override
  Widget buildDesktop(BuildContext context) {
    // TODO: implement buildDesktop
    return buildScreen();
  }

  @override
  Widget buildMobile(BuildContext context) {
    // TODO: implement buildMobile
    return buildScreen();
  }

  @override
  Widget buildTablet(BuildContext context) {
    // TODO: implement buildTablet
    return buildScreen();
  }
}
