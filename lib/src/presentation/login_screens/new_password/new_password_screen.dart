import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'new_password_viewmodel.dart';

class NewPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewPasswordState();
  }
}

class NewPasswordState extends State<NewPassword> with ResponsiveWidget {
  final newPasswordViewModel = NewPasswordViewModel();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: newPasswordViewModel,
        builder: (context, viewModel, child) => Scaffold(appBar: AppBar(title: Text("Tạo lại mật khẩu")), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
      alignment: Alignment.center,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 120),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "MẬT KHẨU MỚI",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.6),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
          ),
          buildTextInput(passwordController, "Mật khẩu"),
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),
          buildTextInput(confirmPasswordController, "Nhập lại mật khẩu"),
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),
          buildButton()
        ],
      ),
    );
  }

  Widget buildTextInput(TextEditingController textController, String hintText) {
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
                        width: 18,
                        height: 26,
                        child: Image.asset(
                          AppImages.icLock,
                          fit: BoxFit.cover,
                        )))),
            Expanded(
              child: Container(
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(border: InputBorder.none, hintText: hintText),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton() {
    return Container(
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
                child: Text("Cập nhật", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.buttonContent)),
                onPressed: () {},
              ),
            )))
          ],
        ),
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
