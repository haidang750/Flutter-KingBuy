import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:toast/toast.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> with ResponsiveWidget {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final changePasswordViewModel = ChangePasswordViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: changePasswordViewModel,
        builder: (context, viewModel, child) =>
            Scaffold(appBar: AppBar(titleSpacing: 0, title: Text("Đổi mật khẩu")), body: buildUi(context: context)));
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
            Padding(
              padding: EdgeInsets.only(top: 60),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "THAY ĐỔI MẬT KHẨU MỚI",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.6),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            buildTextInput(oldPasswordController, "Mật khẩu cũ"),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            buildTextInput(newPasswordController, "Mật khẩu mới"),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            buildTextInput(confirmNewPasswordController, "Nhập lại mật khẩu mới"),
            Padding(
              padding: EdgeInsets.only(top: 25),
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
                      buttonColor: Colors.red.shade800,
                      child: RaisedButton(
                        child: Text("Cập nhật", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
                        onPressed: () async {
                          int status = await changePasswordViewModel.updatePassword(
                              oldPasswordController.text, newPasswordController.text, confirmNewPasswordController.text);
                          if(status == 1){
                            Toast.show("Đổi mật khẩu thành công", context, gravity: Toast.CENTER);
                          }else{
                            if(newPasswordController.text != confirmNewPasswordController.text){
                              Toast.show("Mật khẩu xác nhận không hợp lệ", context, gravity: Toast.CENTER);
                            }else{
                              Toast.show("Mật khẩu cũ không hợp lệ", context, gravity: Toast.CENTER);
                            }
                          }
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
                  controller: textController,
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
