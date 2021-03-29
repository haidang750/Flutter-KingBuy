import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/HomeSreens/MyBottomNavigationBar.dart';
import 'ForgetPassword.dart';
import 'RegisterScreen.dart';
import '../HomeSreens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginSreenState();
  }
}

class LoginSreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: ListView(
        children: [
          Container(
              height: 240,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      height: 180,
                      width: 180,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.cover,
                      )),
                  Text(
                    "ĐĂNG NHẬP",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6),
                  )
                ],
              )),
          Container(
            height: 280,
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
                          width: 210,
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
                                      builder: (context) => ForgetPassword()));
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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyBottomNavigationBar(),
                                  ));
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
            height: 180,
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
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Image.asset("assets/facebook.png"),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
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
    ));
  }
}
