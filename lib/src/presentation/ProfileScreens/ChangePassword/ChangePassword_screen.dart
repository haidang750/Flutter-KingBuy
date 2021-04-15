import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Đổi mật khẩu")),
        body: GestureDetector(
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
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(28))),
                    child: Row(
                      children: [
                        Container(
                            width: 60,
                            child: Center(
                                child: Container(
                                    width: 18,
                                    height: 26,
                                    child: Image.asset(
                                      "assets/lock.png",
                                      fit: BoxFit.cover,
                                    )))),
                        Expanded(
                          child: Container(
                            child: TextField(
                              controller: oldPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Mật khẩu cũ"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(28))),
                    child: Row(
                      children: [
                        Container(
                            width: 60,
                            child: Center(
                                child: Container(
                                    width: 18,
                                    height: 26,
                                    child: Image.asset(
                                      "assets/lock.png",
                                      fit: BoxFit.cover,
                                    )))),
                        Expanded(
                          child: Container(
                            child: TextField(
                              controller: newPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Mật khẩu mới"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(28))),
                    child: Row(
                      children: [
                        Container(
                            width: 60,
                            child: Center(
                                child: Container(
                                    width: 18,
                                    height: 26,
                                    child: Image.asset(
                                      "assets/lock.png",
                                      fit: BoxFit.cover,
                                    )))),
                        Expanded(
                          child: Container(
                            child: TextField(
                              controller: confirmNewPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Nhập lại mật khẩu mới"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                ),
                Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5),
                        Expanded(
                            child: Container(
                                child: ButtonTheme(
                          height: 56,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          buttonColor: Colors.red.shade800,
                          child: RaisedButton(
                            child: Text("Cập nhật",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            onPressed: () {},
                          ),
                        )))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
