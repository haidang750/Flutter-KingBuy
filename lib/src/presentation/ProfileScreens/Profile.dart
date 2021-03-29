// Ảnh 42 - Thông tin cá nhân
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  String radioValue = "";
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = TextEditingController();
  final emailController = TextEditingController();

  // dùng initState để khởi tạo giá trị ban đầu cho các ô TextField (khác với hintText)
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = "Nguyễn Hải Đăng";
    phoneController.text = "+8412345678";
    birthdayController.text = "06-12-1998";
    emailController.text = "nguyenhaidang@gmail.com";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Thông tin cá nhân"),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 16, bottom: 8),
              child: ButtonTheme(
                  minWidth: 66,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  disabledColor: Colors.grey.shade500,
                  buttonColor: Colors.red.shade800,
                  child: RaisedButton(
                    child: Text("LƯU",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        )),
                    onPressed: () {
                      print("Press button LƯU");
                    },
                  )),
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: ListView(
            children: [
              Container(
                  height: 160,
                  child: Center(
                      child: GestureDetector(
                          child: Badge(
                              badgeContent: Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                              ),
                              badgeColor: Colors.red.shade700,
                              position:
                                  BadgePosition.bottomEnd(bottom: -6, end: -6),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage("assets/1.jpg"),
                              )),
                          onTap: () {
                            print("Handle Change Avatar");
                          }))),
              Container(
                  height: 320,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Họ và tên",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            )),
                        TextField(
                          controller: nameController,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Số điện thoại",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            )),
                        TextField(
                            controller: phoneController,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Ngày tháng năm sinh",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            )),
                        TextField(
                            controller: birthdayController,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Email",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            )),
                        TextField(
                            controller: emailController,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                            )),
                      ],
                    ),
                  )),
              Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Giới tính",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Radio(
                                value: "Nam",
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState(() {
                                    radioValue = value;
                                  });
                                }),
                            GestureDetector(
                                child: Text("Nam",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    )),
                                onTap: () {
                                  setState(() {
                                    radioValue = "Nam";
                                  });
                                }),
                            Radio(
                                value: "Nữ",
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState(() {
                                    radioValue = value;
                                  });
                                }),
                            GestureDetector(
                                child: Text("Nữ",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    )),
                                onTap: () {
                                  setState(() {
                                    radioValue = "Nữ";
                                  });
                                }),
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
