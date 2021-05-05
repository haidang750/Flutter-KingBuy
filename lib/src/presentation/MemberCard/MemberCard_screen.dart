import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/MemberCard/MemberCard.dart';
import 'package:projectui/src/presentation/base/base.dart';

class MemberCardScreen extends StatefulWidget {
  @override
  MemberCardScreenState createState() => MemberCardScreenState();
}

class MemberCardScreenState extends State<MemberCardScreen> with ResponsiveWidget {
  final memberCardViewModel = MemberCardViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: memberCardViewModel,
        builder: (context, viewModel, child) =>
            Scaffold(appBar: AppBar(title: Text("Thẻ thành viên"), titleSpacing: 0), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Center(child: Text("Thẻ thành viên"));
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
