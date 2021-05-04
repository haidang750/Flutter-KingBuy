import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projectui/src/presentation/HomeSreens/Home.dart';
import 'package:projectui/src/presentation/HomeSreens/HomeScreen.dart';
import 'package:projectui/src/presentation/LoginScreens/LoginScreen.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/utils/app_shared.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final splashScreenViewModel = SplashScreenViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      splashScreenViewModel.initApp(context);
    });
    Timer(
        Duration(seconds: 5),
        () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyBottomNavigationBar(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            "assets/splashBackground.jpg",
            fit: BoxFit.fill,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              height: 200,
            ),
            SpinKitRipple(
              color: Colors.orange.shade400,
              size: 60,
            )
          ],
        ),
      ],
    ));
  }
}
