import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/login_screens/forget_password/forget_password.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import '../new_password/new_password_screen.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ForgetPasswordState();
  }
}

class ForgetPasswordState extends State<ForgetPassword> with ResponsiveWidget {
  final forgetPasswordViewModel = ForgetPasswordViewModel();
  String email = "";
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: forgetPasswordViewModel,
        builder: (context, viewModel, child) => Scaffold(appBar: AppBar(title: Text("Lấy lại mật khẩu")), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 120),
          ),
          Text(
            "NHẬP THÔNG TIN TÀI KHOẢN",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.6),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
          ),
          Container(
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
                              width: 16,
                              height: 20,
                              child: Image.asset(
                                AppImages.icUser,
                                fit: BoxFit.cover,
                              )))),
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(border: InputBorder.none, hintText: "Email hoặc Số điện thoại"),
                        onChanged: (text) {
                          setState(() {
                            email = text;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
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
                    buttonColor: AppColors.primary,
                    child: RaisedButton(
                        child: Text("Tiếp theo",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.buttonContent)),
                        onPressed: forgetPasswordViewModel.validateEmail(email)
                            ? () {
                                Navigator.pushNamed(context, Routers.New_Password);
                              }
                            : null),
                  )))
                ],
              ),
            ),
          ),
        ],
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
