import 'package:flutter/material.dart';

import 'NewPassword.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ForgetPasswordState();
  }
}

class ForgetPasswordState extends State<ForgetPassword> {
  String email = "";

  validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lấy lại mật khẩu")),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 120),
            ),
            Text(
              "NHẬP THÔNG TIN TÀI KHOẢN",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6),
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
                        width: 80,
                        child: Center(
                            child: Container(
                                width: 16,
                                height: 20,
                                child: Image.asset(
                                  "assets/user.png",
                                  fit: BoxFit.cover,
                                )))),
                    Expanded(
                      child: Container(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email hoặc Số điện thoại"),
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
                    SizedBox(width: 210),
                    Expanded(
                        child: Container(
                            child: ButtonTheme(
                      height: 56,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      buttonColor: Colors.red.shade800,
                      child: RaisedButton(
                          child: Text("Tiếp theo",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          onPressed: validateEmail(email)
                              ? () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewPassword(),
                                      ));
                                }
                              : null),
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
}
