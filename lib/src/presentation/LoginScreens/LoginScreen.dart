import 'package:flutter/material.dart';
import 'ForgetPassword.dart';
import 'LoginScreen_viewmodel.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginSreenState();
  }
}

class LoginSreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginViewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();
    emailController.text = "";
    passwordController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        alignment: Alignment.center,
        child: ListView(
          children: [
            Container(
                height: 190,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: 160,
                        width: 160,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.cover,
                        )),
                    Text(
                      "ĐĂNG NHẬP",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6),
                    )
                  ],
                )),
            Container(
              height: 260,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  Container(
                      height: 56,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(28))),
                        child: Row(
                          children: [
                            Container(
                                width: 60,
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
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email hoặc Số điện thoại"),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
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
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Mật khẩu"),
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Center(
                                child: GestureDetector(
                              child: Text(
                                "Quên mật khẩu?",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgetPassword()));
                              },
                            )),
                          ),
                          Expanded(
                              child: Container(
                                  child: ButtonTheme(
                            height: 56,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            buttonColor: Colors.red.shade800,
                            child: RaisedButton(
                              child: Text("Đăng nhập",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                              // xử lý API => đăng nhập thành công => vào trang Home
                              onPressed: () => loginViewModel.getLoginData(
                                context,
                                "0979629204",
                                "12345678",
                              ),
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
              height: 130,
              child: Column(
                children: [
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
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Image.asset("assets/facebook.png"),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Image.asset("assets/google.jpg"),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Không có tài khoản ?",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                      SizedBox(width: 10),
                      GestureDetector(
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
