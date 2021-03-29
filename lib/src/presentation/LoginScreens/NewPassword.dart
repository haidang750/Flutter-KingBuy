import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewPasswordState();
  }
}

class NewPasswordState extends State<NewPassword> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tạo lại mật khẩu")),
      body: Container(
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
                style: TextStyle(
                    fontSize: 24,
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
                        width: 80,
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
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Mật khẩu"),
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
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(28))),
                child: Row(
                  children: [
                    Container(
                        width: 80,
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
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập lại mật khẩu"),
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
    );
  }
}
