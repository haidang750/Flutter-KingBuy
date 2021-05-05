import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/routers.dart';
import '../PersonalInfo/PersonalInfo_screen.dart';
import 'Register_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> with ResponsiveWidget {
  final registerViewModel = RegisterViewModel();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(viewModel: registerViewModel, builder: (context, viewModel, child) => Scaffold(body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        alignment: Alignment.center,
        child: ListView(
          children: [
            buildAppLogo(),
            Container(
              height: 280,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  buildTextInput(AppImages.icUser, 20, 16, emailController, "Email hoặc Số điện thoại"),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  buildTextInput(AppImages.icLock, 26, 18, passwordController, "Mật khẩu"),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  buildTextInput(AppImages.icLock, 26, 18, confirmPasswordController, "Nhập lại mật khẩu"),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  Container(
                    height: 56,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                          Expanded(
                              child: Container(
                                  child: ButtonTheme(
                            height: 56,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            buttonColor: AppColors.enableButton,
                            child: RaisedButton(
                              child: Text("Đăng ký",
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.buttonContent)),
                              onPressed: () {
                                Navigator.pushNamed(context, Routers.Personal_Info);
                              },
                            ),
                          )))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 160,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  Text(
                    "Hoặc đăng nhập bằng",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Image.asset(AppImages.icFacebook),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Image.asset(AppImages.icGoogle),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Đã có tài khoản ?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                      SizedBox(width: 10),
                      GestureDetector(
                          child: Text(
                            "Đăng nhập",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, decoration: TextDecoration.underline),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          })
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppLogo() {
    return Container(
        height: 190,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                height: 160,
                width: 160,
                child: Image.asset(
                  AppImages.logo,
                  fit: BoxFit.cover,
                )),
            Text(
              "ĐĂNG KÝ TÀI KHOẢN",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.6),
            )
          ],
        ));
  }

  Widget buildTextInput(String iconImage, double iconHeight, double iconWidth, TextEditingController textController, String hintText) {
    return Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 0.5), borderRadius: BorderRadius.all(Radius.circular(28))),
          child: Row(
            children: [
              Container(
                  width: 60,
                  child: Center(
                      child: Container(
                          height: iconHeight,
                          width: iconWidth,
                          child: Image.asset(
                            iconImage,
                            fit: BoxFit.cover,
                          )))),
              Expanded(
                child: Container(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(border: InputBorder.none, hintText: hintText),
                  ),
                ),
              )
            ],
          ),
        ));
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
