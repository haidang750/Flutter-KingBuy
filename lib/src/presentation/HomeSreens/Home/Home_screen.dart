import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/Navigation/Navigation_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:provider/provider.dart';
import 'Home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with ResponsiveWidget {
  final homeViewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: homeViewModel,
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text("Trang chủ"),
                automaticallyImplyLeading: false,
              ),
              body: buildUi(context: context),
            ));
  }

  Widget buildScreen() {
    Data data = Provider.of<Data>(context);

    return GestureDetector(
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
