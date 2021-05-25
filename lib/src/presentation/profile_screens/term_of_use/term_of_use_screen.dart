// Ảnh 47 - Điều khoản sử dụng
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/presentation.dart';

class TermsOfUse extends StatefulWidget {
  @override
  TermsOfUseState createState() => TermsOfUseState();
}

class TermsOfUseState extends State<TermsOfUse> with ResponsiveWidget {
  final termOfUseViewModel = TermOfUseViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: termOfUseViewModel,
        builder: (context, viewModel, child) =>
            Scaffold(appBar: AppBar(titleSpacing: 0, title: Text("Điều khoản sử dụng")), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
      child: Center(
        child: Text("Điều khoản sử dụng"),
      ),
    );
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
