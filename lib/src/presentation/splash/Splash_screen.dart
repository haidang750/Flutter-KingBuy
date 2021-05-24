import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/utils/app_shared.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with ResponsiveWidget {
  final splashScreenViewModel = SplashScreenViewModel();

  @override
  void initState() {
    super.initState();
    getCart();
    AppShared.setShowPopup(true);
    splashScreenViewModel.getProfileUser();
    splashScreenViewModel.getCountNotification();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Timer(Duration(seconds: 6), () => Navigator.pushNamed(context, Routers.Navigation));
    });
  }

  getCart() async {
    await splashScreenViewModel.getCart(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        showPhone: false, viewModel: splashScreenViewModel, builder: (context, viewModel, child) => Scaffold(body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            AppImages.bgSplashScreen,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.logo,
              height: 200,
            ),
            SpinKitRipple(
              color: AppColors.splashSpinKit,
              size: 60,
            )
          ],
        ),
      ],
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
